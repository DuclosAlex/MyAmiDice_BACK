CREATE OR REPLACE FUNCTION get_character_by_id_with_all(
    IN character_id INT
)
RETURNS TABLE( "character" json) AS $$

BEGIN
	RETURN QUERY SELECT row_to_json(Charac) as "character"
	FROM (
	SELECT "Characters"."firstname", "Characters"."lastname", "Characters"."race", "Characters".is_alive, "Characters"."class", (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT id, "name", "description") temptable))) FROM "Skills" WHERE "Characters".id = "Skills".character_id
		) skills, (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT id, "name", "quantity", "description") temptable))) FROM "Items" WHERE "Characters".id = "Items".character_id
		) items, (
        SELECT json_agg(row_to_json((SELECT temptable FROM ( SELECT id, strength, dexterity, constitution, wisdom, charisma, intelligence, "level", hp) temptable))) FROM "Characteristics" WHERE "Characters".id = "Characteristics".character_id
        ) "characteristics"
		FROM "Characters" WHERE "Characters".id = character_id
	) Charac;
END;
$$ LANGUAGE plpgsql;

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