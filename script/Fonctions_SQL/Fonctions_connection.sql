  -- version fonctionnelle de la user_login ADD

CREATE OR REPLACE FUNCTION user_login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("user_log" json) AS $$
  BEGIN
RETURN QUERY SELECT row_to_json(Joueurs) as "user_log"
FROM (
	SELECT "Users".id, "Users".email, "Users".is_admin, "Users".firstname, "Users".lastname, "Users".pseudo,  (
		SELECT jsonb_agg(personnages)
		FROM(
			SELECT "Characters"."firstname", "Characters"."lastname", "Characters"."race", "Characters"."class", 
			(
				SELECT json_agg(Games)
				FROM (
					SELECT "Games"."name", "Games"."id", "Games"."description"
					FROM "Games"
					WHERE "Games".id = "Characters".game_id
				) AS games
			)as games
			FROM "Characters"
			WHERE "Characters".user_id = "Users".id
		)AS Personnages
	) AS Personnages,
	(
		SELECT json_agg(Games_MJ)
		FROM (
			SELECT "Games"."name", "Games".id, "Games"."description"
			FROM "Games"
			WHERE "Games"."user_id" = "Users".id
		) as Games_MJ
	) as Games_MJ
	FROM "Users"
	WHERE "Users".id = 11
) AS Joueurs;

END;

$$ LANGUAGE plpgsql;