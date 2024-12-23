################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script provides functionalites for debugging.
################################################################################

DELIMITER $$

################################################################################
#
# This procedure prints a string on the screen.
#
# @param	output		the text to be displayed
#
################################################################################
DROP PROCEDURE IF EXISTS `put_line` $$
CREATE PROCEDURE `put_line`( IN output VARCHAR( 255 ) )
BEGIN
	# show
	SELECT output;
END $$
################################################################################
#
# This procedure fills the shelves with a given amount of bags.
#
# @param	amount		the amount of bags to be stored in the shelves
#
################################################################################
DROP PROCEDURE IF EXISTS `fill` $$
CREATE PROCEDURE `fill`( IN amount MEDIUMINT )
BEGIN
	# variable declarations
	## loop iterator
	DECLARE i MEDIUMINT DEFAULT 0;
	
	WHILE ( i < amount ) DO
		
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
			START TRANSACTION;

				# insert the new bag with its destination and current timestamp
				INSERT INTO `bag` ( `dest_seg`, `bag_time` ) VALUES( @destSeg, NOW() );
				
				# get the ID of the new bag
				SELECT MAX( bag_id )
					FROM `bag`
					INTO @newBagId;
				
				# store the new bag in the shelf box
				UPDATE `segment`
					SET bag_id = @newBagId, blocker_bag = @newBagId
					WHERE ( seg_id = @destSeg );

			COMMIT;
		ELSE
			SET i = amount;
		END IF;

		# iterate
		SET i = i + 1;
	END WHILE;
END $$
################################################################################

DELIMITER ;