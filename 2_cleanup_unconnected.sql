-- Remove ways and vertices not connected to the road network
CREATE TEMP TABLE connected_vertex (
	id bigint PRIMARY KEY
);

INSERT INTO connected_vertex (id)
SELECT node
FROM pgr_drivingDistance(
    'select gid as id, source, target, 1 as cost, 1 as reverse_cost from ways',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 263568563),
    20000
);

DELETE FROM ways
USING ways_vertices_pgr AS wv
LEFT JOIN connected_vertex cv ON wv.id = cv.id
WHERE ways.source = wv.id
	AND cv.id IS NULL;

DELETE FROM ways_vertices_pgr
USING ways_vertices_pgr AS wv
LEFT JOIN connected_vertex cv ON wv.id = cv.id
WHERE ways_vertices_pgr.id = wv.id
	AND cv.id IS NULL;
