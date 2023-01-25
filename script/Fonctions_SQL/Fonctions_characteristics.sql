-- SQLBook: Code
--Met à jour les stats(Characteristics) d'un personnage "id" en bdd
CREATE OR REPLACE FUNCTION create_or_update_characteristics_with_result(
    IN new_id INT,
    IN new_strength INT,
    IN new_dexterity INT,
    IN new_wisdom INT,
    IN new_charisma INT,
    IN new_constitution INT,
    IN new_intelligence INT,
    IN new_level INT,
    IN new_hp INT,
    IN new_char_id INT
)
RETURNS TABLE("id" INTEGER, strength INT, dexterity INT, wisdom INT, charisma INT, constitution INT, intellignece INT, "level" INT, hp INT, character_id INT, create_at TIMESTAMPTZ, updated_at TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Characteristics" SET strength = new_strength, dexterity = new_dexterity, wisdom = new_wisdom, charisma = new_charisma, constitution = new_constitution, intelligence = new_intelligence, "level" = new_level, hp = new_hp, "character_id" = new_char_id, updated_at = now() WHERE "new_id" = "Characteristics".id;
    IF NOT FOUND THEN 
        INSERT INTO "Characteristics" ( strength, dexterity, wisdom, charisma, constitution, intelligence, "level", hp, character_id) VALUES ( new_strength, new_dexterity, new_wisdom, new_charisma, new_constitution, new_intelligence, new_level, new_hp, new_char_id) RETURNING "Characteristics".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Characteristics".id, "Characteristics".strength, "Characteristics".dexterity, "Characteristics".wisdom, "Characteristics".charisma, "Characteristics".constitution, "Characteristics".intelligence, "Characteristics"."level", "Characteristics".hp, "Characteristics".character_id "Characteristics".created_at, "Characteristics".updated_at FROM "Characteristics" WHERE "Characteristics".id = new_id;
END
$$ LANGUAGE plpgsql;
/*
Script de test de la fonction:

SELECT * from update_characteristics_by_char_id(
	1, 3, 7, 8, 12, 666, 6545, 6, 9)

*/

--Creer les stats(Characteristics) d'un personnage "id" en bdd
CREATE OR REPLACE FUNCTION create_characteristics_by_char_id(IN char_id INT, IN new_strength INT, IN new_dexterity INT, IN new_wisdom INT, IN new_charisma INT, IN new_constitution INT, IN new_intelligence INT, IN new_level INT, IN new_hp INT)
RETURNS TABLE(
    "id" INT,
    "strength" INT,
    "dexterity" INT,
    "wisdom" INT,
    "charisma" INT,
    "constitution" INT,
    "intelligence" INT,
    "level" INT,
    "hp" INT
) AS $$
BEGIN
    INSERT INTO "Characteristics" ( "id", "strength", "dexterity", "wisdom", "charisma", "constitution", "intelligence", "level", "hp")
		VALUES (char_id, new_strength, new_dexterity, new_wisdom, new_charisma, new_constitution, new_intelligence, new_level, new_hp);
    -- ici ou précise Characteristics.wisdom ... afin d'éviter les ambiguïtés,
    RETURN QUERY SELECT "Characteristics"."id", "Characteristics"."strength", "Characteristics"."dexterity", "Characteristics"."wisdom", "Characteristics"."charisma", "Characteristics"."constitution", "Characteristics"."intelligence", "Characteristics"."level", "Characteristics"."hp" FROM "Characteristics" WHERE "character_id" = char_id;
END;
$$ LANGUAGE plpgsql;

/*
Script de test de la fonction:

SELECT create_characteristics_by_char_id(3, 12,18,10,10,10,10,5,50)

CREATE OR REPLACE FUNCTION create_or_update_characteristics_with_result(
    IN new_id INT,
    IN new_strength INT,
    IN new_dexterity INT,
    IN new_wisdom INT,
    IN new_charisma INT,
    IN new_constitution INT,
    IN new_intelligence INT,
    IN new_level INT,
    IN new_hp INT,
    IN new_char_id INT
)
RETURNS TABLE("id" INTEGER, strength INT, dexterity INT, wisdom INT, charisma INT, constitution INT, intellignece INT, "level" INT, hp INT, character_id INT, create_at TIMESTAMPTZ, updated_at TIMESTAMPTZ) AS $$
BEGIN
    -- En first on essai l'update 
    UPDATE "Characteristics" SET strength = new_strength, dexterity = new_dexterity, wisdom = new_wisdom, charisma = new_charisma, constitution = new_constitution, intelligence = new_intelligence, "level" = new_level, hp = new_hp, "character_id" = new_char_id, updated_at = now() WHERE "new_id" = "Characteristics".id;
    IF NOT FOUND THEN 
        INSERT INTO "Characteristics" ( strength, dexterity, wisdom, charisma, constitution, intelligence, "level", hp, "character_id") VALUES ( new_strength, new_dexterity, new_wisdom, new_charisma, new_constitution, new_intelligence, new_level, new_hp, new_char_id) RETURNING "Characteristics".id INTO new_id; -- on stock la valeur de l'id créer dans "new_id"
    END IF;
    RETURN QUERY SELECT "Characteristics".id, "Characteristics".strength, "Characteristics".dexterity, "Characteristics".wisdom, "Characteristics".charisma, "Characteristics".constitution, "Characteristics".intelligence, "Characteristics"."level", "Characteristics".hp, "Characteristics".character_id, "Characteristics".created_at, "Characteristics".updated_at FROM "Characteristics" WHERE "Characteristics".id = new_id;
END
$$ LANGUAGE plpgsql;