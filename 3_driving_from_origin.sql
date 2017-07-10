# Load a table of origin points
CREATE TABLE origin (
	name varchar PRIMARY KEY,
	vertex_id bigint UNIQUE REFERENCES ways_vertices_pgr(id)
);

INSERT INTO origin (name, vertex_id)
SELECT 'Johannesburg', id
FROM ways_vertices_pgr
WHERE osm_id = 201596578;

INSERT INTO origin (name, vertex_id)
SELECT 'Cape Town', id
FROM ways_vertices_pgr
WHERE osm_id = 25550025;

INSERT INTO origin (name, vertex_id)
SELECT 'Durban', id
FROM ways_vertices_pgr
WHERE osm_id = 616970619;

# Calculate driving times from origin points
CREATE TABLE origin_driving_time (
	origin_id bigint REFERENCES origin(vertex_id),
	dest_id bigint REFERENCES ways_vertices_pgr(id),
	time_mins float
);
CREATE INDEX origin_driving_time_origin_id ON origin_driving_time(origin_id);
CREATE INDEX origin_driving_time_dest_id ON origin_driving_time(dest_id);

INSERT INTO origin_driving_time(origin_id, dest_id, time_mins)
SELECT from_v, node, agg_cost
FROM pgr_drivingDistance(
    'SELECT gid AS id, source, target, length_m*0.08/maxspeed_forward AS cost, length_m*0.08/maxspeed_backward AS reverse_cost FROM ways',
    (SELECT array_agg(vertex_id) FROM origin),
    2000, true, false
);
