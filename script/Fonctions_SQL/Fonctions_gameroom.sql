-- SQLBook: Code
--Récupére la gameroom, le mj, les joueurs, et tout le personnage avec ses possessions.
CREATE OR REPLACE FUNCTION gameroom_by_id(userid INT, gameid INT)
RETURNS TABLE(
	Games_name TEXT,
	Games_notes TEXT,
	Users_pseudo_mj TEXT,
	Maps_name TEXT,
	Maps_url url,
	Characters_firstname TEXT,
    Characters_lastname TEXT,
    Characters_description TEXT,
    Characters_race TEXT,
    Characters_class TEXT,
    Characters_is_alive BOOLEAN,
    Skills_name TEXT,
    Skills_description TEXT,
    Characteristics_strength INT,
    Characteristics_dexterity INT,
    Characteristics_wisdom INT,
    Characteristics_charisma INT,
    Characteristics_constitution INT,
    Characteristics_intelligence INT,
    Characteristics_level INT,
    Characteristics_hp INT,
    Items_name TEXT,
    Items_quantity INT,
    Items_description TEXT
) AS $$
BEGIN
	RETURN QUERY SELECT 
	"Games"."name",
	"Games"."notes",
	"Users"."pseudo",
	"Maps"."name",
	"Maps"."url",
	"Characters"."firstname",
    "Characters"."lastname",
    "Characters"."description",
    "Characters"."race",
    "Characters"."class",
    "Characters"."is_alive",
    "Skills"."name",
    "Skills"."description",
    "Characteristics"."strength",
    "Characteristics"."dexterity",
    "Characteristics"."wisdom",
    "Characteristics"."charisma",
    "Characteristics"."constitution",
    "Characteristics"."intelligence",
    "Characteristics"."level",
    "Characteristics"."hp",
    "Items"."name",
    "Items"."quantity",
    "Items"."description" 
	FROM "Games"
	FULL JOIN "Users" ON "Games"."user_id" = "Users"."id"
	FULL JOIN "game_has_maps" ON "Games"."id" = "game_has_maps"."game_id"
	FULL JOIN "Maps" ON "game_has_maps"."map_id" = "Maps"."id"
	FULL JOIN "Characters" ON "Characters"."game_id" = "Games"."id"
	FULL JOIN "Characteristics" ON "Characters"."id" = "Characteristics"."character_id"
	FULL JOIN "Skills" ON "Characters"."id" = "Skills"."character_id"
	FULL JOIN "Items" ON "Characters"."id" = "Items"."character_id"
	WHERE "Games"."id" = gameid
	AND "Games"."user_id" = userid;
	IF NOT FOUND THEN  -- si la fonction n'et pas lancer par le Mj elle retourne uniquement le personnage du joueur au lieu de tout les persos
		RETURN QUERY SELECT 
		"Games"."name",
		"Games"."notes",
		"Users"."pseudo",
		"Maps"."name",
		"Maps"."url",
		"Characters"."firstname",
		"Characters"."lastname",
		"Characters"."description",
		"Characters"."race",
		"Characters"."class",
		"Characters"."is_alive",
		"Skills"."name",
		"Skills"."description",
		"Characteristics"."strength",
		"Characteristics"."dexterity",
		"Characteristics"."wisdom",
		"Characteristics"."charisma",
		"Characteristics"."constitution",
		"Characteristics"."intelligence",
		"Characteristics"."level",
		"Characteristics"."hp",
		"Items"."name",
		"Items"."quantity",
		"Items"."description" 
		FROM "Games"
		FULL JOIN "Users" ON "Games"."user_id" = "Users"."id"
		FULL JOIN "game_has_maps" ON "Games"."id" = "game_has_maps"."game_id"
		FULL JOIN "Maps" ON "game_has_maps"."map_id" = "Maps"."id"
		FULL JOIN "Characters" ON "Characters"."game_id" = "Games"."id"
		FULL JOIN "Characteristics" ON "Characters"."id" = "Characteristics"."character_id"
		FULL JOIN "Skills" ON "Characters"."id" = "Skills"."character_id"
		FULL JOIN "Items" ON "Characters"."id" = "Items"."character_id"
		WHERE "Games"."id" = gameid
		AND "Characters".user_id = userid;
	END IF;
END;
$$ LANGUAGE plpgsql;
/*
SELECT * FROM gameroom_by_id(2, 1)
SELECT * FROM gameroom_by_id(4, 1)
*/