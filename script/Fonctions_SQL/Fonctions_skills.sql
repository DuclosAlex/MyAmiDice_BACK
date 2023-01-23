-- Met le skill “:id” à jour ou Créer un nouveaux skill en base de données si il n'existe pas
CREATE OR REPLACE FUNCTION create_or_update_skills_with_result(
	IN new_id INT,
    IN new_name TEXT, 
    IN new_description TEXT,
    IN new_char_id INT
)
RETURNS TABLE("id" INTEGER, "name" TEXT, "description" TEXT, character_id INT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Skills" SET "name" = new_name, "description" = new_description, character_id = new_char_id WHERE "new_id" = "Skills".id;
    IF NOT FOUND THEN 
        INSERT INTO "Skills" ( name, description, character_id) VALUES ( new_name, new_description, new_char_id) RETURNING "Skills".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Skills".id, "Skills".name, "Skills".description, "Skills".character_id, "Skills".created_at, "Skills".updated_at FROM "Skills" WHERE "Skills".id = new_id;
END;
$$ LANGUAGE plpgsql;
/*
Test de la fonction OK :
SELECT * from create_or_update_skills_with_result(
	3, 'kikoup de la mort', 'casse tout !', 2) 
*/