-- Renvoie la liste de toutes les games
CREATE OR REPLACE FUNCTION get_games() 
RETURNS TABLE("id" INTEGER, "name" TEXT, "description" TEXT, "max_players" INT, "notes" TEXT, "status" TEXT,  "user_id" INT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
    SELECT * FROM "Games";
$$ LANGUAGE SQL;

/*
Script de test de la fonction:

SELECT get_games()
*/


-- Créer la "Games" et retourne les info (mj=user_id) ou update le status et/ou nom
CREATE OR REPLACE FUNCTION create_or_update_games_with_result(
	IN "new_id" INT,
    IN "new_name" TEXT, 
	IN "new_description" TEXT,
    IN "new_max_players" INT, 
    IN "new_user_id" INT,
	IN "new_status" TEXT DEFAULT 'test',
    IN "new_notes" TEXT DEFAULT null
      
)
RETURNS TABLE("id" INTEGER, "name" TEXT, "description" TEXT, "max_players" INT, "notes" TEXT, "status" TEXT, "user_id" INT) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Games" SET "name" = "new_name", "notes" = "new_notes", "status" = "new_status", "description" = "new_description", "user_id" = "new_user_id" WHERE "new_id" = "Games".id;
    IF NOT FOUND THEN 
        INSERT INTO "Games" ( "name", "max_players", "description", "user_id") VALUES ("new_name", "new_max_players", "new_description", "new_user_id");
    END IF;
    RETURN QUERY SELECT "Games".id,"Games"."name", "Games"."description", "Games"."max_players",  "Games"."notes", "Games"."status", "Games"."user_id" FROM "Games" WHERE "Games".id = new_id;
END
$$ LANGUAGE plpgsql;

/*
Script de test de la fonction:

SELECT create_or_update_games_with_result(0, 'maGame', 'test', 4, 2); -- Creer un nouvelle utilisateur quand "id" vaut 0
SELECT create_or_update_games_with_result(1, 'maGame2', 'test2', 4, 4, "break"); -- Update un utilisateur quand "id" existe
SELECT * FROM "Games"

*/


CREATE OR REPLACE FUNCTION get_games_by_id_with_all(
    IN gameroom_id INT
)
RETURNS TABLE( "gameroom" json) AS $$

BEGIN

	RETURN QUERY SELECT row_to_json(Game) as "gameroom"
	FROM (
	SELECT "Games"."name", "Games"."description", "Games"."status", "Games"."notes", "Games".max_players, (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ch.firstname, ch.lastname, ch.description, ch.race, ch.class, ch.is_alive, charac.strength ) temptable))) FROM "Characters" as ch
		JOIN "Characteristics" as charac ON ch.id = charac.character_id
		WHERE ch.game_id = gameroom_id) "characters", (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ma."name", ma."url" ) temptable))) FROM "Maps" as ma
		JOIN game_has_maps as ghm on ghm.map_id = ma.id
		JOIN "Games" as g ON g.id = ghm.game_id
		WHERE g.id = gameroom_id) "maps"
		FROM "Games" WHERE "Games".id = gameroom_id)
	Game;
END;
$$ LANGUAGE plpgsql;


-- Supprime la games “:id”
CREATE OR REPLACE FUNCTION delete_games_by_id(game_id INT)
RETURNS VOID AS $$
    DELETE FROM "Games" WHERE "id" = game_id;
$$ LANGUAGE SQL;

/*
Script de TEST de la fonction:

SELECT delete_characters_by_id(1);
SELECT * FROM "Characters";

*/