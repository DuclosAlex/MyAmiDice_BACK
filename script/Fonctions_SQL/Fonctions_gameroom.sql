CREATE OR REPLACE FUNCTION get_game_by_id_with_all(
    IN gameroom_id INT,
	IN userid INT
)
RETURNS TABLE( "gameroom" json) AS $$
BEGIN
	RETURN QUERY SELECT row_to_json(Game) as "gameroom"
	FROM (
	SELECT "Games"."name", "Games"."description", "Games"."status", "Games"."notes", "Games".max_players, (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ch.firstname, ch.lastname, ch.description, ch.race, ch.class, ch.is_alive ) temptable))) FROM "Characters" as ch WHERE "Games".id = ch.game_id
		) "characters",	(
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ma."name", ma."url" ) temptable))) FROM "Maps" as ma JOIN game_has_maps as ghm on ghm.map_id = ma.id JOIN "Games" as g ON g.id = ghm.game_id WHERE g.id = gameroom_id) "maps"
		FROM "Games" 
		WHERE "Games".id = gameroom_id
		AND userid = "Games".user_id)
	Game;
	IF NOT FOUND THEN
		RETURN QUERY SELECT row_to_json(Game) as "gameroom"
		FROM (
		SELECT "Games"."name", "Games"."description", "Games"."status", "Games"."notes", "Games".max_players, (
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ch.firstname, ch.lastname, ch.description, ch.race, ch.class, ch.is_alive ) temptable))) FROM "Characters" as ch WHERE ch.id = userid
		) "characters", ( 
		SELECT json_agg(row_to_json((SELECT temptable FROM (SELECT ma."name", ma."url" ) temptable))) FROM "Maps" as ma JOIN game_has_maps as ghm on ghm.map_id = ma.id JOIN "Games" as g ON g.id = ghm.game_id WHERE g.id = gameroom_id) "maps"
		FROM "Games" 
		WHERE "Games".id = gameroom_id)
	Game;
	END IF;
END;
$$ LANGUAGE plpgsql;