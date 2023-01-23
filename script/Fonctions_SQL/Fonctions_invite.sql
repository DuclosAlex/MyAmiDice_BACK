-- Met l'invite “:id” à jour ou Créer une nouvelle invite en base de données si il n'existe pas
CREATE OR REPLACE FUNCTION create_or_update_invite_with_result(
	IN new_id INT,
    IN new_status TEXT,
    IN new_gameid INT,
    IN new_userid INT
)
RETURNS TABLE("id" INTEGER, game_id INT, "user_id" INT, "status" TEXT, "created_at" TIMESTAMPTZ, "updated_at" TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Invite" SET "status" = new_status WHERE "new_id" = "Invite".id;
    IF NOT FOUND THEN 
        INSERT INTO "Invite" ( game_id, user_id, status) VALUES ( new_gameid, new_userid, new_status) RETURNING "Invite".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Invite".id, "Invite".game_id, "Invite"."user_id", "Invite"."status", "Invite".created_at, "Invite".updated_at FROM "Invite" WHERE "Invite".id = new_id;
END;
$$ LANGUAGE plpgsql;
/*
Test de la fonction OK:
 SELECT * from create_or_update_invite_with_result(
	2, 'nop !', 14, 2)
/* 