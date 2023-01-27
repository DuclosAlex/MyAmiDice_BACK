-- Appele quand le users se connect et recupere ses info
CREATE OR REPLACE FUNCTION user_login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("login" json) AS $$
BEGIN
  RETURN QUERY SELECT row_to_json("log") as "login"
  FROM (
    SELECT "Users".id, "Users".email, "Users".is_admin, "Users".firstname, "Users".lastname, "Users".pseudo,
    (SELECT json_agg(row_to_json( (SELECT temptable FROM (SELECT "name", "status", "description", "max_players") temptable ))) FROM "Games" WHERE "Users".id = "Games".user_id ) "games",
    (SELECT json_agg(row_to_json( (SELECT temptable FROM (SELECT "firstname", lastname) temptable ))) FROM "Characters" WHERE "Users".id = "Characters".user_id ) "characters",
    (SELECT json_agg(row_to_json( (SELECT temptable FROM (SELECT game_id, user_id) temptable ))) FROM "Invite" WHERE "Users".id = "Invite".user_id) "invite"
    FROM "Users"
    WHERE "Users".email = test_email AND "Users".password = test_password
  ) "log";
END;
$$ LANGUAGE plpgsql;

/*
Script de test de la fonction:

SELECT * FROM user_login('elfedelamort@truc.game', 'lolo-forever');
*/
SELECT row_to_json(Gameroom)
FROM (
    SELECT "Users".pseudo, 
	(
		SELECT jsonb_agg(game_info)
		FROM(
			SELECT "Games".* ,
			(
				SELECT json_agg(Maps)
				FROM(
					SELECT "Maps".*
					FROM "Maps" FULL JOIN "game_has_maps" ON "Maps".id = "game_has_maps".map_id
					WHERE "Games".id = "game_has_maps".game_id
				) AS Maps
			) AS Maps
			FROM "Games"
			WHERE "Games".id = 1 
		) AS game_info
	) AS game_info, 
	(
        SELECT jsonb_agg(personnages)
        FROM(
            SELECT "Characters".*, 
            (
                SELECT json_agg(Skills)
                FROM(
                    SELECT "Skills".*
                    FROM "Skills"
                    WHERE "Skills".character_id = "Characters".id
                ) AS Skills
            ) AS Skills,
            (
                SELECT json_agg(objets)
                FROM(
                    SELECT "Items".*
                    FROM "Items"
                    WHERE "Items".character_id = "Characters".id
                ) AS objets
            ) AS objets
            FROM "Characters"
            WHERE "Characters".user_id = "Users".id
        )AS Personnages
    ) AS Personnages
	
    FROM "Users"
    WHERE "Users".id = 2
) AS Gameroom;