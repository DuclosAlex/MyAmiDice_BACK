-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_character_by_id_with_all(IN char_id INT) 
RETURNS TABLE( 
    "Char_firstname" TEXT,
    "Char_lastname" TEXT ,
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
    FULL JOIN "Skills"
    ON "Characters"."id" = "Skills"."character_id"
    FULL JOIN "Characteristics"
    ON "Characters"."id" = "Characteristics"."character_id"
    FULL JOIN "Items"
    ON "Characters"."id" = "Items"."character_id"
    WHERE "Characters"."id" = char_id;
END;
$$ LANGUAGE plpgsql
--test de la fonction 
--SELECT * FROM get_character_by_id_with_all(1) 


-- Met le perso “:id” à jour ou Créer un nouveaux perso en base de données si il n'existe pas
CREATE OR REPLACE FUNCTION create_or_update_characters_with_result(
	IN new_id INT,
    IN new_firstname TEXT, 
    IN new_lastname TEXT, 
    IN new_description TEXT,
    IN new_race TEXT,
    IN new_class TEXT,
    IN new_is_alive BOOLEAN,
    IN new_user_id INT

)
RETURNS TABLE("id" INTEGER, firstname TEXT, lastname TEXT, "description" TEXT, race TEXT, "class" TEXT, is_alive BOOLEAN, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Characters" SET firstname = new_firstname, lastname = new_lastname, "description" = new_description, race = new_race, is_alive= new_is_alive, "class" = new_class, "user_id" = new_id WHERE "new_id" = "Characters".id;
    IF NOT FOUND THEN 
        INSERT INTO "Characters" ( firstname, lastname, description, race, class, "user_id") VALUES ( new_firstname, new_lastname, new_description, new_race, new_class, new_user_id) RETURNING "Characters".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Characters".id, "Characters".firstname, "Characters".lastname, "Characters".description, "Characters".race, "Characters".class, "Characters".is_alive, "Characters".created_at, "Characters".updated_at FROM "Characters" WHERE "Characters".id = new_id;
END
$$ LANGUAGE plpgsql;
/*
 Test de fonction OK
SELECT * from create_or_update_characters_with_result(
	2, 'grobarg', 'trackmort', 'test', 'ORKS', 'brutal badass', TRUE) 
*/


CREATE OR REPLACE FUNCTION delete_characters_by_id(IN char_id INT)
RETURNS VOID AS $$
    DELETE FROM "Characters" WHERE "id" = char_id;
$$ LANGUAGE SQL;
/*
Script de TEST de la fonction:

SELECT delete_characters_by_id(1);
SELECT * FROM "Characters";
*/