-- SQL code for table creation, sample data insert, and all queries.
-- SQL for table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
)
;

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(100) NOT NULL
)
;

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL,
    species_id INT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
    FOREIGN KEY (species_id) REFERENCES species(species_id)
)
;

-- Insert Sample Data
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

INSERT INTO species
(species_id, common_name, scientific_name, discovery_date, conservation_status)
VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings
(sighting_id, species_id, ranger_id, location, sighting_time, notes)
VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00',
 'Camera trap image captured'),

(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00',
 'Juvenile seen'),

(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00',
 'Feeding observed'),

(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00',
 NULL);

-- Main questions
-- Problem 1
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains')
;

-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3
SELECT * FROM sightings
WHERE location LIKE '%Pass%';

-- Problem 4
SELECT
    r.name,
    COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s
    ON r.ranger_id = s.ranger_id
GROUP BY r.ranger_id, r.name
ORDER BY r.ranger_id;

-- Problem 5
SELECT
    sp.common_name
FROM species sp
LEFT JOIN sightings s
    ON sp.species_id = s.species_id
WHERE s.species_id IS NULL;

-- Problem 6
SELECT
    sp.common_name,
    s.sighting_time,
    r.name
FROM sightings s
JOIN species sp
    ON s.species_id = sp.species_id
JOIN rangers r
    ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

-- Problem 8
SELECT
    sighting_id,
    CASE
        WHEN sighting_time::time < '12:00:00' THEN 'Morning'
        WHEN sighting_time::time >= '12:00:00' AND sighting_time::time < '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings
ORDER BY sighting_id;

-- Problem 9
DELETE FROM rangers r
WHERE NOT EXISTS (
    SELECT 1
    FROM sightings s
    WHERE s.ranger_id = r.ranger_id
);