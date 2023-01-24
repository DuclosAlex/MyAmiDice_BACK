-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_character_by_id_with_all(
    IN char_id INT
)
RETURNS TABLE("id" INTEGER, firstname TEXT, lastname TEXT, "description" TEXT, race TEXT, "class" TEXT, is_alive BOOLEAN, "skills" json, "items" json) AS $$

BEGIN
SELECT row_to_json(Charac) as "result"
    FROM (
    SELECT *, (
        SELECT json_agg(row_to_json("Skills")) FROM "Skills" WHERE "Characters".id = "Skills".character_id
        ) skills, (
        SELECT json_agg(row_to_json("Items")) FROM "Items" WHERE "Characters".id = "Items".character_id
        ) items
        FROM "Characters" WHERE "Characters".id = char_id
    ) Charac; 

END;
$$ LANGUAGE plpgsql;
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
    IN new_user_id INT,
	IN new_game_id INT

)
RETURNS TABLE("id" INTEGER, firstname TEXT, lastname TEXT, "description" TEXT, race TEXT, "class" TEXT, is_alive BOOLEAN, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Characters" SET firstname = new_firstname, lastname = new_lastname, "description" = new_description, race = new_race, is_alive= new_is_alive, "class" = new_class WHERE "new_id" = "Characters".id;
    IF NOT FOUND THEN 
        INSERT INTO "Characters" ( firstname, lastname, description, race, class, "user_id", "game_id" ) VALUES ( new_firstname, new_lastname, new_description, new_race, new_class, new_user_id, new_game_id) RETURNING "Characters".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Characters".id, "Characters".firstname, "Characters".lastname, "Characters".description, "Characters".race, "Characters".class, "Characters".is_alive, "Characters".created_at, "Characters".updated_at FROM "Characters" WHERE "Characters".id = new_id;
END
$$ LANGUAGE plpgsql;


/*
 Test de fonction OK
SELECT * FROM create_or_update_characters_with_result(0, 'Vaqh', 'Omega', '1m95', 'Hybride vampire/loug-garou', 'Guerrier/mage', true, 1, 1)
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