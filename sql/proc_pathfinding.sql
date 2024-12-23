################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script does the pathfinding for the bags.
################################################################################

DELIMITER $$
################################################################################
#
# This procedure checks, if a given bag is allowed to pass on a given segment.
#
# @param	succSeg		the ID of the possible successor
# @param	bagId		the ID of the bag wanting to use the segment succSeg
# @return				the boolean result, if the bag is allowed to use it
################################################################################
DROP PROCEDURE IF EXISTS `checkSucc` $$
CREATE PROCEDURE `checkSucc`( IN succSeg INT, IN bagId INT, OUT isFree BOOLEAN )
BEGIN

	# get the information about the usage and reservation of this segment
	SELECT bag_id, blocker_bag
		FROM `segment`
		WHERE ( seg_id = succSeg )
		INTO @succSegBag, @blockerBag;

	IF ( ISNULL( @succSegBag ) && ( ISNULL( @blockerBag ) || @blockerBag = bagId ) ) THEN
		SET isFree = TRUE;
	ELSE
		SET isFree = FALSE;
	END IF;
END $$
################################################################################
#
# This procedure checks, if a given bag is allowed to pass on the next segment
# of his way.
#
# @param	bagId		the ID of the bag that shall be moved
# @param	succSeg		the ID of the segment where the bag shall be moved to
################################################################################
DROP PROCEDURE IF EXISTS `getSucc` $$
CREATE PROCEDURE `getSucc`( IN bagId INT )
BEGIN
	# variable declarations
	## number of successors
	DECLARE succNum TINYINT DEFAULT 0;
	## ID of the current segment
	DECLARE srcSeg INT;
	## ID of the destination segment
	DECLARE destSeg INT;
	## ID of the successor segment
	DECLARE succSeg INT;
	## iterator checker
	DECLARE entryFound BOOLEAN DEFAULT TRUE;
	# cursor declarations
	## get southern successor
	DECLARE succSouthCursor CURSOR FOR
		SELECT dest_seg
			FROM `connection` c
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src_seg = srcSeg && dest.y = @srcY + 1 );
	## get western successor
	DECLARE succWestCursor CURSOR FOR
		SELECT dest_seg
			FROM `connection` c
			INNER JOIN `segment` dest
				ON ( c.dest_seg = dest.seg_id )
			WHERE ( src_seg = srcSeg && dest.x = @srcX - 1 );
	# handler declarations
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET entryFound = FALSE;

	# get data of current segment
	SELECT seg_id, seg_type, x, y
		FROM `segment`
		WHERE ( bag_id = bagId )
		LIMIT 1
		INTO srcSeg, @srcType, @srcX, @srcY;
	
	# get ID of destination segment
	SELECT dest_seg
		FROM `bag`
		WHERE ( bag_id = bagId )
		INTO destSeg;

	IF ( srcSeg != destSeg ) THEN
		# get number of successors and first successor
		SELECT COUNT( * ) num, dest_seg
			FROM `connection`
			WHERE ( src_seg = srcSeg )
			GROUP BY src_seg
			INTO succNum, succSeg;


		# multiple successors have been found
		IF ( succNum > 1 ) THEN
			# get the bag's destination
			SELECT src.z, dest.x, dest.y, dest.z, l.label_id, l.label_type, l.label_number
				FROM `bag` b
				INNER JOIN `segment` src
					ON ( src.bag_id = bagId )
				INNER JOIN `segment` dest
					ON ( b.dest_seg = dest.seg_id )
				INNER JOIN `label` l
					ON ( dest.label_id = l.label_id )
				WHERE ( b.bag_id = bagId )
				INTO @srcZ, @destX, @destY, @destZ, @labelId, @labelType, @labelNumber;
				
			# get the one with matching destination
			SELECT dest_seg
				FROM `connection` c
				INNER JOIN `destination` cd
					USING ( con_id )
				WHERE ( src_seg = srcSeg && label_id = @labelId )
				INTO succSeg;

			# if no successor has a matching destination defined, keep searching
			IF ( NOT entryFound ) THEN
				SET entryFound = TRUE;

				# checking, if the bag's current destination is a shelf
				IF ( @labelType = 's' ) THEN
					# move south until bag is to the east of the lift
					IF ( @srcY < @destY ) THEN
						# get southern successor
						OPEN succSouthCursor;
						FETCH succSouthCursor INTO succSeg;
						CLOSE succSouthCursor;
					# move on the lift
					ELSEIF ( @srcX > @destX + 1 ) THEN
						OPEN succWestCursor;
						FETCH succWestCursor INTO succSeg;
						CLOSE succWestCursor;
					# move upward while being on the lift
					ELSEIF ( @srcZ < @destZ ) THEN
						# get upward successor
						SELECT dest_seg
							FROM `connection` c
							INNER JOIN `segment` dest
								ON ( c.dest_seg = dest.seg_id )
							WHERE ( src_seg = srcSeg && dest.z = @srcZ + 1 )
							INTO succSeg;
					# move into the shelf
					ELSEIF ( @srcZ = @destZ && @srcX > @destX ) THEN
						# get west successor
						OPEN succWestCursor;
						FETCH succWestCursor INTO succSeg;
						CLOSE succWestCursor;
					END IF;
				# checking, if the bag's current destination is a terminal
				ELSEIF ( @labelType = 't' ) THEN
					# move downward while being on the lift
					IF ( @srcZ > @destZ ) THEN
						# get downward successor
						SELECT dest_seg
							FROM `connection` c
							INNER JOIN `segment` dest
								ON ( c.dest_seg = dest.seg_id )
							WHERE ( src_seg = srcSeg && dest.z = @srcZ - 1 )
							INTO succSeg;
					# move off the lift
					ELSEIF ( @srcZ = @destZ && @srcType = 1 ) THEN
						# get eastern successor
						SELECT dest_seg
							FROM `connection` c
							INNER JOIN `segment` dest
								ON ( c.dest_seg = dest.seg_id )
							WHERE ( src_seg = srcSeg && dest.x = @srcX + 1 )
							INTO succSeg;
					# move south until not further possible
					ELSE
						# get southern successor
						OPEN succSouthCursor;
						FETCH succSouthCursor INTO succSeg;
						CLOSE succSouthCursor;
					END IF;
				END IF;
			END IF;
		END IF;
		
		# debug information
		CALL put_line( CONCAT( 'bag_id: ', bagId, ', dest_seg: ', destSeg, ', src_seg: ', srcSeg, ', succ_seg: ', succSeg ) );
		
		START TRANSACTION;
		
			# check if the successor is free to use
			CALL checkSucc( succSeg, bagId, @isFree );

			# check the segment east of the lift for usage and reservations
			IF ( @isFree && @srcType = 3 ) THEN
				# get its ID
				SELECT seg_id
					FROM `segment`
					WHERE ( x = @srcX + 2 && y = @srcY && z = 0 )
					INTO @eastLiftSeg;

				# the check
				CALL checkSucc( @eastLiftSeg, bagId, @isFree );
			END IF;
			
			
			IF ( @isFree ) THEN
				# get successor type
				SELECT seg_type
					FROM `segment`
					WHERE ( seg_id = succSeg )
					INTO @succType;
			

				# free the formerly used segments
				UPDATE `segment`
					SET bag_id = NULL
					WHERE ( bag_id = bagId );
				# move the bag from one segment to the next
				UPDATE `segment`
					SET bag_id = bagId
					WHERE ( seg_id = succSeg );
				
				# check, if destination has been reached
				IF ( destSeg = succSeg ) THEN
					# get the destination segment's type
					SELECT seg_type, blocker_bag
						FROM `segment`
						WHERE ( seg_id = destSeg )
						INTO @destType, @destBlocker;

					# reaching reserved shelf box
					IF ( @destType = 3 && @destBlocker = bagId ) THEN
						# undo the reservations for lift
						UPDATE `segment`
							SET blocker_bag = NULL
							WHERE ( blocker_bag = bagId && seg_type != 3 );
					# reaching terminal
					ELSEIF ( @destType = 2 ) THEN
						# now delete the bag
						DELETE FROM `bag`
							WHERE ( bag_id = bagId );
					END IF;
				# check, if a shelf box just has been left => enter lift
				ELSEIF ( @srcType = 3 ) THEN
					# free the shelf box the bag just left
					UPDATE `segment`
						SET blocker_bag = NULL
						WHERE ( seg_id = srcSeg );
					
					# block the lift and the segment east of it so no other bag can use them while the current bag goes downward
					UPDATE `segment`
						SET blocker_bag = bagId
						WHERE ( 
							( x = @srcX + 1 && y = @srcY ) ||
							( x = @srcX + 2 && y = @srcY && z = 0 )
						 );
				# check, if a lift has been left towards terminal
				ELSEIF ( @srcType = 1 && @succType = 0 ) THEN
					# undo the reservations for lift and eastern segment
					UPDATE `segment`
						SET blocker_bag = NULL
						WHERE ( blocker_bag = bagId && seg_type != 2 );
				# check, if a lift has been entered towards shelf
				ELSEIF ( @srcType = 0 && @succType = 1 ) THEN
					# reserve the lift
					UPDATE `segment`
						SET blocker_bag = bagId
						WHERE ( x = @srcX - 1 && y = @srcY );
				END IF;
			END IF;
		
		COMMIT;
	END IF;
END $$
################################################################################
#
# This procedure moves all the bags that are not at their destinations yet one 
# step forward.
#
################################################################################
DROP PROCEDURE IF EXISTS `moveBags` $$
CREATE PROCEDURE `moveBags`()
BEGIN
	# variable declarations
	## the bag to be moved
	DECLARE bagId INT;
	## iterator checker
	DECLARE entryFound BOOLEAN DEFAULT TRUE;
	# cursor declarations
	## get the IDs of bags that are not at their destinations yet
	DECLARE bagsCursor CURSOR FOR
		SELECT b.bag_id
			FROM `bag` b
			INNER JOIN `segment` dest
				USING ( bag_id )
			WHERE ( b.dest_seg != dest.seg_id );

	# handler declarations
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET entryFound = FALSE;
	
	OPEN bagsCursor;
	
	WHILE ( entryFound ) DO
		FETCH bagsCursor INTO bagId;

		IF ( entryFound ) THEN
			# move the bag
			CALL getSucc( bagId );
		END IF;
	END WHILE;
	
	CLOSE bagsCursor;
END $$
################################################################################

DELIMITER ;