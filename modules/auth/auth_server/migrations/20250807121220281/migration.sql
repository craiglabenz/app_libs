BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_user_failed_logins" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_users" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "socialId" text,
    "email" text,
    "lastAuthProvider" text NOT NULL,
    "allProviders" json NOT NULL,
    "loggingId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "social_id_idx" ON "auth_users" USING btree ("socialId");
CREATE UNIQUE INDEX "email_auth_user_idx" ON "auth_users" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_users_apple" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "email" text,
    "givenName" text,
    "familyName" text,
    "authorizationCode" text NOT NULL,
    "identityToken" text,
    "userIdentifier" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_users_email" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "email" text NOT NULL,
    "password" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "email_auth_user_email_idx" ON "auth_users_email" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_users_google" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "email" text,
    "displayName" text,
    "photoUrl" text,
    "idToken" text,
    "serverAuthCode" text,
    "uniqueId" text
);

-- Indexes
CREATE UNIQUE INDEX "email_idx" ON "auth_users_google" USING btree ("email");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auth_user_failed_logins"
    ADD CONSTRAINT "auth_user_failed_logins_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "auth_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auth_users_apple"
    ADD CONSTRAINT "auth_users_apple_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "auth_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auth_users_email"
    ADD CONSTRAINT "auth_users_email_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "auth_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auth_users_google"
    ADD CONSTRAINT "auth_users_google_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "auth_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth', '20250807121220281', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250807121220281', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
