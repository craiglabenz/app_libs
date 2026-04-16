BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_user_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userName" text,
    "fullName" text,
    "imageUrl" text,
    "updatedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_profile_userName_idx" ON "auth_user_profile" USING btree ("userName");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_user_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "email" text,
    "loggingId" uuid NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_settings_email_idx" ON "auth_user_settings" USING btree ("email");


--
-- MIGRATION VERSION FOR example
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('example', '20260223001746156-settings-and-profile', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260223001746156-settings-and-profile', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
