<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-09-07
//
// This file contains the color information for the segment. Feel free to edit.
//******************************************************************************
if (!defined('STYLE_COLORS')) {
	define('STYLE_COLORS', 1);

	// get constants
	include("constants.inc.php");

	//******************************************************************************
	/**
	 * This function autoloads missing classes.
	 * @param	String		$className		the name of the missong class
	 */
	function __autoload($class_name) {
	    include_once($class_name . '.class.php');
	}
	//******************************************************************************
	
	$fill_alpha = 50;
	$stroke_alpha = 0;
	$stroke_color = '#000';

	// define the colors related to the segment types
	// Colors([ String $fillColor, String $stroke_color, int $fill_alpha, int $stroke_alpha ])
	//		$fillColor:		'#000' - '#FFF' or '#000000' - '#FFFFF', default: '#000'
	//		$stroke_color:	'#000' - '#FFF' or '#000000' - '#FFFFF', default: '#FFF'
	//		$fill_alpha:		0 - 127, default: 0
	//		$stroke_alpha:	0 - 127, default: 0
	$colors = array (
		TYPE_ACCESS => new Colors('#47E', '#36D', $fill_alpha, $stroke_alpha),
		TYPE_ASSEMBLY_LINE => new Colors('#FC2', '#EB1', $fill_alpha, $stroke_alpha),
		TYPE_ASSEMBLY_LINE_RESERVED => new Colors('#D67', '#F00', $fill_alpha, $stroke_alpha),
		TYPE_BAG => new Colors('#7E3', '#000', 40, 30),
		TYPE_BAG_MARKED => new Colors('#FFF', $stroke_color),
		TYPE_LIFT => new Colors('#F00', '#F00', 127, 30),
		TYPE_MISC => new Colors('#555', '#000', $fill_alpha, $stroke_alpha),
		TYPE_SHELF_EVEN => new Colors('#0EE', '#088', $fill_alpha, $stroke_alpha),
		TYPE_SHELF_ODD => new Colors('#099', '#055', $fill_alpha, $stroke_alpha),
		TYPE_SHELF_RESERVED => new Colors('#E80', '#00F'),
		TYPE_SHELF_USED => new Colors('#7E3', '#000'),
		TYPE_TERMINAL => new Colors('#489', '#156', $fill_alpha, $stroke_alpha),
		TYPE_TERMINAL_RESERVED => new Colors('#F89', '#F44', $fill_alpha, $stroke_alpha)
	);

}
?>