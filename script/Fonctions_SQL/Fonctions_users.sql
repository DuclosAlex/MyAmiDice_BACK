-- SQLBook: Code
-- Renvoi la liste de tout les utilisateurs
CREATE OR REPLACE FUNCTION get_users() 
RETURNS TABLE("id" INTEGER, "pseudo" TEXT, "password" TEXT, "email" TEXT, "is_admin" BOOLEAN, "lastname" TEXT, "firstname" TEXT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
    SELECT * FROM "Users";
$$ LANGUAGE SQL;
-- Test de fonction OK
-- SELECT get_users()
-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_users_by_id(userid INTEGER)
RETURNS TABLE ("id" INTEGER, "pseudo" TEXT, "password" TEXT, "email" TEXT, "is_admin" BOOLEAN, "lastname" TEXT, "firstname" TEXT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
    SELECT * FROM "Users" WHERE "id" = userid;
$$ LANGUAGE SQL;
-- Test de fonction OK
-- SELECT get_users_by_id(1);
-- SQLBook: Code
-- Met l’utilisateur “:id” à jour ou Créer un nouvel utilisateur en base de données si il n'existe pas
CREATE OR REPLACE FUNCTION create_or_update_user_with_result(
	IN new_id INT,
    IN new_pseudo TEXT, 
    IN new_email email, 
    IN new_password TEXT, 
    IN new_firstname TEXT, 
    IN new_lastname TEXT
)
RETURNS TABLE("id" INTEGER, pseudo TEXT, email email, "password" TEXT, is_admin BOOLEAN, firstname TEXT, lastname TEXT) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Users" SET pseudo = new_pseudo, email = new_email, "password" = new_password, firstname = new_firstname, lastname = new_lastname WHERE "new_id" = "Users".id;
    IF NOT FOUND THEN 
        INSERT INTO "Users" ( pseudo, email, "password", is_admin, firstname, lastname) VALUES ( new_pseudo, new_email, new_password, false, new_firstname, new_lastname) RETURNING "Users".id INTO new_id ;
    END IF;
    RETURN QUERY SELECT "Users".id,"Users".pseudo, "Users".email, "Users"."password", "Users".is_admin, "Users".firstname, "Users".lastname FROM "Users" WHERE "Users".id = new_id;
END
$$ LANGUAGE plpgsql;
-- Test de la fonction
-- SELECT create_or_update_user_with_result(1, 'Vaqh_Omegaaa', 'dujmat@hotmail.fr', 'test', 'Mathieu', 'Dujardin'); -- Update un utilisateur quand "id" existe
-- SELECT create_or_update_user_with_result(0, 'Vaqh_Omega', 'dujmat@hotmail.fr', 'test', 'Mathieu', 'Dujardin'); -- Creer un utilisateur quand "id" n'existe pas
-- SQLBook: Code
-- Supprime l’utilisateur “:id” de la base de données
CREATE OR REPLACE FUNCTION delete_users_by_id(userid INTEGER)
RETURNS VOID AS $$
    DELETE FROM "Users" WHERE "id" = userid;
$$ LANGUAGE SQL;
-- Test de fonction OK
-- SELECT delete_users_by_id(1);
-- SQLBook: Code
CREATE OR REPLACE FUNCTION get_game_and_characs_by_user(userid INTEGER)
RETURNS TABLE (charac_name TEXT, game_name TEXT, game_status TEXT, name_user_mj TEXT) AS $$
    SELECT "Characters".firstname, "Games".name, "Games".status, "Users".pseudo FROM "Users"
	FULL JOIN "Games" ON "Users".id = "Games".user_id
	FULL JOIN "Characters" ON "Users".id = "Characters".user_id
	WHERE "Users".id = userid;
$$ LANGUAGE SQL;
-- Test de fonction NOT OK
SELECT get_game_and_characs_by_user(1)