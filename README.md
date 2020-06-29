# 4d-tips-orda-example-macaron
簡単なORDAの例題です。



```4d
C_OBJECT($es)

$売上情報:=ds

Case of 
	: (True)
		$es:=$売上情報.営業日.query("eval(Month of(This.日付)=1)").売上  //1月の売上（evalでクエリ）
	: (False)
		$formula:=Formula(Month of(This.日付)=1)
		$es:=$売上情報.営業日.query($formula).売上  //1月の売上（フォーミュラでクエリ）
	: (True)
		$es:=$売上情報.営業日.query("日付 >= :1 and 日付 <= :2";!2020-01-01!;!2020-01-31!).売上  //1月の売上
End case 

$sum:=$es.sum("明細.行[].金額")  //1月の売上合計額
```
