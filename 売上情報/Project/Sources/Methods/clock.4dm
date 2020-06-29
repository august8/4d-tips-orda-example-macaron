//%attributes = {"invisible":true}
C_PICTURE:C286($0)

If (Storage:C1525.clock.svg=Null:C1517)
	$path:=Get 4D folder:C485(Current resources folder:K5:16)+"clock.svg"
	Use (Storage:C1525)
		Storage:C1525.clock:=New shared object:C1526("svg";Document to text:C1236($path;"utf-8"))
	End use 
End if 

C_TEXT:C284($clock)

$clock:=Storage:C1525.clock.svg

C_TIME:C306($1;$Gmt_Current_Time)

$Gmt_Current_Time:=$1

$secondes:=$Gmt_Current_Time%60
$minutes_r:=(($Gmt_Current_Time\60)%60)+($secondes/60)
$hours_r:=$Gmt_Current_Time/3600

$secondAngle:=($secondes*6)+180
$minuteAngle_r:=($minutes_r*6)+180
$hourAngle_r:=(($hours_r-(12*Num:C11($hours_r>12)))*30)+180

$dom:=DOM Parse XML variable:C720($clock)

C_REAL:C285($cx_r;$cy_r)

$secondsHand:=DOM Find XML element by ID:C1010($dom;"seconds-hand")
DOM GET XML ATTRIBUTE BY NAME:C728($secondsHand;"d4:cx";$cx_r)
DOM GET XML ATTRIBUTE BY NAME:C728($secondsHand;"d4:cy";$cy_r)
$cx_r:=Choose:C955($cx_r=0;200;$cx_r)
$cy_r:=Choose:C955($cy_r=0;200;$cy_r)
DOM SET XML ATTRIBUTE:C866($secondsHand;"transform";"rotate("+String:C10($secondAngle;"&xml")+","+String:C10($cx_r;"&xml")+","+String:C10($cy_r;"&xml")+")")

$minutesHand:=DOM Find XML element by ID:C1010($dom;"minutes-hand")
DOM GET XML ATTRIBUTE BY NAME:C728($minutesHand;"d4:cx";$cx_r)
DOM GET XML ATTRIBUTE BY NAME:C728($minutesHand;"d4:cy";$cy_r)
DOM SET XML ATTRIBUTE:C866($minutesHand;"transform";"rotate("+String:C10($minuteAngle_r;"&xml")+","+String:C10($cx_r;"&xml")+","+String:C10($cy_r;"&xml")+")")

$hoursHand:=DOM Find XML element by ID:C1010($dom;"hours-hand")
DOM GET XML ATTRIBUTE BY NAME:C728($hoursHand;"d4:cx";$cx_r)
DOM GET XML ATTRIBUTE BY NAME:C728($hoursHand;"d4:cy";$cy_r)
DOM SET XML ATTRIBUTE:C866($hoursHand;"transform";"rotate("+String:C10($hourAngle_r;"&xml")+","+String:C10($cx_r;"&xml")+","+String:C10($cy_r;"&xml")+")")

$nightBegins:=?18:00:00?
$nightEnds:=?06:00:00?

  //Set the background according to the daylight if any
If ($Gmt_Current_Time>=$nightEnds) & ($Gmt_Current_Time<=$nightBegins)
	$attributeFill:="d4:day-fill"
	$attributeStroke:="d4:day-stroke"
Else 
	$attributeFill:="d4:night-fill"
	$attributeStroke:="d4:night-stroke"
End if 

ARRAY TEXT:C222($_objectsNames;6)
$_objectsNames{1}:="watch-dial"
$_objectsNames{2}:="hours-hand"
$_objectsNames{3}:="minutes-hand"
$_objectsNames{4}:="seconds-hand"
$_objectsNames{5}:="labels"
$_objectsNames{6}:="clock-glass"

For ($i;1;Size of array:C274($_objectsNames);1)
	$object:=DOM Find XML element by ID:C1010($dom;$_objectsNames{$i})
	DOM GET XML ATTRIBUTE BY NAME:C728($object;$attributeFill;$fillColor)
	If ($fillColor#"")
		DOM SET XML ATTRIBUTE:C866($object;"fill";$fillColor)
	End if 
	DOM GET XML ATTRIBUTE BY NAME:C728($object;$attributeStroke;$strokeColor)
	If ($strokeColor#"")
		DOM SET XML ATTRIBUTE:C866($object;"stroke";$strokeColor)
	End if 
End for 

SVG EXPORT TO PICTURE:C1017($dom;$0;Copy XML data source:K45:17)