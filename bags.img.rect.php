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
function createSegment($x, $y, $width, $height, $segType = TYPE_MISC, $even = 0)
{
	global $img, $colors, $use3d;

	// determine segment color
	if ($segType == TYPE_SHELF) {
		$colorClass = $colors[$even ? TYPE_SHELF_EVEN : TYPE_SHELF_ODD];
	} else {
		$colorClass = $colors[$segType];
	}

	// create colors
	$fillColor = imagecolorallocatealpha($img, hexdec($colorClass->fillRed), hexdec($colorClass->fillGreen), hexdec($colorClass->fillBlue), $colorClass->fillAlpha);
	$strokeColor = imagecolorallocatealpha($img, hexdec($colorClass->strokeRed), hexdec($colorClass->strokeGreen), hexdec($colorClass->strokeBlue), $colorClass->strokeAlpha);

	// create top rectangle
	imagefilledrectangle($img, $x, $y, $x + $width, $y + $height, $fillColor);
	imagerectangle($img, $x, $y, $x + $width, $y + $height, $strokeColor);

	if ($segType != TYPE_LIFT && $use3d && ($segType == TYPE_SHELF || $segType == TYPE_SHELF_RESERVED || $segType == TYPE_SHELF_USED || $segType == TYPE_TERMINAL || $segType == TYPE_BAG || $segType == TYPE_BAG_MARKED || $segType == TYPE_TERMINAL_RESERVED)) {
		// create bottom polygon
		$points = array($x, ($y + $height), ($x + $width), ($y + $height), ($x + $width + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y), ($x + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y));
		imagefilledpolygon($img, $points, 4, $fillColor);
		imagepolygon($img, $points, 4, $strokeColor);
		// create right polygon
		$points = array(($x + $width), $y, ($x + $width + SEG_OFFSET_X), ($y + SEG_OFFSET_Y), ($x + $width + SEG_OFFSET_X), ($y + $height + SEG_OFFSET_Y), ($x + $width), ($y + $height));
		imagefilledpolygon($img, $points, 4, $fillColor);
		imagepolygon($img, $points, 4, $strokeColor);
	}
}

?>