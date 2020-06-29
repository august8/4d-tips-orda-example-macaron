//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($1;$item)

For each ($item;$1.value)
	$1.accumulator.push($item)
End for each 