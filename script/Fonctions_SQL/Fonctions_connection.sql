-- SQLBook: Code
--Vérifié les infos d'un user par ses login et si les info sont bonne on renvoie les perso et les games du users
CREATE OR REPLACE FUNCTION user_login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("id" INT, "email" email, is_admin BOOLEAN, firstname TEXT, lasname TEXT, charac_name TEXT, game_name TEXT, game_status TEXT, name_user_mj TEXT, invite_status TEXT, invite_game INT) AS $$
BEGIN
    RETURN QUERY SELECT "Users".id, "Users".email, "Users".is_admin, "Users".firstname, "Users".lastname, "Characters".firstname, "Games".name, "Games".status, "Users".pseudo, "Invite".status, "Invite".game_id FROM "Users" 
    FULL JOIN "Games" ON "Users".id = "Games".user_id
    FULL JOIN "Characters" ON "Users".id = "Characters".user_id
    FULL JOIN "Invite" ON "Users".id = "Invite".user_id
    WHERE "Users".email = test_email AND "Users".password = test_password;
END;
$$ LANGUAGE plpgsql;
/*
Test de fonction OK:
SELECT * from login1(
    'bouya@mail.com', 'bouya')
*/