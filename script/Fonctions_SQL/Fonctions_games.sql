-- Renvoie la liste de toutes les games
CREATE OR REPLACE FUNCTION get_games() 
RETURNS TABLE("id" INTEGER, "name" TEXT, "max_players" INT, "notes" TEXT, "status" TEXT, "user_id" INT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
    SELECT * FROM "Games";
$$ LANGUAGE SQL;
-- Test de fonction OK
SELECT get_games()

-- Créer la "Games" et retourne les info (mj=user_id)
CREATE OR REPLACE FUNCTION create_game(IN game_name TEXT, IN nbmax_players INT, IN game_notes TEXT, IN game_status TEXT, IN gm_id INT)
RETURNS TABLE(
    "id" INT,
    "name" TEXT,
    "max_players" INT,
    "notes" TEXT,
    "status" TEXT,
    "user_id" INT
) AS $$
--déclare un variable pour récupéré l'id de la game nouvellement créer
DECLARE 
    game_id INT;
BEGIN
    INSERT INTO "Games"("name", "max_players", "notes", "status", "user_id") 
    VALUES (game_name, nbmax_players, game_notes, game_status, gm_id)
    RETURNING "Games"."id" INTO game_id; --récupération de la valeur dans la variable déclaré précédemment
    RETURN QUERY SELECT "Games"."id", "Games"."name", "Games"."max_players", "Games"."notes", "Games"."status", "Games"."user_id" FROM "Games" WHERE "Games".id = game_id;-- utilisation de la variable dans la close WHERE pour renvoyé les bonne données
END;
$$ LANGUAGE plpgsql;
/*
script de test de la fonction :
SELECT * from create_game(
	'newgame', 5, 'far far away', 'lvl8', 1) 
*/