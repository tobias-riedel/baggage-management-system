################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This script establishes the connections between the segments.
################################################################################

# insert connections between segments
CALL establishConnection();

# delete connections at the left side of shelf 1 going from top to bottom
CALL delCons( 3, 's' );
# delete connections at the top side going from right to left
CALL delCons( 1, 'w' );
# delete connections at the bottom side going from left to right
CALL delCons( 31, 'e' );

# delete connections at the right side of shelves going from bottom to top
CALL delCons( 9, 'n' );
CALL delCons( 15, 'n' );
CALL delCons( 21, 'n' );
CALL delCons( 27, 'n' );
CALL delCons( 33, 'n' );

# set destinations for terminal 1 entrance
CALL setConDest( 2, 2, 0, 1, 2, 0, 't', 1 );
CALL setConDest( 2, 2, 0, 3, 2, 0, 's', 1 );
CALL setConDest( 2, 2, 0, 3, 2, 0, 's', 2 );
CALL setConDest( 2, 2, 0, 3, 2, 0, 's', 3 );
CALL setConDest( 2, 2, 0, 3, 2, 0, 's', 4 );
CALL setConDest( 2, 2, 0, 3, 2, 0, 's', 5 );
CALL setConDest( 3, 2, 0, 2, 2, 0, 't', 1 );
CALL setConDest( 3, 2, 0, 3, 1, 0, 's', 1 );
CALL setConDest( 3, 2, 0, 3, 1, 0, 's', 2 );
CALL setConDest( 3, 2, 0, 3, 1, 0, 's', 3 );
CALL setConDest( 3, 2, 0, 3, 1, 0, 's', 4 );
CALL setConDest( 3, 2, 0, 3, 1, 0, 's', 5 );

# set destinations for terminal 2 entrance
CALL setConDest( 2, 6, 0, 1, 6, 0, 't', 2 );
CALL setConDest( 2, 6, 0, 3, 6, 0, 's', 1 );
CALL setConDest( 2, 6, 0, 3, 6, 0, 's', 2 );
CALL setConDest( 2, 6, 0, 3, 6, 0, 's', 3 );
CALL setConDest( 2, 6, 0, 3, 6, 0, 's', 4 );
CALL setConDest( 2, 6, 0, 3, 6, 0, 's', 5 );
CALL setConDest( 3, 6, 0, 2, 6, 0, 't', 2 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 't', 1 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 's', 1 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 's', 2 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 's', 3 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 's', 4 );
CALL setConDest( 3, 6, 0, 3, 5, 0, 's', 5 );

# set destinations for terminal 3 entrance
CALL setConDest( 2, 10, 0, 1, 10, 0, 't', 3 );
CALL setConDest( 2, 10, 0, 3, 10, 0, 's', 1 );
CALL setConDest( 2, 10, 0, 3, 10, 0, 's', 2 );
CALL setConDest( 2, 10, 0, 3, 10, 0, 's', 3 );
CALL setConDest( 2, 10, 0, 3, 10, 0, 's', 4 );
CALL setConDest( 2, 10, 0, 3, 10, 0, 's', 5 );
CALL setConDest( 3, 10, 0, 2, 10, 0, 't', 3 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 't', 2 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 't', 1 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 's', 1 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 's', 2 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 's', 3 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 's', 4 );
CALL setConDest( 3, 10, 0, 3, 9, 0, 's', 5 );

# set destinations for terminal 4 entrance
CALL setConDest( 2, 14, 0, 1, 14, 0, 't', 4 );
CALL setConDest( 2, 14, 0, 3, 14, 0, 's', 1 );
CALL setConDest( 2, 14, 0, 3, 14, 0, 's', 2 );
CALL setConDest( 2, 14, 0, 3, 14, 0, 's', 3 );
CALL setConDest( 2, 14, 0, 3, 14, 0, 's', 4 );
CALL setConDest( 2, 14, 0, 3, 14, 0, 's', 5 );
CALL setConDest( 3, 14, 0, 2, 14, 0, 't', 4 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 't', 3 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 't', 2 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 't', 1 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 's', 1 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 's', 2 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 's', 3 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 's', 4 );
CALL setConDest( 3, 14, 0, 3, 13, 0, 's', 5 );

# set destinations for terminal 5 entrance
CALL setConDest( 2, 18, 0, 1, 18, 0, 't', 5 );
CALL setConDest( 2, 18, 0, 3, 18, 0, 's', 1 );
CALL setConDest( 2, 18, 0, 3, 18, 0, 's', 2 );
CALL setConDest( 2, 18, 0, 3, 18, 0, 's', 3 );
CALL setConDest( 2, 18, 0, 3, 18, 0, 's', 4 );
CALL setConDest( 2, 18, 0, 3, 18, 0, 's', 5 );
CALL setConDest( 3, 18, 0, 2, 18, 0, 't', 5 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 't', 4 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 't', 3 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 't', 2 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 't', 1 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 's', 1 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 's', 2 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 's', 3 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 's', 4 );
CALL setConDest( 3, 18, 0, 3, 17, 0, 's', 5 );

# set destinations for terminal 6 entrance
CALL setConDest( 2, 22, 0, 1, 22, 0, 't', 6 );
CALL setConDest( 2, 22, 0, 3, 22, 0, 's', 1 );
CALL setConDest( 2, 22, 0, 3, 22, 0, 's', 2 );
CALL setConDest( 2, 22, 0, 3, 22, 0, 's', 3 );
CALL setConDest( 2, 22, 0, 3, 22, 0, 's', 4 );
CALL setConDest( 2, 22, 0, 3, 22, 0, 's', 5 );
CALL setConDest( 3, 22, 0, 2, 22, 0, 't', 6 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 't', 5 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 't', 4 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 't', 3 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 't', 2 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 't', 1 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 's', 1 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 's', 2 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 's', 3 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 's', 4 );
CALL setConDest( 3, 22, 0, 3, 21, 0, 's', 5 );

# set destinations for terminal 7 entrance
CALL setConDest( 2, 26, 0, 1, 26, 0, 't', 7 );
CALL setConDest( 2, 26, 0, 3, 26, 0, 's', 1 );
CALL setConDest( 2, 26, 0, 3, 26, 0, 's', 2 );
CALL setConDest( 2, 26, 0, 3, 26, 0, 's', 3 );
CALL setConDest( 2, 26, 0, 3, 26, 0, 's', 4 );
CALL setConDest( 2, 26, 0, 3, 26, 0, 's', 5 );
CALL setConDest( 3, 26, 0, 2, 26, 0, 't', 7 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 6 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 5 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 4 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 3 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 2 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 't', 1 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 's', 1 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 's', 2 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 's', 3 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 's', 4 );
CALL setConDest( 3, 26, 0, 3, 25, 0, 's', 5 );

# set destinations for terminal 8 entrance
CALL setConDest( 2, 30, 0, 1, 30, 0, 't', 8 );
CALL setConDest( 2, 30, 0, 3, 30, 0, 's', 1 );
CALL setConDest( 2, 30, 0, 3, 30, 0, 's', 2 );
CALL setConDest( 2, 30, 0, 3, 30, 0, 's', 3 );
CALL setConDest( 2, 30, 0, 3, 30, 0, 's', 4 );
CALL setConDest( 2, 30, 0, 3, 30, 0, 's', 5 );
CALL setConDest( 3, 30, 0, 2, 30, 0, 't', 8 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 7 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 6 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 5 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 4 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 3 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 2 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 't', 1 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 's', 1 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 's', 2 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 's', 3 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 's', 4 );
CALL setConDest( 3, 30, 0, 3, 29, 0, 's', 5 );

# set destinations for switch 1n
CALL setConDest( 9, 1, 0, 9, 2, 0, 's', 1 );
CALL setConDest( 9, 1, 0, 10, 1, 0, 's', 2 );
CALL setConDest( 9, 1, 0, 10, 1, 0, 's', 3 );
CALL setConDest( 9, 1, 0, 10, 1, 0, 's', 4 );
CALL setConDest( 9, 1, 0, 10, 1, 0, 's', 5 );

# set destinations for switch 2n
CALL setConDest( 15, 1, 0, 15, 2, 0, 's', 2 );
CALL setConDest( 15, 1, 0, 16, 1, 0, 's', 3 );
CALL setConDest( 15, 1, 0, 16, 1, 0, 's', 4 );
CALL setConDest( 15, 1, 0, 16, 1, 0, 's', 5 );

# set destinations for switch 3n
CALL setConDest( 21, 1, 0, 21, 2, 0, 's', 3 );
CALL setConDest( 21, 1, 0, 22, 1, 0, 's', 4 );
CALL setConDest( 21, 1, 0, 22, 1, 0, 's', 5 );

# set destinations for switch 4n
CALL setConDest( 27, 1, 0, 27, 1, 0, 's', 4 );
CALL setConDest( 27, 1, 0, 28, 1, 0, 's', 5 );
