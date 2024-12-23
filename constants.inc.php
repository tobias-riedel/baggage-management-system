<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-07-17
//
// This script defines basic constants.
//******************************************************************************
if (!defined('CONSTANTS')) {
	define('CONSTANTS', 1);
	// defining constants
	// DO NOT EDIT!

	// define view names
	define('VIEW_BAG_IMAGE', 'bag_image');
	define('VIEW_BAG_LIST', 'bag_list');
	define('DT_BAG', 'bag');
	define('DT_SEGMENT', 'segment');

	// define segment types
	define('TYPE_MISC', -1);
	define('TYPE_ASSEMBLY_LINE', 0);
	define('TYPE_LIFT', 1);
	define('TYPE_TERMINAL', 2);
	define('TYPE_SHELF', 3);
	define('TYPE_SHELF_RESERVED', 4);
	define('TYPE_SHELF_USED', 5);
	define('TYPE_ACCESS', 6);
	define('TYPE_TERMINAL_RESERVED', 7);
	define('TYPE_ASSEMBLY_LINE_RESERVED', 8);
	define('TYPE_BAG', 9);
	define('TYPE_BAG_MARKED', 10);
	define('TYPE_SHELF_EVEN', 11);
	define('TYPE_SHELF_ODD', 12);
}
?>