
-- Appele quand le users se connect et recupere ses info
CREATE OR REPLACE FUNCTION user_login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("user_log" json) AS $$
 
  BEGIN
RETURN QUERY SELECT row_to_json(Joueurs) as "user_log"
FROM (
	SELECT us.id, us.email, us.is_admin, us.firstname, us.lastname, us.pseudo,  (
		SELECT jsonb_agg(personnages)
		FROM(
			SELECT "Characters".id, "Characters"."firstname", "Characters"."lastname", "Characters"."race", "Characters"."class", gm."name", gm."description", gm.max_players, us.pseudo
			FROM "Characters"
			JOIN "Games" as gm ON "Characters".game_id = gm.id
			JOIN "Users" as us ON gm.user_id = us.id
			WHERE "Characters".user_id = us.id
		)AS Personnages
	) AS Personnages,
	(
		SELECT json_agg(Games_MJ)
		FROM (
			SELECT "Games"."name", "Games".id, "Games"."status", "Games"."description", "Games"."max_players"
			FROM "Games"
			WHERE "Games"."user_id" = us.id
		) as Games_MJ
	) as Games_MJ,
	(
		SELECT json_agg(Games_Invite)
		FROM (
			SELECT gi."name", gi."id",gi."description", uj."pseudo"
			FROM "Invite"
			LEFT JOIN "Games" as gi ON "Invite".game_id = gi.id
			LEFT JOIN "Users" as uj ON "Games".user_id = uj."pseudo"
			WHERE "Invite".user_id = us.id
		) as Games_Invite
	) as Games_Invite
	FROM "Users" as us
	WHERE us."email" = test_email AND us."password" = test_password
) AS Joueurs;

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




