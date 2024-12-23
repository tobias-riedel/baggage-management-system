################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This is script provides the procedures to create the infrastructure of the
# system.
################################################################################

DELIMITER $$
################################################################################
#
# This function returns the ID of a wanted label
#
# @param	labelType	the type of the label
#							's' => shelf
#							't' => terminal
# @param	labelNumber	the number of the label of this type
# @return				the ID of the label
################################################################################ 
DROP PROCEDURE IF EXISTS `getLabel` $$
CREATE PROCEDURE `getLabel`( IN labelType CHAR( 1 ), IN labelNumber TINYINT, OUT labelId TINYINT )
BEGIN
	# get the ID
	SELECT label_id
		FROM `label`
		WHERE ( label_type = labelType && label_number = labelNumber )
		INTO labelId;
END $$
################################################################################
#
# This function creates a terminal at the given position.
#
# @param	posX		the X position of the beginning of the shelf
# @param	posY		the Y position of the beginning of the shelf
# @param	posZ		the Z position of the beginning of the shelf
# @param	number		the number of the terminal
################################################################################ 
DROP PROCEDURE IF EXISTS `buildTerminal` $$
CREATE PROCEDURE `buildTerminal`( IN posX MEDIUMINT, IN posY MEDIUMINT, IN posZ MEDIUMINT, IN number TINYINT )
BEGIN
	# create new terminal label
	INSERT INTO `label` ( label_type, label_number ) VALUES ( 't', number );
	
	# get the ID of the new label
	CALL getLabel( 't', number, @labelId );

	# create the new terminal
	INSERT INTO `segment` ( x, y, z, seg_type, label_id ) VALUES ( posX, posY, posZ, 2, @labelId );
END $$
################################################################################
#
# This function creates a shelf and the related lifts from the given position
# to bottom ( increasing Y ).
#
# @param	posX		the X position of the beginning of the shelf
# @param	posY		the Y position of the beginning of the shelf
# @param	posZ		the Z position of the beginning of the shelf
# @param	numCols		the number of columns of the shelf
# @param	numRows		the number of rows of the shelf
# @param	number		the number the shelf shall get
################################################################################ 
DROP PROCEDURE IF EXISTS `buildShelf` $$
CREATE PROCEDURE `buildShelf`( IN posX MEDIUMINT, IN posY MEDIUMINT, IN posZ MEDIUMINT, IN numCols MEDIUMINT, IN numRows MEDIUMINT, IN number TINYINT )
BEGIN
	# variable declarations
	## iteratiors
	DECLARE col MEDIUMINT DEFAULT 0;
	DECLARE row MEDIUMINT DEFAULT 0;

	# create new shelf label
	INSERT INTO `label` ( label_type, label_number ) VALUES ( 's', number );
	
	# get the ID of the new label
	CALL getLabel( 's', number, @labelId );

	WHILE ( row < numRows ) DO
		WHILE ( col < numCols ) DO
			# create shelf box segment
			INSERT INTO `segment` ( x, y, z, seg_type, label_id ) VALUES ( posX, posY + col, posZ + row, 3, @labelId );
			# create related lift segment
			INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( posX + 1, posY + col, posZ + row, 1 );
			SET col = col + 1;
		END WHILE;

		SET col = 0;

		SET row = row + 1;
	END WHILE;
END $$
################################################################################
#
# This function creates a shelf and the related lifts from the given position
# to bottom ( increasing Y ).
#
# @param	startX		the X position of the beginning of the line
# @param	startY		the Y position of the beginning of the line
# @param	startZ		the Z position of the beginning of the line
# @param	endX		the X position of the ending of the line
# @param	endY		the Y position of the ending of the line
# @param	endZ		the Z position of the ending of the line
################################################################################ 
DROP PROCEDURE IF EXISTS `buildAssemblyLine` $$
CREATE PROCEDURE `buildAssemblyLine`( IN startX MEDIUMINT, IN startY MEDIUMINT, IN startZ MEDIUMINT, IN endX MEDIUMINT, IN endY MEDIUMINT, IN endZ MEDIUMINT )
BEGIN
	# variable declarations
	## iteratiors
	DECLARE itX TINYINT DEFAULT 1;
	DECLARE itY TINYINT DEFAULT 1;
	DECLARE itZ TINYINT DEFAULT 1;

	# initialize loop variables
	
	SET @loopX = startX;
	SET @loopY = startY;
	SET @loopZ = startZ;
	IF ( startX > endX ) THEN
		SET itX = -1;
		SET endX = endX - 1;
	ELSE
		SET endX = endX + 1;
	END IF;
	IF ( startY > endY ) THEN
		SET itY = -1;
		SET endY = endY - 1;
	ELSE
		SET endY = endY + 1;
	END IF;
	IF ( startZ > endZ ) THEN
		SET itZ = -1;
		SET endZ = endZ - 1;
	ELSE
		SET endZ = endZ + 1;
	END IF;
	
	
	REPEAT
		REPEAT
			REPEAT
				INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( @loopX, @loopY, @loopZ, 0 );
				SET @loopX = @loopX + itX;
			UNTIL @loopX = endX || startX = endX
			END REPEAT;
			SET @loopX = startX;
			SET @loopY = @loopY + itY;
		UNTIL @loopY = endY || startY = endY
		END REPEAT;
		SET @loopY = startY;
		SET @loopZ = @loopZ + itZ;
	UNTIL @loopZ = endZ || startZ = endZ
	END REPEAT;
END $$
################################################################################

DELIMITER ;