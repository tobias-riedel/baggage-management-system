<?PHP
//******************************************************************************
// author:	Tobias Riedel
// date:	2008-07-17
//
// This is the web front-end of the system.
//******************************************************************************

// start session
session_start();

// get constants, config data, and language definitions
include("constants.inc.php");
include("config.inc.php");
include("lang.inc.php");

// include html header
include("header.html.php");

// create default links
$link_read_me = "<a href=\"readme.txt\" target=\"_blank\" title=\"{$lang['read_me']}\">{$lang['read_me']}</a>";

?>

	<fieldset id="discardBaggageDialog" class="dialog">
		<legend><img src="img/gui/application-exit.png" width="16" height="16" /> <?PHP echo $lang['discard_baggage']; ?></legend>
		<br/><?PHP echo $lang['confirm_discard_all_the_baggage']; ?><br/><br/>
		<button type="button" id="confirmDiscardBags" title="<?PHP echo $lang['ok']; ?>"><?PHP echo $lang['ok']; ?></button>
		<button type="button" id="cancelDiscardBags" title="<?PHP echo $lang['cancel']; ?>"><?PHP echo $lang['cancel']; ?></button>
	</fieldset>

	<fieldset id="databaseNotInstalledDialog" class="dialog">
		<legend><img src="img/gui/application-exit.png" width="16" height="16" /> <?PHP echo $lang['database_not_installed']; ?></legend>
		<br/><?PHP echo $lang['database_not_installed_see_read_me']; ?><br/><br/>
		[<?PHP echo $link_read_me; ?>] [<a href="#" onclick="window.location.reload()" title="<?PHP echo $lang['refresh']; ?>"><?PHP echo $lang['refresh']; ?></a>]
	</fieldset>
	
	<fieldset id="aboutDialog" class="dialog" style="width: 500px;">
		<legend>
			<img src="img/gui/view-media-artist.png" width="16" height="16" /> <?PHP echo $lang['about']; ?>
		</legend>
		
		<div style="padding: 5px 30px;">
			<div class="aboutDialogTitle"><?PHP echo $lang['baggage_management_system']; ?></div><br/>

			<div class="aboutDialogDescription"><?PHP echo $lang['author']; ?>:</div>
			<div class="aboutDialogContent">Tobias Riedel</div><br/>
			
			<div style="display: table; margin: auto;">
				<div style="float: left; padding-right: 20px;">
					<div class="aboutDialogDescription"><?PHP echo $lang['tutor']; ?>:</div>
					<div class="aboutDialogContent">Dr. Peter-Uwe Zettier</div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['institute']; ?>:</div>
					<div class="aboutDialogContent"><a href="http://cs.uni-potsdam.de/" target="_blank">Institut f&uuml;r Informatik</a><br/>
					<a href="http://www.uni-potsdam.de/" target="_blank">Universit&auml;t Potsdam</a> <img src="img/de.gif" alt="Germany" title="Germany"/></div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['date']; ?>:</div>
					<div class="aboutDialogContent">2008-09-19</div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['version']; ?>:</div>
					<div class="aboutDialogContent">1.6.0</div>
				</div><div style="float: left;">
					<div class="aboutDialogDescription"><?PHP echo $lang['lecture']; ?>:</div>
					<div class="aboutDialogContent">Datenbankpraktikum</div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['documentation']; ?>:</div>
					<div class="aboutDialogContent"><a href="doc/bms.pdf" target="_blank" title="<?PHP echo $lang['white_paper']; ?>"><?PHP echo $lang['white_paper']; ?></a></div>
					<div class="aboutDialogContent"><?PHP echo $link_read_me; ?></div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['modified']; ?>:</div>
					<div class="aboutDialogContent">2015-06-16</div><br/>
					
					<div class="aboutDialogDescription"><?PHP echo $lang['archived_screenshots']; ?>:</div>
					<div class="aboutDialogContent">
						[<a href="img/screenshots/bms-v1.1.0.png" target="screenshots">1.1.0</a>]
						[<a href="img/screenshots/bms-v1.4.0.png" target="screenshots">1.4.0</a>]
						[<a href="img/screenshots/bms-v1.5.0.png" target="screenshots">1.5.0</a>]
					</div>
				</div><div style="clear: both;"></div><br/>
			</div><br/>
				
			<div style="text-align: center"><button type="button" id="btnCloseAboutDialog" title="<?PHP echo $lang['close']; ?>"><?PHP echo $lang['close']; ?></button></div>
		</div>
	</fieldset>
	
	<div id="content">
		<div id="pageTitle"><?PHP echo $lang['baggage_management_system']; ?></div><br/>
	
		<fieldset id="bagImgs" data-fieldset-id="bagImage">
			<legend><img src="img/gui/favicon.png" width="16" height="16" /> <?PHP echo $lang['baggage_management_system']; ?></legend>
			
			<div style="display: table;">
				<div style="display: table-cell; vertical-align: middle;">
					
					<?PHP echo "<img id=\"bagImg\" width=\"" . IMG_WIDTH . "\" height=\"" . IMG_HEIGHT . "\" src=\"bags.img.php\" />\n"; ?>
					<input type="image" class="terminalImg popupAnchor" value="1" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 55px;"/>
					<input type="image" class="terminalImg popupAnchor" value="2" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 127px;"/>
					<input type="image" class="terminalImg popupAnchor" value="3" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 199px;"/>
					<input id="terminal4" type="image" class="terminalImg popupAnchor" value="4" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 271px;"/>
					<input type="image" class="terminalImg popupAnchor" value="5" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 343px;"/>
					<input type="image" class="terminalImg popupAnchor" value="6" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 415px;"/>
					<input type="image" class="terminalImg popupAnchor" value="7" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 487px;"/>
					<input type="image" class="terminalImg popupAnchor" value="8" src="img/terminal.png" width="29" height="29" style="POSITION: absolute; LEFT: 18px; TOP: 559px;"/>
					<div id="bagsScript"></div>
					<div id="bags"></div>
					
					<fieldset id="getBaggage" class="popup">
						<legend>
							<img src="img/gui/arrow-up-double.png" width="16" height="16" /> <?PHP echo $lang['place_get_baggage']; ?>
							<img src="img/gui/help-about.png" class="help" width="16" height="16" title="<?PHP echo $lang['help_place_get_baggage']; ?>" alt="<?PHP echo $lang['help'] ?>" />
						</legend>

						<div style="float: left; text-align: center;">
							<b><?PHP echo $lang['bag_id']; ?></b><br/>
							<select id="bagList" name="bagId" SIZE="7"></select><br/>
							<input type="number" value="100" id="inputFillShelves" SIZE="3" style="width: 39px;" />
							<input type="image" id="buttonFillShelves" title="<?PHP echo $lang['add_amount_of_bags']; ?>" src="img/gui/list-add-global.png" width="16" height="16" />
						</div><div style="float: left; padding-left: 10px; text-align: center;">
							<b>T-<span id="terminalNumber"></span></b><br/>
							<input type="image" id="buttonBaggageList" title="<?PHP echo $lang['press_to_get_list_of_currently_stored_baggage']; ?>" src="img/gui/refresh.png" width="32" height="32" /><br/>
							<input type="image" id="addBag" title="<?PHP echo $lang['place_new_baggage']; ?>" src="img/gui/list-add.png" width="32" height="32" /><br/>
							<input type="image" id="getBag" title="<?PHP echo $lang['retrieve_baggage_from_shelf']; ?>" src="img/gui/list-remove-disabled.png" width="32" height="32" disabled /><br/>
							<input type="image" id="discardBags" title="<?PHP echo $lang['press_to_discard_all_the_baggage']; ?>" src="img/gui/process-stop.png" width="32" height="32" />
						</div><div style="clear: both;"></div>
						
					</fieldset>
					
					<span id="terminal4Bubble" class="bubble" style="display: none; z-index: 2001; width: 200px;"><?PHP echo $lang['click_here_to_place_bag']; ?></span>
				
				</div><div style="display: table-cell; vertical-align: middle; padding-right: 10px;">
					<span id="ctrlElems">
						<div class="controlElements" style="text-align: left;">
							<input type="image" id="btnScheduler" src="img/gui/media-play.png" width="22" height="22"  title="<?PHP echo $lang['event_scheduler']; ?>" alt="<?PHP echo $lang['event_scheduler']; ?>" value="1" /><br/>
							<input type="image" id="btnNextStep" src="img/gui/media-next.png" width="22" height="22"  title="<?PHP echo $lang['proceed_one_step']; ?>" alt="<?PHP echo $lang['proceed_one_step']; ?>" value="1" /><br/>
							<input type="image" id="btnAutoMode" src="img/gui/media-repeat.png" width="22" height="22"  title="<?PHP echo $lang['auto_mode']; ?>" alt="<?PHP echo $lang['auto_mode']; ?>" value="0" /><br/>
							<input type="image" id="btn24hLimit" src="img/gui/24h.png" width="22" height="22"  title="<?PHP echo $lang['24h_limit']; ?>" alt="<?PHP echo $lang['24h_limit']; ?>" value="1" />
						</div><br/><br/>
						<div class="controlElements" style="text-align: left;">
							<input type="image" id="btn3d" src="img/gui/3d.png" width="22" height="22"  title="<?PHP echo $lang['use_3d']; ?>" alt="<?PHP echo $lang['use_3d']; ?>" value="1" /><br/>
							<input type="image" id="btnBaggageIDs" src="img/gui/id.png" width="22" height="22"  title="<?PHP echo $lang['show_baggage_ids']; ?>" alt="<?PHP echo $lang['show_baggage_ids']; ?>" value="0" /><br/>
							<input type="image" id="btnRenderTime" src="img/gui/render-time.png" width="22" height="22"  title="<?PHP echo $lang['show_render_time']; ?>" alt="<?PHP echo $lang['show_render_time']; ?>" value="0" /><br/>
							<input type="image" id="btnStatistics" src="img/gui/statistics.png" width="22" height="22"  title="<?PHP echo $lang['show_statistics']; ?>" alt="<?PHP echo $lang['show_statistics']; ?>" value="1" /><br/>

							<input type="image" id="btnAnimations" src="img/gui/animations.png" class="popupAnchor" width="22" height="22"  title="<?PHP echo $lang['use_animations']; ?>" alt="<?PHP echo $lang['use_animations']; ?>" value="1" />
							<fieldset id="animationIconsPopup" class="popup" style="z-index: 2001; width: 140px;">
								<legend><?PHP echo $lang['animation_icons']; ?></legend>
								<input type="radio" name="animationIcon" id="bagIconRandom" value="random" disabled checked /><label for="bagIconRandom"> <img src="img/random.png" width="18" height="18" /></label>
								<input type="radio" name="animationIcon" id="bagIcon1" value="img/bag_green_block.png" disabled /><label for="bagIcon1"> <img src="img/bag_green_block.png" width="18" height="18" /></label>
								<input type="radio" name="animationIcon" id="bagIcon5" value="img/bag_colored.png" disabled /><label for="bagIcon5"> <img src="img/bag_colored.png" width="18" height="18" /></label><br/>
								<input type="radio" name="animationIcon" id="bagIcon2" value="img/bag_black.png" disabled /><label for="bagIcon2"> <img src="img/bag_black.png" width="18" height="18" /></label>
								<input type="radio" name="animationIcon" id="bagIcon3" value="img/bag_brown.png" disabled /><label for="bagIcon3"> <img src="img/bag_brown.png" width="18" height="18" /></label>
								<input type="radio" name="animationIcon" id="bagIcon4" value="img/bag_brown2.png" disabled /><label for="bagIcon4"> <img src="img/bag_brown2.png" width="18" height="18" /></label>
							</fieldset>
						</div><br/><br/>
						<div class="controlElements" style="text-align: left;">
							<img id="btnPreferences" src="img/gui/preferences.png" class="popupAnchor" width="22" height="22"  title="<?PHP echo $lang['preferences']; ?>" alt="<?PHP echo $lang['preferences']; ?>" /><br/>
							<fieldset id="preferencesPopup" class="popup" style="width: 140px;">
								<legend><?PHP echo $lang['preferences']; ?></legend>
								<input type="checkbox" value="1" id="checkboxShowHelpBubbles" checked /><label for="checkboxShowHelpBubbles"> <?PHP echo $lang['show_help_bubbles']; ?></label><br/>
								<input type="checkbox" value="1" id="checkboxShowQueries" checked /><label for="checkboxShowQueries"> <?PHP echo $lang['show_queries']; ?></label><br/>
								<?PHP echo $lang['theme']; ?>:<br/>
								<select id="slctTheme">
									<option value="bms_light">Light</option>
									<option value="bms_dark">Dark</option>
								</select><br/>
								<?PHP echo $lang['render_style']; ?>:<br/>
								<select id="slctRenderStyle">
									<option value="rect"><?PHP echo $lang['rectangles']; ?></option>
									<option value="circle"><?PHP echo $lang['circles']; ?></option>
								</select>
								<br/><br/>
								
								<button type="button" value="1" id="buttonResetUI"><?PHP echo $lang['reset_gui']; ?></button>
							</fieldset>
							
							<input type="image" id="btnAbout" src="img/gui/about.png" width="22" height="22"  title="<?PHP echo $lang['about']; ?>" alt="<?PHP echo $lang['about']; ?>" />
						</div>
					</span>
					<span class="bubble" id="ctrlElemsBubble" style="display: none; z-index: 2001; width: 230px;"><?PHP echo $lang['use_these_buttons_to_control_the_systems_behavior']; ?></span>
				</div>
			</div>
		</fieldset><br/>
		
		<fieldset data-fieldset-id="queries">
			<legend id="linkLog">
				<img src="img/gui/applications-utilities.png" width="16" height="16" /> <?PHP echo $lang['queries']; ?>
				<input type="image" id="btnLogFontSizeUp" src="img/gui/arrow-up.png" width="16" height="16"  title="<?PHP echo $lang['increase_font_size']; ?>" alt="+" />
				<input type="image" id="btnLogFontSizeDown" src="img/gui/arrow-down.png" width="16" height="16"  title="<?PHP echo $lang['decrease_font_size']; ?>" alt="-" />
				<img src="img/gui/help-about.png" class="help" width="16" height="16" title="<?PHP echo $lang['help_queries']; ?>" alt="<?PHP echo $lang['help'] ?>" />
				<input id="btnCloseQueries" type="image" src="img/gui/application-exit.png" width="16" height="16" title="<?PHP echo $lang['close']; ?>" alt="<?PHP echo $lang['close']; ?>"/>
			</legend>
			<textarea id="log" name="log" style="width: 98%;" rows="7" readonly></textarea>
		</fieldset><br/>

	</div>

<?PHP
// check database connection
try {
	$db = new PDO('mysql:host=' . CFG_DB_HOST . ';dbname=' . CFG_DB_NAME, CFG_DB_USER, CFG_DB_PWD);
	$db = null;
} catch (PDOException $e) {
	// Database not installed properly. Send message to user.
?>
	<script type="text/javascript">
		$('#databaseNotInstalledDialog').showDialog(false);
	</script>
<?PHP
}

// include html footer
include("footer.html.php");
?>