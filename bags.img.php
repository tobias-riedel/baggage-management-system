<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-07-17
//
// This script creates the graphical output of the system.
//******************************************************************************

// needed for render time
$timeStart = microtime(true);

// get constants, configs, languages, ...
include("constants.inc.php");
include("config.inc.php");
include("lang.inc.php");
include("colors.inc.php");

// get baggage to mark
$markedBag = @$_REQUEST['mark'];
$useAnimations = @$_REQUEST['useAnimations'];
$labels = @$_REQUEST['labels'];
$stats = @$_REQUEST['stats'];
$use3d = @$_REQUEST['use3d'];
$textColor = @$_REQUEST['textColor'];
$renderStyle = !empty(@$_REQUEST['renderStyle']) ? $_REQUEST['renderStyle'] : 'rect';

// Use the right render style,
include("bags.img." . $renderStyle . ".php");
//*****************************************************************
/**
 *
 * This function places text in the image.
 *
 */
function createText($x, $y, $z, $text, $font = 1)
{
	global $img, $textColor;

	// position text within the segment
	$newX = $x * SEG_WIDTH - $z * SEG_OFFSET_X + 5;
	$newY = $y * SEG_HEIGHT - $z * SEG_OFFSET_Y + 7;

	$c = $textColor;
	$c = substr($c, strpos($c, '(') + 1);
	$c = substr($c, 0, strrpos($c, ')'));
	$ca = explode(',', $c);

	$colorBlack = imagecolorallocate($img, 0x00, 0x00, 0x00);
	$fontColor = !@$textColor ? $colorBlack : imagecolorallocate($img, $ca[0], $ca[1], $ca[2]);

	// create text
	imagestring($img, $font, $newX, $newY, $text, $fontColor);
}
//*****************************************************************
/**
 *
 * This function prepares the values to create the segment.
 *
 */
function putSegment($x, $y, $z, $segType = 0, $even = 0)
{
	// put a segment
	createSegment($x * SEG_WIDTH - $z * SEG_OFFSET_X, $y * SEG_HEIGHT - $z * SEG_OFFSET_Y, SEG_WIDTH, SEG_HEIGHT, $segType, $even);
}
//*****************************************************************

// create image
$img = @imagecreatetruecolor(IMG_WIDTH, IMG_HEIGHT) or die("Could not initialize GD stream!");
// create transparent background
$bg = imagecolorallocate($img, 0xFF, 0xFF, 0xFF);
imagecolortransparent($img, $bg);
imagefilledrectangle($img, 0, 0, IMG_WIDTH, IMG_HEIGHT, $bg);

// connect to database
try {
	$db = new PDO('mysql:host=' . CFG_DB_HOST . ';dbname=' . CFG_DB_NAME, CFG_DB_USER, CFG_DB_PWD);
} catch (PDOException $e) {
	// In case of not installed DB.
	createText(15, 15, 0, $lang['database_not_installed'] . "!");
	imagepng($img);
	imagedestroy($img);

	die();
}

// label the shelves
createText(6, 2, 0, $lang['shelf'] . ' 1');
createText(12, 2, 0, $lang['shelf'] . ' 2');
createText(18, 2, 0, $lang['shelf'] . ' 3');
createText(24, 2, 0, $lang['shelf'] . ' 4');
createText(30, 2, 0, $lang['shelf'] . ' 5');

// select the segment' structure
$query = "SELECT *
	FROM " . VIEW_BAG_IMAGE . " 
	ORDER BY z ASC, x ASC, y ASC";

$result = $db->query($query);

// print the segments structure
while ($row = $result->fetchObject()) {

	$boxType = $row->seg_type;

	// initialize segment row
	$newZ = $row->z;

	// some cosmetic stuff
	if ($boxType == TYPE_TERMINAL && $row->blocker_bag)
		$boxType = TYPE_TERMINAL_RESERVED;

	if ($boxType == TYPE_LIFT && !$row->z)
		$boxType = TYPE_ACCESS;

	if (($boxType == TYPE_ASSEMBLY_LINE || $boxType == TYPE_ACCESS) && $row->blocker_bag)
		$boxType = TYPE_ASSEMBLY_LINE_RESERVED;
	elseif ($boxType == TYPE_SHELF || $boxType == TYPE_TERMINAL || $boxType == TYPE_TERMINAL_RESERVED)
		$newZ++;

	if ($boxType == TYPE_SHELF && $row->blocker_bag)
		$boxType = $row->bag_id ? TYPE_SHELF_USED : TYPE_SHELF_RESERVED;

	// place the segment
	if ($boxType != TYPE_SHELF_USED) {
		putSegment($row->x, $row->y, $newZ, $boxType, $row->z % 2);
	}

	// there is a bag here => place it
	if ($row->bag_id) {
		if ($useAnimations != 'true' || $boxType == TYPE_SHELF_USED) {
			putSegment($row->x, $row->y, $row->z + 1, $row->bag_id == $markedBag ? TYPE_BAG_MARKED : TYPE_BAG);
		}

		if ($labels == 'true') {
			createText($row->x, $row->y, $row->z + 1, $row->bag_id);
		}
	}

}
$result->closeCursor();

// label the terminals
createText(0, 1, 1, $lang['terminal'] . ' 1');
createText(0, 5, 1, $lang['terminal'] . ' 2');
createText(0, 9, 1, $lang['terminal'] . ' 3');
createText(0, 13, 1, $lang['terminal'] . ' 4');
createText(0, 17, 1, $lang['terminal'] . ' 5');
createText(0, 21, 1, $lang['terminal'] . ' 6');
createText(0, 25, 1, $lang['terminal'] . ' 7');
createText(0, 29, 1, $lang['terminal'] . ' 8');

// show stats
if ($stats == 'true') {
	// total shelves
	$query = "SELECT COUNT(*) AS shelves
		FROM " . VIEW_BAG_IMAGE . " 
		WHERE (seg_type = " . TYPE_SHELF . ")";
	$result = $db->query($query);
	$row = $result->fetchObject();
	$result->closeCursor();
	$shelves = $row->shelves;

	// unused shelves
	$query = "SELECT COUNT(*) AS unused_shelves
		FROM " . VIEW_BAG_IMAGE . " 
		WHERE (seg_type = " . TYPE_SHELF . " && ISNULL(blocker_bag))";
	$result = $db->query($query);
	$row = $result->fetchObject();
	$result->closeCursor();
	$unused_shelves = $row->unused_shelves;

	// used shelves
	$query = "SELECT COUNT(*) AS used_shelves
		FROM " . VIEW_BAG_IMAGE . " 
		WHERE (seg_type = " . TYPE_SHELF . " && !ISNULL(blocker_bag) && !ISNULL(bag_id))";
	$result = $db->query($query);
	$row = $result->fetchObject();
	$result->closeCursor();
	$used_shelves = $row->used_shelves;

	// reserved shelves
	$query = "SELECT COUNT(*) AS reserved_shelves
		FROM " . VIEW_BAG_IMAGE . " 
		WHERE (seg_type = " . TYPE_SHELF . " && !ISNULL(blocker_bag))";
	$result = $db->query($query);
	$row = $result->fetchObject();
	$result->closeCursor();
	$reserved_shelves = $row->reserved_shelves;

	// reserved terminals
	$query = "SELECT COUNT(*) AS reserved_terminals
		FROM " . VIEW_BAG_IMAGE . " 
		WHERE (seg_type = " . TYPE_TERMINAL . " && !ISNULL(blocker_bag))";
	$result = $db->query($query);
	$row = $result->fetchObject();
	$result->closeCursor();
	$reserved_terminals = $row->reserved_terminals;

	$incoming_bags = $reserved_shelves - $used_shelves;
	$workload = number_format((float) round(($used_shelves * 100) / $shelves, 2), 2, '.', '');

	$msg = $lang['workload'] . ': ' . $workload . '% [+' . $incoming_bags . '][-' . $reserved_terminals . '][=' . $used_shelves . '/' . $shelves . ']';
	createText(19, 32, 0, $msg, 3);
}

// set header for png
header("Content-Type: image/png");
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Sat, 26 Jul 1997 05:00:00 GMT");

// render time
$renderTime = @$_REQUEST['rtime'];

if ($renderTime == 'true') {
	$timeEnd = microtime(true);
	$renderTime = number_format((float) round($timeEnd - $timeStart, 6), 6, '.', '');
	createText(3, 32, 0, $lang['render_time'] . ': ' . $renderTime . 's', 3);
}

// terminate database connection
@$db = null;

// print the image
imagepng($img);
imagedestroy($img);
?>