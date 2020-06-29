$event:=Form event code:C388

Case of 
	: ($event=On Load:K2:1)
		
		OBJECT Get pointer:C1124(Object named:K67:5;"終了.list")->:=1
		OBJECT Get pointer:C1124(Object named:K67:5;"残数.list")->:=1
		OBJECT Get pointer:C1124(Object named:K67:5;"統計.simple")->:=1
		
		OBJECT Get pointer:C1124(Object named:K67:5;"Ruler")->:=\
			Selected record number:C246(Current form table:C627->)/\
			Records in selection:C76(Current form table:C627->)*100
		
		OBJECT SET VISIBLE:C603(*;"統計.label@";True:C214)
		OBJECT SET VISIBLE:C603(*;"統計.field@";True:C214)
		OBJECT SET VISIBLE:C603(*;"統計.detail";False:C215)
		
End case 