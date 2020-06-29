# 4d-tips-orda-example-macaron
簡単なORDAの例題です。

<img width="443" alt="Screen Shot 2020-06-29 at 22 29 05" src="https://user-images.githubusercontent.com/1725068/86011789-1d51a600-ba58-11ea-910a-acb82d14d2b3.png">

#### セットアップ

``create_sample_data``メソッドを実行します。データの範囲は``23``-``24``行で調整することができます。

```
$sd:=!2019-12-31!
$ed:=!2020-12-31!
```

#### クエリ

```
C_OBJECT($es)

$売上情報:=ds

Case of 
: (True)
	$es:=$売上情報.営業日.query("eval(Month of(This.日付)=1)").売上  //1月の売上（evalでクエリ）
: (False)
	$formula:=Formula(Month of(This.日付)=1)
	$es:=$売上情報.営業日.query($formula).売上  //1月の売上（フォーミュラでクエリ）
: (False)
	$es:=$売上情報.営業日.query("日付 >= :1 and 日付 <= :2";!2020-01-01!;!2020-01-31!).売上  //1月の売上
End case 

$sum:=$es.sum("明細.行[].金額")  //1月の売上合計額
```
