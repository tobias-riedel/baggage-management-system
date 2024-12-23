################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script creates the infrastructure of the system.
################################################################################

# build shelves and related lifts
CALL buildShelf( 7, 5, 0, 25, 12, 1 );
CALL buildShelf( 13, 5, 0, 25, 12, 2 );
CALL buildShelf( 19, 5, 0, 25, 12, 3 );
CALL buildShelf( 25, 5, 0, 25, 12, 4 );
CALL buildShelf( 31, 5, 0, 25, 12, 5 );

# horizontal way south
CALL buildAssemblyLine( 33, 31, 0, 3, 31, 0 );

# switches from north to south
CALL buildAssemblyLine( 9, 30, 0, 9, 2, 0 );
CALL buildAssemblyLine( 15, 30, 0, 15, 2, 0 );
CALL buildAssemblyLine( 21, 30, 0, 21, 2, 0 );
CALL buildAssemblyLine( 27, 30, 0, 27, 2, 0 );
CALL buildAssemblyLine( 33, 30, 0, 33, 2, 0 );

# horizontal way north
CALL buildAssemblyLine( 33, 1, 0, 3, 1, 0 );

# vertical way from terminals to switches
CALL buildAssemblyLine( 3, 2, 0, 3, 30, 0 );

# terminals
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 2, 0, 0 );
CALL buildTerminal( 1, 2, 0, 1 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 6, 0, 0 );
CALL buildTerminal( 1, 6, 0, 2 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 10, 0, 0 );
CALL buildTerminal( 1, 10, 0, 3 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 14, 0, 0 );
CALL buildTerminal( 1, 14, 0, 4 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 18, 0, 0 );
CALL buildTerminal( 1, 18, 0, 5 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 22, 0, 0 );
CALL buildTerminal( 1, 22, 0, 6 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 26, 0, 0 );
CALL buildTerminal( 1, 26, 0, 7 );
INSERT INTO `segment` ( x, y, z, seg_type ) VALUES ( 2, 30, 0, 0 );
CALL buildTerminal( 1, 30, 0, 8 );