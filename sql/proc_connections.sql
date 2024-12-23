################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script provides the procedures to establish the connections between the
# segments.
################################################################################

DELIMITER $$

################################################################################
#
# This function deletes connections between segments in a direction given by a parameter.
#
# @param	coord	the coordinate to delete from
# @param	drct	the direction the connections are deleted for; possible values:
#						'n'	=>	North
#						'e'	=>	East
#						's'	=>	South
#						'w'	=>	West
#						'u'	=>	Up
#						'd'	=>	Down
#
################################################################################
DROP PROCEDURE IF EXISTS `delCons` $$
CREATE PROCEDURE `delCons`( IN coord MEDIUMINT, IN drct CHAR( 1 ) )
BEGIN
	# variable declarations
	## ID of the connection to be deleted
	DECLARE conId INT;
	## iterator checker
	DECLARE entryFound BOOLEAN DEFAULT TRUE;
	
	# cursor declarations
	## South cursor deleting all connections going South
	DECLARE delSouthCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.x = coord && dest.y = src.y + 1 );
	## North cursor deleting all connections going North
	DECLARE delNorthCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.x = coord && dest.y = src.y - 1 );
	## East cursor deleting all connections going East
	DECLARE delEastCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.y = coord && dest.x = src.x + 1 );
	## West cursor deleting all connections going West
	DECLARE delWestCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.y = coord && dest.x = src.x - 1 );
	## up cursor deleting all connections going up
	DECLARE delUpCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.x = coord && dest.z = src.z + 1 );
	## down cursor deleting all connections going down
	DECLARE delDownCursor CURSOR FOR
		SELECT con_id
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src.x = coord && src.z > 0 && dest.z = src.z - 1 );
	
	# handler declarations
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET entryFound = FALSE;

	IF ( drct = 's' ) THEN OPEN delSouthCursor;
		ELSEIF ( drct = 'n' ) THEN OPEN delNorthCursor;
		ELSEIF ( drct = 'e' ) THEN OPEN delEastCursor;
		ELSEIF ( drct = 'w' ) THEN OPEN delWestCursor;
		ELSEIF ( drct = 'u' ) THEN OPEN delUpCursor;
		ELSEIF ( drct = 'd' ) THEN OPEN delDownCursor;
	END IF;
	
	WHILE ( entryFound ) DO
		# get ID of the connection to be deleted
		IF ( drct = 's' ) THEN FETCH delSouthCursor INTO conId;
			ELSEIF ( drct = 'n' ) THEN FETCH delNorthCursor INTO conId;
			ELSEIF ( drct = 'e' ) THEN FETCH delEastCursor INTO conId;
			ELSEIF ( drct = 'w' ) THEN FETCH delWestCursor INTO conId;
			ELSEIF ( drct = 'u' ) THEN FETCH delUpCursor INTO conId;
			ELSEIF ( drct = 'd' ) THEN FETCH delDownCursor INTO conId;
		END IF;

		IF ( entryFound ) THEN
			DELETE FROM `connection`
				WHERE ( con_id = conId );
		END IF;
	END WHILE;
	
	IF ( drct = 's' ) THEN CLOSE delSouthCursor;
		ELSEIF ( drct = 'n' ) THEN CLOSE delNorthCursor;
		ELSEIF ( drct = 'e' ) THEN CLOSE delEastCursor;
		ELSEIF ( drct = 'w' ) THEN CLOSE delWestCursor;
		ELSEIF ( drct = 'u' ) THEN CLOSE delUpCursor;
		ELSEIF ( drct = 'd' ) THEN CLOSE delDownCursor;
	END IF;
END $$
################################################################################
#
# This function adds specific destination values for specific connections.
#
# @param	srcX		the X positon of the source segment
# @param	srcY		the Y positon of the source segment
# @param	srcZ		the Z positon of the source segment
# @param	destX		the X positon of the destination segment
# @param	destY		the Y positon of the destination segment
# @param	destZ		the Z positon of the destination segment
# @param	destType	the type of the destination segment
#							's' => shelf
#							't' => terminal
# @param	destId		the ID of the destination segment
#
################################################################################
DROP PROCEDURE IF EXISTS `setConDest` $$
CREATE PROCEDURE `setConDest`( IN srcX MEDIUMINT, IN srcY MEDIUMINT, IN srcZ MEDIUMINT, IN destX MEDIUMINT, IN destY MEDIUMINT, IN destZ MEDIUMINT, IN destType CHAR( 1 ), IN destId TINYINT )
BEGIN
	# get the ID of the label of the destination
	CALL getLabel( destType, destId, @labelId );

	# insert the new destination to the related connection ID
	INSERT INTO `destination` ( `con_id`, `label_id` )
		# get the connection ID and add label ID
		SELECT con_id, @labelId
			FROM `connection` c
			INNER JOIN `segment` src
				ON ( c.src_seg = src.seg_id )
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( 
				( src.x = srcX ) && ( src.y = srcY ) && ( src.z = srcZ ) &&
				( dest.x = destX ) && ( dest.y = destY ) && ( dest.z = destZ )
			 );
END $$
################################################################################
#
# This function adds connections between neighboring segments.
#
###########################################################################
DROP PROCEDURE IF EXISTS `establishConnection` $$
CREATE PROCEDURE `establishConnection`()
BEGIN

	# clean connections datatable
	DELETE FROM `connection`;
	
	# connect source and destinations segments
	INSERT INTO `connection` ( src_seg, dest_seg ) 
		SELECT src.seg_id src_seg, dest.seg_id dest_seg
			FROM `segment` src
			INNER JOIN `segment` dest
				ON ( 
					# east connection
					( ( dest.x = src.x + 1 ) && ( dest.y = src.y ) && ( dest.z = src.z ) ) ||
					# west connection
					( ( dest.x = src.x - 1 ) && ( dest.y = src.y ) && ( dest.z = src.z ) ) || ( 
						 # north to south and reverse connections are only allowed for assembly lines ( seg_type 0 ) and terminal ( 2 )
						 ( src.seg_type = 0 || src.seg_type = 2 ) && ( 
							# south connection
							( ( dest.x = src.x ) && ( dest.y = src.y + 1 ) && ( dest.z = src.z ) ) ||
							# north connection
							( ( dest.x = src.x ) && ( dest.y = src.y - 1 ) && ( dest.z = src.z ) )
						 )
					 ) || ( 
						# upward and downward connections for lifts ( 1 ) only
						dest.seg_type = 1 && ( 
							# upward connection
							( ( dest.x = src.x ) && ( dest.y = src.y ) && ( dest.z = src.z + 1 ) ) ||
							# downward connection
							( ( dest.x = src.x ) && ( dest.y = src.y ) && (src.z > 0) && ( dest.z = src.z - 1 ) )
						 )
					 )
				 )
			ORDER BY src.z ASC, src.y ASC, src.x ASC;
END $$
################################################################################

DELIMITER ;