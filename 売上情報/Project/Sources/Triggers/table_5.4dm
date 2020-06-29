$event:=Trigger event:C369

Case of 
	: ($event=On Saving Existing Record Event:K3:2)\
		 | ($event=On Saving New Record Event:K3:1)\
		 | ($event=On Deleting Record Event:K3:3)
		
		C_OBJECT:C1216($営業日)
		$営業日:=ds:C1482.営業日.get([売上:5]日付:5)
		
		If ($営業日=Null:C1517)
			$営業日:=ds:C1482.営業日.new()
			[売上:5]日付:5:=$営業日.ID
		End if 
		
		$営業日.統計:=get_stats ([売上:5]日付:5)
		$営業日.save()
		
End case 