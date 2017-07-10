CREATE TABLE airport (
	iata char(3) PRIMARY KEY,
	vertex_id bigint UNIQUE REFERENCES ways_vertices_pgr(id)
);

CREATE TEMP TABLE imp_airport (
	iata char(3) PRIMARY KEY,
	osm_id bigint UNIQUE
);

\COPY imp_airport FROM airports.csv WITH CSV HEADER

INSERT INTO airport (iata, vertex_id)
SELECT iata, wv.id
FROM imp_airport i
	JOIN ways_vertices_pgr wv ON i.osm_id = wv.osm_id;
