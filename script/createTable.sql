BEGIN;

DROP TABLE IF EXISTS "game_has_maps",
"Invite",
"Maps",
"News",
"Characteristics",
"Skills",
"Items",
"Characters",
"Games",
"Users" CASCADE;


DROP DOMAIN IF EXISTS "email", "url";


-- Création du domaine 'path'
CREATE DOMAIN "url" AS text
CONSTRAINT url_format CHECK (value ~ '^(\/[a-zA-Z0-9_.-]+)+\/?$');

-- Création du domaine 'email'
CREATE DOMAIN email AS text
CONSTRAINT email_format CHECK (value ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

CREATE TABLE IF NOT EXISTS "Users" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "pseudo" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "email" email NOT NULL UNIQUE,
    "is_admin" BOOLEAN NOT NULL DEFAULT FALSE,
    "lastname" TEXT,
    "firstname" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Games" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT NOT NULL,
    "max_players" INT NOT NULL,
    "notes" TEXT,
    "status" TEXT NOT NULL DEFAULT 'start',
    "user_id" INT REFERENCES "Users"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Characters" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "firstname" TEXT NOT NULL,
    "lastname" TEXT,
    "avatar" url,
    "description" TEXT NOT NULL,
    "race" TEXT NOT NULL,
    "class" TEXT NOT NULL,
    "is_alive" BOOLEAN NOT NULL DEFAULT TRUE,
    "game_id" INT REFERENCES  "Games"("id") ON DELETE CASCADE ,
    "user_id" INT REFERENCES "Users"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Items" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL,
    "quantity" INT,
    "description" TEXT,
    "character_id" INT REFERENCES "Characters"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Skills" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "character_id" INT REFERENCES "Characters"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Characteristics"(
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "strength" INT NOT NULL,
    "dexterity" INT NOT NULL,
    "wisdom" INT NOT NULL,
    "charisma" INT NOT NULL,
    "constitution" INT NOT NULL,
    "intelligence"INT NOT NULL,
    "level" INT NOT NULL,
    "max_hp" INT NOT NULL,
    "current_hp" INT NOT NULL,
    "max_mana" INT NOT NULL,
    "current_mana" INT NOT NULL,
    "character_id" INT UNIQUE REFERENCES "Characters"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "News" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "user_id" INT REFERENCES "Users"("id") ON DELETE SET NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Maps" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "url" url NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "Invite" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "game_id" INT NOT NULL REFERENCES "Games"("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "Users"("id") ON DELETE CASCADE,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- on peut également utiliser NOW()
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "game_has_maps" (
    "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "game_id" INT NOT NULL REFERENCES "Games"("id") ON DELETE CASCADE,
    "map_id" INT NOT NULL REFERENCES "Maps"("id") ON DELETE CASCADE
);

COMMIT;