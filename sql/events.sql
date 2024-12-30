################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This is script adds the events used to move the bags forward and to delete 
# them when expired.
################################################################################

# ACTIVATE THE EVENT SCHEDULER
#SET GLOBAL event_scheduler = 1;

DELIMITER $$

################################################################################
# This event moves the bags forward every second.
################################################################################
DROP EVENT IF EXISTS `ev_moveBags` $$
CREATE EVENT `ev_moveBags`
	ON SCHEDULE
		EVERY 1 SECOND
	COMMENT 'Move the bags that are not at their destination yet.'
DO BEGIN

	CALL moveBags();
	
END $$
################################################################################
# This event deletes bags being in the cycle longer than five minutes.
################################################################################
DROP EVENT IF EXISTS `ev_24hLimit` $$
CREATE EVENT `ev_24hLimit`
	ON SCHEDULE
		EVERY 5 MINUTE
	COMMENT 'Delete every bag being in the cycle longer than five minutes.'
DO BEGIN

	# delete the expired bags
	DELETE FROM `bag`
		WHERE ( ABS( MINUTE ( NOW() ) - MINUTE ( bag_time ) ) >= 5 );

END $$
################################################################################
# This event automatically places and retrieves bags at random.
################################################################################
DROP EVENT IF EXISTS `ev_AutoMode` $$
CREATE EVENT `ev_AutoMode`
	ON SCHEDULE
		EVERY 3 SECOND
	DISABLE
	COMMENT 'Automatically place and retrieve bags at random.'
DO BEGIN

	# get number of terminals
	SELECT COUNT( * ) 
		FROM `segment`
		WHERE ( seg_type = 2 )
		INTO @terminals;

	# do a random event for every terminal except terminal 1
	SET @i = 2;
	WHILE ( @i < ( @terminals + 1 ) ) DO
	
		# randomizer
		SELECT FLOOR( RAND() * 4 )
			INTO @randomEvent;
			
		IF ( @randomEvent = 0 ) THEN
			CALL placeBag( @i );
		ELSEIF ( @randomEvent = 1 ) THEN
			CALL retrieveRandomBag( @i );
		END IF;
		
		SET @i = @i + 1;
	END WHILE;

END $$
################################################################################

DELIMITER ;