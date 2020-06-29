$event:=Form event code:C388

Case of 
	: ($event=On Data Change:K2:15) | ($event=On Clicked:K2:4)
		
		$value:=Self:C308->
		$size:=Records in selection:C76(Current form table:C627->)
		
		Case of 
			: ($value=0)
				FIRST RECORD:C50(Current form table:C627->)
			: ($value=100)
				LAST RECORD:C200(Current form table:C627->)
			Else 
				GOTO SELECTED RECORD:C245(Current form table:C627->;$size*($value/100))
		End case 
		
		RELATE ONE:C42([売上:5]日付:5)
		
End case 