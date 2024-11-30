BEGIN;
--
-- Create model Project
--
CREATE TABLE "portfolio_project" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "title" varchar(200) NOT NULL, "description" text NOT NULL, "image" varchar(100) NULL, "live_url" varchar(200) NOT NULL, "github_url" varchar(200) NOT NULL, "created_at" timestamp with time zone NOT NULL, "updated_at" timestamp with time zone NOT NULL);
--
-- Create model ProjectTechnology
--
CREATE TABLE "portfolio_projecttechnology" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "name" varchar(50) NOT NULL, "project_id" bigint NOT NULL);
--
-- Create model UserProfile
--
CREATE TABLE "portfolio_userprofile" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "avatar" varchar(100) NULL, "title" varchar(100) NOT NULL, "bio" text NOT NULL, "location" varchar(100) NOT NULL, "phone" varchar(20) NOT NULL, "website" varchar(200) NOT NULL, "github" varchar(200) NOT NULL, "linkedin" varchar(200) NOT NULL, "twitter" varchar(200) NOT NULL, "created_at" timestamp with time zone NOT NULL, "updated_at" timestamp with time zone NOT NULL, "user_id" integer NOT NULL UNIQUE);
--
-- Create model Skill
--
CREATE TABLE "portfolio_skill" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "name" varchar(50) NOT NULL, "profile_id" bigint NOT NULL);
--
-- Add field profile to project
--
ALTER TABLE "portfolio_project" ADD COLUMN "profile_id" bigint NOT NULL CONSTRAINT "portfolio_project_profile_id_9a9ce36a_fk_portfolio" REFERENCES "portfolio_userprofile"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "portfolio_project_profile_id_9a9ce36a_fk_portfolio" IMMEDIATE;
--
-- Create model Experience
--
CREATE TABLE "portfolio_experience" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "company" varchar(100) NOT NULL, "position" varchar(100) NOT NULL, "description" text NOT NULL, "start_date" date NOT NULL, "end_date" date NULL, "current" boolean NOT NULL, "created_at" timestamp with time zone NOT NULL, "updated_at" timestamp with time zone NOT NULL, "profile_id" bigint NOT NULL);
--
-- Create model Education
--
CREATE TABLE "portfolio_education" ("id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, "institution" varchar(200) NOT NULL, "degree" varchar(200) NOT NULL, "field_of_study" varchar(200) NOT NULL, "description" text NOT NULL, "start_date" date NOT NULL, "end_date" date NULL, "current" boolean NOT NULL, "created_at" timestamp with time zone NOT NULL, "updated_at" timestamp with time zone NOT NULL, "profile_id" bigint NOT NULL);
ALTER TABLE "portfolio_projecttechnology" ADD CONSTRAINT "portfolio_projecttec_project_id_a4961492_fk_portfolio" FOREIGN KEY ("project_id") REFERENCES "portfolio_project" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "portfolio_projecttechnology_project_id_a4961492" ON "portfolio_projecttechnology" ("project_id");
ALTER TABLE "portfolio_userprofile" ADD CONSTRAINT "portfolio_userprofile_user_id_81c8245f_fk_auth_user_id" FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "portfolio_skill" ADD CONSTRAINT "portfolio_skill_profile_id_59554540_fk_portfolio_userprofile_id" FOREIGN KEY ("profile_id") REFERENCES "portfolio_userprofile" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "portfolio_skill_profile_id_59554540" ON "portfolio_skill" ("profile_id");
CREATE INDEX "portfolio_project_profile_id_9a9ce36a" ON "portfolio_project" ("profile_id");
ALTER TABLE "portfolio_experience" ADD CONSTRAINT "portfolio_experience_profile_id_3cec475f_fk_portfolio" FOREIGN KEY ("profile_id") REFERENCES "portfolio_userprofile" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "portfolio_experience_profile_id_3cec475f" ON "portfolio_experience" ("profile_id");
ALTER TABLE "portfolio_education" ADD CONSTRAINT "portfolio_education_profile_id_12a0cfc7_fk_portfolio" FOREIGN KEY ("profile_id") REFERENCES "portfolio_userprofile" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "portfolio_education_profile_id_12a0cfc7" ON "portfolio_education" ("profile_id");
COMMIT;
