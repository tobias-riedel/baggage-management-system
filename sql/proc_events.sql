################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script provides procedures the set und get the state of events and the 
# event scheduler.
################################################################################


DELIMITER $$

################################################################################
#
# This function returns the status of event scheduler.
#
# @return	the state of the event scheduler
#				0 => off
#				1 => on
#
################################################################################
DROP FUNCTION IF EXISTS `getEventScheduler` $$
CREATE FUNCTION `getEventScheduler`() RETURNS TINYINT
BEGIN
	# get the current state of the event scheduler
	SELECT @@event_scheduler
		INTO @state;
	
	# convert the result from CHAR to INT
	IF ( @state = 'ON' ) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	
END $$
################################################################################
#
# This function turns the event scheduler on or off.
#
# @param	value	the value to set the event scheduler to
#						0 => off
#						1 => on
#
################################################################################
DROP PROCEDURE IF EXISTS `setEventScheduler` $$
CREATE PROCEDURE `setEventScheduler`( IN value TINYINT )
BEGIN
	
	IF ( value ) THEN
		SET GLOBAL event_scheduler = 1;
	ELSE
		SET GLOBAL event_scheduler = 0;
	END IF;
	
	# debug information
	CALL put_line( CONCAT( 'State of the event scheduler: ', if(getEventScheduler(), 1 , 0) ) );

END $$
################################################################################
#
# This function returns the status of the 24-hour-event.
#
# @return	the state of the 24-hour-event
#				0 => off
#				1 => on
#
################################################################################
DROP FUNCTION IF EXISTS `getEvent24hLimit` $$
CREATE FUNCTION `getEvent24hLimit`() RETURNS TINYINT
BEGIN
	# get the current state of the event
	SELECT status
		FROM `information_schema`.`events`
		WHERE ( event_name = 'ev_24hLimit' )
		INTO @state;
	
	# convert the result from CHAR to INT
	IF ( @state = 'ENABLED' ) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END $$
################################################################################
#
# This function turns the 24-hour-event on or off.
#
# @param	value	the value to set the 24-hour-event to
#						0 => off
#						1 => on
#
################################################################################
DROP PROCEDURE IF EXISTS `setEvent24hLimit` $$
CREATE PROCEDURE `setEvent24hLimit`( IN value TINYINT )
BEGIN
	
	IF ( value ) THEN
		ALTER EVENT `ev_24hLimit` ENABLE;
	ELSE
		ALTER EVENT `ev_24hLimit` DISABLE;
	END IF;
	
	# debug information
	CALL put_line( CONCAT( 'State of the event `ev_24hLimit`: ', if(getEvent24hLimit(), 1, 0) ) );
END $$
################################################################################
#
# This function returns the stauts of the auto-mode-event.
#
# @return	the state of the auto-mode-event
#				0 => off
#				1 => on
#
################################################################################
DROP FUNCTION IF EXISTS `getEventAutoMode` $$
CREATE FUNCTION `getEventAutoMode`() RETURNS TINYINT
BEGIN
	# get the current state of the event
	SELECT status
		FROM `information_schema`.`events`
		WHERE ( event_name = 'ev_AutoMode' )
		INTO @state;
	
	# convert the result from CHAR to INT
	IF ( @state = 'ENABLED' ) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END $$
################################################################################
#
# This function turns the auto mode event on or off.
#
# @param	value	the value to set the auto mode to
#						0 => off
#						1 => on
#
################################################################################
DROP PROCEDURE IF EXISTS `setEventAutoMode` $$
CREATE PROCEDURE `setEventAutoMode`( IN value TINYINT )
BEGIN

	IF ( value ) THEN
		ALTER EVENT `ev_AutoMode` ENABLE;
	ELSE
		ALTER EVENT `ev_AutoMode` DISABLE;
	END IF;
	
	# debug information
	CALL put_line( CONCAT( 'State of the event `ev_AutoMode`: ', if(getEventAutoMode(), 1, 0) ) );

END $$
################################################################################

DELIMITER ;