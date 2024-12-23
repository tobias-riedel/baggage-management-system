<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-07-17
//
// This is the web front-end of the system.
//******************************************************************************

include("config.inc.php");
include("constants.inc.php");
include("lang.inc.php");

// get action to perform
$_action = @$_REQUEST['action'];
// create default link
$link_query = "query.ajax.php";

// connect to database
$db = new PDO('mysql:host=' . CFG_DB_HOST . ';dbname=' . CFG_DB_NAME, CFG_DB_USER, CFG_DB_PWD);

// decide which action to do
switch ($_action) {
	case "placeBaggage":
		header('Content-type: text/html');
		try {
			$_id = @$_REQUEST['id'];
			
			// place the new baggage at a terminal
			$query = "CALL placeBag($_id);";
			$db->query($query);
			
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "getBaggageList":
		header('Content-type: text/html');
		
		// get all bags that are at their intended shelves
		$query = "SELECT * 
			FROM " . VIEW_BAG_LIST . " 
			ORDER BY bag_id;";
		// just some formatting
		$formated_query = str_replace("\n", "", str_replace("\r", "", str_replace("\t", "", $query)));

		try {		
			$result = $db->query($query);
			$num_rows = @$result->rowCount();
			
			echo "<BLIST>\n";
			echo "	<QUERY>$formated_query</QUERY>\n";
			echo "	<BAG_LIST>\n";
		
			if ($num_rows) {
				while ($row = $result->fetchObject()) {
					printf("	 							<option value=\"%d\">%05d</option>\n", $row->bag_id, $row->bag_id);
				}
				$result->closeCursor();
			} else {
				echo "	 							<option value=\"0\">({$lang['baggage_list_none']})</option>\n";
			}
			echo "	</BAG_LIST>\n";
			echo "	<ENABLE_SELECT>" . ($num_rows > 0) . "</ENABLE_SELECT>\n";
			echo "</BLIST>\n";
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "retrieveBaggage":
		header('Content-type: text/html');
		try {
			$bagId = @$_REQUEST['bagId'];
			
			if ($bagId) {
				$dest = $_REQUEST['dest'];
				
				if ($dest) {
					// retrieve the baggage
					$query = "CALL retrieveBag($bagId, $dest);";
					$db->query($query);
				}
				else {
					// no terminal selected
					$query = $lang['no_query'];
				}
			}
			else {
				// no baggage selected
				$query = $lang['no_query'];
			}

			// return answer
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "setEvent":
		header('Content-type: text/html');
		$_perform = @$_REQUEST['perform'];

		// get the new status for the event scheduler
		$_value = (@$_REQUEST['value'] || !$_action) ? 1 : 0;

		// choose the event to be set
		switch ($_perform) {
			// the event scheduler
			case "autoMode":
				$query = "CALL setEventAutoMode($_value);";
			break;
			// the event scheduler
			case "scheduler":
				$query = "CALL setEventScheduler($_value);";
			break;
			// the 24h-limit event
			case "24hLimit":
				$query = "CALL setEvent24hLimit($_value);";
			break;
			default:
		}

		try {
			$db->query($query);
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "getEvent":
		header('Content-type: text/xml');
		$_perform = @$_REQUEST['perform'];

		// choose the event to be checked
		switch ($_perform) {
			// the event scheduler
			case "scheduler":
				$query = "SELECT getEventScheduler() state;";
			break;
			// the 24h-limit event
			case "24hLimit":
				$query = "SELECT getEvent24hLimit() state;";
			break;
			// the auto-mode-limit event
			case "autoMode":
				$query = "SELECT getEventAutoMode() state;";
			break;
		}
		
		try {
			$result = $db->query($query);
			$event = $result->fetchObject();
			$result->closeCursor();
			
			// return answer
			echo "<EVENT>
					<QUERY>$query</QUERY>
					<STATE>$event->state</STATE>
				</EVENT>\n";
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "fillShelves":
		header('Content-type: text/html');
		try {
			$_num = @$_REQUEST['num'];
			
			// place the new baggage at a terminal
			$query = "CALL fill($_num);";
			$db->query($query);
			
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "discardBaggage":
		header('Content-type: text/html');
		try {
			// discard the baggage
			$query = "CALL discardBags();";
			$db->query($query);
			
			// return answer
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "moveBags":
		header('Content-type: text/html');
		try {
			$query = "CALL moveBags();";
			$db->query($query);
			echo $query;
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	case "animate":
		header('Content-type: text/html');
		try {
			// get all bags that are at their intended shelves
			$query = "SELECT s.* 
				FROM " . DT_BAG . " b
					INNER JOIN " . DT_SEGMENT . " s ON (b.bag_id = s.bag_id)
				WHERE (b.dest_seg != s.seg_id) 
				ORDER BY x ASC, y ASC";
			$result = $db->query($query);
		
			$text = "";
			
			echo "<BLIST>\n";
			echo "	<HTML>\n";
			echo "		<script type=\"text/javascript\">";
			if ($result->rowCount()) {
				$z_index = 1000;
				while ($row = $result->fetchObject()) {
					echo "putBag($row->bag_id, $row->x, $row->y, $row->z, " . SEG_WIDTH . ", " . SEG_HEIGHT . ", " . SEG_OFFSET_X . ", " . SEG_OFFSET_Y . ", " . ($z_index++) . ");\n";
					$text .= "$row->bag_id ($row->x, $row->y, $row->z) ";
				}
				$result->closeCursor();
			}

			echo "			flushBags();";
			echo "		</script>";		
			echo "	</HTML>\n";
			echo "	<QUERY>$text</QUERY>\n";
			echo "</BLIST>\n";
		} catch (PDOException $e) {
			echo $lang['database_error'] . ': ' . $e->getMessage();
		}
	break;
	default:
}

// close sql connection
$db = null;
?>