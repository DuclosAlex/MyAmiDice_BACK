-- SQLBook: Code

-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_games_by_userid(userid int) RETURNS Games AS $$
    SELECT * FROM Games WHERE "id" = userid
-- SQLBook: Code
CREATE FUNCTION delete_user_by_id (userid, int) RETURNS Users ASS $$

-- SQLBook: Code
CREATE OR REPLACE FUNCTION create_or_update_user_by_id(userid int) RETURNS "Users" AS $$
    IF (SELECT "code_user" FROM "Users" WHERE "code_user" = userid) = NOT NULL
        SELECT * FROM "Users" WHERE "code_user" = userid
$$ LANGUAGE sql
SELECT create_or_update_user_by_id()
-- SQLBook: Code
CREATE OR REPLACE FUNCTION create_or_update_user_by_id(userid INTEGER, new_pseudo TEXT, new_email TEXT, new_password TEXT, new_is_admin BOOLEAN, new_firstname TEXT, new_lastname TEXT)
RETURNS TABLE(id INTEGER, pseudo TEXT, email TEXT, password TEXT, is_admin BOOLEAN, firstname TEXT, lastname TEXT) AS $$
BEGIN
    -- If user already exists in table
    IF EXISTS (SELECT 1 FROM "Users" WHERE "id" = userid) THEN
        -- update the user
        UPDATE "Users" SET pseudo = new_pseudo, email = new_email, "password" = new_password, is_admin = new_is_admin, firstname = new_firstname, lastname = new_lastname WHERE "id" = userid;
        -- return the updated user
        RETURN QUERY SELECT "id", new_pseudo as pseudo, new_email as email, new_password as "password", new_is_admin as is_admin, new_firstname as firstname, new_lastname as lastname FROM "Users" WHERE "id" = userid;
    ELSE
        -- insert the new user into the table
        INSERT INTO "Users" ( pseudo, email, "password", is_admin, firstname, lastname) VALUES ( new_pseudo, new_email, new_password, new_is_admin, new_firstname, new_lastname);
        -- return the new user
        RETURN QUERY SELECT "id", new_pseudo as pseudo, new_email as email, new_password as "password", new_is_admin as is_admin, new_firstname as firstname, new_lastname as lastname FROM "Users" ;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT create_or_update_user_by_id(2, 'Vaqh', 'test@test.com', 'pass', true, 'Math', 't');

SELECT * FROM "Users"
-- SQLBook: Code
CREATE OR REPLACE FUNCTION create_or_update_user_with_result(
	IN new_id INT,
    IN new_pseudo TEXT, 
    IN new_email TEXT, 
    IN new_password TEXT, 
    IN new_is_admin BOOLEAN, 
    IN new_firstname TEXT, 
    IN new_lastname TEXT
)
RETURNS TABLE("id" INTEGER, pseudo TEXT, email TEXT, "password" TEXT, is_admin BOOLEAN, firstname TEXT, lastname TEXT) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Users" SET pseudo = new_pseudo, email = new_email, "password" = new_password, is_admin = new_is_admin, firstname = new_firstname, lastname = new_lastname WHERE "new_id" = "Users".id;
    IF NOT FOUND THEN 
        INSERT INTO "Users" ( pseudo, email, "password", is_admin, firstname, lastname) VALUES ( new_pseudo, new_email, new_password, new_is_admin, new_firstname, new_lastname);
    END IF;
    RETURN QUERY SELECT "Users".id,"Users".pseudo, "Users".email, "Users"."password", "Users".is_admin, "Users".firstname, "Users".lastname FROM "Users" WHERE "Users".id = new_id;
END
$$ LANGUAGE plpgsql;

SELECT create_or_update_user_with_result(0, 'Omega_Vaqh', 'dujmat@hotmail.fr', 'test', true, 'Mathieu', 'Dujardin');

SELECT * FROM "Users"
-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_users() RETURNS "Users" AS $$
    SELECT * FROM "Users";
$$ LANGUAGE sql; 