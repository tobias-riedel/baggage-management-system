################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script creates the views for the web front-end.
################################################################################

# create new view `bag_system` for the image
DROP VIEW IF EXISTS `bag_image`;
CREATE VIEW `bag_image` AS
	SELECT x, y, z, seg_type, bag_id, blocker_bag
		FROM `segment`
		WHERE ( 
			z = 0 OR
			seg_type != 1 OR
			( seg_type = 1 AND blocker_bag IS NOT NULL )
		);

# create new view `bag_list` for the baggage list
DROP VIEW IF EXISTS `bag_list`;
CREATE VIEW `bag_list` AS
	SELECT b.bag_id
		FROM `bag` b
		INNER JOIN `segment` dest
			USING ( bag_id )
		WHERE ( b.dest_seg = dest.seg_id );