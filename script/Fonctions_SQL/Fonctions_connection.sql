-- Appele quand le users se connect et recupere ses info
CREATE OR REPLACE FUNCTION user_login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("login" json) AS $$
BEGIN
  RETURN QUERY SELECT row_to_json("log") as "login"
  FROM (
    SELECT "Users".id, "Users".email, "Users".is_admin, "Users".firstname, "Users".lastname, "Users".pseudo, "Users".avatar,
    (SELECT json_agg(row_to_json( (SELECT temptable FROM (SELECT "name", "status", "description", "max_players") temptable ))) FROM "Games" WHERE "Users".id = "Games".user_id ) "games",
    (SELECT json_agg(row_to_json( (SELECT temptable FROM (SELECT "firstname", "lastname") temptable ))) FROM "Characters" WHERE "Users".id = "Characters".user_id ) "characters",
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