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
	global $img, $colors;

	// determine segment color
	if ($segType == TYPE_SHELF) {
		if ($even) {
			$colorClass = $colors[TYPE_SHELF_EVEN];
		} else {
			$colorClass = $colors[TYPE_SHELF_ODD];
		}
	} else {
		$colorClass = $colors[$segType];
	}

	// create colors
	$fillColor = imagecolorallocatealpha($img, hexdec($colorClass->fillRed), hexdec($colorClass->fillGreen), hexdec($colorClass->fillBlue), $colorClass->fillAlpha);
	$strokeColor = imagecolorallocatealpha($img, hexdec($colorClass->strokeRed), hexdec($colorClass->strokeGreen), hexdec($colorClass->strokeBlue), $colorClass->strokeAlpha);

	// create ellipse
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

}

?>