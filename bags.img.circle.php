<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2015-06-17
//
// This script creates the graphical output of the system.
//******************************************************************************



//*****************************************************************
/**
 *
 * This function creates the graphical segment.
 *
 */
function createSegment($x, $y, $width, $height, $segType = TYPE_MISC, $even = 0) {
	global $img, $colors, $use3d;
	
	// determine segment color
	if ($segType == TYPE_SHELF) {
		if ($even) {
			$colorClass = $colors[TYPE_SHELF_EVEN];
		}
		else {
			$colorClass = $colors[TYPE_SHELF_ODD];
		}
	} else {
		$colorClass = $colors[$segType];
	}
	
	// create colors
	$fillColor = imagecolorallocatealpha($img, $colorClass->fillRed, $colorClass->fillGreen, $colorClass->fillBlue, $colorClass->fillAlpha);
	$strokeColor = imagecolorallocatealpha($img, $colorClass->strokeRed, $colorClass->strokeGreen, $colorClass->strokeBlue, $colorClass->strokeAlpha);

	// create top rectangle
	
	if ($segType == TYPE_ASSEMBLY_LINE || $segType == TYPE_ACCESS) {
		$radHor = $width / 4;
		$radVer = $height / 4;
	} else if ($segType == TYPE_SHELF) {
		$radHor = $width / 2;
		$radVer = $height / 2;
	} else {
		$radHor = $width;
		$radVer = $height;
	}

	imagefilledellipse($img, $x + ($width / 2), $y + ($height / 2), $radHor, $radVer, $fillColor);
	imageellipse($img, $x + ($width / 2), $y + ($height / 2), $radHor, $radVer, $strokeColor);
	
	/*
	if ($segType != TYPE_LIFT && $use3d == 'true' && ($segType == TYPE_SHELF || $segType == TYPE_SHELF_RESERVED || $segType == TYPE_SHELF_USED || $segType == TYPE_TERMINAL || $segType == TYPE_BAG || $segType == TYPE_BAG_MARKED || $segType == TYPE_TERMINAL_RESERVED)) {
		// create bottom polygon
		$points = array($x, ($y + $height), ($x + $width), ($y + $height), ($x + $width + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y), ($x + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y));
		imagefilledpolygon($img, $points, 4, $fillColor);
		imagepolygon($img, $points, 4, $strokeColor);
		// create right polygon
		$points = array(($x + $width), $y, ($x + $width + SEG_OFFSET_X), ($y + SEG_OFFSET_Y), ($x + $width + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y), ($x + $width), ($y + $height));
		imagefilledpolygon($img, $points, 4, $fillColor);
		imagepolygon($img, $points, 4, $strokeColor);
	}
	*/
}

?>