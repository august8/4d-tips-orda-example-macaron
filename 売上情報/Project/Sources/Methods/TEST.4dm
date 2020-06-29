//%attributes = {}
C_OBJECT:C1216($es)

$売上情報:=ds:C1482

Case of 
	: (True:C214)
		$es:=$売上情報.営業日.query("eval(Month of(This.日付)=1)").売上  //1月の売上（evalでクエリ）
	: (False:C215)
		$formula:=Formula:C1597(Month of:C24(This:C1470.日付)=1)
		$es:=$売上情報.営業日.query($formula).売上  //1月の売上（フォーミュラでクエリ）
	: (False:C215)
		$es:=$売上情報.営業日.query("日付 >= :1 and 日付 <= :2";!2020-01-01!;!2020-01-31!).売上  //1月の売上
End case 

$sum:=$es.sum("明細.行[].金額")  //1月の売上合計額