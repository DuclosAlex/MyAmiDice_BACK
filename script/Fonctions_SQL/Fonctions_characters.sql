CREATE OR REPLACE FUNCTION get_character_by_id_with_all(IN char_id INT) 
RETURNS TABLE( 
    "Char_firstname" TEXT,
    "Char_lastname" TEXT,
    "Char_description" TEXT,
    "Char_race" TEXT,
    "Char_class" TEXT,
    "Char_is_alive" BOOLEAN,
    "Skills_name" TEXT,
    "Skills_description" TEXT,
    "stats_strength" INT,
    "stats_dexterity" INT,
    "stats_wisdom" INT,
    "stats_charisma" INT,
    "stats_constitution" INT,
    "stats_intelligence" INT,
    "stats_level" INT,
    "stats_hp" INT,
    "Items_name" TEXT,
    "Items_quantity" INT,
    "Items_description" TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT  
    "Characters"."firstname",
    "Characters"."lastname",
    "Characters"."description",
    "Characters"."race",
    "Characters"."class",
    "Characters"."is_alive",
    "Skills"."name",
    "Skills"."description",
    "Characteristics"."strength",
    "Characteristics"."dexterity",
    "Characteristics"."wisdom",
    "Characteristics"."charisma",
    "Characteristics"."constitution",
    "Characteristics"."intelligence",
    "Characteristics"."level",
    "Characteristics"."hp",
    "Items"."name",
    "Items"."quantity",
    "Items"."description"
    FROM "Characters"
    JOIN "Skills"
    ON "Characters"."id" = "Skills"."character_id"
    JOIN "Characteristics"
    ON "Characters"."id" = "Characteristics"."character_id"
    JOIN "Items"
    ON "Characters"."id" = "Items"."character_id"
    WHERE "Characters"."id" = char_id;
END;
$$ LANGUAGE plpgsql
--test de la fonction 
--SELECT get_character_by_id_with_all(1) 

