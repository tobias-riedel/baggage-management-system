################################################################################
# author:	Tobias Riedel
# date:		2008-07-17
#
# This is the initialization script that gets all the parts together.
################################################################################

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

# provide procedures for debugging
SOURCE proc_debug.sql;

# create all the needed datatables
SOURCE datatables.sql;

# create related views
SOURCE views.sql;

# create the infrastructure first
SOURCE proc_infrastructure.sql;
SOURCE data_infrastructure.sql;

# establish connections between the infrastructure`s segments and set destinations for switches
SOURCE proc_connections.sql;
SOURCE data_connections.sql;

# add pathfinding procedures
SOURCE proc_pathfinding.sql;

# add bags datatable plus procdures for placement and retrieval of bags
SOURCE proc_bags.sql;

# add events to move the bags every second and remove them after the 24h-limit
SOURCE events.sql;

# activate the event scheduler and add functions to set the 24h-limit event, and the event scheduler
SOURCE proc_events.sql;
CALL setEventScheduler( 1 );