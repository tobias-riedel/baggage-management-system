<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-07-17
//
// This is the config file. Adjust to your needs.
//******************************************************************************



// load database configuration
$cfg = file_get_contents('config.cfg.php');
preg_match_all('/(?P<key>\w+)=(?P<value>\w*)/', $cfg, $matches);

$c = count($matches[1]);
for ($i = 0; $i < $c; $i++) {
	$cfg_key = $matches[1][$i];
	$cfg_val = $matches[2][$i];
	define('CFG_' . $cfg_key, $cfg_val);
}

//*****************************************************************************
// The following lines change the appearance of the image you will see in the 
// index.php. Feel free to experiment.
//*****************************************************************************
// set the dimensions of the displayed image (in pixel)
define('IMG_WIDTH', 630);
define('IMG_HEIGHT', 600);

// dimensions of one segment
define('SEG_WIDTH', 18);
define('SEG_HEIGHT', 18);
// the 3D offset of segment
define('SEG_OFFSET_X', 4);
define('SEG_OFFSET_Y', 4);

?>