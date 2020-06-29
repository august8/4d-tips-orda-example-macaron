//%attributes = {"invisible":true}
If (True:C214)
	
	  //create records
	
	TRUNCATE TABLE:C1051([営業日:6])
	SET DATABASE PARAMETER:C642([営業日:6];Table sequence number:K37:31;0)
	
	TRUNCATE TABLE:C1051([売上:5])
	SET DATABASE PARAMETER:C642([売上:5];Table sequence number:K37:31;0)
	
	Begin SQL
		ALTER TABLE [売上] DISABLE TRIGGERS;
	End SQL
	
	C_OBJECT:C1216($商品;$伝票)
	
	$numberOfVists:=1000
	
	$maxCount:=16
	
	$variant:=120
	
	$sd:=!2019-12-31!
	$ed:=!2020-12-31!
	
	For ($d;1;$ed-$sd)
		
		$start:=?11:00:00?
		$end:=?19:00:00?
		C_TIME:C306($time)
		$time:=$start
		C_COLLECTION:C1488($counts)
		C_OBJECT:C1216($count)
		C_COLLECTION:C1488($products)
		C_LONGINT:C283($p)
		
		$date:=Add to date:C393($sd;0;0;$d)
		
		$counts:=ds:C1482.洋菓子.all().toCollection()
		
		For each ($count;$counts)
			$count.製造数:=Int:C8($count.製造数*(1-((Random:C100%$variant)/1000)))
			$count.個数:=$count.製造数
			
		End for each 
		
		For ($i;1;$numberOfVists)
			
			Case of 
				: ($time>?15:00:00?) & ($time<?16:00:00?)
					$time:=$time+(Random:C100%40)
				: ($time>?17:30:00?) & ($time<?21:00:00?)
					$time:=$time+(Random:C100%60)
				Else 
					$time:=$time+(Random:C100%100)
			End case 
			
			$伝票:=ds:C1482.売上.new()
			$find:=Find in field:C653([営業日:6]日付:2;$date)
			If ($find#-1)
				GOTO RECORD:C242([営業日:6];$find)
			Else 
				CREATE RECORD:C68([営業日:6])
				[営業日:6]日付:2:=$date
				SAVE RECORD:C53([営業日:6])
			End if 
			$伝票.日付:=[営業日:6]ID:1
			UNLOAD RECORD:C212([営業日:6])
			
			$伝票.時刻:=$time
			$伝票.番号:=String:C10($i;"000000")
			$伝票.明細:=New object:C1471("行";New collection:C1472)
			
			$products:=$counts.query("個数 > 0")
			
			For ($ii;1;1+(Random:C100%$products.length))
				
				If ($products.length#0)
					
					Repeat 
						$p:=(Random:C100%$products.length)
						$商品:=ds:C1482.洋菓子.get($products[$p].ID)
						$count:=$counts.query("名称 = :1";$商品.名称)[0]
					Until ($count.個数#0)
					
					Case of 
						: ($time>?20:15:00?)
							  //$maxCount:=24
					End case 
					
					$_count:=1+(Random:C100%$maxCount)
					If ($_count>=$count.個数)
						$_count:=$count.個数
						  //うりきれ
						$count.isLast:=True:C214
					End if 
					
					$明細:=New object:C1471
					$明細.商品ID:=$商品.ID
					$明細.商品名:=$商品.名称
					$明細.個数:=$_count
					$明細.伝票ID:=$伝票.ID
					
					Case of 
						: ($time>?20:00:00?)
							$明細.単価:=150
						: ($time>?18:00:00?) & ($count.個数>30)
							$明細.単価:=200
						Else 
							$明細.単価:=300
					End case 
					
					$明細.金額:=$明細.個数*$明細.単価
					$伝票.明細.行.push($明細)
					
					$count.個数:=$count.個数-$_count
					
					$products.remove($p)
					
				Else 
					  //すべてうりきれ
				End if 
				
			End for 
			
			If ($伝票.明細.行.length#0)
				$伝票.明細.残数:=New collection:C1472
				For each ($count;$counts)
					
					$残数:=New object:C1471(\
						"商品ID";$count.ID;\
						"個数";$count.個数;\
						"製造数";$count.製造数;\
						"商品名";$count.名称)
					
					If (Bool:C1537($count.isLast))
						$残数.終了時刻:=$time
						OB REMOVE:C1226($count;"isLast")
					End if 
					
					$伝票.明細.残数.push($残数)
				End for each 
				$伝票.save()
			End if 
			
		End for 
		
	End for 
	
End if 

Begin SQL
	ALTER TABLE [売上] ENABLE TRIGGERS;
End SQL

READ ONLY:C145([営業日:6])  //to allow orda in trigger to update table
ALL RECORDS:C47([営業日:6])

SET QUERY LIMIT:C395(1)  //only need 1 record to indentify related N
SET FIELD RELATION:C919([売上:5]日付:5;Manual:K51:3;Manual:K51:3)  //prevent apply to selection from invoking automatic relation

For ($i;1;Records in selection:C76([営業日:6]))
	QUERY:C277([売上:5];[売上:5]日付:5=[営業日:6]ID:1)
	APPLY TO SELECTION:C70([売上:5];[売上:5]日付:5:=[売上:5]日付:5)  //invoke trigger
	NEXT RECORD:C51([営業日:6])
End for 

  //reset context
SET QUERY LIMIT:C395(0)
SET FIELD RELATION:C919([売上:5]日付:5;Structure configuration:K51:2;Structure configuration:K51:2)
READ WRITE:C146([営業日:6])