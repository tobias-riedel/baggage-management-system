<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-09-07
//
// This class contains the color information of segment for later use in the
// gd library.
//******************************************************************************
if (!defined('CLASS_COLORS')) {
	define('CLASS_COLORS', 1);

	//******************************************************************************
	class Colors {
		// fill colors
		private $fillRed;
		private $fillGreen;
		private $fillBlue;
		// fill alpha
		private $fillAlpha;
		
		// stroke colors
		private $strokeRed;
		private $strokeGreen;
		private $strokeBlue;
		// stroke alpha
		private $strokeAlpha;

		//******************************************************************************
		/**
		 * This method gets the values of members.
		 *
		 * @param	String		$var			the name of the member
		 * @return	mixed						the value for the member
		 */
		public function __get($var) {
			return $this->$var;
		}
		//******************************************************************************
		/**
		 * This method initializes the object's members.
		 *
		 * @param	String		$fillColor		hexadecimal number beginning with '#'
		 *										and having a length of 4 or 7 for the
		 *										fill color of a segment
		 * @param	String		$strokeColor	hexadecimal number beginning with '#'
		 *										and having a length of 4 or 7 for the
		 *										stroke color of a segment
		 * @param	integer		$fillAlpha		the alpha of the fill color (0 - 127)
		 *											0	=> no alpha
		 *											127	=> transparent
		 * @param	integer		$strokeAlpha	the alpha of the stroke color (0 - 127)
		 *											0	=> no alpha
		 *											127	=> transparent
		 */
		function __construct($fillColor = '#000', $strokeColor = '#FFF', $fillAlpha = 0, $strokeAlpha = 0) {
			
			// if fill color string is like '#FDA', convert it to '#FFDDAA'
			if (strlen($fillColor) == 4)
				$fillColor = $fillColor[0] . $fillColor[1] . $fillColor[1] . $fillColor[2] . $fillColor[2] . $fillColor[3] . $fillColor[3];
			// if stroke color string is like '#FDA', convert it to '#FFDDAA'
			if (strlen($strokeColor) == 4)
				$strokeColor = $strokeColor[0] . $strokeColor[1] . $strokeColor[1] . $strokeColor[2] . $strokeColor[2] . $strokeColor[3] . $strokeColor[3];

			// set the colors
			$this->fillRed = '0x' . $fillColor[1] . $fillColor[2];
			$this->fillGreen = '0x' . $fillColor[3] . $fillColor[4];
			$this->fillBlue = '0x' . $fillColor[5] . $fillColor[6];
			$this->strokeRed = '0x' . $strokeColor[1] . $strokeColor[2];
			$this->strokeGreen = '0x' . $strokeColor[3] . $strokeColor[4];
			$this->strokeBlue = '0x' . $strokeColor[5] . $strokeColor[6];
			
			// set alpha inside the limits of 0  and 127
			$fillAlpha = ($fillAlpha < 0) ? 0 : (($fillAlpha > 127) ? 127 : $fillAlpha) ;
			$strokeAlpha = ($strokeAlpha < 0) ? 0 : (($strokeAlpha > 127) ? 127 : $strokeAlpha) ;
			
			// set alpha values
			$this->fillAlpha = $fillAlpha;
			$this->strokeAlpha = $strokeAlpha;
		}
		//******************************************************************************
	}
	//******************************************************************************
}
?>