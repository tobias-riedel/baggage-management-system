################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script creates all the need datatables.
################################################################################
SET FOREIGN_KEY_CHECKS = 0;


# create new table `label`
DROP TABLE IF EXISTS `label`;
CREATE TABLE IF NOT EXISTS `label` ( 
	`label_id` tinyint( 4 ) NOT NULL AUTO_INCREMENT,
	`label_type` char( 1 ) DEFAULT NULL,
	`label_number` tinyint( 4 ) DEFAULT NULL,
	PRIMARY KEY ( `label_id` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# create new table `bag`
DROP TABLE IF EXISTS `bag`;
CREATE TABLE `bag` ( 
	`bag_id` bigint NOT NULL AUTO_INCREMENT,
	`dest_seg` bigint NOT NULL,
	`bag_time` DATETIME NOT NULL ,
	PRIMARY KEY ( `bag_id` ) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# create new table `segment`
DROP TABLE IF EXISTS `segment`;
CREATE TABLE IF NOT EXISTS `segment` ( 
	`seg_id` bigint NOT NULL AUTO_INCREMENT,
	`x` bigint unsigned NOT NULL,
	`y` bigint unsigned NOT NULL,
	`z` bigint unsigned NOT NULL,
	`seg_type` tinyint( 4 ) NOT NULL,
	`label_id` tinyint( 4 ) DEFAULT NULL,
	`bag_id` bigint DEFAULT NULL,
	`blocker_bag` bigint DEFAULT NULL,
	FOREIGN KEY ( `label_id` ) REFERENCES `label`( `label_id` ) ON DELETE SET NULL,
	FOREIGN KEY ( `bag_id` ) REFERENCES `bag`( `bag_id` ) ON DELETE SET NULL,
	FOREIGN KEY ( `blocker_bag` ) REFERENCES `bag`( `bag_id` ) ON DELETE SET NULL,
	PRIMARY KEY ( `seg_id` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# reference `bag` to `segment`
ALTER TABLE `bag` ADD FOREIGN KEY ( `dest_seg` ) REFERENCES `segment`( `seg_id` );


# create new table `connection`
DROP TABLE IF EXISTS `connection`;
CREATE TABLE `connection` ( 
	`con_id` bigint NOT NULL auto_increment,
	`src_seg` bigint NOT NULL,
	`dest_seg` bigint NOT NULL,
	FOREIGN KEY ( `src_seg` ) REFERENCES `segment`( `seg_id` ),
	FOREIGN KEY ( `dest_seg` ) REFERENCES `segment`( `seg_id` ),
	PRIMARY KEY	( `con_id` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# create new table `destination`
DROP TABLE IF EXISTS `destination`;
CREATE TABLE `destination` ( 
	`con_id` bigint NOT NULL,
	`label_id` TINYINT( 4 ) NOT NULL,
	FOREIGN KEY ( `con_id` ) REFERENCES `connection`( `con_id` ),
	FOREIGN KEY ( `label_id` ) REFERENCES `label`( `label_id` ) ON DELETE CASCADE,
	PRIMARY KEY	( `con_id`, `label_id` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;