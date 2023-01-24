-- SQLBook: Code
-- Renvoie la liste de toutes les games
CREATE OR REPLACE FUNCTION get_games() 
RETURNS TABLE("id" INTEGER, "name" TEXT, "max_players" INT, "notes" TEXT, "status" TEXT, "user_id" INT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
    SELECT * FROM "Games";
$$ LANGUAGE SQL;
-- Test de fonction OK
SELECT get_games()

-- Créer la "Games" et retourne les info (mj=user_id) ou update le status et/ou nom
CREATE OR REPLACE FUNCTION create_or_update_game_with_result(
	IN "new_id" INT,
    IN "new_name" TEXT, 
    IN "new_max_players" INT, 
    IN "new_notes" TEXT, 
    IN "new_status" TEXT, 
    IN "new_user_id" INT
)
RETURNS TABLE("id" INTEGER, "name" TEXT, "max_players" INT, "notes" TEXT, "status" TEXT, "user_id" INT) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Games" SET "name" = "new_name", "notes" = "new_notes", "status" = "new_status" WHERE "new_id" = "Games".id;
    IF NOT FOUND THEN 
        INSERT INTO "Games" ( "name", "max_players", "notes", "status", "user_id") VALUES ( "new_name", "new_max_players", "new_notes", "new_status", "new_user_id");
    END IF;
    SELECT "Games".id,"Games"."name", "Games"."max_players", "Games"."notes", "Games"."status", "Games"."user_id" FROM "Games" WHERE "Games".id = new_id;
END
$$ LANGUAGE plpgsql;
-- Test de fonction OK
SELECT create_or_update_game_with_result(0,'maGame',4, ' ', 'break',2); -- Creer un nouvelle utilisateur quand "id" vaut 0
SELECT create_or_update_game_with_result(1,'maGame2',4, ' ', 'break',4); -- Update un utilisateur quand "id" existe
SELECT * FROM "Games"

