# Database name and username. If your database also needs a hostname or
# password, you'll need to add those parameters to the commands below.
DBNAME=traveltime
DBUSER=adrian

# Create database
createdb -U $DBUSER $DBNAME
psql -U $DBUSER $DBNAME -c "create extension postgis; create extension pgrouting;"

# Download latest South Africa OSM extract
wget http://download.geofabrik.de/africa/south-africa-latest.osm.bz2
bunzip2 south-africa-latest.osm.bz2

# Load into pgRouting schema in the database
osm2pgrouting --f south-africa-latest.osm --conf mapconfig.xml \
 --dbname $DBNAME --username $DBUSER --clean
