-- Rename weight to atomic_mass
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

-- Rename melting_point to melting_point_celsius
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;

-- Rename boiling_point to boiling_point_celsius
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE(symbol);
ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE(name);

ALTER TABLE properties ADD CONSTRAINT properties_atomic_number_fkey
FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR NOT NULL
);

SELECT DISTINCT type FROM properties;

INSERT INTO types(type) VALUES ('metal'), ('nonmetal'), ('metalloid');

ALTER TABLE properties ADD COLUMN type_id INT;

-- Update type_id values based on existing type column
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE type = properties.type);

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

ALTER TABLE properties ADD CONSTRAINT fk_type FOREIGN KEY (type_id) REFERENCES types(type_id);

ALTER TABLE properties DROP COLUMN type;

UPDATE elements SET symbol = INITCAP(symbol);

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE properties SET atomic_mass = 1.008 WHERE atomic_number = 1;
UPDATE properties SET atomic_mass = 4.0026 WHERE atomic_number = 2;
UPDATE properties SET atomic_mass = 6.94 WHERE atomic_number = 3;
UPDATE properties SET atomic_mass = 9.0122 WHERE atomic_number = 4;
UPDATE properties SET atomic_mass = 10.81 WHERE atomic_number = 5;
UPDATE properties SET atomic_mass = 12.011 WHERE atomic_number = 6;
UPDATE properties SET atomic_mass = 14.007 WHERE atomic_number = 7;
UPDATE properties SET atomic_mass = 15.999 WHERE atomic_number = 8;
UPDATE properties SET atomic_mass = 18.998 WHERE atomic_number = 9;
UPDATE properties SET atomic_mass = 20.18 WHERE atomic_number = 10;

-- Insert into elements
INSERT INTO elements(atomic_number, symbol, name)
VALUES (9, 'F', 'Fluorine'),
       (10, 'Ne', 'Neon');

-- Insert into properties
INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES 
(9, 18.998, -220, -188.1, (SELECT type_id FROM types WHERE type='nonmetal')),
(10, 20.18, -248.6, -246.1, (SELECT type_id FROM types WHERE type='nonmetal'));

DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;

-- fix: rename columns --
-- feat: add types table --
-- chore: add fluorine and neon --
-- refactor: update atomic_mass values --
