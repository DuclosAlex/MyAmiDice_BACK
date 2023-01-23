--Vérifié les infos d'un user par ses login
CREATE OR REPLACE FUNCTION login(IN test_email email, IN test_password TEXT)
RETURNS TABLE("id" INT, "email" email, is_admin BOOLEAN, firstname TEXT, lasname TEXT) AS $$
BEGIN
    RETURN QUERY SELECT "Users".id, "Users".email, "Users".is_admin, "Users".firstname, "Users".lastname FROM "Users" WHERE "Users".email = test_email AND "Users".password = test_password;
END;
$$ LANGUAGE plpgsql;
/*
Test de la fonction OK
SELECT * from login(
	'bouya@mail.com', 'bouya')
*/