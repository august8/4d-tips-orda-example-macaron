//%attributes = {"invisible":true,"preemptive":"capable"}
  //統計

C_LONGINT:C283($1)
C_OBJECT:C1216($0;$営業日;$統計)

$ID:=$1

$営業日:=ds:C1482.営業日.get($ID)

If ($営業日#Null:C1517)
	
	C_OBJECT:C1216($today)
	$today:=ds:C1482.売上.query("日付 = :1";$営業日.ID)
	
	C_COLLECTION:C1488($lines)
	$lines:=$today.明細.extract("行").reduce("get_lines";New collection:C1472)
	
	$統計:=New object:C1471
	
	$統計.合計:=$lines.sum("個数")
	$統計.半額:=$lines.query("単価 = :1";150).sum("個数")
	$統計.値引:=$lines.query("単価 = :1";200).sum("個数")
	$統計.終了:=$today.query("明細.残数[a].商品名 in :1 and 明細.残数[a].終了時刻 != null";ds:C1482.洋菓子.all().名称)\
		.明細\
		.extract("残数")\
		.reduce("get_lines";New collection:C1472)\
		.query("終了時刻 != null")\
		.orderBy("終了時刻 asc")
	
End if 

$0:=$統計