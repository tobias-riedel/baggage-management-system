################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script handles bag placement und retrieval.
################################################################################

DELIMITER $$

################################################################################
#
# This procedure adds a new bag to the system.
#
# @param	labelNumber		the ID of the terminal where teh bag is placed
#
################################################################################
DROP PROCEDURE IF EXISTS `placeBag` $$
CREATE PROCEDURE `placeBag`( IN labelNumber INT )
BEGIN

	# get the ID of the terminal where the bag shall start its journey
	CALL getLabel( 't', labelNumber, @labelId );
	SELECT seg_id
		FROM `segment`
		WHERE ( label_id = @labelId )
		INTO @termSegId;

	# check, if the terminal is free
	CALL checkSucc( @termSegId, NULL, @isFree );

	IF ( @isFree ) THEN
		# get a random free shelf box
		SELECT seg_id
			FROM `segment`
			WHERE ( seg_type = 3 && ISNULL( blocker_bag ) )
			ORDER BY RAND()
			LIMIT 1
			INTO @destSeg;

		# check, if the destined shelf box really is free
		CALL checkSucc( @destSeg, NULL, @isFree );

		IF ( @isFree ) THEN
			# insert the new bag with its destination and current timestamp
			INSERT INTO `bag` ( `dest_seg`, `bag_time` ) VALUES( @destSeg, NOW() );
			
			# get the ID of the new bag
			SELECT bag_id
				FROM `bag`
				WHERE ( dest_seg = @destSeg )
				INTO @newBagId;
			
			# place the bag at the given terminal
			UPDATE `segment`
				SET bag_id = @newBagId
				WHERE seg_id = @termSegId;
			
			# reserve the shelf box for the bag
			UPDATE `segment`
				SET blocker_bag = @newBagId
				WHERE ( seg_id = @destSeg );

			# debug information
			CALL put_line( CONCAT( 'Baggage ( bag_id ', @newBagId, ' ) placed at terminal #', labelNumber, ' ( seg_id ', @termSegId, ' ). Destination shelf has seg_id ', @destSeg, '.' ) );
		ELSE
			# debug information
			CALL put_line( CONCAT( 'Cannot place baggage! There is no more shelf left to store it!' ) );
		END IF;
	ELSE
		# debug information
		CALL put_line( CONCAT( 'Cannot place baggage! Terminal ', labelNumber, ' ( seg_id ', @termSegId, ' ) is not free!' ) );
	END IF;
	
END $$
################################################################################
#
# This procedure initiates the retrieval of a bag from a shelf to a terminal.
#
# @param	bagId			the ID of the bag that shall be retrieved
# @param	labelNumber		the ID of the terminal where the bag shall be brought to
#
################################################################################
DROP PROCEDURE IF EXISTS `retrieveBag` $$
CREATE PROCEDURE `retrieveBag`( IN bagId INT, IN labelNumber INT )
BEGIN

	# get terminal ID
	CALL getLabel( 't', labelNumber, @labelId );
	SELECT seg_id
		FROM `segment`
		WHERE ( label_id = @labelId )
		INTO @destSeg;

	# check, if the destined terminal is really free
	CALL checkSucc( @destSeg, NULL, @isFree );
	
	IF ( @isFree ) THEN
		# reserve terminal for bag
		UPDATE `segment`
			SET blocker_bag = bagId
			WHERE ( seg_id = @destSeg );

		# set new course for bag
		UPDATE `bag`
			SET dest_seg = @destSeg
			WHERE ( bag_id = bagId );

		# debug information
		#CALL put_line( CONCAT( 'Baggage ( bag_id ', bagId, ' ) is on its way to terminal #', labelNumber, ' ( seg_id ', @destSeg, ' ).' ) );
	ELSE
		# debug information
		CALL put_line( CONCAT( 'Cannot retrieve baggage ( bag_id ', bagId, ' ) from terminal #', labelNumber, ' ( seg_id ', @destSeg, ' ). Terminal is blocked or reserved.' ) );
	END IF;

END $$
################################################################################
#
# This procedure discards all the baggage.
#
################################################################################
DROP PROCEDURE IF EXISTS `discardBags` $$
CREATE PROCEDURE `discardBags`()
BEGIN
	# get rid of the bags
	DELETE FROM `bag`;
	
	# debug information
	CALL put_line( CONCAT( 'Discarded all the baggage.' ) );
END $$
################################################################################
#
# This procedure returns the ID of a random, free terminal.
#
# @return	the label number of the free terminal
#
################################################################################
DROP PROCEDURE IF EXISTS `getRandomFreeTerminal` $$
CREATE PROCEDURE `getRandomFreeTerminal`( OUT terminalId INT )
BEGIN

	SELECT l.label_number
		FROM `label` l
		INNER JOIN `segment` s ON ( s.label_id = l.label_id )
		WHERE ( ISNULL( s.bag_id ) && s.seg_type = 2 )
		ORDER BY RAND()
		LIMIT 1
		INTO terminalId;
	
END $$
################################################################################
#
# This procedure places one bag at a random terminal.
#
################################################################################
DROP PROCEDURE IF EXISTS `placeRandomBag` $$
CREATE PROCEDURE `placeRandomBag`()
BEGIN
	CALL getRandomFreeTerminal( @terminalId );
	CALL placeBag( @terminalId );
END $$
################################################################################
#
# This procedure retrieves one random bag from the shelves.
#
################################################################################
DROP PROCEDURE IF EXISTS `retrieveRandomBag` $$
CREATE PROCEDURE `retrieveRandomBag`( IN terminalId INT )
BEGIN

	# get a random bag from a shelf
	SELECT bag_id
		FROM `segment`
		WHERE ( seg_type = 3 && !ISNULL( blocker_bag ) )
		ORDER BY RAND()
		LIMIT 1
		INTO @bagId;

	CALL retrieveBag( @bagId, terminalId );
END $$
################################################################################

DELIMITER ;