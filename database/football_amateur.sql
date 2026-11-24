--
-- PostgreSQL database dump
--

\restrict 7PZL7b4OfoDNMKbmLmOBQp87c4bGPY1TCIQsSwRiul3TWylBiXs5zIl7zDvJPfs

-- Dumped from database version 16.16
-- Dumped by pg_dump version 16.16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."TrainingSessions" DROP CONSTRAINT IF EXISTS "TrainingSessions_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."TrainingSessions" DROP CONSTRAINT IF EXISTS "TrainingSessions_coachId_fkey";
ALTER TABLE IF EXISTS ONLY public."TrainingAttendances" DROP CONSTRAINT IF EXISTS "TrainingAttendances_trainingSessionId_fkey";
ALTER TABLE IF EXISTS ONLY public."TrainingAttendances" DROP CONSTRAINT IF EXISTS "TrainingAttendances_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."TournamentApplications" DROP CONSTRAINT IF EXISTS "TournamentApplications_tournamentId_fkey";
ALTER TABLE IF EXISTS ONLY public."TournamentApplications" DROP CONSTRAINT IF EXISTS "TournamentApplications_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."TournamentApplications" DROP CONSTRAINT IF EXISTS "TournamentApplications_reviewedBy_fkey";
ALTER TABLE IF EXISTS ONLY public."Teams" DROP CONSTRAINT IF EXISTS "Teams_tournamentId_fkey";
ALTER TABLE IF EXISTS ONLY public."ScoutWatchlists" DROP CONSTRAINT IF EXISTS "ScoutWatchlists_scoutId_fkey";
ALTER TABLE IF EXISTS ONLY public."ScoutWatchlists" DROP CONSTRAINT IF EXISTS "ScoutWatchlists_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."ScoutEvaluations" DROP CONSTRAINT IF EXISTS "ScoutEvaluations_scoutId_fkey";
ALTER TABLE IF EXISTS ONLY public."ScoutEvaluations" DROP CONSTRAINT IF EXISTS "ScoutEvaluations_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."RefereeMissions" DROP CONSTRAINT IF EXISTS "RefereeMissions_refereeId_fkey";
ALTER TABLE IF EXISTS ONLY public."RefereeMissions" DROP CONSTRAINT IF EXISTS "RefereeMissions_matchId_fkey";
ALTER TABLE IF EXISTS ONLY public."Players" DROP CONSTRAINT IF EXISTS "Players_userId_fkey";
ALTER TABLE IF EXISTS ONLY public."Players" DROP CONSTRAINT IF EXISTS "Players_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerStats" DROP CONSTRAINT IF EXISTS "PlayerStats_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerRewards" DROP CONSTRAINT IF EXISTS "PlayerRewards_tournamentId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerRewards" DROP CONSTRAINT IF EXISTS "PlayerRewards_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerRewards" DROP CONSTRAINT IF EXISTS "PlayerRewards_awardedById_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerClubHistories" DROP CONSTRAINT IF EXISTS "PlayerClubHistories_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerClubHistories" DROP CONSTRAINT IF EXISTS "PlayerClubHistories_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerBadges" DROP CONSTRAINT IF EXISTS "PlayerBadges_tournamentId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerBadges" DROP CONSTRAINT IF EXISTS "PlayerBadges_playerId_fkey";
ALTER TABLE IF EXISTS ONLY public."PlayerBadges" DROP CONSTRAINT IF EXISTS "PlayerBadges_awardedById_fkey";
ALTER TABLE IF EXISTS ONLY public."Matches" DROP CONSTRAINT IF EXISTS "Matches_tournamentId_fkey";
ALTER TABLE IF EXISTS ONLY public."Matches" DROP CONSTRAINT IF EXISTS "Matches_homeTeamId_fkey";
ALTER TABLE IF EXISTS ONLY public."Matches" DROP CONSTRAINT IF EXISTS "Matches_awayTeamId_fkey";
ALTER TABLE IF EXISTS ONLY public."MatchLineups" DROP CONSTRAINT IF EXISTS "MatchLineups_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."MatchLineups" DROP CONSTRAINT IF EXISTS "MatchLineups_matchId_fkey";
ALTER TABLE IF EXISTS ONLY public."MatchEvents" DROP CONSTRAINT IF EXISTS "MatchEvents_matchId_fkey";
ALTER TABLE IF EXISTS ONLY public."Chats" DROP CONSTRAINT IF EXISTS "Chats_teamId_fkey";
ALTER TABLE IF EXISTS ONLY public."Chats" DROP CONSTRAINT IF EXISTS "Chats_senderId_fkey";
DROP INDEX IF EXISTS public.training_attendances_training_session_id_player_id;
DROP INDEX IF EXISTS public.tournaments_status;
DROP INDEX IF EXISTS public.tournaments_start_date;
DROP INDEX IF EXISTS public.tournaments_is_public;
DROP INDEX IF EXISTS public.scout_watchlists_scout_id_player_id;
DROP INDEX IF EXISTS public.scout_evaluations_scout_id_player_id;
DROP INDEX IF EXISTS public.referee_missions_match_id_referee_id;
DROP INDEX IF EXISTS public.match_lineups_match_id_team_id;
DROP INDEX IF EXISTS public.chats_team_id;
DROP INDEX IF EXISTS public.chats_created_at;
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_pkey";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key5";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key4";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key3";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key2";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key1";
ALTER TABLE IF EXISTS ONLY public."Users" DROP CONSTRAINT IF EXISTS "Users_email_key";
ALTER TABLE IF EXISTS ONLY public."TrainingSessions" DROP CONSTRAINT IF EXISTS "TrainingSessions_pkey";
ALTER TABLE IF EXISTS ONLY public."TrainingAttendances" DROP CONSTRAINT IF EXISTS "TrainingAttendances_pkey";
ALTER TABLE IF EXISTS ONLY public."Tournaments" DROP CONSTRAINT IF EXISTS "Tournaments_pkey";
ALTER TABLE IF EXISTS ONLY public."TournamentApplications" DROP CONSTRAINT IF EXISTS "TournamentApplications_pkey";
ALTER TABLE IF EXISTS ONLY public."Teams" DROP CONSTRAINT IF EXISTS "Teams_pkey";
ALTER TABLE IF EXISTS ONLY public."ScoutWatchlists" DROP CONSTRAINT IF EXISTS "ScoutWatchlists_pkey";
ALTER TABLE IF EXISTS ONLY public."ScoutEvaluations" DROP CONSTRAINT IF EXISTS "ScoutEvaluations_pkey";
ALTER TABLE IF EXISTS ONLY public."RefereeMissions" DROP CONSTRAINT IF EXISTS "RefereeMissions_pkey";
ALTER TABLE IF EXISTS ONLY public."Players" DROP CONSTRAINT IF EXISTS "Players_pkey";
ALTER TABLE IF EXISTS ONLY public."PlayerStats" DROP CONSTRAINT IF EXISTS "PlayerStats_pkey";
ALTER TABLE IF EXISTS ONLY public."PlayerRewards" DROP CONSTRAINT IF EXISTS "PlayerRewards_pkey";
ALTER TABLE IF EXISTS ONLY public."PlayerClubHistories" DROP CONSTRAINT IF EXISTS "PlayerClubHistories_pkey";
ALTER TABLE IF EXISTS ONLY public."PlayerBadges" DROP CONSTRAINT IF EXISTS "PlayerBadges_pkey";
ALTER TABLE IF EXISTS ONLY public."Matches" DROP CONSTRAINT IF EXISTS "Matches_pkey";
ALTER TABLE IF EXISTS ONLY public."MatchLineups" DROP CONSTRAINT IF EXISTS "MatchLineups_pkey";
ALTER TABLE IF EXISTS ONLY public."MatchEvents" DROP CONSTRAINT IF EXISTS "MatchEvents_pkey";
ALTER TABLE IF EXISTS ONLY public."Chats" DROP CONSTRAINT IF EXISTS "Chats_pkey";
ALTER TABLE IF EXISTS public."Users" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."TrainingSessions" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."TrainingAttendances" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Tournaments" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."TournamentApplications" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Teams" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."ScoutWatchlists" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."ScoutEvaluations" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."RefereeMissions" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Players" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PlayerStats" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PlayerRewards" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PlayerClubHistories" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PlayerBadges" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Matches" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."MatchLineups" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."MatchEvents" ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public."Users_id_seq";
DROP TABLE IF EXISTS public."Users";
DROP SEQUENCE IF EXISTS public."TrainingSessions_id_seq";
DROP TABLE IF EXISTS public."TrainingSessions";
DROP SEQUENCE IF EXISTS public."TrainingAttendances_id_seq";
DROP TABLE IF EXISTS public."TrainingAttendances";
DROP SEQUENCE IF EXISTS public."Tournaments_id_seq";
DROP TABLE IF EXISTS public."Tournaments";
DROP SEQUENCE IF EXISTS public."TournamentApplications_id_seq";
DROP TABLE IF EXISTS public."TournamentApplications";
DROP SEQUENCE IF EXISTS public."Teams_id_seq";
DROP TABLE IF EXISTS public."Teams";
DROP SEQUENCE IF EXISTS public."ScoutWatchlists_id_seq";
DROP TABLE IF EXISTS public."ScoutWatchlists";
DROP SEQUENCE IF EXISTS public."ScoutEvaluations_id_seq";
DROP TABLE IF EXISTS public."ScoutEvaluations";
DROP SEQUENCE IF EXISTS public."RefereeMissions_id_seq";
DROP TABLE IF EXISTS public."RefereeMissions";
DROP SEQUENCE IF EXISTS public."Players_id_seq";
DROP TABLE IF EXISTS public."Players";
DROP SEQUENCE IF EXISTS public."PlayerStats_id_seq";
DROP TABLE IF EXISTS public."PlayerStats";
DROP SEQUENCE IF EXISTS public."PlayerRewards_id_seq";
DROP TABLE IF EXISTS public."PlayerRewards";
DROP SEQUENCE IF EXISTS public."PlayerClubHistories_id_seq";
DROP TABLE IF EXISTS public."PlayerClubHistories";
DROP SEQUENCE IF EXISTS public."PlayerBadges_id_seq";
DROP TABLE IF EXISTS public."PlayerBadges";
DROP SEQUENCE IF EXISTS public."Matches_id_seq";
DROP TABLE IF EXISTS public."Matches";
DROP SEQUENCE IF EXISTS public."MatchLineups_id_seq";
DROP TABLE IF EXISTS public."MatchLineups";
DROP SEQUENCE IF EXISTS public."MatchEvents_id_seq";
DROP TABLE IF EXISTS public."MatchEvents";
DROP TABLE IF EXISTS public."Chats";
DROP TYPE IF EXISTS public."enum_Users_role";
DROP TYPE IF EXISTS public."enum_TrainingSessions_type";
DROP TYPE IF EXISTS public."enum_TrainingSessions_status";
DROP TYPE IF EXISTS public."enum_TrainingAttendances_status";
DROP TYPE IF EXISTS public."enum_Tournaments_status";
DROP TYPE IF EXISTS public."enum_Tournaments_format";
DROP TYPE IF EXISTS public."enum_TournamentApplications_status";
DROP TYPE IF EXISTS public."enum_ScoutEvaluations_recommendation";
DROP TYPE IF EXISTS public."enum_ScoutEvaluations_potential";
DROP TYPE IF EXISTS public."enum_RefereeMissions_status";
DROP TYPE IF EXISTS public."enum_RefereeMissions_role";
DROP TYPE IF EXISTS public."enum_Players_preferredFoot";
DROP TYPE IF EXISTS public."enum_Players_position";
DROP TYPE IF EXISTS public."enum_PlayerRewards_type";
DROP TYPE IF EXISTS public."enum_PlayerRewards_category";
DROP TYPE IF EXISTS public."enum_PlayerBadges_type";
DROP TYPE IF EXISTS public."enum_PlayerBadges_source";
DROP TYPE IF EXISTS public."enum_PlayerBadges_rarity";
DROP TYPE IF EXISTS public."enum_Matches_status";
DROP TYPE IF EXISTS public."enum_MatchLineups_status";
DROP TYPE IF EXISTS public."enum_MatchEvents_type";
DROP TYPE IF EXISTS public."enum_Chats_messageType";
--
-- Name: enum_Chats_messageType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Chats_messageType" AS ENUM (
    'text',
    'image',
    'file'
);


--
-- Name: enum_MatchEvents_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_MatchEvents_type" AS ENUM (
    'goal',
    'assist',
    'yellow_card',
    'red_card',
    'substitution',
    'injury',
    'penalty_goal',
    'own_goal'
);


--
-- Name: enum_MatchLineups_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_MatchLineups_status" AS ENUM (
    'draft',
    'published'
);


--
-- Name: enum_Matches_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Matches_status" AS ENUM (
    'scheduled',
    'in_progress',
    'completed',
    'cancelled',
    'postponed'
);


--
-- Name: enum_PlayerBadges_rarity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_PlayerBadges_rarity" AS ENUM (
    'common',
    'uncommon',
    'rare',
    'epic',
    'legendary'
);


--
-- Name: enum_PlayerBadges_source; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_PlayerBadges_source" AS ENUM (
    'coach',
    'admin',
    'tournament',
    'system'
);


--
-- Name: enum_PlayerBadges_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_PlayerBadges_type" AS ENUM (
    'tournament',
    'training',
    'match',
    'achievement',
    'participation',
    'excellence'
);


--
-- Name: enum_PlayerRewards_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_PlayerRewards_category" AS ENUM (
    'tournament',
    'training',
    'special',
    'milestone'
);


--
-- Name: enum_PlayerRewards_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_PlayerRewards_type" AS ENUM (
    'tournament',
    'training',
    'special',
    'milestone'
);


--
-- Name: enum_Players_position; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Players_position" AS ENUM (
    'gardien',
    'defenseur',
    'milieu',
    'attaquant'
);


--
-- Name: enum_Players_preferredFoot; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Players_preferredFoot" AS ENUM (
    'gauche',
    'droit',
    'ambidextre'
);


--
-- Name: enum_RefereeMissions_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_RefereeMissions_role" AS ENUM (
    'main',
    'assistant',
    'fourth'
);


--
-- Name: enum_RefereeMissions_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_RefereeMissions_status" AS ENUM (
    'pending',
    'accepted',
    'declined'
);


--
-- Name: enum_ScoutEvaluations_potential; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_ScoutEvaluations_potential" AS ENUM (
    'low',
    'medium',
    'high',
    'elite'
);


--
-- Name: enum_ScoutEvaluations_recommendation; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_ScoutEvaluations_recommendation" AS ENUM (
    'sign',
    'watch',
    'reject'
);


--
-- Name: enum_TournamentApplications_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_TournamentApplications_status" AS ENUM (
    'pending',
    'approved',
    'rejected'
);


--
-- Name: enum_Tournaments_format; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Tournaments_format" AS ENUM (
    'league',
    'knockout',
    'group_then_knockout'
);


--
-- Name: enum_Tournaments_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Tournaments_status" AS ENUM (
    'draft',
    'active',
    'completed',
    'cancelled'
);


--
-- Name: enum_TrainingAttendances_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_TrainingAttendances_status" AS ENUM (
    'present',
    'absent',
    'excused'
);


--
-- Name: enum_TrainingSessions_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_TrainingSessions_status" AS ENUM (
    'scheduled',
    'completed',
    'cancelled'
);


--
-- Name: enum_TrainingSessions_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_TrainingSessions_type" AS ENUM (
    'technique',
    'tactique',
    'physique',
    'match',
    'autre'
);


--
-- Name: enum_Users_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."enum_Users_role" AS ENUM (
    'admin',
    'coach',
    'joueur',
    'arbitre'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Chats" (
    id uuid NOT NULL,
    message text NOT NULL,
    "messageType" public."enum_Chats_messageType" DEFAULT 'text'::public."enum_Chats_messageType",
    "senderId" integer NOT NULL,
    "teamId" integer NOT NULL,
    "isRead" boolean DEFAULT false,
    "readAt" timestamp with time zone,
    "attachmentUrl" character varying(255),
    "readBy" json DEFAULT '[]'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: MatchEvents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MatchEvents" (
    id integer NOT NULL,
    "matchId" integer,
    type public."enum_MatchEvents_type" NOT NULL,
    minute integer NOT NULL,
    "extraMinute" integer,
    description text,
    "isHomeTeam" boolean NOT NULL,
    "relatedPlayerId" integer,
    "relatedPlayerName" character varying(255),
    "substitutionPlayerInId" integer,
    "substitutionPlayerInName" character varying(255),
    "substitutionPlayerOutId" integer,
    "substitutionPlayerOutName" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: MatchEvents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."MatchEvents_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: MatchEvents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."MatchEvents_id_seq" OWNED BY public."MatchEvents".id;


--
-- Name: MatchLineups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MatchLineups" (
    id integer NOT NULL,
    "matchId" integer NOT NULL,
    "teamId" integer NOT NULL,
    formation character varying(10) DEFAULT '4-3-3'::character varying NOT NULL,
    players json DEFAULT '[]'::json NOT NULL,
    status public."enum_MatchLineups_status" DEFAULT 'draft'::public."enum_MatchLineups_status" NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: MatchLineups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."MatchLineups_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: MatchLineups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."MatchLineups_id_seq" OWNED BY public."MatchLineups".id;


--
-- Name: Matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Matches" (
    id integer NOT NULL,
    "tournamentId" integer,
    "roundNumber" integer,
    "matchIndex" integer,
    "homeTeamId" integer,
    "awayTeamId" integer,
    date timestamp with time zone NOT NULL,
    location character varying(255),
    status public."enum_Matches_status" DEFAULT 'scheduled'::public."enum_Matches_status",
    "homeTeamScore" integer DEFAULT 0,
    "awayTeamScore" integer DEFAULT 0,
    "winnerTeamId" integer,
    "advancesToMatchId" integer,
    "halfTimeHomeScore" integer DEFAULT 0,
    "halfTimeAwayScore" integer DEFAULT 0,
    referee character varying(255),
    "assistantReferee1" character varying(255),
    "assistantReferee2" character varying(255),
    "fourthOfficial" character varying(255),
    weather character varying(255),
    attendance integer,
    notes text,
    "reminderSent" boolean DEFAULT false NOT NULL,
    "notifSoonSent" boolean DEFAULT false NOT NULL,
    "minutesComputed" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: Matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Matches_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Matches_id_seq" OWNED BY public."Matches".id;


--
-- Name: PlayerBadges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PlayerBadges" (
    id integer NOT NULL,
    "playerId" integer NOT NULL,
    name character varying(255) NOT NULL,
    type public."enum_PlayerBadges_type" DEFAULT 'achievement'::public."enum_PlayerBadges_type" NOT NULL,
    rarity public."enum_PlayerBadges_rarity" DEFAULT 'common'::public."enum_PlayerBadges_rarity" NOT NULL,
    description text,
    count integer DEFAULT 1,
    source public."enum_PlayerBadges_source" DEFAULT 'coach'::public."enum_PlayerBadges_source" NOT NULL,
    icon character varying(255),
    "awardedById" integer,
    "tournamentId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: PlayerBadges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PlayerBadges_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PlayerBadges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PlayerBadges_id_seq" OWNED BY public."PlayerBadges".id;


--
-- Name: PlayerClubHistories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PlayerClubHistories" (
    id integer NOT NULL,
    "playerId" integer NOT NULL,
    "teamId" integer,
    "teamName" character varying(255) NOT NULL,
    "teamLogo" character varying(255),
    "startDate" date,
    "endDate" date,
    goals integer DEFAULT 0,
    assists integer DEFAULT 0,
    matches integer DEFAULT 0,
    "minutesPlayed" integer DEFAULT 0,
    "yellowCards" integer DEFAULT 0,
    "redCards" integer DEFAULT 0,
    "cleanSheets" integer DEFAULT 0,
    saves integer DEFAULT 0,
    tackles integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: PlayerClubHistories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PlayerClubHistories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PlayerClubHistories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PlayerClubHistories_id_seq" OWNED BY public."PlayerClubHistories".id;


--
-- Name: PlayerRewards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PlayerRewards" (
    id integer NOT NULL,
    "playerId" integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    type public."enum_PlayerRewards_type" DEFAULT 'special'::public."enum_PlayerRewards_type" NOT NULL,
    category public."enum_PlayerRewards_category" DEFAULT 'special'::public."enum_PlayerRewards_category" NOT NULL,
    value integer DEFAULT 0,
    icon character varying(255),
    "awardedById" integer,
    "tournamentId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: PlayerRewards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PlayerRewards_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PlayerRewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PlayerRewards_id_seq" OWNED BY public."PlayerRewards".id;


--
-- Name: PlayerStats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PlayerStats" (
    id integer NOT NULL,
    "playerId" integer,
    goals integer DEFAULT 0,
    assists integer DEFAULT 0,
    shots integer DEFAULT 0,
    "shotsOnTarget" integer DEFAULT 0,
    passes integer DEFAULT 0,
    "keyPasses" integer DEFAULT 0,
    tackles integer DEFAULT 0,
    interceptions integer DEFAULT 0,
    clearances integer DEFAULT 0,
    dribbles integer DEFAULT 0,
    "foulsCommitted" integer DEFAULT 0,
    "foulsSuffered" integer DEFAULT 0,
    offsides integer DEFAULT 0,
    saves integer DEFAULT 0,
    "cleanSheets" integer DEFAULT 0,
    "goalsConceded" integer DEFAULT 0,
    "penaltiesSaved" integer DEFAULT 0,
    "duelsWon" integer DEFAULT 0,
    "aerialDuelsWon" integer DEFAULT 0,
    "minutesPlayed" integer DEFAULT 0,
    "yellowCards" integer DEFAULT 0,
    "redCards" integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: PlayerStats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PlayerStats_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PlayerStats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PlayerStats_id_seq" OWNED BY public."PlayerStats".id;


--
-- Name: Players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Players" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "position" public."enum_Players_position" NOT NULL,
    "jerseyNumber" integer,
    "teamId" integer,
    "userId" integer,
    "dateOfBirth" date,
    height integer,
    weight integer,
    nationality character varying(255),
    "preferredFoot" public."enum_Players_preferredFoot",
    "isCaptain" boolean DEFAULT false,
    "isActive" boolean DEFAULT true,
    "joinDate" date,
    avatar character varying(255),
    email character varying(255),
    phone character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: Players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Players_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Players_id_seq" OWNED BY public."Players".id;


--
-- Name: RefereeMissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."RefereeMissions" (
    id integer NOT NULL,
    "matchId" integer NOT NULL,
    "refereeId" integer NOT NULL,
    role public."enum_RefereeMissions_role" DEFAULT 'main'::public."enum_RefereeMissions_role" NOT NULL,
    status public."enum_RefereeMissions_status" DEFAULT 'pending'::public."enum_RefereeMissions_status" NOT NULL,
    "respondedAt" timestamp with time zone,
    "declineReason" character varying(300),
    "presenceSheetUrl" character varying(255),
    "matchSheetUrl" character varying(255),
    "assignedById" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: RefereeMissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."RefereeMissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: RefereeMissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."RefereeMissions_id_seq" OWNED BY public."RefereeMissions".id;


--
-- Name: ScoutEvaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ScoutEvaluations" (
    id integer NOT NULL,
    "scoutId" integer NOT NULL,
    "playerId" integer NOT NULL,
    date date NOT NULL,
    "overallRating" double precision NOT NULL,
    "technicalScore" double precision,
    "physicalScore" double precision,
    "mentalScore" double precision,
    "tacticalScore" double precision,
    recommendation public."enum_ScoutEvaluations_recommendation",
    potential public."enum_ScoutEvaluations_potential",
    notes text,
    "position" character varying(50),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: ScoutEvaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ScoutEvaluations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ScoutEvaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ScoutEvaluations_id_seq" OWNED BY public."ScoutEvaluations".id;


--
-- Name: ScoutWatchlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ScoutWatchlists" (
    id integer NOT NULL,
    "scoutId" integer NOT NULL,
    "playerId" integer NOT NULL,
    notes character varying(300),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: ScoutWatchlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ScoutWatchlists_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ScoutWatchlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ScoutWatchlists_id_seq" OWNED BY public."ScoutWatchlists".id;


--
-- Name: Teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Teams" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "coachId" integer,
    "tournamentId" integer,
    "shortName" character varying(10),
    description text,
    logo character varying(255),
    colors json,
    "foundedYear" integer,
    "homeGround" character varying(255),
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: Teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Teams_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Teams_id_seq" OWNED BY public."Teams".id;


--
-- Name: TournamentApplications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."TournamentApplications" (
    id integer NOT NULL,
    "teamId" integer NOT NULL,
    "tournamentId" integer NOT NULL,
    status public."enum_TournamentApplications_status" DEFAULT 'pending'::public."enum_TournamentApplications_status",
    "appliedAt" timestamp with time zone,
    "reviewedAt" timestamp with time zone,
    "reviewedBy" integer,
    notes text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: TournamentApplications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."TournamentApplications_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TournamentApplications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."TournamentApplications_id_seq" OWNED BY public."TournamentApplications".id;


--
-- Name: Tournaments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Tournaments" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    status public."enum_Tournaments_status" DEFAULT 'draft'::public."enum_Tournaments_status",
    "maxTeams" integer,
    location character varying(255),
    rules text,
    "registrationDeadline" timestamp with time zone,
    "prizePool" numeric(10,2),
    "entryFee" numeric(10,2),
    format public."enum_Tournaments_format" DEFAULT 'league'::public."enum_Tournaments_format",
    "isPublic" boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: Tournaments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Tournaments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Tournaments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Tournaments_id_seq" OWNED BY public."Tournaments".id;


--
-- Name: TrainingAttendances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."TrainingAttendances" (
    id integer NOT NULL,
    "trainingSessionId" integer NOT NULL,
    "playerId" integer NOT NULL,
    status public."enum_TrainingAttendances_status" DEFAULT 'absent'::public."enum_TrainingAttendances_status",
    note character varying(300),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: TrainingAttendances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."TrainingAttendances_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TrainingAttendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."TrainingAttendances_id_seq" OWNED BY public."TrainingAttendances".id;


--
-- Name: TrainingSessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."TrainingSessions" (
    id integer NOT NULL,
    "teamId" integer NOT NULL,
    "coachId" integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    type public."enum_TrainingSessions_type" DEFAULT 'technique'::public."enum_TrainingSessions_type",
    date timestamp with time zone NOT NULL,
    duration integer,
    location character varying(200),
    status public."enum_TrainingSessions_status" DEFAULT 'scheduled'::public."enum_TrainingSessions_status",
    notes text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: TrainingSessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."TrainingSessions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TrainingSessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."TrainingSessions_id_seq" OWNED BY public."TrainingSessions".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    role public."enum_Users_role" DEFAULT 'joueur'::public."enum_Users_role" NOT NULL,
    phone character varying(255),
    "teamId" integer,
    "isActive" boolean DEFAULT true,
    "fcmToken" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: MatchEvents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchEvents" ALTER COLUMN id SET DEFAULT nextval('public."MatchEvents_id_seq"'::regclass);


--
-- Name: MatchLineups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchLineups" ALTER COLUMN id SET DEFAULT nextval('public."MatchLineups_id_seq"'::regclass);


--
-- Name: Matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Matches" ALTER COLUMN id SET DEFAULT nextval('public."Matches_id_seq"'::regclass);


--
-- Name: PlayerBadges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerBadges" ALTER COLUMN id SET DEFAULT nextval('public."PlayerBadges_id_seq"'::regclass);


--
-- Name: PlayerClubHistories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerClubHistories" ALTER COLUMN id SET DEFAULT nextval('public."PlayerClubHistories_id_seq"'::regclass);


--
-- Name: PlayerRewards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerRewards" ALTER COLUMN id SET DEFAULT nextval('public."PlayerRewards_id_seq"'::regclass);


--
-- Name: PlayerStats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerStats" ALTER COLUMN id SET DEFAULT nextval('public."PlayerStats_id_seq"'::regclass);


--
-- Name: Players id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Players" ALTER COLUMN id SET DEFAULT nextval('public."Players_id_seq"'::regclass);


--
-- Name: RefereeMissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RefereeMissions" ALTER COLUMN id SET DEFAULT nextval('public."RefereeMissions_id_seq"'::regclass);


--
-- Name: ScoutEvaluations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutEvaluations" ALTER COLUMN id SET DEFAULT nextval('public."ScoutEvaluations_id_seq"'::regclass);


--
-- Name: ScoutWatchlists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutWatchlists" ALTER COLUMN id SET DEFAULT nextval('public."ScoutWatchlists_id_seq"'::regclass);


--
-- Name: Teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Teams" ALTER COLUMN id SET DEFAULT nextval('public."Teams_id_seq"'::regclass);


--
-- Name: TournamentApplications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TournamentApplications" ALTER COLUMN id SET DEFAULT nextval('public."TournamentApplications_id_seq"'::regclass);


--
-- Name: Tournaments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tournaments" ALTER COLUMN id SET DEFAULT nextval('public."Tournaments_id_seq"'::regclass);


--
-- Name: TrainingAttendances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingAttendances" ALTER COLUMN id SET DEFAULT nextval('public."TrainingAttendances_id_seq"'::regclass);


--
-- Name: TrainingSessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingSessions" ALTER COLUMN id SET DEFAULT nextval('public."TrainingSessions_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Data for Name: Chats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Chats" (id, message, "messageType", "senderId", "teamId", "isRead", "readAt", "attachmentUrl", "readBy", "createdAt", "updatedAt") FROM stdin;
3b83fd5f-ff8d-4951-ae24-75c6b87033a3	Rendez-vous 18h au stade, soyez à l'heure.	text	2	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]	2026-11-20 18:10:13.589+00	2026-11-20 18:10:13.589+00
3d6d1dbc-04f0-4417-ba70-17cd602936ea	Pensez à apporter vos protège-tibias.	text	2	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]	2026-11-21 14:10:13.589+00	2026-11-21 14:10:13.589+00
85ba6ff2-718b-44b1-8574-87c00de44f91	Pensez à apporter vos protège-tibias.	text	2	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]	2026-11-22 10:10:13.589+00	2026-11-22 10:10:13.589+00
92c23ff6-6d68-45eb-b4d4-12abd3082ca1	La compo sera publiée demain matin.	text	21	2	t	\N	\N	[22,23,24,25,26,27,28,29,30]	2026-11-20 18:10:13.594+00	2026-11-20 18:10:13.594+00
05c45719-4115-4191-8d7f-99c3d054e7c6	Je suis un peu en retard, j'arrive.	text	35	2	t	\N	\N	[22,23,24,25,26,27,28,29,30,31,32,33]	2026-11-20 23:10:13.594+00	2026-11-20 23:10:13.594+00
20ab9f6d-e27f-4049-a5f8-e3011d90e552	Bien reçu coach 👍	text	34	2	t	\N	\N	[22,23,24,25,26,27]	2026-11-21 04:10:13.594+00	2026-11-21 04:10:13.594+00
33c881f0-575b-40f7-8829-da384c87803e	Je serai là.	text	34	2	t	\N	\N	[22,23,24,25,26,27,28,29,30,31,32,33]	2026-11-21 09:10:13.594+00	2026-11-21 09:10:13.594+00
0957daff-c608-46d9-8046-3f90b5d2cffb	Bravo pour le match d'hier, belle mentalité !	text	21	2	t	\N	\N	[22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]	2026-11-21 14:10:13.594+00	2026-11-21 14:10:13.594+00
bf3ecc15-8e6c-4761-902a-72ecb81e0aa0	Bien reçu coach 👍	text	29	2	t	\N	\N	[22,23,24,25,26,27]	2026-11-21 19:10:13.594+00	2026-11-21 19:10:13.594+00
9ae6ddaf-7e0a-43df-8f34-792d9bfd6412	Je serai là.	text	34	2	t	\N	\N	[22,23,24,25,26,27,28,29,30]	2026-11-22 00:10:13.594+00	2026-11-22 00:10:13.594+00
764d95d3-8653-438e-b5c7-4a5447e6d983	Bien reçu coach 👍	text	23	2	t	\N	\N	[22,23,24,25,26,27,28,29,30,31,32,33,34,35]	2026-11-22 05:10:13.594+00	2026-11-22 05:10:13.594+00
a54b9135-e13a-447b-8134-e82740949b73	La compo sera publiée demain matin.	text	21	2	t	\N	\N	[22,23,24,25,26,27,28,29,30]	2026-11-22 10:10:13.594+00	2026-11-22 10:10:13.594+00
217a0588-9030-4515-bfc1-fc7291733353	Bien reçu coach 👍	text	36	2	t	\N	\N	[22,23,24,25,26]	2026-11-22 15:10:13.594+00	2026-11-22 15:10:13.594+00
24f76eed-8a68-4a43-980a-c7f71ee1a838	Je suis un peu en retard, j'arrive.	text	32	2	t	\N	\N	[22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38]	2026-11-22 20:10:13.594+00	2026-11-22 20:10:13.594+00
f72df5a3-c4ea-47c2-9f6b-4719f388e482	Bien reçu coach 👍	text	28	2	f	\N	\N	[]	2026-11-23 01:10:13.594+00	2026-11-23 01:10:13.594+00
b71e88d6-e5d8-4c18-98fa-06a687ca0f98	Bravo pour le match d'hier, belle mentalité !	text	21	2	f	\N	\N	[]	2026-11-23 06:10:13.594+00	2026-11-23 06:10:13.594+00
96203122-3f91-439c-9dd9-e28558444c5b	Je serai là.	text	38	2	f	\N	\N	[]	2026-11-23 11:10:13.594+00	2026-11-23 11:10:13.594+00
eac91c0c-4d26-475b-8724-ff09e6cd7187	Bravo pour le match d'hier, belle mentalité !	text	40	3	t	\N	\N	[41,42,43,44,45,46,47]	2026-11-20 18:10:13.597+00	2026-11-20 18:10:13.597+00
4072e534-2dab-4db2-ad88-303c863368e1	On lâche rien les gars 💪	text	46	3	t	\N	\N	[41,42,43,44,45]	2026-11-20 23:10:13.597+00	2026-11-20 23:10:13.597+00
2ea27b67-e632-4e47-be57-cd32af3ed84f	On lâche rien les gars 💪	text	56	3	t	\N	\N	[41,42,43,44,45,46,47,48]	2026-11-21 04:10:13.597+00	2026-11-21 04:10:13.597+00
09a1e38f-7429-46de-ace0-ae7be2d9c8ed	Je serai là.	text	44	3	t	\N	\N	[41,42,43,44,45,46,47,48,49,50,51,52,53,54,55]	2026-11-21 09:10:13.597+00	2026-11-21 09:10:13.597+00
44edbd6f-84a0-49ce-bf17-97019003728e	Pensez à apporter vos protège-tibias.	text	40	3	t	\N	\N	[41,42,43,44,45,46,47,48,49,50,51]	2026-11-21 14:10:13.597+00	2026-11-21 14:10:13.597+00
7e7bf8fc-9c07-435f-b8ad-f214829bad57	Qui peut me déposer samedi ?	text	48	3	t	\N	\N	[41,42,43,44,45,46,47,48]	2026-11-21 19:10:13.597+00	2026-11-21 19:10:13.597+00
1cf60ccc-e193-45b3-9303-57adcb0bf569	Je serai là.	text	50	3	t	\N	\N	[41,42,43,44,45,46,47,48,49,50,51,52,53,54]	2026-11-22 00:10:13.597+00	2026-11-22 00:10:13.597+00
8bfcf327-1845-4734-9161-3cf8c9a8793b	Je serai là.	text	47	3	t	\N	\N	[41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58]	2026-11-22 05:10:13.597+00	2026-11-22 05:10:13.597+00
fafdc4c6-4f1a-443e-b03e-9a7e4703b894	Séance vidéo jeudi avant l'entraînement.	text	40	3	t	\N	\N	[41,42,43,44,45,46,47,48,49]	2026-11-22 10:10:13.597+00	2026-11-22 10:10:13.597+00
5ba6a549-031c-44b3-ac52-4c811b605d88	On lâche rien les gars 💪	text	44	3	t	\N	\N	[41,42,43,44,45,46,47,48,49,50]	2026-11-22 15:10:13.597+00	2026-11-22 15:10:13.597+00
20fb9aa7-68f8-429d-856e-d293440683ac	Bien reçu coach 👍	text	48	3	t	\N	\N	[41,42,43,44,45,46]	2026-11-22 20:10:13.597+00	2026-11-22 20:10:13.597+00
9ded8d2b-9c04-4d41-a04e-cf49aabc7565	Merci coach !	text	48	3	f	\N	\N	[]	2026-11-23 01:10:13.597+00	2026-11-23 01:10:13.597+00
132deb68-6c63-410d-9d86-2523262a9566	La compo sera publiée demain matin.	text	40	3	f	\N	\N	[]	2026-11-23 06:10:13.597+00	2026-11-23 06:10:13.597+00
41af0df3-bcca-4b69-b8d8-8826c0a11e53	Merci coach !	text	58	3	f	\N	\N	[]	2026-11-23 11:10:13.597+00	2026-11-23 11:10:13.597+00
377181ab-beef-4146-95a6-f0c52c2c8241	Rendez-vous 18h au stade, soyez à l'heure.	text	59	4	t	\N	\N	[60,61,62,63,64,65,66,67,68,69,70,71,72]	2026-11-20 18:10:13.603+00	2026-11-20 18:10:13.603+00
0fd45617-32ed-40ff-aeab-e3481525e8cd	On lâche rien les gars 💪	text	68	4	t	\N	\N	[60,61,62,63,64,65]	2026-11-20 23:10:13.603+00	2026-11-20 23:10:13.603+00
0927889a-f44d-47e2-9bc6-e502ce7ae0f7	Bien reçu coach 👍	text	74	4	t	\N	\N	[60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77]	2026-11-21 04:10:13.603+00	2026-11-21 04:10:13.603+00
aa8d4c33-c310-4c41-9ba7-b43fd2bf5011	Merci coach !	text	77	4	t	\N	\N	[60,61,62,63,64,65,66,67,68,69,70,71]	2026-11-21 09:10:13.603+00	2026-11-21 09:10:13.603+00
352f446a-278a-421a-9a7b-c38d4ee610a1	Rendez-vous 18h au stade, soyez à l'heure.	text	59	4	t	\N	\N	[60,61,62,63,64]	2026-11-21 14:10:13.603+00	2026-11-21 14:10:13.603+00
ef274127-2d70-46cc-9101-bec363825046	On lâche rien les gars 💪	text	68	4	t	\N	\N	[60,61,62,63,64,65,66]	2026-11-21 19:10:13.603+00	2026-11-21 19:10:13.603+00
cb316874-0d59-4130-9643-7ab04c20e56c	On lâche rien les gars 💪	text	69	4	t	\N	\N	[60,61,62,63,64,65,66,67,68,69,70]	2026-11-22 00:10:13.603+00	2026-11-22 00:10:13.603+00
327db1e7-a98c-4a27-bf39-db4084e7a4f2	Je suis un peu en retard, j'arrive.	text	64	4	t	\N	\N	[60,61,62,63,64,65,66]	2026-11-22 05:10:13.603+00	2026-11-22 05:10:13.603+00
5760c241-a7b1-44b4-a330-07fda9532851	Séance vidéo jeudi avant l'entraînement.	text	59	4	t	\N	\N	[60,61,62,63,64,65,66,67]	2026-11-22 10:10:13.603+00	2026-11-22 10:10:13.603+00
af88d9fd-0474-4071-9297-050ec3bd4ef8	Merci coach !	text	61	4	t	\N	\N	[60,61,62,63,64,65,66,67,68,69,70,71,72,73]	2026-11-22 15:10:13.603+00	2026-11-22 15:10:13.603+00
e396755f-0466-4bab-8c53-989707b7da2e	Qui peut me déposer samedi ?	text	67	4	t	\N	\N	[60,61,62,63,64,65]	2026-11-22 20:10:13.603+00	2026-11-22 20:10:13.603+00
8caacbf6-dc1a-45a2-b76d-1147f286dd30	On lâche rien les gars 💪	text	67	4	f	\N	\N	[]	2026-11-23 01:10:13.603+00	2026-11-23 01:10:13.603+00
1857e3f3-14e5-45f3-8bb2-1f98a62cf1b5	La compo sera publiée demain matin.	text	59	4	f	\N	\N	[]	2026-11-23 06:10:13.603+00	2026-11-23 06:10:13.603+00
29397e8d-a807-4d4c-8fdd-c4cf68845f41	On lâche rien les gars 💪	text	75	4	f	\N	\N	[]	2026-11-23 11:10:13.603+00	2026-11-23 11:10:13.603+00
285378f6-538c-4510-b6b3-042594247b68	Séance vidéo jeudi avant l'entraînement.	text	78	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94]	2026-11-20 18:10:13.611+00	2026-11-20 18:10:13.611+00
22a1273b-be0e-4ad2-92e4-7d970044b25b	On lâche rien les gars 💪	text	18	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,2]	2026-11-22 05:10:13.589+00	2026-11-23 16:16:50.429+00
4ae1c329-d1ed-4d00-9c8e-e220fc68f7eb	Qui peut me déposer samedi ?	text	5	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,2]	2026-11-22 15:10:13.589+00	2026-11-23 16:16:50.429+00
e93018c2-a25a-4c29-97fb-b21d9402e122	On lâche rien les gars 💪	text	11	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,2]	2026-11-22 20:10:13.589+00	2026-11-23 16:16:50.43+00
d3649651-ec97-43c1-b66d-f18d6f954d9a	On lâche rien les gars 💪	text	5	1	f	\N	\N	[2,3]	2026-11-23 11:10:13.589+00	2026-11-23 18:00:13.813+00
8988a2b3-ca52-48da-a470-d622f66ed313	La compo sera publiée demain matin.	text	2	1	f	\N	\N	[3]	2026-11-23 06:10:13.589+00	2026-11-23 18:00:13.813+00
c790468b-d3f5-4922-844c-ffefdc051cad	Je suis un peu en retard, j'arrive.	text	8	1	f	\N	\N	[2,3]	2026-11-23 01:10:13.589+00	2026-11-23 18:00:13.813+00
f26de288-505f-4b9d-93a7-57c9d2c738e8	Qui peut me déposer samedi ?	text	85	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88]	2026-11-20 23:10:13.611+00	2026-11-20 23:10:13.611+00
3bcaffd4-aa16-4e8c-ad35-6701f976f249	Je suis un peu en retard, j'arrive.	text	94	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95]	2026-11-21 04:10:13.611+00	2026-11-21 04:10:13.611+00
3c21f4b8-d5d4-4d76-be3b-08a7beb397d7	Bien reçu coach 👍	text	93	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92]	2026-11-21 09:10:13.611+00	2026-11-21 09:10:13.611+00
c02b7cfd-ccf1-48e4-8bbe-d3bcf78b349b	Pensez à apporter vos protège-tibias.	text	78	5	t	\N	\N	[79,80,81,82,83,84,85]	2026-11-21 14:10:13.611+00	2026-11-21 14:10:13.611+00
233a04e7-3270-4337-b8d1-c3285536d44c	Qui peut me déposer samedi ?	text	95	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93]	2026-11-21 19:10:13.611+00	2026-11-21 19:10:13.611+00
c5579536-2805-430b-a654-217dc16eae66	Bien reçu coach 👍	text	92	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95]	2026-11-22 00:10:13.611+00	2026-11-22 00:10:13.611+00
41e3ca30-6d84-41e3-b582-3c4bbd90a240	Je suis un peu en retard, j'arrive.	text	95	5	t	\N	\N	[79,80,81,82,83]	2026-11-22 05:10:13.611+00	2026-11-22 05:10:13.611+00
e0e85c84-5072-4859-9779-f307d1fd013d	Bravo pour le match d'hier, belle mentalité !	text	78	5	t	\N	\N	[79,80,81,82,83]	2026-11-22 10:10:13.611+00	2026-11-22 10:10:13.611+00
d9a0775e-38c6-4b13-95de-f84cae1993eb	Je suis un peu en retard, j'arrive.	text	86	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93]	2026-11-22 15:10:13.611+00	2026-11-22 15:10:13.611+00
af976964-6184-432f-a8f2-fdbaeb1b0a34	On lâche rien les gars 💪	text	87	5	t	\N	\N	[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93]	2026-11-22 20:10:13.611+00	2026-11-22 20:10:13.611+00
d4d051a2-e42e-46b5-8ae7-662c6f7efccf	Bien reçu coach 👍	text	91	5	f	\N	\N	[]	2026-11-23 01:10:13.611+00	2026-11-23 01:10:13.611+00
a99e744e-6832-43d0-84bf-f9b6a2d755f6	La compo sera publiée demain matin.	text	78	5	f	\N	\N	[]	2026-11-23 06:10:13.611+00	2026-11-23 06:10:13.611+00
eeceeaba-b3cd-4b40-9d38-875fad704a13	On lâche rien les gars 💪	text	84	5	f	\N	\N	[]	2026-11-23 11:10:13.611+00	2026-11-23 11:10:13.611+00
0d9ea7e0-637f-405e-9217-305d6f00da49	Rendez-vous 18h au stade, soyez à l'heure.	text	97	6	t	\N	\N	[98,99,100,101,102,103,104]	2026-11-20 18:10:13.619+00	2026-11-20 18:10:13.619+00
d2b036fc-04bd-49e1-a3c2-ec37abc54834	Je serai là.	text	105	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113]	2026-11-20 23:10:13.619+00	2026-11-20 23:10:13.619+00
778068da-f801-49e1-922f-c31f41745912	Qui peut me déposer samedi ?	text	104	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107]	2026-11-21 04:10:13.619+00	2026-11-21 04:10:13.619+00
e04b74ed-1c63-451e-84a7-ae590173dd7f	Merci coach !	text	114	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107,108,109,110]	2026-11-21 09:10:13.619+00	2026-11-21 09:10:13.619+00
a5659803-00ea-4d99-b026-f9231bd8ac6e	La compo sera publiée demain matin.	text	97	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113]	2026-11-21 14:10:13.619+00	2026-11-21 14:10:13.619+00
4e12c8ef-a69a-4c7b-8d90-9b29d629cc1f	Qui peut me déposer samedi ?	text	98	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107,108,109,110,111,112]	2026-11-21 19:10:13.619+00	2026-11-21 19:10:13.619+00
77897cb4-a4fc-4eb1-acbc-f109b63284ab	Bien reçu coach 👍	text	111	6	t	\N	\N	[98,99,100,101,102,103,104,105,106]	2026-11-22 00:10:13.619+00	2026-11-22 00:10:13.619+00
0c3f5687-475a-46b7-bbd3-5e7960131bc5	Je serai là.	text	106	6	t	\N	\N	[98,99,100,101,102]	2026-11-22 05:10:13.619+00	2026-11-22 05:10:13.619+00
d62c7f4c-e517-400a-b874-a3317405f348	La compo sera publiée demain matin.	text	97	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114]	2026-11-22 10:10:13.619+00	2026-11-22 10:10:13.619+00
3974e7c8-16e1-4475-b2c0-b702e9701e8a	Je suis un peu en retard, j'arrive.	text	101	6	t	\N	\N	[98,99,100,101,102,103,104,105,106,107]	2026-11-22 15:10:13.619+00	2026-11-22 15:10:13.619+00
25afbf19-ecf8-4621-b3e8-99d4d703bb55	Bien reçu coach 👍	text	113	6	t	\N	\N	[98,99,100,101,102,103]	2026-11-22 20:10:13.619+00	2026-11-22 20:10:13.619+00
e1a95b10-9949-4632-98a2-16a7f15f4969	Je suis un peu en retard, j'arrive.	text	102	6	f	\N	\N	[]	2026-11-23 01:10:13.619+00	2026-11-23 01:10:13.619+00
cf7cac65-c35d-4ee5-b799-1286c2c7acc4	La compo sera publiée demain matin.	text	97	6	f	\N	\N	[]	2026-11-23 06:10:13.619+00	2026-11-23 06:10:13.619+00
5e0dba79-e6b4-4e08-a6df-c90163f13552	On lâche rien les gars 💪	text	101	6	f	\N	\N	[]	2026-11-23 11:10:13.619+00	2026-11-23 11:10:13.619+00
a60081bc-d813-402c-802a-b3661f5fbc43	La compo sera publiée demain matin.	text	116	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129]	2026-11-20 18:10:13.628+00	2026-11-20 18:10:13.628+00
124d9aa8-4bb5-49d9-b0c1-306b9ddaa686	Je suis un peu en retard, j'arrive.	text	121	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128]	2026-11-20 23:10:13.628+00	2026-11-20 23:10:13.628+00
abc81df6-d0a1-45a2-859b-bfe98044ceff	Je serai là.	text	123	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133]	2026-11-21 04:10:13.628+00	2026-11-21 04:10:13.628+00
fc61212f-926e-4c9a-a18c-38409b819965	On lâche rien les gars 💪	text	132	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132]	2026-11-21 09:10:13.628+00	2026-11-21 09:10:13.628+00
53ff49d1-2b58-4954-817f-a29aa1f3bb75	Séance vidéo jeudi avant l'entraînement.	text	116	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133]	2026-11-21 14:10:13.628+00	2026-11-21 14:10:13.628+00
80b7dde0-f010-4575-b0b1-d0a26f1dda35	Je suis un peu en retard, j'arrive.	text	126	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134]	2026-11-21 19:10:13.628+00	2026-11-21 19:10:13.628+00
6349ccd9-93fc-434d-81a5-3644ffd3508f	Je suis un peu en retard, j'arrive.	text	129	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128,129]	2026-11-22 00:10:13.628+00	2026-11-22 00:10:13.628+00
66ef25c3-865c-41cf-bed5-14fea776e180	Bien reçu coach 👍	text	121	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126,127,128]	2026-11-22 05:10:13.628+00	2026-11-22 05:10:13.628+00
ee4e6985-87e8-4a5d-aad1-ee0b56385469	Séance vidéo jeudi avant l'entraînement.	text	116	7	t	\N	\N	[117,118,119,120,121,122]	2026-11-22 10:10:13.628+00	2026-11-22 10:10:13.628+00
780e83ed-5de5-41f4-9936-15ba36b02328	Qui peut me déposer samedi ?	text	124	7	t	\N	\N	[117,118,119,120,121,122,123]	2026-11-22 15:10:13.628+00	2026-11-22 15:10:13.628+00
c7b10cf6-a5ac-406a-af62-feded564b672	Qui peut me déposer samedi ?	text	124	7	t	\N	\N	[117,118,119,120,121,122,123,124,125,126]	2026-11-22 20:10:13.628+00	2026-11-22 20:10:13.628+00
44301473-08fc-4786-80e5-54a6dd5737e3	Qui peut me déposer samedi ?	text	125	7	f	\N	\N	[]	2026-11-23 01:10:13.628+00	2026-11-23 01:10:13.628+00
45abfb3f-7cd3-439c-b75d-465afec12d01	La compo sera publiée demain matin.	text	116	7	f	\N	\N	[]	2026-11-23 06:10:13.628+00	2026-11-23 06:10:13.628+00
2891ccb8-21df-43a0-9fc4-1dd493003899	On lâche rien les gars 💪	text	120	7	f	\N	\N	[]	2026-11-23 11:10:13.628+00	2026-11-23 11:10:13.628+00
af4e64ef-46c7-4b15-be8d-a722a925a40e	Bravo pour le match d'hier, belle mentalité !	text	135	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145,146]	2026-11-20 18:10:13.636+00	2026-11-20 18:10:13.636+00
86e29151-fa69-4fab-82bf-e550adc4ae02	Bien reçu coach 👍	text	148	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145,146,147,148,149,150]	2026-11-20 23:10:13.636+00	2026-11-20 23:10:13.636+00
af5b7f59-efbf-4b6f-92e6-a62a774d08bc	Je suis un peu en retard, j'arrive.	text	153	8	t	\N	\N	[136,137,138,139,140,141,142,143]	2026-11-21 04:10:13.636+00	2026-11-21 04:10:13.636+00
c521c8c8-f0ee-43cc-9704-1b998d20566f	On lâche rien les gars 💪	text	149	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145]	2026-11-21 09:10:13.636+00	2026-11-21 09:10:13.636+00
e6fc86bc-00db-486f-85ae-0c453b498442	Pensez à apporter vos protège-tibias.	text	135	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153]	2026-11-21 14:10:13.636+00	2026-11-21 14:10:13.636+00
b916a395-4bbd-4162-bdb8-022fc293036c	Je suis un peu en retard, j'arrive.	text	147	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145]	2026-11-21 19:10:13.636+00	2026-11-21 19:10:13.636+00
0b6aa338-5d7b-492f-b88e-6aa2780cd25f	Je suis un peu en retard, j'arrive.	text	146	8	t	\N	\N	[136,137,138,139,140]	2026-11-22 00:10:13.636+00	2026-11-22 00:10:13.636+00
46b5a725-4332-4e23-abe1-b0c4ddc527b0	Qui peut me déposer samedi ?	text	136	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145,146]	2026-11-22 05:10:13.636+00	2026-11-22 05:10:13.636+00
97d37a8c-6471-48e4-ac5d-3d2418e15c32	La compo sera publiée demain matin.	text	135	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145]	2026-11-22 10:10:13.636+00	2026-11-22 10:10:13.636+00
e9bd901f-abb3-4eab-9aa9-1b6edce74775	Qui peut me déposer samedi ?	text	146	8	t	\N	\N	[136,137,138,139,140,141,142]	2026-11-22 15:10:13.636+00	2026-11-22 15:10:13.636+00
9093333a-d791-40c0-b959-78cf6bf3dd49	Je suis un peu en retard, j'arrive.	text	152	8	t	\N	\N	[136,137,138,139,140,141,142,143,144,145,146,147,148,149]	2026-11-22 20:10:13.636+00	2026-11-22 20:10:13.636+00
73dc6d00-a831-4a60-a1f6-2242832322c3	Je serai là.	text	153	8	f	\N	\N	[]	2026-11-23 01:10:13.636+00	2026-11-23 01:10:13.636+00
63f24879-0856-430d-b789-4e131b47ae8d	Bravo pour le match d'hier, belle mentalité !	text	135	8	f	\N	\N	[]	2026-11-23 06:10:13.636+00	2026-11-23 06:10:13.636+00
55a56e9a-e4e0-4c12-b4e5-ea4b97172ab5	Je serai là.	text	141	8	f	\N	\N	[]	2026-11-23 11:10:13.636+00	2026-11-23 11:10:13.636+00
084331c7-f61d-4ce2-820c-8f6e3bb84e50	Pensez à apporter vos protège-tibias.	text	154	9	t	\N	\N	[155,156,157,158,159,160]	2026-11-20 18:10:13.642+00	2026-11-20 18:10:13.642+00
d2404ec6-bd84-4eec-a535-c7ba3d368b1a	Je suis un peu en retard, j'arrive.	text	171	9	t	\N	\N	[155,156,157,158,159,160,161,162,163]	2026-11-20 23:10:13.642+00	2026-11-20 23:10:13.642+00
5f6464ed-bb63-42fe-8ffb-55622b8a6eb0	Je suis un peu en retard, j'arrive.	text	157	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164]	2026-11-21 04:10:13.642+00	2026-11-21 04:10:13.642+00
d5ffe331-14fa-4a3e-b0e7-1182ac6b3bb7	Bien reçu coach 👍	text	158	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172]	2026-11-21 09:10:13.642+00	2026-11-21 09:10:13.642+00
8a31a012-404a-406d-ac26-1fbb8bf1d424	La compo sera publiée demain matin.	text	154	9	t	\N	\N	[155,156,157,158,159,160,161,162]	2026-11-21 14:10:13.642+00	2026-11-21 14:10:13.642+00
acfbb133-e53e-4e61-81f8-7c8487afc65a	Qui peut me déposer samedi ?	text	172	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164,165,166,167,168]	2026-11-21 19:10:13.642+00	2026-11-21 19:10:13.642+00
9a0643a0-0cd2-4aa2-803d-899383f3c832	Je serai là.	text	156	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164,165,166,167,168]	2026-11-22 00:10:13.642+00	2026-11-22 00:10:13.642+00
c9d47f0d-b887-4ced-8260-3e45fe5a72f3	Bien reçu coach 👍	text	158	9	t	\N	\N	[155,156,157,158,159,160,161,162,163]	2026-11-22 05:10:13.642+00	2026-11-22 05:10:13.642+00
83c3ea01-b567-4b49-bfd0-427d22c25c2f	Bravo pour le match d'hier, belle mentalité !	text	154	9	t	\N	\N	[155,156,157,158,159,160]	2026-11-22 10:10:13.642+00	2026-11-22 10:10:13.642+00
28f110a3-7847-46cb-9f24-a14b4d330e69	Je serai là.	text	166	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164,165,166]	2026-11-22 15:10:13.642+00	2026-11-22 15:10:13.642+00
939be298-3944-4928-bef0-ce93b417e27a	Bien reçu coach 👍	text	168	9	t	\N	\N	[155,156,157,158,159,160,161,162,163,164,165,166]	2026-11-22 20:10:13.642+00	2026-11-22 20:10:13.642+00
5e01fa4a-a426-4993-a4ba-e7664d8aadfc	Bien reçu coach 👍	text	159	9	f	\N	\N	[]	2026-11-23 01:10:13.642+00	2026-11-23 01:10:13.642+00
94d37343-cd1d-4738-8ddc-c14fc7abbb15	Bravo pour le match d'hier, belle mentalité !	text	154	9	f	\N	\N	[]	2026-11-23 06:10:13.642+00	2026-11-23 06:10:13.642+00
5eb6370d-b9f8-445d-933d-c547e8f99739	Je serai là.	text	159	9	f	\N	\N	[]	2026-11-23 11:10:13.642+00	2026-11-23 11:10:13.642+00
a980d0a4-ed6e-4ac1-9f18-29ccae8a2a59	Bravo pour le match d'hier, belle mentalité !	text	173	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184,185,186,187,188]	2026-11-20 18:10:13.649+00	2026-11-20 18:10:13.649+00
44ba6824-e86c-4ea2-b31c-03bfc6ef80f0	Bien reçu coach 👍	text	190	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184,185]	2026-11-20 23:10:13.649+00	2026-11-20 23:10:13.649+00
82ec508c-bd82-4dbc-94cb-1babd475a8cd	Je serai là.	text	184	10	t	\N	\N	[174,175,176,177,178,179,180,181,182]	2026-11-21 04:10:13.649+00	2026-11-21 04:10:13.649+00
17027da0-425e-4e5f-8c3f-7b977d53a05b	Je suis un peu en retard, j'arrive.	text	181	10	t	\N	\N	[174,175,176,177,178]	2026-11-21 09:10:13.649+00	2026-11-21 09:10:13.649+00
026e397b-7028-4a8a-8437-6b584e07f145	Rendez-vous 18h au stade, soyez à l'heure.	text	173	10	t	\N	\N	[174,175,176,177,178,179,180]	2026-11-21 14:10:13.649+00	2026-11-21 14:10:13.649+00
135eaa83-5263-47bc-ab3c-9c336255f357	On lâche rien les gars 💪	text	182	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184,185]	2026-11-21 19:10:13.649+00	2026-11-21 19:10:13.649+00
f5d8e9b4-4794-4160-84f2-0d04ae085580	Merci coach !	text	182	10	t	\N	\N	[174,175,176,177,178,179]	2026-11-22 00:10:13.649+00	2026-11-22 00:10:13.649+00
46e73703-67ee-4f62-b115-18df3c38966f	On lâche rien les gars 💪	text	185	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184]	2026-11-22 05:10:13.649+00	2026-11-22 05:10:13.649+00
5183caae-8c4b-4483-b743-14e354959675	Séance vidéo jeudi avant l'entraînement.	text	173	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184,185,186]	2026-11-22 10:10:13.649+00	2026-11-22 10:10:13.649+00
8e5443aa-3e5e-40c3-b1f1-a2de5e490512	Qui peut me déposer samedi ?	text	182	10	t	\N	\N	[174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191]	2026-11-22 15:10:13.649+00	2026-11-22 15:10:13.649+00
8cf78de4-8e36-4564-8f49-0e2d662b055d	Je serai là.	text	181	10	t	\N	\N	[174,175,176,177,178]	2026-11-22 20:10:13.649+00	2026-11-22 20:10:13.649+00
d0cacf78-d244-4b08-9cfa-73c93830c315	Bien reçu coach 👍	text	189	10	f	\N	\N	[]	2026-11-23 01:10:13.649+00	2026-11-23 01:10:13.649+00
df33fd20-0726-4a69-a4b1-50f6d11903cc	Pensez à apporter vos protège-tibias.	text	173	10	f	\N	\N	[]	2026-11-23 06:10:13.649+00	2026-11-23 06:10:13.649+00
6501a9c1-fc50-4ae8-909c-f74b96e15e7a	Je serai là.	text	180	10	f	\N	\N	[]	2026-11-23 11:10:13.649+00	2026-11-23 11:10:13.649+00
fe00ff17-fc96-4bd5-96c1-8a4ff65fa4f3	Bravo pour le match d'hier, belle mentalité !	text	192	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203]	2026-11-20 18:10:13.658+00	2026-11-20 18:10:13.658+00
bbae898b-0bbf-4070-8d4c-6177e4538dd2	Merci coach !	text	210	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210]	2026-11-20 23:10:13.658+00	2026-11-20 23:10:13.658+00
531a364d-8e96-4819-a65f-a160b1a1a3cf	Merci coach !	text	195	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205]	2026-11-21 04:10:13.658+00	2026-11-21 04:10:13.658+00
8ce1c820-3ea5-4f13-8068-46a368ee77cf	Bien reçu coach 👍	text	196	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205,206]	2026-11-21 09:10:13.658+00	2026-11-21 09:10:13.658+00
b07385fe-e537-4a0d-8dd5-ddcdcfafc891	Séance vidéo jeudi avant l'entraînement.	text	192	11	t	\N	\N	[193,194,195,196,197,198,199,200,201]	2026-11-21 14:10:13.658+00	2026-11-21 14:10:13.658+00
3df3a5b2-5ec6-4d89-a6ed-e94e5f749ed4	Je serai là.	text	205	11	t	\N	\N	[193,194,195,196,197,198,199,200]	2026-11-21 19:10:13.658+00	2026-11-21 19:10:13.658+00
caffca66-7390-48c9-b7d5-adae3b09e241	Qui peut me déposer samedi ?	text	209	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205,206]	2026-11-22 00:10:13.658+00	2026-11-22 00:10:13.658+00
f1732f6d-75df-4668-a2d7-cc6dcfc17b85	Qui peut me déposer samedi ?	text	200	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205,206,207]	2026-11-22 05:10:13.658+00	2026-11-22 05:10:13.658+00
621e2447-d4ef-4bb2-bccb-0ae40a3e1a69	Pensez à apporter vos protège-tibias.	text	192	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209]	2026-11-22 10:10:13.658+00	2026-11-22 10:10:13.658+00
fedf12e0-b92f-41e3-990b-f58c4332acf1	On lâche rien les gars 💪	text	205	11	t	\N	\N	[193,194,195,196,197,198,199,200,201,202,203,204]	2026-11-22 15:10:13.658+00	2026-11-22 15:10:13.658+00
f8d1ff44-7076-4cf1-a3ac-82e990203cc9	Qui peut me déposer samedi ?	text	209	11	t	\N	\N	[193,194,195,196,197,198]	2026-11-22 20:10:13.658+00	2026-11-22 20:10:13.658+00
453991c9-643b-4486-832a-9003b1339b24	Merci coach !	text	195	11	f	\N	\N	[]	2026-11-23 01:10:13.658+00	2026-11-23 01:10:13.658+00
ad990024-23b6-4e4a-a139-1957d0f76761	Séance vidéo jeudi avant l'entraînement.	text	192	11	f	\N	\N	[]	2026-11-23 06:10:13.658+00	2026-11-23 06:10:13.658+00
64aa84bc-c0cd-4b13-a63d-be1966004197	Je serai là.	text	193	11	f	\N	\N	[]	2026-11-23 11:10:13.658+00	2026-11-23 11:10:13.658+00
95f07bdf-f288-4ce6-99e0-8ccd5b4fa55c	Pensez à apporter vos protège-tibias.	text	211	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221]	2026-11-20 18:10:13.663+00	2026-11-20 18:10:13.663+00
8ce36dfb-ec72-44cc-8b8a-50c81a70edc4	Merci coach !	text	214	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221]	2026-11-20 23:10:13.663+00	2026-11-20 23:10:13.663+00
c06c4b79-7b0e-43b5-9642-a24c1512a1af	Bien reçu coach 👍	text	221	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226]	2026-11-21 04:10:13.663+00	2026-11-21 04:10:13.663+00
8a1e5021-26e0-405d-99b8-c1b56fc75b1c	Je serai là.	text	218	12	t	\N	\N	[212,213,214,215,216,217,218]	2026-11-21 09:10:13.663+00	2026-11-21 09:10:13.663+00
1ec26d28-0d06-4ffd-b876-977a6fd5e25e	La compo sera publiée demain matin.	text	211	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223]	2026-11-21 14:10:13.663+00	2026-11-21 14:10:13.663+00
84ae8567-3056-426e-be5f-c8b306409cf0	Merci coach !	text	223	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226]	2026-11-21 19:10:13.663+00	2026-11-21 19:10:13.663+00
2bdcfefb-0bde-440b-bc15-2e8076975512	Merci coach !	text	218	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226]	2026-11-22 00:10:13.663+00	2026-11-22 00:10:13.663+00
ca13ce2b-6eda-4a65-b8f3-bdf6fdb0c764	Merci coach !	text	214	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229]	2026-11-22 05:10:13.663+00	2026-11-22 05:10:13.663+00
1545d6cb-bf85-4e2b-9a0f-8f93463a20f4	Pensez à apporter vos protège-tibias.	text	211	12	t	\N	\N	[212,213,214,215,216,217]	2026-11-22 10:10:13.663+00	2026-11-22 10:10:13.663+00
8aee9ae0-b5e0-403b-b585-5ac58a06d3b7	Qui peut me déposer samedi ?	text	218	12	t	\N	\N	[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228]	2026-11-22 15:10:13.663+00	2026-11-22 15:10:13.663+00
f1fdd0b1-109f-498a-b882-b8152b48e761	On lâche rien les gars 💪	text	229	12	t	\N	\N	[212,213,214,215,216,217]	2026-11-22 20:10:13.663+00	2026-11-22 20:10:13.663+00
3c32fbad-869b-4085-b2d8-3eaf015cd598	Merci coach !	text	227	12	f	\N	\N	[]	2026-11-23 01:10:13.663+00	2026-11-23 01:10:13.663+00
07364816-2bb6-403d-8f43-bbf23ef36498	Bravo pour le match d'hier, belle mentalité !	text	211	12	f	\N	\N	[]	2026-11-23 06:10:13.663+00	2026-11-23 06:10:13.663+00
0018496e-0943-4abc-8319-91636b72efb4	Bien reçu coach 👍	text	214	12	f	\N	\N	[]	2026-11-23 11:10:13.663+00	2026-11-23 11:10:13.663+00
5cdc1d52-593f-4872-8ef6-4efbf5b27e23	La compo sera publiée demain matin.	text	230	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242]	2026-11-20 18:10:13.667+00	2026-11-20 18:10:13.667+00
16b324a5-0555-441e-907b-fe3f4e618349	Qui peut me déposer samedi ?	text	238	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240]	2026-11-20 23:10:13.667+00	2026-11-20 23:10:13.667+00
b01acfaf-5733-4354-9f90-082b174e7445	Je suis un peu en retard, j'arrive.	text	244	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241]	2026-11-21 04:10:13.667+00	2026-11-21 04:10:13.667+00
cd43e6c5-49bd-4432-bf2d-b316452925cf	On lâche rien les gars 💪	text	244	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242,243,244]	2026-11-21 09:10:13.667+00	2026-11-21 09:10:13.667+00
a17ca7aa-ac9e-43a4-acd2-708e0ecc8f81	Rendez-vous 18h au stade, soyez à l'heure.	text	230	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240]	2026-11-21 14:10:13.667+00	2026-11-21 14:10:13.667+00
9c04e7bd-d933-4585-a3f7-84712946492d	Qui peut me déposer samedi ?	text	242	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240]	2026-11-21 19:10:13.667+00	2026-11-21 19:10:13.667+00
9b6f1122-ada0-4d87-8dcd-90e91382a399	Qui peut me déposer samedi ?	text	236	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242,243]	2026-11-22 00:10:13.667+00	2026-11-22 00:10:13.667+00
3b34fb03-525e-4289-8dd9-217889d2ea23	Qui peut me déposer samedi ?	text	236	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248]	2026-11-22 05:10:13.667+00	2026-11-22 05:10:13.667+00
9c3b0af1-2b55-47d4-9496-92fbe6bc35f7	Pensez à apporter vos protège-tibias.	text	230	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242]	2026-11-22 10:10:13.667+00	2026-11-22 10:10:13.667+00
20ece45c-51ec-438f-a458-8a0a1b9f60bc	On lâche rien les gars 💪	text	236	13	t	\N	\N	[231,232,233,234,235,236,237,238,239,240,241,242,243,244,245]	2026-11-22 15:10:13.667+00	2026-11-22 15:10:13.667+00
e8b48772-8424-42f2-961f-5e4a94a10174	Qui peut me déposer samedi ?	text	234	13	t	\N	\N	[231,232,233,234,235]	2026-11-22 20:10:13.667+00	2026-11-22 20:10:13.667+00
5f20fb78-b632-46b5-976b-7c298f4c3291	Merci coach !	text	239	13	f	\N	\N	[]	2026-11-23 01:10:13.667+00	2026-11-23 01:10:13.667+00
67be8e9c-31e8-4e71-8f20-ad3b238c3734	Rendez-vous 18h au stade, soyez à l'heure.	text	230	13	f	\N	\N	[]	2026-11-23 06:10:13.667+00	2026-11-23 06:10:13.667+00
61578d26-950e-42a8-bb55-3aac19f801e2	Qui peut me déposer samedi ?	text	246	13	f	\N	\N	[]	2026-11-23 11:10:13.667+00	2026-11-23 11:10:13.667+00
2ac7869e-6e3e-4c5e-b179-e635d2cff33f	Bravo pour le match d'hier, belle mentalité !	text	249	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259,260]	2026-11-20 18:10:13.671+00	2026-11-20 18:10:13.671+00
217237f6-1bc3-47b0-ac68-f74a14432896	Qui peut me déposer samedi ?	text	250	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259]	2026-11-20 23:10:13.671+00	2026-11-20 23:10:13.671+00
91935cc9-2f3f-48d3-9c2c-5cb878ce59b7	Bien reçu coach 👍	text	250	14	t	\N	\N	[250,251,252,253,254,255,256,257,258]	2026-11-21 04:10:13.671+00	2026-11-21 04:10:13.671+00
33fdd0b4-0e1f-42c4-9e64-1e1d452d7244	Je suis un peu en retard, j'arrive.	text	252	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259]	2026-11-21 09:10:13.671+00	2026-11-21 09:10:13.671+00
f04efc7f-f318-4daa-8896-4a8f9c5af400	La compo sera publiée demain matin.	text	249	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259,260,261,262]	2026-11-21 14:10:13.671+00	2026-11-21 14:10:13.671+00
94338902-22a1-497c-b84b-9ca09eea818a	Bien reçu coach 👍	text	250	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259,260,261,262,263]	2026-11-21 19:10:13.671+00	2026-11-21 19:10:13.671+00
8a20b745-07fe-456c-a1b1-b9de05ba97ff	Merci coach !	text	267	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259,260,261]	2026-11-22 00:10:13.671+00	2026-11-22 00:10:13.671+00
f8a0d663-27e3-4895-956e-b8459b297b53	Je suis un peu en retard, j'arrive.	text	262	14	t	\N	\N	[250,251,252,253,254,255,256,257,258,259,260,261,262,263]	2026-11-22 05:10:13.671+00	2026-11-22 05:10:13.671+00
cc8327c8-577c-4459-8a42-0efb448c5269	Pensez à apporter vos protège-tibias.	text	249	14	t	\N	\N	[250,251,252,253,254,255,256,257,258]	2026-11-22 10:10:13.671+00	2026-11-22 10:10:13.671+00
ae4ba1a9-12e4-45c9-a96f-e5e2087601c2	Qui peut me déposer samedi ?	text	263	14	t	\N	\N	[250,251,252,253,254,255,256,257,258]	2026-11-22 15:10:13.671+00	2026-11-22 15:10:13.671+00
4a2dea7a-059a-41ac-852f-465f39482b37	Bien reçu coach 👍	text	258	14	t	\N	\N	[250,251,252,253,254]	2026-11-22 20:10:13.671+00	2026-11-22 20:10:13.671+00
038f0531-79d0-4839-af5d-f7e09acce94d	Je suis un peu en retard, j'arrive.	text	266	14	f	\N	\N	[]	2026-11-23 01:10:13.671+00	2026-11-23 01:10:13.671+00
70e9b6e0-6d94-4571-8ea1-60e938fae619	Séance vidéo jeudi avant l'entraînement.	text	249	14	f	\N	\N	[]	2026-11-23 06:10:13.671+00	2026-11-23 06:10:13.671+00
0bd315ae-2b79-4238-8715-34d4aa3df07c	Qui peut me déposer samedi ?	text	262	14	f	\N	\N	[]	2026-11-23 11:10:13.671+00	2026-11-23 11:10:13.671+00
621d0ac0-0a57-4aa7-ae38-382adadabf7a	Rendez-vous 18h au stade, soyez à l'heure.	text	268	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281]	2026-11-20 18:10:13.675+00	2026-11-20 18:10:13.675+00
2cb3beb4-85cb-41d7-8e0c-526a5152d2f1	Qui peut me déposer samedi ?	text	280	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286]	2026-11-20 23:10:13.675+00	2026-11-20 23:10:13.675+00
d85d15f4-faf2-4817-be00-24f1788df091	Bien reçu coach 👍	text	273	15	t	\N	\N	[269,270,271,272,273]	2026-11-21 04:10:13.675+00	2026-11-21 04:10:13.675+00
a803c056-8a16-47f7-8ec2-a6a5cfd68bd9	Je serai là.	text	279	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280]	2026-11-21 09:10:13.675+00	2026-11-21 09:10:13.675+00
7a65f93e-c5db-4c3f-81f0-85af44c862cf	Rendez-vous 18h au stade, soyez à l'heure.	text	268	15	t	\N	\N	[269,270,271,272,273,274,275]	2026-11-21 14:10:13.675+00	2026-11-21 14:10:13.675+00
82fe1f01-6b0a-4c50-a746-99624424393f	Je suis un peu en retard, j'arrive.	text	271	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285]	2026-11-21 19:10:13.675+00	2026-11-21 19:10:13.675+00
71a00726-1af0-4ff1-aa35-acb0227e4782	Je suis un peu en retard, j'arrive.	text	274	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282]	2026-11-22 00:10:13.675+00	2026-11-22 00:10:13.675+00
b25c4b3d-56d1-4a1b-9df1-3c0587c1755e	Je serai là.	text	286	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282,283]	2026-11-22 05:10:13.675+00	2026-11-22 05:10:13.675+00
48779780-ce18-40e7-b1f8-ce8a7025d07f	Séance vidéo jeudi avant l'entraînement.	text	268	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282,283]	2026-11-22 10:10:13.675+00	2026-11-22 10:10:13.675+00
07bb15b8-bac9-4a88-ba7e-aeecaa569579	Merci coach !	text	280	15	t	\N	\N	[269,270,271,272,273,274,275,276,277]	2026-11-22 15:10:13.675+00	2026-11-22 15:10:13.675+00
10c7093c-0cf4-4f25-ab8a-7b0e3d43cbea	Je suis un peu en retard, j'arrive.	text	273	15	t	\N	\N	[269,270,271,272,273,274,275,276,277,278,279,280,281,282,283]	2026-11-22 20:10:13.675+00	2026-11-22 20:10:13.675+00
a6f05576-8dbc-451f-ac86-80bd8427a488	Bien reçu coach 👍	text	282	15	f	\N	\N	[]	2026-11-23 01:10:13.675+00	2026-11-23 01:10:13.675+00
88a1bb12-6253-4e29-ac1c-8bce5ede1d4f	Séance vidéo jeudi avant l'entraînement.	text	268	15	f	\N	\N	[]	2026-11-23 06:10:13.675+00	2026-11-23 06:10:13.675+00
7612e01c-1144-4ff1-b501-caadb5493880	Bien reçu coach 👍	text	276	15	f	\N	\N	[]	2026-11-23 11:10:13.675+00	2026-11-23 11:10:13.675+00
9bad5a03-77f1-470d-b29d-0a1bf2102c2c	Pensez à apporter vos protège-tibias.	text	287	16	t	\N	\N	[288,289,290,291,292,293]	2026-11-20 18:10:13.679+00	2026-11-20 18:10:13.679+00
e0258092-a248-4305-9934-d7cfd59640ea	Je suis un peu en retard, j'arrive.	text	303	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303]	2026-11-20 23:10:13.679+00	2026-11-20 23:10:13.679+00
2681fafd-0ab2-4185-88f1-b97263bceb55	Merci coach !	text	291	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303]	2026-11-21 04:10:13.68+00	2026-11-21 04:10:13.68+00
299577f1-3180-4f18-acf0-46c11ef7f67b	On lâche rien les gars 💪	text	300	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298]	2026-11-21 09:10:13.68+00	2026-11-21 09:10:13.68+00
ae7721da-ecfc-4dab-82c5-4faed1583f17	Bravo pour le match d'hier, belle mentalité !	text	287	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305]	2026-11-21 14:10:13.68+00	2026-11-21 14:10:13.68+00
985f7685-d147-4cc8-9d8b-211a1b18fbec	Je suis un peu en retard, j'arrive.	text	304	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304]	2026-11-21 19:10:13.68+00	2026-11-21 19:10:13.68+00
6a28110b-f335-4157-b81e-5ede106ab626	Bien reçu coach 👍	text	304	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303]	2026-11-22 00:10:13.68+00	2026-11-22 00:10:13.68+00
48c300c1-c7a7-4d95-baeb-6d541f84675f	Je serai là.	text	301	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305]	2026-11-22 05:10:13.68+00	2026-11-22 05:10:13.68+00
a0e66be4-e591-41a9-845c-acc5196393da	Séance vidéo jeudi avant l'entraînement.	text	287	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300]	2026-11-22 10:10:13.68+00	2026-11-22 10:10:13.68+00
65d2b694-68fc-4025-8ac9-f77a54c18433	Je serai là.	text	297	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304]	2026-11-22 15:10:13.68+00	2026-11-22 15:10:13.68+00
31b7fb54-4025-418d-bdf3-7c8514a5b417	Merci coach !	text	301	16	t	\N	\N	[288,289,290,291,292,293,294,295,296,297,298,299,300,301,302]	2026-11-22 20:10:13.68+00	2026-11-22 20:10:13.68+00
949364cb-8c09-4e6b-a033-94fc8a27c0e4	Je suis un peu en retard, j'arrive.	text	294	16	f	\N	\N	[]	2026-11-23 01:10:13.68+00	2026-11-23 01:10:13.68+00
d8af9395-5a94-4628-8620-902b048ae92b	Rendez-vous 18h au stade, soyez à l'heure.	text	287	16	f	\N	\N	[]	2026-11-23 06:10:13.68+00	2026-11-23 06:10:13.68+00
ad7bea81-bbdd-45fa-a2c8-66d046b78dc1	Je serai là.	text	302	16	f	\N	\N	[]	2026-11-23 11:10:13.68+00	2026-11-23 11:10:13.68+00
fe6073fa-5a46-41d7-a5aa-22f0e780b2b2	Bien reçu coach 👍	text	15	1	t	\N	\N	[3,4,5,6,7,8,2]	2026-11-20 23:10:13.589+00	2026-11-23 16:16:50.428+00
7192de9c-5697-4fd5-bcca-aabde2ac7494	Merci coach !	text	3	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,2]	2026-11-21 04:10:13.589+00	2026-11-23 16:16:50.429+00
eb92f023-47d5-4c9b-87a2-680fc8d80d41	Je suis un peu en retard, j'arrive.	text	10	1	t	\N	\N	[3,4,5,6,7,2]	2026-11-21 19:10:13.589+00	2026-11-23 16:16:50.429+00
27ee1948-6a98-489b-960b-6aabedd541a6	Je serai là.	text	3	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,2]	2026-11-21 09:10:13.589+00	2026-11-23 16:16:50.429+00
277d0619-4bbe-46e8-aaec-0542a1b2208d	Bien reçu coach 👍	text	15	1	t	\N	\N	[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,2]	2026-11-22 00:10:13.589+00	2026-11-23 16:16:50.429+00
e8cd5d58-ee76-407c-b376-509c2b25dbef	salut	text	3	1	f	\N	\N	[3,2]	2026-11-24 10:11:17.783+00	2026-11-24 10:11:45.531+00
\.


--
-- Data for Name: MatchEvents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MatchEvents" (id, "matchId", type, minute, "extraMinute", description, "isHomeTeam", "relatedPlayerId", "relatedPlayerName", "substitutionPlayerInId", "substitutionPlayerInName", "substitutionPlayerOutId", "substitutionPlayerOutName", "createdAt", "updatedAt") FROM stdin;
1	1	substitution	57	\N	Khalid Saiss remplace Karim Jabrane	f	\N	\N	131	Khalid Saiss	132	Karim Jabrane	2026-11-23 16:10:09.493+00	2026-11-23 16:10:09.493+00
2	1	goal	58	\N	But de Hakim Benoun	t	18	Hakim Benoun	\N	\N	\N	\N	2026-11-23 16:10:09.498+00	2026-11-23 16:10:09.498+00
3	1	substitution	63	\N	Tarik Ezzalzouli remplace Mehdi Harit	f	\N	\N	130	Tarik Ezzalzouli	134	Mehdi Harit	2026-11-23 16:10:09.5+00	2026-11-23 16:10:09.5+00
4	1	substitution	64	\N	Soufiane Tazi remplace Karim Ounahi	t	\N	\N	8	Soufiane Tazi	3	Karim Ounahi	2026-11-23 16:10:09.503+00	2026-11-23 16:10:09.503+00
5	1	substitution	78	\N	Zakaria Boufal remplace Rachid Rahimi	f	\N	\N	137	Zakaria Boufal	140	Rachid Rahimi	2026-11-23 16:10:09.507+00	2026-11-23 16:10:09.507+00
6	1	substitution	78	\N	Mehdi Ezzalzouli remplace Fouad Bouzidi	f	\N	\N	138	Mehdi Ezzalzouli	136	Fouad Bouzidi	2026-11-23 16:10:09.509+00	2026-11-23 16:10:09.509+00
7	1	substitution	82	\N	Yassine El Idrissi remplace Walid Rahimi	t	\N	\N	6	Yassine El Idrissi	7	Walid Rahimi	2026-11-23 16:10:09.512+00	2026-11-23 16:10:09.512+00
8	1	substitution	83	\N	Tarik Seddiki remplace Yassine Mazraoui	t	\N	\N	11	Tarik Seddiki	14	Yassine Mazraoui	2026-11-23 16:10:09.515+00	2026-11-23 16:10:09.515+00
9	1	red_card	85	\N	Carton rouge	f	135	Tarik Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:09.519+00	2026-11-23 16:10:09.519+00
10	2	goal	12	\N	But de Jawad Haddad	f	119	Jawad Haddad	\N	\N	\N	\N	2026-11-23 16:10:09.536+00	2026-11-23 16:10:09.536+00
11	2	red_card	37	\N	Carton rouge	f	114	Ayman Mazraoui	\N	\N	\N	\N	2026-11-23 16:10:09.538+00	2026-11-23 16:10:09.538+00
12	2	substitution	55	\N	Adil Chraibi remplace Soufiane Mazraoui	t	\N	\N	26	Adil Chraibi	24	Soufiane Mazraoui	2026-11-23 16:10:09.539+00	2026-11-23 16:10:09.539+00
13	2	substitution	60	\N	Nabil Moutaouakil remplace Mohamed Ouazzani	f	\N	\N	112	Nabil Moutaouakil	115	Mohamed Ouazzani	2026-11-23 16:10:09.541+00	2026-11-23 16:10:09.541+00
14	2	substitution	60	\N	Omar Sqalli remplace Taha Benali	f	\N	\N	117	Omar Sqalli	120	Taha Benali	2026-11-23 16:10:09.543+00	2026-11-23 16:10:09.543+00
15	2	substitution	61	\N	Abdelali Jabrane remplace Taha Alaoui	t	\N	\N	27	Abdelali Jabrane	28	Taha Alaoui	2026-11-23 16:10:09.544+00	2026-11-23 16:10:09.544+00
16	2	substitution	63	\N	Mounir Boufal remplace Fouad Hakimi	t	\N	\N	31	Mounir Boufal	30	Fouad Hakimi	2026-11-23 16:10:09.546+00	2026-11-23 16:10:09.546+00
17	2	substitution	70	\N	Abdelali Fassi remplace Khalid Aguerd	t	\N	\N	23	Abdelali Fassi	22	Khalid Aguerd	2026-11-23 16:10:09.547+00	2026-11-23 16:10:09.547+00
18	2	substitution	77	\N	Tarik Berrada remplace Ayman Mazraoui	f	\N	\N	116	Tarik Berrada	114	Ayman Mazraoui	2026-11-23 16:10:09.549+00	2026-11-23 16:10:09.549+00
19	2	substitution	85	\N	Ilyas Amallah remplace Noureddine Fassi	f	\N	\N	121	Ilyas Amallah	118	Noureddine Fassi	2026-11-23 16:10:09.552+00	2026-11-23 16:10:09.552+00
20	3	goal	2	\N	But de Ayman Benali	f	108	Ayman Benali	\N	\N	\N	\N	2026-11-23 16:10:09.564+00	2026-11-23 16:10:09.564+00
21	3	assist	2	\N	Passe décisive de Abdelali El Idrissi	f	93	Abdelali El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.566+00	2026-11-23 16:10:09.566+00
22	3	goal	13	\N	But de Nabil Berrada	t	53	Nabil Berrada	\N	\N	\N	\N	2026-11-23 16:10:09.567+00	2026-11-23 16:10:09.567+00
23	3	assist	13	\N	Passe décisive de Nabil El Kaabi	t	50	Nabil El Kaabi	\N	\N	\N	\N	2026-11-23 16:10:09.569+00	2026-11-23 16:10:09.569+00
24	3	yellow_card	30	\N	Carton jaune	f	95	Omar Ziani	\N	\N	\N	\N	2026-11-23 16:10:09.57+00	2026-11-23 16:10:09.57+00
25	3	substitution	70	\N	Hamza Benali remplace Rachid El Idrissi	t	\N	\N	40	Hamza Benali	41	Rachid El Idrissi	2026-11-23 16:10:09.573+00	2026-11-23 16:10:09.573+00
26	3	substitution	70	\N	Mohamed Bouzidi remplace Omar Ziani	f	\N	\N	97	Mohamed Bouzidi	95	Omar Ziani	2026-11-23 16:10:09.574+00	2026-11-23 16:10:09.574+00
27	3	substitution	77	\N	Zakaria Bouzidi remplace Soufiane Tazi	f	\N	\N	98	Zakaria Bouzidi	96	Soufiane Tazi	2026-11-23 16:10:09.576+00	2026-11-23 16:10:09.576+00
28	3	substitution	78	\N	Karim Benoun remplace Karim Chraibi	t	\N	\N	44	Karim Benoun	42	Karim Chraibi	2026-11-23 16:10:09.578+00	2026-11-23 16:10:09.578+00
29	3	goal	83	\N	But de Fouad Ounahi	f	104	Fouad Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.58+00	2026-11-23 16:10:09.58+00
30	3	assist	83	\N	Passe décisive de Omar Ziani	f	95	Omar Ziani	\N	\N	\N	\N	2026-11-23 16:10:09.582+00	2026-11-23 16:10:09.582+00
31	4	goal	7	\N	But de Achraf El Kaabi	t	69	Achraf El Kaabi	\N	\N	\N	\N	2026-11-23 16:10:09.593+00	2026-11-23 16:10:09.593+00
32	4	assist	7	\N	Passe décisive de Salah Jabrane	t	57	Salah Jabrane	\N	\N	\N	\N	2026-11-23 16:10:09.595+00	2026-11-23 16:10:09.595+00
33	4	goal	15	\N	But de Khalid Benoun	t	59	Khalid Benoun	\N	\N	\N	\N	2026-11-23 16:10:09.596+00	2026-11-23 16:10:09.596+00
34	4	yellow_card	15	\N	Carton jaune	t	66	Salah Benali	\N	\N	\N	\N	2026-11-23 16:10:09.601+00	2026-11-23 16:10:09.601+00
35	4	goal	20	\N	But de Salah Ounahi	f	87	Salah Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.605+00	2026-11-23 16:10:09.605+00
36	4	goal	53	\N	But de Nassim Alaoui	t	62	Nassim Alaoui	\N	\N	\N	\N	2026-11-23 16:10:09.608+00	2026-11-23 16:10:09.608+00
37	4	substitution	59	\N	Fouad Boufal remplace Mehdi Kettani	f	\N	\N	82	Fouad Boufal	84	Mehdi Kettani	2026-11-23 16:10:09.611+00	2026-11-23 16:10:09.611+00
38	4	substitution	67	\N	Hicham Fassi remplace Badr Ait Ali	t	\N	\N	63	Hicham Fassi	68	Badr Ait Ali	2026-11-23 16:10:09.615+00	2026-11-23 16:10:09.615+00
39	4	substitution	68	\N	Hamza Boufal remplace Bilal Ouchen	f	\N	\N	77	Hamza Boufal	80	Bilal Ouchen	2026-11-23 16:10:09.619+00	2026-11-23 16:10:09.619+00
40	4	substitution	69	\N	Mehdi Ziani remplace Salah Benali	t	\N	\N	64	Mehdi Ziani	66	Salah Benali	2026-11-23 16:10:09.624+00	2026-11-23 16:10:09.624+00
41	4	substitution	71	\N	Abdelali Harit remplace Salah Amallah	f	\N	\N	85	Abdelali Harit	83	Salah Amallah	2026-11-23 16:10:09.628+00	2026-11-23 16:10:09.628+00
42	4	substitution	77	\N	Said Rami remplace Othmane El Kaabi	f	\N	\N	75	Said Rami	79	Othmane El Kaabi	2026-11-23 16:10:09.632+00	2026-11-23 16:10:09.632+00
43	4	substitution	81	\N	Fouad Chraibi remplace Nassim Alaoui	t	\N	\N	58	Fouad Chraibi	62	Nassim Alaoui	2026-11-23 16:10:09.637+00	2026-11-23 16:10:09.637+00
44	4	yellow_card	83	\N	Carton jaune	f	88	Jawad Amallah	\N	\N	\N	\N	2026-11-23 16:10:09.641+00	2026-11-23 16:10:09.641+00
45	4	red_card	83	\N	Carton rouge	f	87	Salah Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.644+00	2026-11-23 16:10:09.644+00
46	4	substitution	85	\N	Mohamed Lahlou remplace Khalid Benoun	t	\N	\N	61	Mohamed Lahlou	59	Khalid Benoun	2026-11-23 16:10:09.648+00	2026-11-23 16:10:09.648+00
47	5	goal	13	\N	But de Tarik Harit	f	16	Tarik Harit	\N	\N	\N	\N	2026-11-23 16:10:09.661+00	2026-11-23 16:10:09.661+00
48	5	assist	13	\N	Passe décisive de Zakaria El Khattabi	f	10	Zakaria El Khattabi	\N	\N	\N	\N	2026-11-23 16:10:09.663+00	2026-11-23 16:10:09.663+00
49	5	yellow_card	14	\N	Carton jaune	t	121	Ilyas Amallah	\N	\N	\N	\N	2026-11-23 16:10:09.665+00	2026-11-23 16:10:09.665+00
50	5	yellow_card	21	\N	Carton jaune	f	16	Tarik Harit	\N	\N	\N	\N	2026-11-23 16:10:09.667+00	2026-11-23 16:10:09.667+00
51	5	goal	50	\N	But de Walid Zerouali	t	111	Walid Zerouali	\N	\N	\N	\N	2026-11-23 16:10:09.67+00	2026-11-23 16:10:09.67+00
52	5	assist	50	\N	Passe décisive de Taha Benali	t	120	Taha Benali	\N	\N	\N	\N	2026-11-23 16:10:09.672+00	2026-11-23 16:10:09.672+00
53	5	goal	51	\N	But de Hicham Kettani	f	15	Hicham Kettani	\N	\N	\N	\N	2026-11-23 16:10:09.674+00	2026-11-23 16:10:09.674+00
54	5	assist	51	\N	Passe décisive de Khalid El Amrani	f	12	Khalid El Amrani	\N	\N	\N	\N	2026-11-23 16:10:09.675+00	2026-11-23 16:10:09.675+00
55	5	yellow_card	54	\N	Carton jaune	t	124	Karim Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:09.677+00	2026-11-23 16:10:09.677+00
56	5	substitution	59	\N	Soufiane Tazi remplace Hamza Boufal	f	\N	\N	8	Soufiane Tazi	4	Hamza Boufal	2026-11-23 16:10:09.679+00	2026-11-23 16:10:09.679+00
57	5	red_card	62	\N	Carton rouge	t	119	Jawad Haddad	\N	\N	\N	\N	2026-11-23 16:10:09.682+00	2026-11-23 16:10:09.682+00
58	5	substitution	70	\N	Tarik Seddiki remplace Khalid El Amrani	f	\N	\N	11	Tarik Seddiki	12	Khalid El Amrani	2026-11-23 16:10:09.685+00	2026-11-23 16:10:09.685+00
59	5	goal	72	\N	But de Zakaria El Khattabi	t	113	Zakaria El Khattabi	\N	\N	\N	\N	2026-11-23 16:10:09.688+00	2026-11-23 16:10:09.688+00
60	5	assist	72	\N	Passe décisive de Karim Moutaouakil	t	124	Karim Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:09.689+00	2026-11-23 16:10:09.689+00
61	5	substitution	76	\N	Tarik Berrada remplace Ayman Mazraoui	t	\N	\N	116	Tarik Berrada	114	Ayman Mazraoui	2026-11-23 16:10:09.692+00	2026-11-23 16:10:09.692+00
62	5	substitution	79	\N	Karim Ounahi remplace Walid Rahimi	f	\N	\N	3	Karim Ounahi	7	Walid Rahimi	2026-11-23 16:10:09.696+00	2026-11-23 16:10:09.696+00
63	5	substitution	83	\N	Mohamed Ouazzani remplace Nabil Moutaouakil	t	\N	\N	115	Mohamed Ouazzani	112	Nabil Moutaouakil	2026-11-23 16:10:09.699+00	2026-11-23 16:10:09.699+00
64	5	goal	89	\N	But de Tarik Harit	f	16	Tarik Harit	\N	\N	\N	\N	2026-11-23 16:10:09.701+00	2026-11-23 16:10:09.701+00
65	5	assist	89	\N	Passe décisive de Yassine El Idrissi	f	6	Yassine El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.704+00	2026-11-23 16:10:09.704+00
66	6	goal	8	\N	But de Jawad Aguerd	f	143	Jawad Aguerd	\N	\N	\N	\N	2026-11-23 16:10:09.721+00	2026-11-23 16:10:09.721+00
67	6	assist	8	\N	Passe décisive de Mehdi Ezzalzouli	f	144	Mehdi Ezzalzouli	\N	\N	\N	\N	2026-11-23 16:10:09.722+00	2026-11-23 16:10:09.722+00
68	6	yellow_card	30	\N	Carton jaune	t	101	Adil Berrada	\N	\N	\N	\N	2026-11-23 16:10:09.727+00	2026-11-23 16:10:09.727+00
69	6	yellow_card	32	\N	Carton jaune	f	132	Karim Jabrane	\N	\N	\N	\N	2026-11-23 16:10:09.729+00	2026-11-23 16:10:09.729+00
70	6	goal	44	\N	But de Adil Rahimi	t	102	Adil Rahimi	\N	\N	\N	\N	2026-11-23 16:10:09.731+00	2026-11-23 16:10:09.731+00
71	6	assist	44	\N	Passe décisive de Abdelali Harit	t	100	Abdelali Harit	\N	\N	\N	\N	2026-11-23 16:10:09.733+00	2026-11-23 16:10:09.733+00
72	6	yellow_card	58	\N	Carton jaune	t	100	Abdelali Harit	\N	\N	\N	\N	2026-11-23 16:10:09.734+00	2026-11-23 16:10:09.734+00
73	6	yellow_card	62	\N	Carton jaune	t	100	Abdelali Harit	\N	\N	\N	\N	2026-11-23 16:10:09.736+00	2026-11-23 16:10:09.736+00
74	6	substitution	62	\N	Taha El Kaabi remplace Adil Rahimi	t	\N	\N	103	Taha El Kaabi	102	Adil Rahimi	2026-11-23 16:10:09.737+00	2026-11-23 16:10:09.737+00
75	6	substitution	67	\N	Tarik Moutaouakil remplace Fouad Bouzidi	f	\N	\N	135	Tarik Moutaouakil	136	Fouad Bouzidi	2026-11-23 16:10:09.738+00	2026-11-23 16:10:09.738+00
76	6	substitution	68	\N	Zakaria Bouzidi remplace Soufiane Tazi	t	\N	\N	98	Zakaria Bouzidi	96	Soufiane Tazi	2026-11-23 16:10:09.739+00	2026-11-23 16:10:09.739+00
77	6	substitution	68	\N	Driss Aguerd remplace Abdelali Harit	t	\N	\N	99	Driss Aguerd	100	Abdelali Harit	2026-11-23 16:10:09.741+00	2026-11-23 16:10:09.741+00
78	6	substitution	78	\N	Anas Rahimi remplace Khalid Saiss	f	\N	\N	129	Anas Rahimi	131	Khalid Saiss	2026-11-23 16:10:09.742+00	2026-11-23 16:10:09.742+00
79	6	substitution	79	\N	Mohamed Bouzidi remplace Khalid Kettani	t	\N	\N	97	Mohamed Bouzidi	94	Khalid Kettani	2026-11-23 16:10:09.743+00	2026-11-23 16:10:09.743+00
80	6	substitution	85	\N	Adil Boufal remplace Karim Jabrane	f	\N	\N	133	Adil Boufal	132	Karim Jabrane	2026-11-23 16:10:09.745+00	2026-11-23 16:10:09.745+00
81	7	goal	26	\N	But de Rachid Ouchen	f	29	Rachid Ouchen	\N	\N	\N	\N	2026-11-23 16:10:09.755+00	2026-11-23 16:10:09.755+00
82	7	goal	37	\N	But de Youssef Bennani	f	34	Youssef Bennani	\N	\N	\N	\N	2026-11-23 16:10:09.757+00	2026-11-23 16:10:09.757+00
83	7	assist	37	\N	Passe décisive de Achraf Ziani	f	33	Achraf Ziani	\N	\N	\N	\N	2026-11-23 16:10:09.758+00	2026-11-23 16:10:09.758+00
84	7	goal	48	\N	But de Bilal Ouchen	t	80	Bilal Ouchen	\N	\N	\N	\N	2026-11-23 16:10:09.759+00	2026-11-23 16:10:09.759+00
85	7	assist	48	\N	Passe décisive de Hamza Boufal	t	77	Hamza Boufal	\N	\N	\N	\N	2026-11-23 16:10:09.761+00	2026-11-23 16:10:09.761+00
86	7	goal	51	\N	But de Bilal Ouchen	t	80	Bilal Ouchen	\N	\N	\N	\N	2026-11-23 16:10:09.762+00	2026-11-23 16:10:09.762+00
87	7	assist	51	\N	Passe décisive de Hamza Boufal	t	77	Hamza Boufal	\N	\N	\N	\N	2026-11-23 16:10:09.765+00	2026-11-23 16:10:09.765+00
88	7	goal	52	\N	But de Ilyas Saiss	f	36	Ilyas Saiss	\N	\N	\N	\N	2026-11-23 16:10:09.767+00	2026-11-23 16:10:09.767+00
89	7	substitution	57	\N	Fouad Hakimi remplace Mounir Boufal	f	\N	\N	30	Fouad Hakimi	31	Mounir Boufal	2026-11-23 16:10:09.769+00	2026-11-23 16:10:09.769+00
90	7	substitution	58	\N	Othmane El Kaabi remplace Said Ounahi	t	\N	\N	79	Othmane El Kaabi	78	Said Ounahi	2026-11-23 16:10:09.772+00	2026-11-23 16:10:09.772+00
91	7	substitution	62	\N	Mehdi Kettani remplace Salah Amallah	t	\N	\N	84	Mehdi Kettani	83	Salah Amallah	2026-11-23 16:10:09.774+00	2026-11-23 16:10:09.774+00
92	7	goal	68	\N	But de Nabil Zerouali	t	89	Nabil Zerouali	\N	\N	\N	\N	2026-11-23 16:10:09.777+00	2026-11-23 16:10:09.777+00
93	7	assist	68	\N	Passe décisive de Salah Amallah	t	83	Salah Amallah	\N	\N	\N	\N	2026-11-23 16:10:09.778+00	2026-11-23 16:10:09.778+00
94	7	substitution	72	\N	Hicham Berrada remplace Soufiane Mazraoui	f	\N	\N	21	Hicham Berrada	24	Soufiane Mazraoui	2026-11-23 16:10:09.78+00	2026-11-23 16:10:09.78+00
95	7	substitution	77	\N	Khalid Aguerd remplace Abdelali Fassi	f	\N	\N	22	Khalid Aguerd	23	Abdelali Fassi	2026-11-23 16:10:09.783+00	2026-11-23 16:10:09.783+00
96	7	substitution	79	\N	Abdelali Jabrane remplace Rachid Ouchen	f	\N	\N	27	Abdelali Jabrane	29	Rachid Ouchen	2026-11-23 16:10:09.786+00	2026-11-23 16:10:09.786+00
97	7	substitution	82	\N	Said Rami remplace Achraf Harit	t	\N	\N	75	Said Rami	76	Achraf Harit	2026-11-23 16:10:09.788+00	2026-11-23 16:10:09.788+00
98	8	yellow_card	22	\N	Carton jaune	f	44	Karim Benoun	\N	\N	\N	\N	2026-11-23 16:10:09.8+00	2026-11-23 16:10:09.8+00
99	8	goal	53	\N	But de Karim Benoun	f	44	Karim Benoun	\N	\N	\N	\N	2026-11-23 16:10:09.802+00	2026-11-23 16:10:09.802+00
100	8	assist	53	\N	Passe décisive de Taha Sqalli	f	52	Taha Sqalli	\N	\N	\N	\N	2026-11-23 16:10:09.804+00	2026-11-23 16:10:09.804+00
101	8	substitution	56	\N	Salah Jabrane remplace Karim Moutaouakil	t	\N	\N	57	Salah Jabrane	60	Karim Moutaouakil	2026-11-23 16:10:09.805+00	2026-11-23 16:10:09.805+00
102	8	substitution	58	\N	Mohamed Lahlou remplace Nassim Alaoui	t	\N	\N	61	Mohamed Lahlou	62	Nassim Alaoui	2026-11-23 16:10:09.807+00	2026-11-23 16:10:09.807+00
103	8	substitution	71	\N	Said Boufal remplace Driss El Khattabi	f	\N	\N	43	Said Boufal	39	Driss El Khattabi	2026-11-23 16:10:09.808+00	2026-11-23 16:10:09.808+00
104	8	goal	77	\N	But de Amine Ziani	t	70	Amine Ziani	\N	\N	\N	\N	2026-11-23 16:10:09.809+00	2026-11-23 16:10:09.809+00
105	8	assist	77	\N	Passe décisive de Said Ouchen	t	72	Said Ouchen	\N	\N	\N	\N	2026-11-23 16:10:09.811+00	2026-11-23 16:10:09.811+00
106	8	substitution	78	\N	Hicham Fassi remplace Jawad Mazraoui	t	\N	\N	63	Hicham Fassi	67	Jawad Mazraoui	2026-11-23 16:10:09.815+00	2026-11-23 16:10:09.815+00
107	8	substitution	78	\N	Rachid El Idrissi remplace Karim Chraibi	f	\N	\N	41	Rachid El Idrissi	42	Karim Chraibi	2026-11-23 16:10:09.818+00	2026-11-23 16:10:09.818+00
108	8	goal	82	\N	But de Fouad Chraibi	t	58	Fouad Chraibi	\N	\N	\N	\N	2026-11-23 16:10:09.822+00	2026-11-23 16:10:09.822+00
109	8	assist	82	\N	Passe décisive de Bilal Naciri	t	65	Bilal Naciri	\N	\N	\N	\N	2026-11-23 16:10:09.825+00	2026-11-23 16:10:09.825+00
110	8	yellow_card	88	\N	Carton jaune	f	52	Taha Sqalli	\N	\N	\N	\N	2026-11-23 16:10:09.83+00	2026-11-23 16:10:09.83+00
111	8	goal	90	\N	But de Driss El Khattabi	f	39	Driss El Khattabi	\N	\N	\N	\N	2026-11-23 16:10:09.835+00	2026-11-23 16:10:09.835+00
112	8	assist	90	\N	Passe décisive de Mehdi Tazi	f	46	Mehdi Tazi	\N	\N	\N	\N	2026-11-23 16:10:09.84+00	2026-11-23 16:10:09.84+00
113	9	penalty_goal	7	\N	But de Said Boufal	t	9	Said Boufal	\N	\N	\N	\N	2026-11-23 16:10:09.863+00	2026-11-23 16:10:09.863+00
114	9	assist	7	\N	Passe décisive de Yassine El Idrissi	t	6	Yassine El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.868+00	2026-11-23 16:10:09.868+00
115	9	yellow_card	30	\N	Carton jaune	t	3	Karim Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.87+00	2026-11-23 16:10:09.87+00
116	9	goal	32	\N	But de Walid Rahimi	t	7	Walid Rahimi	\N	\N	\N	\N	2026-11-23 16:10:09.871+00	2026-11-23 16:10:09.871+00
117	9	assist	32	\N	Passe décisive de Yassine El Idrissi	t	6	Yassine El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.874+00	2026-11-23 16:10:09.874+00
118	9	yellow_card	48	\N	Carton jaune	f	93	Abdelali El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.877+00	2026-11-23 16:10:09.877+00
119	9	substitution	57	\N	Omar Ziani remplace Zakaria Bouzidi	f	\N	\N	95	Omar Ziani	98	Zakaria Bouzidi	2026-11-23 16:10:09.88+00	2026-11-23 16:10:09.88+00
120	9	substitution	58	\N	Amine Rahimi remplace Yassine El Idrissi	t	\N	\N	5	Amine Rahimi	6	Yassine El Idrissi	2026-11-23 16:10:09.883+00	2026-11-23 16:10:09.883+00
121	9	substitution	59	\N	Soufiane Tazi remplace Walid Rahimi	t	\N	\N	8	Soufiane Tazi	7	Walid Rahimi	2026-11-23 16:10:09.885+00	2026-11-23 16:10:09.885+00
122	9	substitution	74	\N	Soufiane Tazi remplace Khalid Kettani	f	\N	\N	96	Soufiane Tazi	94	Khalid Kettani	2026-11-23 16:10:09.887+00	2026-11-23 16:10:09.887+00
123	9	substitution	74	\N	Driss Aguerd remplace Adil Berrada	f	\N	\N	99	Driss Aguerd	101	Adil Berrada	2026-11-23 16:10:09.89+00	2026-11-23 16:10:09.89+00
124	9	goal	85	\N	But de Hamza Boufal	t	4	Hamza Boufal	\N	\N	\N	\N	2026-11-23 16:10:09.893+00	2026-11-23 16:10:09.893+00
125	9	assist	85	\N	Passe décisive de Karim Ounahi	t	3	Karim Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.896+00	2026-11-23 16:10:09.896+00
126	10	penalty_goal	26	\N	But de Walid Zerouali	t	111	Walid Zerouali	\N	\N	\N	\N	2026-11-23 16:10:09.908+00	2026-11-23 16:10:09.908+00
127	10	assist	26	\N	Passe décisive de Ayman Mazraoui	t	114	Ayman Mazraoui	\N	\N	\N	\N	2026-11-23 16:10:09.909+00	2026-11-23 16:10:09.909+00
128	10	goal	37	\N	But de Walid Zerouali	t	111	Walid Zerouali	\N	\N	\N	\N	2026-11-23 16:10:09.911+00	2026-11-23 16:10:09.911+00
129	10	red_card	39	\N	Carton rouge	t	125	Nabil Ounahi	\N	\N	\N	\N	2026-11-23 16:10:09.914+00	2026-11-23 16:10:09.914+00
130	10	penalty_goal	60	\N	But de Mehdi Kettani	f	84	Mehdi Kettani	\N	\N	\N	\N	2026-11-23 16:10:09.917+00	2026-11-23 16:10:09.917+00
131	10	assist	60	\N	Passe décisive de Jawad Amallah	f	88	Jawad Amallah	\N	\N	\N	\N	2026-11-23 16:10:09.919+00	2026-11-23 16:10:09.919+00
132	10	substitution	60	\N	Mohamed Ouazzani remplace Zakaria El Khattabi	t	\N	\N	115	Mohamed Ouazzani	113	Zakaria El Khattabi	2026-11-23 16:10:09.921+00	2026-11-23 16:10:09.921+00
133	10	substitution	63	\N	Omar Sqalli remplace Ilyas Amallah	t	\N	\N	117	Omar Sqalli	121	Ilyas Amallah	2026-11-23 16:10:09.923+00	2026-11-23 16:10:09.923+00
134	10	yellow_card	70	\N	Carton jaune	t	120	Taha Benali	\N	\N	\N	\N	2026-11-23 16:10:09.924+00	2026-11-23 16:10:09.924+00
135	10	substitution	71	\N	Bilal Ouchen remplace Hamza Boufal	f	\N	\N	80	Bilal Ouchen	77	Hamza Boufal	2026-11-23 16:10:09.926+00	2026-11-23 16:10:09.926+00
136	10	substitution	73	\N	Nabil Moutaouakil remplace Tarik Berrada	t	\N	\N	112	Nabil Moutaouakil	116	Tarik Berrada	2026-11-23 16:10:09.928+00	2026-11-23 16:10:09.928+00
137	10	substitution	83	\N	Othmane El Kaabi remplace Achraf Harit	f	\N	\N	79	Othmane El Kaabi	76	Achraf Harit	2026-11-23 16:10:09.931+00	2026-11-23 16:10:09.931+00
138	11	yellow_card	24	\N	Carton jaune	f	68	Badr Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:09.944+00	2026-11-23 16:10:09.944+00
139	11	substitution	55	\N	Tarik Ezzalzouli remplace Khalid Saiss	t	\N	\N	130	Tarik Ezzalzouli	131	Khalid Saiss	2026-11-23 16:10:09.946+00	2026-11-23 16:10:09.946+00
140	11	substitution	55	\N	Bilal Naciri remplace Badr Ait Ali	f	\N	\N	65	Bilal Naciri	68	Badr Ait Ali	2026-11-23 16:10:09.948+00	2026-11-23 16:10:09.948+00
141	11	substitution	57	\N	Salah Jabrane remplace Mohamed Lahlou	f	\N	\N	57	Salah Jabrane	61	Mohamed Lahlou	2026-11-23 16:10:09.951+00	2026-11-23 16:10:09.951+00
142	11	substitution	58	\N	Mehdi Harit remplace Adil Boufal	t	\N	\N	134	Mehdi Harit	133	Adil Boufal	2026-11-23 16:10:09.954+00	2026-11-23 16:10:09.954+00
143	11	substitution	64	\N	Zakaria Boufal remplace Fouad Bouzidi	t	\N	\N	137	Zakaria Boufal	136	Fouad Bouzidi	2026-11-23 16:10:09.955+00	2026-11-23 16:10:09.955+00
144	11	substitution	73	\N	Mehdi Ezzalzouli remplace Fouad Amrabat	t	\N	\N	138	Mehdi Ezzalzouli	139	Fouad Amrabat	2026-11-23 16:10:09.956+00	2026-11-23 16:10:09.956+00
145	11	substitution	75	\N	Hicham Fassi remplace Mehdi Ziani	f	\N	\N	63	Hicham Fassi	64	Mehdi Ziani	2026-11-23 16:10:09.958+00	2026-11-23 16:10:09.958+00
146	11	substitution	76	\N	Nassim Alaoui remplace Fouad Chraibi	f	\N	\N	62	Nassim Alaoui	58	Fouad Chraibi	2026-11-23 16:10:09.959+00	2026-11-23 16:10:09.959+00
147	11	yellow_card	78	\N	Carton jaune	t	143	Jawad Aguerd	\N	\N	\N	\N	2026-11-23 16:10:09.961+00	2026-11-23 16:10:09.961+00
148	11	yellow_card	79	\N	Carton jaune	f	72	Said Ouchen	\N	\N	\N	\N	2026-11-23 16:10:09.963+00	2026-11-23 16:10:09.963+00
149	11	yellow_card	86	\N	Carton jaune	f	70	Amine Ziani	\N	\N	\N	\N	2026-11-23 16:10:09.966+00	2026-11-23 16:10:09.966+00
150	12	goal	4	\N	But de Hicham Berrada	t	21	Hicham Berrada	\N	\N	\N	\N	2026-11-23 16:10:09.978+00	2026-11-23 16:10:09.978+00
151	12	assist	4	\N	Passe décisive de Mounir Boufal	t	31	Mounir Boufal	\N	\N	\N	\N	2026-11-23 16:10:09.979+00	2026-11-23 16:10:09.979+00
152	12	yellow_card	22	\N	Carton jaune	f	49	Amine Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:09.981+00	2026-11-23 16:10:09.981+00
153	12	yellow_card	27	\N	Carton jaune	t	21	Hicham Berrada	\N	\N	\N	\N	2026-11-23 16:10:09.984+00	2026-11-23 16:10:09.984+00
154	12	yellow_card	27	\N	Carton jaune	f	45	Hamza El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:09.987+00	2026-11-23 16:10:09.987+00
155	12	yellow_card	37	\N	Carton jaune	t	23	Abdelali Fassi	\N	\N	\N	\N	2026-11-23 16:10:09.988+00	2026-11-23 16:10:09.988+00
156	12	goal	38	\N	But de Ilyas Saiss	t	36	Ilyas Saiss	\N	\N	\N	\N	2026-11-23 16:10:09.99+00	2026-11-23 16:10:09.99+00
157	12	goal	52	\N	But de Ilyas Saiss	t	36	Ilyas Saiss	\N	\N	\N	\N	2026-11-23 16:10:09.991+00	2026-11-23 16:10:09.991+00
158	12	assist	52	\N	Passe décisive de Taha Alaoui	t	28	Taha Alaoui	\N	\N	\N	\N	2026-11-23 16:10:09.993+00	2026-11-23 16:10:09.993+00
159	12	substitution	59	\N	Soufiane Mazraoui remplace Hicham Berrada	t	\N	\N	24	Soufiane Mazraoui	21	Hicham Berrada	2026-11-23 16:10:09.994+00	2026-11-23 16:10:09.994+00
160	12	substitution	59	\N	Adil Chraibi remplace Rachid Aguerd	t	\N	\N	26	Adil Chraibi	25	Rachid Aguerd	2026-11-23 16:10:09.996+00	2026-11-23 16:10:09.996+00
161	12	substitution	61	\N	Rachid Ouchen remplace Taha Alaoui	t	\N	\N	29	Rachid Ouchen	28	Taha Alaoui	2026-11-23 16:10:09.997+00	2026-11-23 16:10:09.997+00
162	12	substitution	68	\N	Driss El Khattabi remplace Karim Chraibi	f	\N	\N	39	Driss El Khattabi	42	Karim Chraibi	2026-11-23 16:10:10+00	2026-11-23 16:10:10+00
163	12	substitution	85	\N	Karim Benoun remplace Said Boufal	f	\N	\N	44	Karim Benoun	43	Said Boufal	2026-11-23 16:10:10.001+00	2026-11-23 16:10:10.001+00
164	13	yellow_card	22	\N	Carton jaune	f	15	Hicham Kettani	\N	\N	\N	\N	2026-11-23 16:10:10.01+00	2026-11-23 16:10:10.01+00
165	13	goal	23	\N	But de Tarik Harit	f	16	Tarik Harit	\N	\N	\N	\N	2026-11-23 16:10:10.012+00	2026-11-23 16:10:10.012+00
166	13	assist	23	\N	Passe décisive de Hamza Boufal	f	4	Hamza Boufal	\N	\N	\N	\N	2026-11-23 16:10:10.014+00	2026-11-23 16:10:10.014+00
167	13	goal	57	\N	But de Tarik Seddiki	f	11	Tarik Seddiki	\N	\N	\N	\N	2026-11-23 16:10:10.016+00	2026-11-23 16:10:10.016+00
168	13	goal	58	\N	But de Hamza Boufal	f	4	Hamza Boufal	\N	\N	\N	\N	2026-11-23 16:10:10.018+00	2026-11-23 16:10:10.018+00
169	13	assist	58	\N	Passe décisive de Yassine El Idrissi	f	6	Yassine El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:10.021+00	2026-11-23 16:10:10.021+00
170	13	substitution	58	\N	Othmane El Kaabi remplace Said Rami	t	\N	\N	79	Othmane El Kaabi	75	Said Rami	2026-11-23 16:10:10.024+00	2026-11-23 16:10:10.024+00
171	13	substitution	62	\N	Khalid El Amrani remplace Zakaria El Khattabi	f	\N	\N	12	Khalid El Amrani	10	Zakaria El Khattabi	2026-11-23 16:10:10.026+00	2026-11-23 16:10:10.026+00
172	13	substitution	63	\N	Karim Ounahi remplace Soufiane Tazi	f	\N	\N	3	Karim Ounahi	8	Soufiane Tazi	2026-11-23 16:10:10.028+00	2026-11-23 16:10:10.028+00
173	13	substitution	65	\N	Walid Rahimi remplace Yassine El Idrissi	f	\N	\N	7	Walid Rahimi	6	Yassine El Idrissi	2026-11-23 16:10:10.03+00	2026-11-23 16:10:10.03+00
174	13	substitution	68	\N	Fouad Boufal remplace Soufiane Ait Ali	t	\N	\N	82	Fouad Boufal	86	Soufiane Ait Ali	2026-11-23 16:10:10.032+00	2026-11-23 16:10:10.032+00
175	13	substitution	69	\N	Achraf Harit remplace Hamza Boufal	t	\N	\N	76	Achraf Harit	77	Hamza Boufal	2026-11-23 16:10:10.035+00	2026-11-23 16:10:10.035+00
176	13	substitution	76	\N	Said Boufal remplace Driss El Kaabi	f	\N	\N	9	Said Boufal	13	Driss El Kaabi	2026-11-23 16:10:10.041+00	2026-11-23 16:10:10.041+00
177	14	yellow_card	14	\N	Carton jaune	t	72	Said Ouchen	\N	\N	\N	\N	2026-11-23 16:10:10.065+00	2026-11-23 16:10:10.065+00
178	14	yellow_card	21	\N	Carton jaune	f	107	Hamza Naciri	\N	\N	\N	\N	2026-11-23 16:10:10.071+00	2026-11-23 16:10:10.071+00
179	14	yellow_card	22	\N	Carton jaune	f	106	Walid Benoun	\N	\N	\N	\N	2026-11-23 16:10:10.075+00	2026-11-23 16:10:10.075+00
180	14	yellow_card	35	\N	Carton jaune	t	66	Salah Benali	\N	\N	\N	\N	2026-11-23 16:10:10.077+00	2026-11-23 16:10:10.077+00
181	14	yellow_card	60	\N	Carton jaune	t	68	Badr Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:10.081+00	2026-11-23 16:10:10.081+00
182	14	substitution	64	\N	Zakaria Bouzidi remplace Mohamed Bouzidi	f	\N	\N	98	Zakaria Bouzidi	97	Mohamed Bouzidi	2026-11-23 16:10:10.086+00	2026-11-23 16:10:10.086+00
183	14	substitution	67	\N	Nassim Alaoui remplace Mohamed Lahlou	t	\N	\N	62	Nassim Alaoui	61	Mohamed Lahlou	2026-11-23 16:10:10.088+00	2026-11-23 16:10:10.088+00
184	14	substitution	68	\N	Khalid Kettani remplace Abdelali El Idrissi	f	\N	\N	94	Khalid Kettani	93	Abdelali El Idrissi	2026-11-23 16:10:10.09+00	2026-11-23 16:10:10.09+00
185	14	substitution	70	\N	Driss Aguerd remplace Fouad Ounahi	f	\N	\N	99	Driss Aguerd	104	Fouad Ounahi	2026-11-23 16:10:10.095+00	2026-11-23 16:10:10.095+00
186	14	substitution	79	\N	Hicham Fassi remplace Bilal Naciri	t	\N	\N	63	Hicham Fassi	65	Bilal Naciri	2026-11-23 16:10:10.098+00	2026-11-23 16:10:10.098+00
187	14	substitution	82	\N	Fouad Chraibi remplace Salah Jabrane	t	\N	\N	58	Fouad Chraibi	57	Salah Jabrane	2026-11-23 16:10:10.101+00	2026-11-23 16:10:10.101+00
188	14	goal	87	\N	But de Soufiane Tazi	f	96	Soufiane Tazi	\N	\N	\N	\N	2026-11-23 16:10:10.103+00	2026-11-23 16:10:10.103+00
189	14	assist	87	\N	Passe décisive de Ayman Benali	f	108	Ayman Benali	\N	\N	\N	\N	2026-11-23 16:10:10.104+00	2026-11-23 16:10:10.104+00
190	15	goal	16	\N	But de Ilyas Sqalli	t	51	Ilyas Sqalli	\N	\N	\N	\N	2026-11-23 16:10:10.116+00	2026-11-23 16:10:10.116+00
191	15	assist	16	\N	Passe décisive de Hamza El Idrissi	t	45	Hamza El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:10.118+00	2026-11-23 16:10:10.118+00
192	15	penalty_goal	34	\N	But de Nassim Lahlou	f	123	Nassim Lahlou	\N	\N	\N	\N	2026-11-23 16:10:10.12+00	2026-11-23 16:10:10.12+00
193	15	assist	34	\N	Passe décisive de Karim Moutaouakil	f	124	Karim Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:10.122+00	2026-11-23 16:10:10.122+00
194	15	substitution	61	\N	Jawad Haddad remplace Taha Benali	f	\N	\N	119	Jawad Haddad	120	Taha Benali	2026-11-23 16:10:10.125+00	2026-11-23 16:10:10.125+00
195	15	substitution	66	\N	Nabil Moutaouakil remplace Tarik Berrada	f	\N	\N	112	Nabil Moutaouakil	116	Tarik Berrada	2026-11-23 16:10:10.127+00	2026-11-23 16:10:10.127+00
196	15	goal	69	\N	But de Ayman Mazraoui	f	114	Ayman Mazraoui	\N	\N	\N	\N	2026-11-23 16:10:10.129+00	2026-11-23 16:10:10.129+00
197	15	assist	69	\N	Passe décisive de Tarik Berrada	f	116	Tarik Berrada	\N	\N	\N	\N	2026-11-23 16:10:10.131+00	2026-11-23 16:10:10.131+00
198	15	substitution	71	\N	Driss El Khattabi remplace Karim Chraibi	t	\N	\N	39	Driss El Khattabi	42	Karim Chraibi	2026-11-23 16:10:10.132+00	2026-11-23 16:10:10.132+00
199	15	goal	73	\N	But de Karim Chraibi	t	42	Karim Chraibi	\N	\N	\N	\N	2026-11-23 16:10:10.134+00	2026-11-23 16:10:10.134+00
200	15	assist	73	\N	Passe décisive de Hamza Benali	t	40	Hamza Benali	\N	\N	\N	\N	2026-11-23 16:10:10.137+00	2026-11-23 16:10:10.137+00
201	15	yellow_card	73	\N	Carton jaune	f	117	Omar Sqalli	\N	\N	\N	\N	2026-11-23 16:10:10.139+00	2026-11-23 16:10:10.139+00
202	15	substitution	79	\N	Said Boufal remplace Karim Benoun	t	\N	\N	43	Said Boufal	44	Karim Benoun	2026-11-23 16:10:10.141+00	2026-11-23 16:10:10.141+00
203	15	substitution	80	\N	Mehdi Tazi remplace Hamza El Idrissi	t	\N	\N	46	Mehdi Tazi	45	Hamza El Idrissi	2026-11-23 16:10:10.142+00	2026-11-23 16:10:10.142+00
204	15	goal	81	\N	But de Mohamed Ouazzani	f	115	Mohamed Ouazzani	\N	\N	\N	\N	2026-11-23 16:10:10.144+00	2026-11-23 16:10:10.144+00
205	15	assist	81	\N	Passe décisive de Walid Belhaj	f	122	Walid Belhaj	\N	\N	\N	\N	2026-11-23 16:10:10.146+00	2026-11-23 16:10:10.146+00
206	15	substitution	81	\N	Noureddine Fassi remplace Walid Belhaj	f	\N	\N	118	Noureddine Fassi	122	Walid Belhaj	2026-11-23 16:10:10.15+00	2026-11-23 16:10:10.15+00
207	15	substitution	82	\N	Zakaria El Khattabi remplace Ayman Mazraoui	f	\N	\N	113	Zakaria El Khattabi	114	Ayman Mazraoui	2026-11-23 16:10:10.153+00	2026-11-23 16:10:10.153+00
208	16	goal	11	\N	But de Ilyas Saiss	t	36	Ilyas Saiss	\N	\N	\N	\N	2026-11-23 16:10:10.175+00	2026-11-23 16:10:10.175+00
209	16	goal	26	\N	But de Abdelali Fassi	t	23	Abdelali Fassi	\N	\N	\N	\N	2026-11-23 16:10:10.177+00	2026-11-23 16:10:10.177+00
210	16	assist	26	\N	Passe décisive de Youssef Bennani	t	34	Youssef Bennani	\N	\N	\N	\N	2026-11-23 16:10:10.179+00	2026-11-23 16:10:10.179+00
211	16	goal	32	\N	But de Khalid Saiss	f	131	Khalid Saiss	\N	\N	\N	\N	2026-11-23 16:10:10.182+00	2026-11-23 16:10:10.182+00
212	16	substitution	57	\N	Anas Rahimi remplace Tarik Ezzalzouli	f	\N	\N	129	Anas Rahimi	130	Tarik Ezzalzouli	2026-11-23 16:10:10.183+00	2026-11-23 16:10:10.183+00
213	16	substitution	57	\N	Zakaria Boufal remplace Fouad Amrabat	f	\N	\N	137	Zakaria Boufal	139	Fouad Amrabat	2026-11-23 16:10:10.186+00	2026-11-23 16:10:10.186+00
214	16	substitution	62	\N	Soufiane Mazraoui remplace Abdelali Fassi	t	\N	\N	24	Soufiane Mazraoui	23	Abdelali Fassi	2026-11-23 16:10:10.188+00	2026-11-23 16:10:10.188+00
215	16	substitution	67	\N	Rachid Aguerd remplace Hicham Berrada	t	\N	\N	25	Rachid Aguerd	21	Hicham Berrada	2026-11-23 16:10:10.19+00	2026-11-23 16:10:10.19+00
216	16	substitution	68	\N	Adil Boufal remplace Khalid Saiss	f	\N	\N	133	Adil Boufal	131	Khalid Saiss	2026-11-23 16:10:10.192+00	2026-11-23 16:10:10.192+00
217	16	goal	78	\N	But de Ilyas Saiss	t	36	Ilyas Saiss	\N	\N	\N	\N	2026-11-23 16:10:10.194+00	2026-11-23 16:10:10.194+00
218	16	assist	78	\N	Passe décisive de Mounir Boufal	t	31	Mounir Boufal	\N	\N	\N	\N	2026-11-23 16:10:10.196+00	2026-11-23 16:10:10.196+00
219	16	goal	83	\N	But de Taha Alaoui	t	28	Taha Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.198+00	2026-11-23 16:10:10.198+00
220	16	assist	83	\N	Passe décisive de Amine Alaoui	t	35	Amine Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.199+00	2026-11-23 16:10:10.199+00
221	32	yellow_card	34	\N	Carton jaune	t	159	Imad Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.348+00	2026-11-23 16:10:10.348+00
222	32	substitution	57	\N	Youssef Benoun remplace Anas Ouchen	f	\N	\N	202	Youssef Benoun	201	Anas Ouchen	2026-11-23 16:10:10.349+00	2026-11-23 16:10:10.349+00
223	32	substitution	66	\N	Badr Alaoui remplace Karim Ouchen	f	\N	\N	206	Badr Alaoui	203	Karim Ouchen	2026-11-23 16:10:10.351+00	2026-11-23 16:10:10.351+00
224	32	goal	68	\N	But de Karim Ouchen	t	152	Karim Ouchen	\N	\N	\N	\N	2026-11-23 16:10:10.352+00	2026-11-23 16:10:10.352+00
225	32	goal	73	\N	But de Anas Seddiki	t	156	Anas Seddiki	\N	\N	\N	\N	2026-11-23 16:10:10.355+00	2026-11-23 16:10:10.355+00
226	32	assist	73	\N	Passe décisive de Badr Amrabat	t	151	Badr Amrabat	\N	\N	\N	\N	2026-11-23 16:10:10.358+00	2026-11-23 16:10:10.358+00
227	32	substitution	80	\N	Hicham Mansouri remplace Karim Ouchen	t	\N	\N	149	Hicham Mansouri	152	Karim Ouchen	2026-11-23 16:10:10.361+00	2026-11-23 16:10:10.361+00
228	32	substitution	82	\N	Khalid Aguerd remplace Badr Amrabat	t	\N	\N	147	Khalid Aguerd	151	Badr Amrabat	2026-11-23 16:10:10.362+00	2026-11-23 16:10:10.362+00
229	33	goal	6	\N	But de Othmane Moutaouakil	f	171	Othmane Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:10.376+00	2026-11-23 16:10:10.376+00
230	33	assist	6	\N	Passe décisive de Driss Rahimi	f	174	Driss Rahimi	\N	\N	\N	\N	2026-11-23 16:10:10.378+00	2026-11-23 16:10:10.378+00
231	33	goal	19	\N	But de Amine Rahimi	t	250	Amine Rahimi	\N	\N	\N	\N	2026-11-23 16:10:10.381+00	2026-11-23 16:10:10.381+00
232	33	assist	19	\N	Passe décisive de Abdelali Belhaj	t	249	Abdelali Belhaj	\N	\N	\N	\N	2026-11-23 16:10:10.384+00	2026-11-23 16:10:10.384+00
233	33	goal	29	\N	But de Zakaria El Khattabi	t	241	Zakaria El Khattabi	\N	\N	\N	\N	2026-11-23 16:10:10.389+00	2026-11-23 16:10:10.389+00
234	33	substitution	62	\N	Mehdi Moutaouakil remplace Amine Boufal	t	\N	\N	239	Mehdi Moutaouakil	238	Amine Boufal	2026-11-23 16:10:10.391+00	2026-11-23 16:10:10.391+00
235	33	substitution	64	\N	Nassim Fassi remplace Driss Rahimi	f	\N	\N	175	Nassim Fassi	174	Driss Rahimi	2026-11-23 16:10:10.394+00	2026-11-23 16:10:10.394+00
236	33	goal	65	\N	But de Noureddine Naciri	f	168	Noureddine Naciri	\N	\N	\N	\N	2026-11-23 16:10:10.396+00	2026-11-23 16:10:10.396+00
237	33	substitution	67	\N	Khalid Bennani remplace Othmane Moutaouakil	f	\N	\N	172	Khalid Bennani	171	Othmane Moutaouakil	2026-11-23 16:10:10.398+00	2026-11-23 16:10:10.398+00
238	33	substitution	71	\N	Fouad Harit remplace Hakim Naciri	t	\N	\N	247	Fouad Harit	245	Hakim Naciri	2026-11-23 16:10:10.4+00	2026-11-23 16:10:10.4+00
239	33	substitution	72	\N	Mounir Sqalli remplace Othmane Chraibi	t	\N	\N	242	Mounir Sqalli	237	Othmane Chraibi	2026-11-23 16:10:10.402+00	2026-11-23 16:10:10.402+00
240	33	yellow_card	73	\N	Carton jaune	t	250	Amine Rahimi	\N	\N	\N	\N	2026-11-23 16:10:10.403+00	2026-11-23 16:10:10.403+00
241	33	substitution	73	\N	Ilyas Ouchen remplace Noureddine Naciri	f	\N	\N	170	Ilyas Ouchen	168	Noureddine Naciri	2026-11-23 16:10:10.405+00	2026-11-23 16:10:10.405+00
242	33	substitution	81	\N	Ayoub El Amrani remplace Nabil El Kaabi	f	\N	\N	167	Ayoub El Amrani	169	Nabil El Kaabi	2026-11-23 16:10:10.406+00	2026-11-23 16:10:10.406+00
243	33	substitution	83	\N	Yassine Haddad remplace Omar Ait Ali	t	\N	\N	244	Yassine Haddad	243	Omar Ait Ali	2026-11-23 16:10:10.409+00	2026-11-23 16:10:10.409+00
244	33	goal	86	\N	But de Tarik Hakimi	f	173	Tarik Hakimi	\N	\N	\N	\N	2026-11-23 16:10:10.411+00	2026-11-23 16:10:10.411+00
245	33	assist	86	\N	Passe décisive de Adil Ait Ali	f	180	Adil Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:10.412+00	2026-11-23 16:10:10.412+00
246	33	goal	89	\N	But de Omar Ait Ali	t	243	Omar Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:10.417+00	2026-11-23 16:10:10.417+00
247	34	yellow_card	14	\N	Carton jaune	f	268	Hicham Benoun	\N	\N	\N	\N	2026-11-23 16:10:10.43+00	2026-11-23 16:10:10.43+00
248	34	penalty_goal	17	\N	But de Hamza Berrada	t	223	Hamza Berrada	\N	\N	\N	\N	2026-11-23 16:10:10.432+00	2026-11-23 16:10:10.432+00
249	34	assist	17	\N	Passe décisive de Zakaria Chraibi	t	225	Zakaria Chraibi	\N	\N	\N	\N	2026-11-23 16:10:10.434+00	2026-11-23 16:10:10.434+00
250	34	yellow_card	48	\N	Carton jaune	t	226	Rachid El Kaabi	\N	\N	\N	\N	2026-11-23 16:10:10.435+00	2026-11-23 16:10:10.435+00
251	34	substitution	55	\N	Ayman Zerouali remplace Zakaria Tazi	f	\N	\N	264	Ayman Zerouali	261	Zakaria Tazi	2026-11-23 16:10:10.437+00	2026-11-23 16:10:10.437+00
252	34	goal	60	\N	But de Mehdi El Idrissi	f	260	Mehdi El Idrissi	\N	\N	\N	\N	2026-11-23 16:10:10.438+00	2026-11-23 16:10:10.438+00
253	34	assist	60	\N	Passe décisive de Hicham Hakimi	f	266	Hicham Hakimi	\N	\N	\N	\N	2026-11-23 16:10:10.441+00	2026-11-23 16:10:10.441+00
254	34	substitution	61	\N	Abdelali Chraibi remplace Salah Aguerd	t	\N	\N	222	Abdelali Chraibi	221	Salah Aguerd	2026-11-23 16:10:10.443+00	2026-11-23 16:10:10.443+00
255	34	substitution	70	\N	Karim Alaoui remplace Rachid El Kaabi	t	\N	\N	227	Karim Alaoui	226	Rachid El Kaabi	2026-11-23 16:10:10.445+00	2026-11-23 16:10:10.445+00
256	34	substitution	77	\N	Nabil Seddiki remplace Hicham Hakimi	f	\N	\N	262	Nabil Seddiki	266	Hicham Hakimi	2026-11-23 16:10:10.447+00	2026-11-23 16:10:10.447+00
257	34	substitution	80	\N	Ayoub Alaoui remplace Adil Naciri	f	\N	\N	256	Ayoub Alaoui	255	Adil Naciri	2026-11-23 16:10:10.45+00	2026-11-23 16:10:10.45+00
258	34	substitution	81	\N	Imad Tazi remplace Walid Jabrane	t	\N	\N	219	Imad Tazi	224	Walid Jabrane	2026-11-23 16:10:10.452+00	2026-11-23 16:10:10.452+00
259	34	substitution	83	\N	Mounir Rahimi remplace Ismail Ouazzani	f	\N	\N	259	Mounir Rahimi	258	Ismail Ouazzani	2026-11-23 16:10:10.455+00	2026-11-23 16:10:10.455+00
260	34	goal	90	\N	But de Rachid Tazi	t	232	Rachid Tazi	\N	\N	\N	\N	2026-11-23 16:10:10.457+00	2026-11-23 16:10:10.457+00
261	35	yellow_card	17	\N	Carton jaune	f	194	Mounir Ouchen	\N	\N	\N	\N	2026-11-23 16:10:10.485+00	2026-11-23 16:10:10.485+00
262	35	yellow_card	28	\N	Carton jaune	f	198	Achraf Hakimi	\N	\N	\N	\N	2026-11-23 16:10:10.49+00	2026-11-23 16:10:10.49+00
263	35	goal	54	\N	But de Fouad Ait Ali	t	283	Fouad Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:10.495+00	2026-11-23 16:10:10.495+00
264	35	assist	54	\N	Passe décisive de Karim Rahimi	t	274	Karim Rahimi	\N	\N	\N	\N	2026-11-23 16:10:10.499+00	2026-11-23 16:10:10.499+00
265	35	substitution	55	\N	Tarik Ouazzani remplace Hakim Rahimi	t	\N	\N	276	Tarik Ouazzani	278	Hakim Rahimi	2026-11-23 16:10:10.503+00	2026-11-23 16:10:10.503+00
266	35	substitution	55	\N	Abdelali Rahimi remplace Achraf Fassi	f	\N	\N	189	Abdelali Rahimi	192	Achraf Fassi	2026-11-23 16:10:10.509+00	2026-11-23 16:10:10.509+00
267	35	substitution	63	\N	Reda Aguerd remplace Ismail El Kaabi	f	\N	\N	188	Reda Aguerd	187	Ismail El Kaabi	2026-11-23 16:10:10.512+00	2026-11-23 16:10:10.512+00
268	35	substitution	78	\N	Tarik Amrabat remplace Karim Rahimi	t	\N	\N	273	Tarik Amrabat	274	Karim Rahimi	2026-11-23 16:10:10.514+00	2026-11-23 16:10:10.514+00
269	35	substitution	80	\N	Ayoub Tazi remplace Tarik Mazraoui	f	\N	\N	184	Ayoub Tazi	185	Tarik Mazraoui	2026-11-23 16:10:10.518+00	2026-11-23 16:10:10.518+00
270	30	goal	10	\N	But de Adil Zerouali	t	157	Adil Zerouali	\N	\N	\N	\N	2026-11-23 16:10:10.551+00	2026-11-23 16:10:10.551+00
271	30	assist	10	\N	Passe décisive de Tarik Seddiki	t	148	Tarik Seddiki	\N	\N	\N	\N	2026-11-23 16:10:10.555+00	2026-11-23 16:10:10.555+00
272	30	yellow_card	10	\N	Carton jaune	t	147	Khalid Aguerd	\N	\N	\N	\N	2026-11-23 16:10:10.557+00	2026-11-23 16:10:10.557+00
273	30	goal	14	\N	But de Noureddine Harit	f	177	Noureddine Harit	\N	\N	\N	\N	2026-11-23 16:10:10.559+00	2026-11-23 16:10:10.559+00
274	30	assist	14	\N	Passe décisive de Khalid Bennani	f	172	Khalid Bennani	\N	\N	\N	\N	2026-11-23 16:10:10.56+00	2026-11-23 16:10:10.56+00
275	30	yellow_card	41	\N	Carton jaune	f	172	Khalid Bennani	\N	\N	\N	\N	2026-11-23 16:10:10.562+00	2026-11-23 16:10:10.562+00
276	30	substitution	56	\N	Tarik Ezzalzouli remplace Tarik Seddiki	t	\N	\N	150	Tarik Ezzalzouli	148	Tarik Seddiki	2026-11-23 16:10:10.564+00	2026-11-23 16:10:10.564+00
277	30	yellow_card	57	\N	Carton jaune	f	171	Othmane Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:10.566+00	2026-11-23 16:10:10.566+00
278	30	substitution	67	\N	Nabil El Kaabi remplace Ilyas Ouchen	f	\N	\N	169	Nabil El Kaabi	170	Ilyas Ouchen	2026-11-23 16:10:10.568+00	2026-11-23 16:10:10.568+00
279	30	yellow_card	68	\N	Carton jaune	f	167	Ayoub El Amrani	\N	\N	\N	\N	2026-11-23 16:10:10.571+00	2026-11-23 16:10:10.571+00
280	30	substitution	70	\N	Badr Amrabat remplace Karim Ouchen	t	\N	\N	151	Badr Amrabat	152	Karim Ouchen	2026-11-23 16:10:10.573+00	2026-11-23 16:10:10.573+00
281	30	substitution	77	\N	Amine Chraibi remplace Adil Zerouali	t	\N	\N	153	Amine Chraibi	157	Adil Zerouali	2026-11-23 16:10:10.575+00	2026-11-23 16:10:10.575+00
282	30	substitution	80	\N	Mounir Alaoui remplace Adil Amrabat	f	\N	\N	165	Mounir Alaoui	166	Adil Amrabat	2026-11-23 16:10:10.577+00	2026-11-23 16:10:10.577+00
283	30	substitution	82	\N	Tarik Hakimi remplace Khalid Bennani	f	\N	\N	173	Tarik Hakimi	172	Khalid Bennani	2026-11-23 16:10:10.58+00	2026-11-23 16:10:10.58+00
284	30	goal	88	\N	But de Taha Saiss	t	161	Taha Saiss	\N	\N	\N	\N	2026-11-23 16:10:10.593+00	2026-11-23 16:10:10.593+00
285	30	yellow_card	89	\N	Carton jaune	t	148	Tarik Seddiki	\N	\N	\N	\N	2026-11-23 16:10:10.608+00	2026-11-23 16:10:10.608+00
286	31	goal	4	\N	But de Hamza Mazraoui	t	234	Hamza Mazraoui	\N	\N	\N	\N	2026-11-23 16:10:10.629+00	2026-11-23 16:10:10.629+00
287	31	assist	4	\N	Passe décisive de Youssef Moutaouakil	t	228	Youssef Moutaouakil	\N	\N	\N	\N	2026-11-23 16:10:10.631+00	2026-11-23 16:10:10.631+00
288	31	yellow_card	17	\N	Carton jaune	f	285	Taha Bouzidi	\N	\N	\N	\N	2026-11-23 16:10:10.634+00	2026-11-23 16:10:10.634+00
289	31	yellow_card	18	\N	Carton jaune	t	230	Abdelali Belhaj	\N	\N	\N	\N	2026-11-23 16:10:10.636+00	2026-11-23 16:10:10.636+00
290	31	goal	19	\N	But de Imad Haddad	f	280	Imad Haddad	\N	\N	\N	\N	2026-11-23 16:10:10.643+00	2026-11-23 16:10:10.643+00
291	31	assist	19	\N	Passe décisive de Nabil Fassi	f	288	Nabil Fassi	\N	\N	\N	\N	2026-11-23 16:10:10.645+00	2026-11-23 16:10:10.645+00
292	31	goal	31	\N	But de Mounir Harit	t	220	Mounir Harit	\N	\N	\N	\N	2026-11-23 16:10:10.647+00	2026-11-23 16:10:10.647+00
293	31	assist	31	\N	Passe décisive de Hamza Berrada	t	223	Hamza Berrada	\N	\N	\N	\N	2026-11-23 16:10:10.65+00	2026-11-23 16:10:10.65+00
294	31	goal	31	\N	But de Karim Alaoui	t	227	Karim Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.652+00	2026-11-23 16:10:10.652+00
295	31	assist	31	\N	Passe décisive de Khalid Rami	t	231	Khalid Rami	\N	\N	\N	\N	2026-11-23 16:10:10.654+00	2026-11-23 16:10:10.654+00
296	31	yellow_card	49	\N	Carton jaune	t	220	Mounir Harit	\N	\N	\N	\N	2026-11-23 16:10:10.659+00	2026-11-23 16:10:10.659+00
297	31	substitution	57	\N	Zakaria Chraibi remplace Abdelali Belhaj	t	\N	\N	225	Zakaria Chraibi	230	Abdelali Belhaj	2026-11-23 16:10:10.662+00	2026-11-23 16:10:10.662+00
298	31	substitution	59	\N	Imad Tazi remplace Hamza Berrada	t	\N	\N	219	Imad Tazi	223	Hamza Berrada	2026-11-23 16:10:10.666+00	2026-11-23 16:10:10.666+00
299	31	yellow_card	60	\N	Carton jaune	t	227	Karim Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.669+00	2026-11-23 16:10:10.669+00
300	31	substitution	60	\N	Salah Seddiki remplace Karim Rahimi	f	\N	\N	277	Salah Seddiki	274	Karim Rahimi	2026-11-23 16:10:10.671+00	2026-11-23 16:10:10.671+00
301	31	goal	63	\N	But de Hakim Sqalli	f	287	Hakim Sqalli	\N	\N	\N	\N	2026-11-23 16:10:10.673+00	2026-11-23 16:10:10.673+00
302	31	assist	63	\N	Passe décisive de Taha Bouzidi	f	285	Taha Bouzidi	\N	\N	\N	\N	2026-11-23 16:10:10.674+00	2026-11-23 16:10:10.674+00
303	31	substitution	68	\N	Walid Jabrane remplace Mounir Harit	t	\N	\N	224	Walid Jabrane	220	Mounir Harit	2026-11-23 16:10:10.677+00	2026-11-23 16:10:10.677+00
304	31	goal	73	\N	But de Karim Rahimi	f	274	Karim Rahimi	\N	\N	\N	\N	2026-11-23 16:10:10.68+00	2026-11-23 16:10:10.68+00
305	31	substitution	73	\N	Jawad Ziani remplace Said Boufal	f	\N	\N	279	Jawad Ziani	282	Said Boufal	2026-11-23 16:10:10.682+00	2026-11-23 16:10:10.682+00
306	31	substitution	81	\N	Rachid El Kaabi remplace Youssef Moutaouakil	t	\N	\N	226	Rachid El Kaabi	228	Youssef Moutaouakil	2026-11-23 16:10:10.685+00	2026-11-23 16:10:10.685+00
307	31	substitution	85	\N	Noureddine Saiss remplace Tarik Ouazzani	f	\N	\N	275	Noureddine Saiss	276	Tarik Ouazzani	2026-11-23 16:10:10.687+00	2026-11-23 16:10:10.687+00
308	29	goal	1	\N	But de Khalid Aguerd	t	147	Khalid Aguerd	\N	\N	\N	\N	2026-11-23 16:10:10.709+00	2026-11-23 16:10:10.709+00
309	29	assist	1	\N	Passe décisive de Imad Alaoui	t	159	Imad Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.712+00	2026-11-23 16:10:10.712+00
310	29	goal	11	\N	But de Fouad Ait Ali	f	283	Fouad Ait Ali	\N	\N	\N	\N	2026-11-23 16:10:10.73+00	2026-11-23 16:10:10.73+00
311	29	assist	11	\N	Passe décisive de Tarik Ouazzani	f	276	Tarik Ouazzani	\N	\N	\N	\N	2026-11-23 16:10:10.734+00	2026-11-23 16:10:10.734+00
312	29	yellow_card	19	\N	Carton jaune	f	273	Tarik Amrabat	\N	\N	\N	\N	2026-11-23 16:10:10.738+00	2026-11-23 16:10:10.738+00
313	29	goal	20	\N	But de Salah Seddiki	f	277	Salah Seddiki	\N	\N	\N	\N	2026-11-23 16:10:10.741+00	2026-11-23 16:10:10.741+00
314	29	assist	20	\N	Passe décisive de Taha Bouzidi	f	285	Taha Bouzidi	\N	\N	\N	\N	2026-11-23 16:10:10.75+00	2026-11-23 16:10:10.75+00
315	29	yellow_card	36	\N	Carton jaune	t	157	Adil Zerouali	\N	\N	\N	\N	2026-11-23 16:10:10.754+00	2026-11-23 16:10:10.754+00
316	29	substitution	58	\N	Karim Rahimi remplace Tarik Ouazzani	f	\N	\N	274	Karim Rahimi	276	Tarik Ouazzani	2026-11-23 16:10:10.757+00	2026-11-23 16:10:10.757+00
317	29	substitution	59	\N	Hakim Rahimi remplace Noureddine Saiss	f	\N	\N	278	Hakim Rahimi	275	Noureddine Saiss	2026-11-23 16:10:10.759+00	2026-11-23 16:10:10.759+00
318	29	substitution	64	\N	Omar Amallah remplace Fouad Ait Ali	f	\N	\N	281	Omar Amallah	283	Fouad Ait Ali	2026-11-23 16:10:10.762+00	2026-11-23 16:10:10.762+00
319	29	substitution	65	\N	Badr Amrabat remplace Karim Ouchen	t	\N	\N	151	Badr Amrabat	152	Karim Ouchen	2026-11-23 16:10:10.764+00	2026-11-23 16:10:10.764+00
320	29	goal	70	\N	But de Imad Alaoui	t	159	Imad Alaoui	\N	\N	\N	\N	2026-11-23 16:10:10.767+00	2026-11-23 16:10:10.767+00
321	29	assist	70	\N	Passe décisive de Karim Ouchen	t	152	Karim Ouchen	\N	\N	\N	\N	2026-11-23 16:10:10.77+00	2026-11-23 16:10:10.77+00
322	29	substitution	70	\N	Anas Zerouali remplace Amine Chraibi	t	\N	\N	155	Anas Zerouali	153	Amine Chraibi	2026-11-23 16:10:10.772+00	2026-11-23 16:10:10.772+00
323	29	substitution	77	\N	Tarik Seddiki remplace Khalid Aguerd	t	\N	\N	148	Tarik Seddiki	147	Khalid Aguerd	2026-11-23 16:10:10.773+00	2026-11-23 16:10:10.773+00
324	29	substitution	77	\N	Imad Haddad remplace Said Boufal	f	\N	\N	280	Imad Haddad	282	Said Boufal	2026-11-23 16:10:10.774+00	2026-11-23 16:10:10.774+00
325	29	substitution	79	\N	Anas Seddiki remplace Rachid Bouzidi	t	\N	\N	156	Anas Seddiki	154	Rachid Bouzidi	2026-11-23 16:10:10.775+00	2026-11-23 16:10:10.775+00
326	29	goal	82	\N	But de Amine Chraibi	t	153	Amine Chraibi	\N	\N	\N	\N	2026-11-23 16:10:10.776+00	2026-11-23 16:10:10.776+00
327	29	red_card	82	\N	Carton rouge	t	149	Hicham Mansouri	\N	\N	\N	\N	2026-11-23 16:10:10.778+00	2026-11-23 16:10:10.778+00
328	29	goal	84	\N	But de Nabil Amallah	t	162	Nabil Amallah	\N	\N	\N	\N	2026-11-23 16:10:10.78+00	2026-11-23 16:10:10.78+00
\.


--
-- Data for Name: MatchLineups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MatchLineups" (id, "matchId", "teamId", formation, players, status, "createdAt", "updatedAt") FROM stdin;
1	1	1	4-3-3	[{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":true},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":false}]	published	2026-11-23 16:10:09.484+00	2026-11-23 16:10:09.484+00
2	1	8	4-3-3	[{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":true},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":false},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":false}]	published	2026-11-23 16:10:09.489+00	2026-11-23 16:10:09.489+00
3	2	2	4-3-3	[{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":false},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":false},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":false}]	published	2026-11-23 16:10:09.529+00	2026-11-23 16:10:09.529+00
4	2	7	4-3-3	[{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":false},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":false}]	published	2026-11-23 16:10:09.533+00	2026-11-23 16:10:09.533+00
5	3	3	4-3-3	[{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":false},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":false},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":false}]	published	2026-11-23 16:10:09.559+00	2026-11-23 16:10:09.559+00
6	3	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":false},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":false}]	published	2026-11-23 16:10:09.561+00	2026-11-23 16:10:09.561+00
7	4	4	4-3-3	[{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":true},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:09.589+00	2026-11-23 16:10:09.589+00
8	4	5	4-3-3	[{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":true},{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":false},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":false}]	published	2026-11-23 16:10:09.591+00	2026-11-23 16:10:09.591+00
9	5	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":true},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":false}]	published	2026-11-23 16:10:09.656+00	2026-11-23 16:10:09.656+00
10	5	1	4-3-3	[{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":false},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":false}]	published	2026-11-23 16:10:09.659+00	2026-11-23 16:10:09.659+00
11	6	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:09.711+00	2026-11-23 16:10:09.711+00
12	6	8	4-3-3	[{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":false},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:09.715+00	2026-11-23 16:10:09.715+00
13	7	5	4-3-3	[{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":false},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":false}]	published	2026-11-23 16:10:09.751+00	2026-11-23 16:10:09.751+00
14	7	2	4-3-3	[{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":true},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":false},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":false}]	published	2026-11-23 16:10:09.754+00	2026-11-23 16:10:09.754+00
15	8	4	4-3-3	[{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":true},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":false},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":false}]	published	2026-11-23 16:10:09.795+00	2026-11-23 16:10:09.795+00
16	8	3	4-3-3	[{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":true},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":true},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":false},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":false},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":false},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:09.797+00	2026-11-23 16:10:09.797+00
17	9	1	4-3-3	[{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":true},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":false}]	published	2026-11-23 16:10:09.858+00	2026-11-23 16:10:09.858+00
18	9	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":false},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":false}]	published	2026-11-23 16:10:09.861+00	2026-11-23 16:10:09.861+00
19	10	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:09.904+00	2026-11-23 16:10:09.904+00
20	10	5	4-3-3	[{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":false},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":false}]	published	2026-11-23 16:10:09.906+00	2026-11-23 16:10:09.906+00
21	11	8	4-3-3	[{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":true},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":false}]	published	2026-11-23 16:10:09.937+00	2026-11-23 16:10:09.937+00
22	11	4	4-3-3	[{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":false},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":false},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:09.942+00	2026-11-23 16:10:09.942+00
23	12	2	4-3-3	[{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":true},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":false}]	published	2026-11-23 16:10:09.974+00	2026-11-23 16:10:09.974+00
24	12	3	4-3-3	[{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":false},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":false}]	published	2026-11-23 16:10:09.976+00	2026-11-23 16:10:09.976+00
25	13	5	4-3-3	[{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":false},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":false}]	published	2026-11-23 16:10:10.006+00	2026-11-23 16:10:10.006+00
26	13	1	4-3-3	[{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":true},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":false},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":false}]	published	2026-11-23 16:10:10.007+00	2026-11-23 16:10:10.007+00
27	14	4	4-3-3	[{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":false},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:10.055+00	2026-11-23 16:10:10.055+00
28	14	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:10.061+00	2026-11-23 16:10:10.061+00
29	15	3	4-3-3	[{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":true},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":false},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":false},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:10.112+00	2026-11-23 16:10:10.112+00
30	15	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":true},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":false},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":false}]	published	2026-11-23 16:10:10.114+00	2026-11-23 16:10:10.114+00
31	16	2	4-3-3	[{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":true},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":false},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:10.167+00	2026-11-23 16:10:10.167+00
32	16	8	4-3-3	[{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":true},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":false}]	published	2026-11-23 16:10:10.171+00	2026-11-23 16:10:10.171+00
33	17	1	4-3-3	[{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":false},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":false},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":false}]	published	2026-11-23 16:10:10.205+00	2026-11-23 16:10:10.205+00
34	17	4	4-3-3	[{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":true},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":false},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:10.208+00	2026-11-23 16:10:10.208+00
35	18	5	4-3-3	[{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":false},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":false}]	published	2026-11-23 16:10:10.217+00	2026-11-23 16:10:10.217+00
36	18	3	4-3-3	[{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":true},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":false},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":false},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:10.221+00	2026-11-23 16:10:10.221+00
37	19	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":false}]	published	2026-11-23 16:10:10.227+00	2026-11-23 16:10:10.227+00
38	19	2	4-3-3	[{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":true},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":false},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":false}]	published	2026-11-23 16:10:10.23+00	2026-11-23 16:10:10.23+00
39	20	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":true},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":false},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":false}]	published	2026-11-23 16:10:10.237+00	2026-11-23 16:10:10.237+00
40	20	8	4-3-3	[{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":false},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":false}]	published	2026-11-23 16:10:10.239+00	2026-11-23 16:10:10.239+00
41	21	3	4-3-3	[{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":true},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":false},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":false},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":false},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":false}]	published	2026-11-23 16:10:10.246+00	2026-11-23 16:10:10.246+00
43	22	2	4-3-3	[{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":true},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":true},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":false},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":false},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":false}]	published	2026-11-23 16:10:10.258+00	2026-11-23 16:10:10.258+00
44	22	4	4-3-3	[{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":true},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":true},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":true},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":false},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:10.263+00	2026-11-23 16:10:10.263+00
42	21	1	4-3-3	[{"playerId":1,"playerName":"Amine Tazi","jerseyNumber":1,"positionLabel":"GK","slotIndex":0,"isStarter":true},{"playerId":5,"playerName":"Amine Rahimi","jerseyNumber":13,"positionLabel":"LB","slotIndex":1,"isStarter":true},{"playerId":8,"playerName":"Soufiane Tazi","jerseyNumber":12,"positionLabel":"CB","slotIndex":2,"isStarter":true},{"playerId":7,"playerName":"Walid Rahimi","jerseyNumber":27,"positionLabel":"CB","slotIndex":3,"isStarter":true},{"playerId":6,"playerName":"Yassine El Idrissi","jerseyNumber":28,"positionLabel":"RB","slotIndex":4,"isStarter":true},{"playerId":11,"playerName":"Tarik Seddiki","jerseyNumber":6,"positionLabel":"CM","slotIndex":5,"isStarter":true},{"playerId":10,"playerName":"Zakaria El Khattabi","jerseyNumber":10,"positionLabel":"CM","slotIndex":6,"isStarter":true},{"playerId":12,"playerName":"Khalid El Amrani","jerseyNumber":5,"positionLabel":"CM","slotIndex":7,"isStarter":true},{"playerId":16,"playerName":"Tarik Harit","jerseyNumber":21,"positionLabel":"LW","slotIndex":8,"isStarter":true},{"playerId":15,"playerName":"Hicham Kettani","jerseyNumber":24,"positionLabel":"ST","slotIndex":9,"isStarter":true},{"playerId":18,"playerName":"Hakim Benoun","jerseyNumber":16,"positionLabel":"RW","slotIndex":10,"isStarter":true},{"playerId":null,"playerName":"Amine Tazi","jerseyNumber":1,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Yassine El Idrissi","jerseyNumber":28,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Walid Rahimi","jerseyNumber":27,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Zakaria El Khattabi","jerseyNumber":10,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Khalid El Amrani","jerseyNumber":5,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Driss El Kaabi","jerseyNumber":25,"positionLabel":"SUB","isStarter":false},{"playerId":null,"playerName":"Tarik Harit","jerseyNumber":21,"positionLabel":"SUB","isStarter":false}]	published	2026-11-23 16:10:10.251+00	2026-11-24 09:29:46.19+00
45	23	8	4-3-3	[{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":true},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":true},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":false},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:10.273+00	2026-11-23 16:10:10.273+00
46	23	5	4-3-3	[{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":true},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":false},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":false}]	published	2026-11-23 16:10:10.279+00	2026-11-23 16:10:10.279+00
47	24	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":true},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":true},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":false},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":false}]	published	2026-11-23 16:10:10.29+00	2026-11-23 16:10:10.29+00
48	24	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":false},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":false}]	published	2026-11-23 16:10:10.297+00	2026-11-23 16:10:10.297+00
49	25	1	4-3-3	[{"playerId":1,"name":"Amine Tazi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":8,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":4,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":3,"name":"Karim Ounahi","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":7,"name":"Walid Rahimi","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":14,"name":"Yassine Mazraoui","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":10,"name":"Zakaria El Khattabi","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":11,"name":"Tarik Seddiki","position":"milieu","jerseyNumber":6,"isStarter":true},{"playerId":18,"name":"Hakim Benoun","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":15,"name":"Hicham Kettani","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":16,"name":"Tarik Harit","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":2,"name":"Salah Ouazzani","position":"gardien","jerseyNumber":15,"isStarter":false},{"playerId":5,"name":"Amine Rahimi","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":6,"name":"Yassine El Idrissi","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":9,"name":"Said Boufal","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":12,"name":"Khalid El Amrani","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":13,"name":"Driss El Kaabi","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":17,"name":"Taha Moutaouakil","position":"attaquant","jerseyNumber":4,"isStarter":false}]	published	2026-11-23 16:10:10.304+00	2026-11-23 16:10:10.304+00
50	25	2	4-3-3	[{"playerId":19,"name":"Anas Jabrane","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":24,"name":"Soufiane Mazraoui","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":21,"name":"Hicham Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":25,"name":"Rachid Aguerd","position":"defenseur","jerseyNumber":25,"isStarter":true},{"playerId":26,"name":"Adil Chraibi","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":27,"name":"Abdelali Jabrane","position":"milieu","jerseyNumber":9,"isStarter":true},{"playerId":28,"name":"Taha Alaoui","position":"milieu","jerseyNumber":29,"isStarter":true},{"playerId":32,"name":"Jawad Alaoui","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":33,"name":"Achraf Ziani","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":34,"name":"Youssef Bennani","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":35,"name":"Amine Alaoui","position":"attaquant","jerseyNumber":21,"isStarter":true},{"playerId":20,"name":"Imad Bouzidi","position":"gardien","jerseyNumber":27,"isStarter":false},{"playerId":22,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":23,"name":"Abdelali Fassi","position":"defenseur","jerseyNumber":3,"isStarter":false},{"playerId":29,"name":"Rachid Ouchen","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":30,"name":"Fouad Hakimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":31,"name":"Mounir Boufal","position":"milieu","jerseyNumber":16,"isStarter":false},{"playerId":36,"name":"Ilyas Saiss","position":"attaquant","jerseyNumber":15,"isStarter":false}]	published	2026-11-23 16:10:10.306+00	2026-11-23 16:10:10.306+00
51	26	3	4-3-3	[{"playerId":38,"name":"Taha Jabrane","position":"gardien","jerseyNumber":12,"isStarter":true},{"playerId":44,"name":"Karim Benoun","position":"defenseur","jerseyNumber":5,"isStarter":true},{"playerId":42,"name":"Karim Chraibi","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":43,"name":"Said Boufal","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":39,"name":"Driss El Khattabi","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":50,"name":"Nabil El Kaabi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":46,"name":"Mehdi Tazi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":45,"name":"Hamza El Idrissi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":53,"name":"Nabil Berrada","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":51,"name":"Ilyas Sqalli","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":52,"name":"Taha Sqalli","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":37,"name":"Ismail El Idrissi","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":40,"name":"Hamza Benali","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":41,"name":"Rachid El Idrissi","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":47,"name":"Salah El Amrani","position":"milieu","jerseyNumber":4,"isStarter":false},{"playerId":48,"name":"Mohamed Ziani","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":49,"name":"Amine Ait Ali","position":"milieu","jerseyNumber":29,"isStarter":false},{"playerId":54,"name":"Driss Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":false}]	published	2026-11-23 16:10:10.31+00	2026-11-23 16:10:10.31+00
52	26	8	4-3-3	[{"playerId":128,"name":"Ilyas Seddiki","position":"gardien","jerseyNumber":25,"isStarter":true},{"playerId":129,"name":"Anas Rahimi","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":131,"name":"Khalid Saiss","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":130,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":20,"isStarter":true},{"playerId":133,"name":"Adil Boufal","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":136,"name":"Fouad Bouzidi","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":140,"name":"Rachid Rahimi","position":"milieu","jerseyNumber":3,"isStarter":true},{"playerId":135,"name":"Tarik Moutaouakil","position":"milieu","jerseyNumber":31,"isStarter":true},{"playerId":141,"name":"Jawad Ait Ali","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":142,"name":"Ismail Ezzalzouli","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":144,"name":"Mehdi Ezzalzouli","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":127,"name":"Said Alaoui","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":132,"name":"Karim Jabrane","position":"defenseur","jerseyNumber":21,"isStarter":false},{"playerId":134,"name":"Mehdi Harit","position":"defenseur","jerseyNumber":24,"isStarter":false},{"playerId":137,"name":"Zakaria Boufal","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":138,"name":"Mehdi Ezzalzouli","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":139,"name":"Fouad Amrabat","position":"milieu","jerseyNumber":2,"isStarter":false},{"playerId":143,"name":"Jawad Aguerd","position":"attaquant","jerseyNumber":6,"isStarter":false}]	published	2026-11-23 16:10:10.312+00	2026-11-23 16:10:10.312+00
53	27	4	4-3-3	[{"playerId":55,"name":"Jawad Ouchen","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":61,"name":"Mohamed Lahlou","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":58,"name":"Fouad Chraibi","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":59,"name":"Khalid Benoun","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":62,"name":"Nassim Alaoui","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":68,"name":"Badr Ait Ali","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":65,"name":"Bilal Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":66,"name":"Salah Benali","position":"milieu","jerseyNumber":14,"isStarter":true},{"playerId":71,"name":"Mounir Moutaouakil","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":70,"name":"Amine Ziani","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":69,"name":"Achraf El Kaabi","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":56,"name":"Badr Belhaj","position":"gardien","jerseyNumber":6,"isStarter":false},{"playerId":57,"name":"Salah Jabrane","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":60,"name":"Karim Moutaouakil","position":"defenseur","jerseyNumber":24,"isStarter":false},{"playerId":63,"name":"Hicham Fassi","position":"milieu","jerseyNumber":10,"isStarter":false},{"playerId":64,"name":"Mehdi Ziani","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":67,"name":"Jawad Mazraoui","position":"milieu","jerseyNumber":11,"isStarter":false},{"playerId":72,"name":"Said Ouchen","position":"attaquant","jerseyNumber":17,"isStarter":false}]	published	2026-11-23 16:10:10.32+00	2026-11-23 16:10:10.32+00
54	27	7	4-3-3	[{"playerId":110,"name":"Karim Rahimi","position":"gardien","jerseyNumber":3,"isStarter":true},{"playerId":113,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":18,"isStarter":true},{"playerId":114,"name":"Ayman Mazraoui","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":112,"name":"Nabil Moutaouakil","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":111,"name":"Walid Zerouali","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":121,"name":"Ilyas Amallah","position":"milieu","jerseyNumber":4,"isStarter":true},{"playerId":118,"name":"Noureddine Fassi","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":120,"name":"Taha Benali","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":123,"name":"Nassim Lahlou","position":"attaquant","jerseyNumber":2,"isStarter":true},{"playerId":124,"name":"Karim Moutaouakil","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":125,"name":"Nabil Ounahi","position":"attaquant","jerseyNumber":12,"isStarter":true},{"playerId":109,"name":"Bilal Ait Ali","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":115,"name":"Mohamed Ouazzani","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":116,"name":"Tarik Berrada","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":117,"name":"Omar Sqalli","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":119,"name":"Jawad Haddad","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":122,"name":"Walid Belhaj","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":126,"name":"Ayoub Haddad","position":"attaquant","jerseyNumber":11,"isStarter":false}]	published	2026-11-23 16:10:10.323+00	2026-11-23 16:10:10.323+00
55	28	5	4-3-3	[{"playerId":74,"name":"Nassim Mazraoui","position":"gardien","jerseyNumber":27,"isStarter":true},{"playerId":76,"name":"Achraf Harit","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":77,"name":"Hamza Boufal","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":79,"name":"Othmane El Kaabi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":80,"name":"Bilal Ouchen","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":86,"name":"Soufiane Ait Ali","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":82,"name":"Fouad Boufal","position":"milieu","jerseyNumber":11,"isStarter":true},{"playerId":85,"name":"Abdelali Harit","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":89,"name":"Nabil Zerouali","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":87,"name":"Salah Ounahi","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":88,"name":"Jawad Amallah","position":"attaquant","jerseyNumber":3,"isStarter":true},{"playerId":73,"name":"Taha Saiss","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":75,"name":"Said Rami","position":"defenseur","jerseyNumber":29,"isStarter":false},{"playerId":78,"name":"Said Ounahi","position":"defenseur","jerseyNumber":25,"isStarter":false},{"playerId":81,"name":"Tarik Jabrane","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":83,"name":"Salah Amallah","position":"milieu","jerseyNumber":26,"isStarter":false},{"playerId":84,"name":"Mehdi Kettani","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":90,"name":"Walid Tazi","position":"attaquant","jerseyNumber":8,"isStarter":false}]	published	2026-11-23 16:10:10.328+00	2026-11-23 16:10:10.328+00
56	28	6	4-3-3	[{"playerId":92,"name":"Ilyas Alaoui","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":94,"name":"Khalid Kettani","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":95,"name":"Omar Ziani","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":98,"name":"Zakaria Bouzidi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":93,"name":"Abdelali El Idrissi","position":"defenseur","jerseyNumber":29,"isStarter":true},{"playerId":104,"name":"Fouad Ounahi","position":"milieu","jerseyNumber":28,"isStarter":true},{"playerId":102,"name":"Adil Rahimi","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":101,"name":"Adil Berrada","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":108,"name":"Ayman Benali","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":106,"name":"Walid Benoun","position":"attaquant","jerseyNumber":24,"isStarter":true},{"playerId":107,"name":"Hamza Naciri","position":"attaquant","jerseyNumber":11,"isStarter":true},{"playerId":91,"name":"Othmane Boufal","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":96,"name":"Soufiane Tazi","position":"defenseur","jerseyNumber":6,"isStarter":false},{"playerId":97,"name":"Mohamed Bouzidi","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":99,"name":"Driss Aguerd","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":100,"name":"Abdelali Harit","position":"milieu","jerseyNumber":21,"isStarter":false},{"playerId":103,"name":"Taha El Kaabi","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":105,"name":"Ismail Tazi","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:10.329+00	2026-11-23 16:10:10.329+00
57	32	9	4-3-3	[{"playerId":145,"name":"Yassine Amallah","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":151,"name":"Badr Amrabat","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":148,"name":"Tarik Seddiki","position":"defenseur","jerseyNumber":17,"isStarter":true},{"playerId":152,"name":"Karim Ouchen","position":"defenseur","jerseyNumber":4,"isStarter":true},{"playerId":150,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":155,"name":"Anas Zerouali","position":"milieu","jerseyNumber":15,"isStarter":true},{"playerId":153,"name":"Amine Chraibi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":156,"name":"Anas Seddiki","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":160,"name":"Zakaria Fassi","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":159,"name":"Imad Alaoui","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":162,"name":"Nabil Amallah","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":146,"name":"Bilal El Kaabi","position":"gardien","jerseyNumber":13,"isStarter":false},{"playerId":147,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":28,"isStarter":false},{"playerId":149,"name":"Hicham Mansouri","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":154,"name":"Rachid Bouzidi","position":"milieu","jerseyNumber":18,"isStarter":false},{"playerId":157,"name":"Adil Zerouali","position":"milieu","jerseyNumber":24,"isStarter":false},{"playerId":158,"name":"Youssef El Khattabi","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":161,"name":"Taha Saiss","position":"attaquant","jerseyNumber":9,"isStarter":false}]	published	2026-11-23 16:10:10.344+00	2026-11-23 16:10:10.344+00
58	32	12	4-3-3	[{"playerId":199,"name":"Salah Boufal","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":201,"name":"Anas Ouchen","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":205,"name":"Ismail Alaoui","position":"defenseur","jerseyNumber":18,"isStarter":true},{"playerId":203,"name":"Karim Ouchen","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":204,"name":"Ayoub Haddad","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":210,"name":"Youssef Ouazzani","position":"milieu","jerseyNumber":25,"isStarter":true},{"playerId":209,"name":"Mohamed El Amrani","position":"milieu","jerseyNumber":10,"isStarter":true},{"playerId":207,"name":"Yassine Tazi","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":213,"name":"Said Ezzalzouli","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":215,"name":"Taha Amrabat","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":214,"name":"Driss Alaoui","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":200,"name":"Hamza Jabrane","position":"gardien","jerseyNumber":14,"isStarter":false},{"playerId":202,"name":"Youssef Benoun","position":"defenseur","jerseyNumber":12,"isStarter":false},{"playerId":206,"name":"Badr Alaoui","position":"defenseur","jerseyNumber":9,"isStarter":false},{"playerId":208,"name":"Taha Benali","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":211,"name":"Mehdi Rahimi","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":212,"name":"Bilal Fassi","position":"milieu","jerseyNumber":13,"isStarter":false},{"playerId":216,"name":"Othmane Ziani","position":"attaquant","jerseyNumber":27,"isStarter":false}]	published	2026-11-23 16:10:10.346+00	2026-11-23 16:10:10.346+00
59	33	14	4-3-3	[{"playerId":235,"name":"Hakim El Kaabi","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":238,"name":"Amine Boufal","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":241,"name":"Zakaria El Khattabi","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":237,"name":"Othmane Chraibi","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":240,"name":"Reda El Kaabi","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":243,"name":"Omar Ait Ali","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":246,"name":"Hicham Naciri","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":245,"name":"Hakim Naciri","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":249,"name":"Abdelali Belhaj","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":251,"name":"Driss Tazi","position":"attaquant","jerseyNumber":22,"isStarter":true},{"playerId":250,"name":"Amine Rahimi","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":236,"name":"Marouane El Amrani","position":"gardien","jerseyNumber":3,"isStarter":false},{"playerId":239,"name":"Mehdi Moutaouakil","position":"defenseur","jerseyNumber":11,"isStarter":false},{"playerId":242,"name":"Mounir Sqalli","position":"defenseur","jerseyNumber":6,"isStarter":false},{"playerId":244,"name":"Yassine Haddad","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":247,"name":"Fouad Harit","position":"milieu","jerseyNumber":24,"isStarter":false},{"playerId":248,"name":"Salah Jabrane","position":"milieu","jerseyNumber":9,"isStarter":false},{"playerId":252,"name":"Anas Moutaouakil","position":"attaquant","jerseyNumber":15,"isStarter":false}]	published	2026-11-23 16:10:10.371+00	2026-11-23 16:10:10.371+00
60	33	10	4-3-3	[{"playerId":163,"name":"Walid Seddiki","position":"gardien","jerseyNumber":1,"isStarter":true},{"playerId":169,"name":"Nabil El Kaabi","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":166,"name":"Adil Amrabat","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":168,"name":"Noureddine Naciri","position":"defenseur","jerseyNumber":5,"isStarter":true},{"playerId":165,"name":"Mounir Alaoui","position":"defenseur","jerseyNumber":13,"isStarter":true},{"playerId":171,"name":"Othmane Moutaouakil","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":173,"name":"Tarik Hakimi","position":"milieu","jerseyNumber":30,"isStarter":true},{"playerId":174,"name":"Driss Rahimi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":179,"name":"Zakaria Berrada","position":"attaquant","jerseyNumber":25,"isStarter":true},{"playerId":180,"name":"Adil Ait Ali","position":"attaquant","jerseyNumber":26,"isStarter":true},{"playerId":178,"name":"Hakim Lahlou","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":164,"name":"Omar Hakimi","position":"gardien","jerseyNumber":11,"isStarter":false},{"playerId":167,"name":"Ayoub El Amrani","position":"defenseur","jerseyNumber":9,"isStarter":false},{"playerId":170,"name":"Ilyas Ouchen","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":172,"name":"Khalid Bennani","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":175,"name":"Nassim Fassi","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":176,"name":"Badr Tazi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":177,"name":"Noureddine Harit","position":"attaquant","jerseyNumber":18,"isStarter":false}]	published	2026-11-23 16:10:10.374+00	2026-11-23 16:10:10.374+00
61	34	13	4-3-3	[{"playerId":218,"name":"Hakim Kettani","position":"gardien","jerseyNumber":6,"isStarter":true},{"playerId":224,"name":"Walid Jabrane","position":"defenseur","jerseyNumber":7,"isStarter":true},{"playerId":220,"name":"Mounir Harit","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":221,"name":"Salah Aguerd","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":223,"name":"Hamza Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":226,"name":"Rachid El Kaabi","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":225,"name":"Zakaria Chraibi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":230,"name":"Abdelali Belhaj","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":233,"name":"Rachid Ouchen","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":232,"name":"Rachid Tazi","position":"attaquant","jerseyNumber":5,"isStarter":true},{"playerId":231,"name":"Khalid Rami","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":217,"name":"Marouane Haddad","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":219,"name":"Imad Tazi","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":222,"name":"Abdelali Chraibi","position":"defenseur","jerseyNumber":21,"isStarter":false},{"playerId":227,"name":"Karim Alaoui","position":"milieu","jerseyNumber":12,"isStarter":false},{"playerId":228,"name":"Youssef Moutaouakil","position":"milieu","jerseyNumber":24,"isStarter":false},{"playerId":229,"name":"Noureddine Benali","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":234,"name":"Hamza Mazraoui","position":"attaquant","jerseyNumber":26,"isStarter":false}]	published	2026-11-23 16:10:10.427+00	2026-11-23 16:10:10.427+00
62	34	15	4-3-3	[{"playerId":254,"name":"Hakim Benoun","position":"gardien","jerseyNumber":17,"isStarter":true},{"playerId":255,"name":"Adil Naciri","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":260,"name":"Mehdi El Idrissi","position":"defenseur","jerseyNumber":23,"isStarter":true},{"playerId":258,"name":"Ismail Ouazzani","position":"defenseur","jerseyNumber":4,"isStarter":true},{"playerId":257,"name":"Khalid Seddiki","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":266,"name":"Hicham Hakimi","position":"milieu","jerseyNumber":21,"isStarter":true},{"playerId":263,"name":"Othmane Moutaouakil","position":"milieu","jerseyNumber":2,"isStarter":true},{"playerId":261,"name":"Zakaria Tazi","position":"milieu","jerseyNumber":24,"isStarter":true},{"playerId":270,"name":"Youssef Kettani","position":"attaquant","jerseyNumber":7,"isStarter":true},{"playerId":269,"name":"Reda Lahlou","position":"attaquant","jerseyNumber":27,"isStarter":true},{"playerId":268,"name":"Hicham Benoun","position":"attaquant","jerseyNumber":10,"isStarter":true},{"playerId":253,"name":"Hakim Seddiki","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":256,"name":"Ayoub Alaoui","position":"defenseur","jerseyNumber":26,"isStarter":false},{"playerId":259,"name":"Mounir Rahimi","position":"defenseur","jerseyNumber":15,"isStarter":false},{"playerId":262,"name":"Nabil Seddiki","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":264,"name":"Ayman Zerouali","position":"milieu","jerseyNumber":6,"isStarter":false},{"playerId":265,"name":"Reda Kettani","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":267,"name":"Hamza El Kaabi","position":"attaquant","jerseyNumber":9,"isStarter":false}]	published	2026-11-23 16:10:10.429+00	2026-11-23 16:10:10.429+00
63	35	16	4-3-3	[{"playerId":272,"name":"Ilyas Zerouali","position":"gardien","jerseyNumber":26,"isStarter":true},{"playerId":274,"name":"Karim Rahimi","position":"defenseur","jerseyNumber":15,"isStarter":true},{"playerId":277,"name":"Salah Seddiki","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":278,"name":"Hakim Rahimi","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":275,"name":"Noureddine Saiss","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":281,"name":"Omar Amallah","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":284,"name":"Tarik Naciri","position":"milieu","jerseyNumber":5,"isStarter":true},{"playerId":283,"name":"Fouad Ait Ali","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":287,"name":"Hakim Sqalli","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":285,"name":"Taha Bouzidi","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":286,"name":"Nabil Jabrane","position":"attaquant","jerseyNumber":31,"isStarter":true},{"playerId":271,"name":"Omar Moutaouakil","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":273,"name":"Tarik Amrabat","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":276,"name":"Tarik Ouazzani","position":"defenseur","jerseyNumber":21,"isStarter":false},{"playerId":279,"name":"Jawad Ziani","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":280,"name":"Imad Haddad","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":282,"name":"Said Boufal","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":288,"name":"Nabil Fassi","position":"attaquant","jerseyNumber":29,"isStarter":false}]	published	2026-11-23 16:10:10.474+00	2026-11-23 16:10:10.474+00
64	35	11	4-3-3	[{"playerId":182,"name":"Mounir El Amrani","position":"gardien","jerseyNumber":26,"isStarter":true},{"playerId":185,"name":"Tarik Mazraoui","position":"defenseur","jerseyNumber":6,"isStarter":true},{"playerId":183,"name":"Zakaria Zerouali","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":187,"name":"Ismail El Kaabi","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":186,"name":"Rachid Bouzidi","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":192,"name":"Achraf Fassi","position":"milieu","jerseyNumber":17,"isStarter":true},{"playerId":194,"name":"Mounir Ouchen","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":190,"name":"Badr Zerouali","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":198,"name":"Achraf Hakimi","position":"attaquant","jerseyNumber":12,"isStarter":true},{"playerId":197,"name":"Reda Boufal","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":195,"name":"Soufiane Bouzidi","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":181,"name":"Nabil Lahlou","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":184,"name":"Ayoub Tazi","position":"defenseur","jerseyNumber":27,"isStarter":false},{"playerId":188,"name":"Reda Aguerd","position":"defenseur","jerseyNumber":20,"isStarter":false},{"playerId":189,"name":"Abdelali Rahimi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":191,"name":"Nassim Amallah","position":"milieu","jerseyNumber":3,"isStarter":false},{"playerId":193,"name":"Reda El Amrani","position":"milieu","jerseyNumber":18,"isStarter":false},{"playerId":196,"name":"Ismail Kettani","position":"attaquant","jerseyNumber":2,"isStarter":false}]	published	2026-11-23 16:10:10.48+00	2026-11-23 16:10:10.48+00
65	30	9	4-3-3	[{"playerId":146,"name":"Bilal El Kaabi","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":148,"name":"Tarik Seddiki","position":"defenseur","jerseyNumber":17,"isStarter":true},{"playerId":147,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":152,"name":"Karim Ouchen","position":"defenseur","jerseyNumber":4,"isStarter":true},{"playerId":149,"name":"Hicham Mansouri","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":157,"name":"Adil Zerouali","position":"milieu","jerseyNumber":24,"isStarter":true},{"playerId":155,"name":"Anas Zerouali","position":"milieu","jerseyNumber":15,"isStarter":true},{"playerId":156,"name":"Anas Seddiki","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":162,"name":"Nabil Amallah","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":161,"name":"Taha Saiss","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":160,"name":"Zakaria Fassi","position":"attaquant","jerseyNumber":16,"isStarter":true},{"playerId":145,"name":"Yassine Amallah","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":150,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":27,"isStarter":false},{"playerId":151,"name":"Badr Amrabat","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":153,"name":"Amine Chraibi","position":"milieu","jerseyNumber":7,"isStarter":false},{"playerId":154,"name":"Rachid Bouzidi","position":"milieu","jerseyNumber":18,"isStarter":false},{"playerId":158,"name":"Youssef El Khattabi","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":159,"name":"Imad Alaoui","position":"attaquant","jerseyNumber":6,"isStarter":false}]	published	2026-11-23 16:10:10.53+00	2026-11-23 16:10:10.53+00
66	30	10	4-3-3	[{"playerId":164,"name":"Omar Hakimi","position":"gardien","jerseyNumber":11,"isStarter":true},{"playerId":166,"name":"Adil Amrabat","position":"defenseur","jerseyNumber":12,"isStarter":true},{"playerId":167,"name":"Ayoub El Amrani","position":"defenseur","jerseyNumber":9,"isStarter":true},{"playerId":170,"name":"Ilyas Ouchen","position":"defenseur","jerseyNumber":10,"isStarter":true},{"playerId":168,"name":"Noureddine Naciri","position":"defenseur","jerseyNumber":5,"isStarter":true},{"playerId":172,"name":"Khalid Bennani","position":"milieu","jerseyNumber":19,"isStarter":true},{"playerId":174,"name":"Driss Rahimi","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":171,"name":"Othmane Moutaouakil","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":180,"name":"Adil Ait Ali","position":"attaquant","jerseyNumber":26,"isStarter":true},{"playerId":178,"name":"Hakim Lahlou","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":177,"name":"Noureddine Harit","position":"attaquant","jerseyNumber":18,"isStarter":true},{"playerId":163,"name":"Walid Seddiki","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":165,"name":"Mounir Alaoui","position":"defenseur","jerseyNumber":13,"isStarter":false},{"playerId":169,"name":"Nabil El Kaabi","position":"defenseur","jerseyNumber":16,"isStarter":false},{"playerId":173,"name":"Tarik Hakimi","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":175,"name":"Nassim Fassi","position":"milieu","jerseyNumber":17,"isStarter":false},{"playerId":176,"name":"Badr Tazi","position":"milieu","jerseyNumber":28,"isStarter":false},{"playerId":179,"name":"Zakaria Berrada","position":"attaquant","jerseyNumber":25,"isStarter":false}]	published	2026-11-23 16:10:10.545+00	2026-11-23 16:10:10.545+00
67	31	13	4-3-3	[{"playerId":218,"name":"Hakim Kettani","position":"gardien","jerseyNumber":6,"isStarter":true},{"playerId":223,"name":"Hamza Berrada","position":"defenseur","jerseyNumber":31,"isStarter":true},{"playerId":221,"name":"Salah Aguerd","position":"defenseur","jerseyNumber":14,"isStarter":true},{"playerId":220,"name":"Mounir Harit","position":"defenseur","jerseyNumber":22,"isStarter":true},{"playerId":222,"name":"Abdelali Chraibi","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":230,"name":"Abdelali Belhaj","position":"milieu","jerseyNumber":13,"isStarter":true},{"playerId":227,"name":"Karim Alaoui","position":"milieu","jerseyNumber":12,"isStarter":true},{"playerId":228,"name":"Youssef Moutaouakil","position":"milieu","jerseyNumber":24,"isStarter":true},{"playerId":233,"name":"Rachid Ouchen","position":"attaquant","jerseyNumber":15,"isStarter":true},{"playerId":234,"name":"Hamza Mazraoui","position":"attaquant","jerseyNumber":26,"isStarter":true},{"playerId":231,"name":"Khalid Rami","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":217,"name":"Marouane Haddad","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":219,"name":"Imad Tazi","position":"defenseur","jerseyNumber":10,"isStarter":false},{"playerId":224,"name":"Walid Jabrane","position":"defenseur","jerseyNumber":7,"isStarter":false},{"playerId":225,"name":"Zakaria Chraibi","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":226,"name":"Rachid El Kaabi","position":"milieu","jerseyNumber":19,"isStarter":false},{"playerId":229,"name":"Noureddine Benali","position":"milieu","jerseyNumber":25,"isStarter":false},{"playerId":232,"name":"Rachid Tazi","position":"attaquant","jerseyNumber":5,"isStarter":false}]	published	2026-11-23 16:10:10.625+00	2026-11-23 16:10:10.625+00
68	31	16	4-3-3	[{"playerId":272,"name":"Ilyas Zerouali","position":"gardien","jerseyNumber":26,"isStarter":true},{"playerId":276,"name":"Tarik Ouazzani","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":273,"name":"Tarik Amrabat","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":274,"name":"Karim Rahimi","position":"defenseur","jerseyNumber":15,"isStarter":true},{"playerId":278,"name":"Hakim Rahimi","position":"defenseur","jerseyNumber":30,"isStarter":true},{"playerId":282,"name":"Said Boufal","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":281,"name":"Omar Amallah","position":"milieu","jerseyNumber":22,"isStarter":true},{"playerId":280,"name":"Imad Haddad","position":"milieu","jerseyNumber":27,"isStarter":true},{"playerId":285,"name":"Taha Bouzidi","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":287,"name":"Hakim Sqalli","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":288,"name":"Nabil Fassi","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":271,"name":"Omar Moutaouakil","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":275,"name":"Noureddine Saiss","position":"defenseur","jerseyNumber":24,"isStarter":false},{"playerId":277,"name":"Salah Seddiki","position":"defenseur","jerseyNumber":19,"isStarter":false},{"playerId":279,"name":"Jawad Ziani","position":"milieu","jerseyNumber":23,"isStarter":false},{"playerId":283,"name":"Fouad Ait Ali","position":"milieu","jerseyNumber":8,"isStarter":false},{"playerId":284,"name":"Tarik Naciri","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":286,"name":"Nabil Jabrane","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:10.627+00	2026-11-23 16:10:10.627+00
69	29	9	4-3-3	[{"playerId":146,"name":"Bilal El Kaabi","position":"gardien","jerseyNumber":13,"isStarter":true},{"playerId":147,"name":"Khalid Aguerd","position":"defenseur","jerseyNumber":28,"isStarter":true},{"playerId":149,"name":"Hicham Mansouri","position":"defenseur","jerseyNumber":26,"isStarter":true},{"playerId":152,"name":"Karim Ouchen","position":"defenseur","jerseyNumber":4,"isStarter":true},{"playerId":150,"name":"Tarik Ezzalzouli","position":"defenseur","jerseyNumber":27,"isStarter":true},{"playerId":153,"name":"Amine Chraibi","position":"milieu","jerseyNumber":7,"isStarter":true},{"playerId":157,"name":"Adil Zerouali","position":"milieu","jerseyNumber":24,"isStarter":true},{"playerId":154,"name":"Rachid Bouzidi","position":"milieu","jerseyNumber":18,"isStarter":true},{"playerId":159,"name":"Imad Alaoui","position":"attaquant","jerseyNumber":6,"isStarter":true},{"playerId":161,"name":"Taha Saiss","position":"attaquant","jerseyNumber":9,"isStarter":true},{"playerId":162,"name":"Nabil Amallah","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":145,"name":"Yassine Amallah","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":148,"name":"Tarik Seddiki","position":"defenseur","jerseyNumber":17,"isStarter":false},{"playerId":151,"name":"Badr Amrabat","position":"defenseur","jerseyNumber":23,"isStarter":false},{"playerId":155,"name":"Anas Zerouali","position":"milieu","jerseyNumber":15,"isStarter":false},{"playerId":156,"name":"Anas Seddiki","position":"milieu","jerseyNumber":20,"isStarter":false},{"playerId":158,"name":"Youssef El Khattabi","position":"milieu","jerseyNumber":30,"isStarter":false},{"playerId":160,"name":"Zakaria Fassi","position":"attaquant","jerseyNumber":16,"isStarter":false}]	published	2026-11-23 16:10:10.7+00	2026-11-23 16:10:10.7+00
70	29	16	4-3-3	[{"playerId":272,"name":"Ilyas Zerouali","position":"gardien","jerseyNumber":26,"isStarter":true},{"playerId":276,"name":"Tarik Ouazzani","position":"defenseur","jerseyNumber":21,"isStarter":true},{"playerId":273,"name":"Tarik Amrabat","position":"defenseur","jerseyNumber":16,"isStarter":true},{"playerId":275,"name":"Noureddine Saiss","position":"defenseur","jerseyNumber":24,"isStarter":true},{"playerId":277,"name":"Salah Seddiki","position":"defenseur","jerseyNumber":19,"isStarter":true},{"playerId":282,"name":"Said Boufal","position":"milieu","jerseyNumber":20,"isStarter":true},{"playerId":279,"name":"Jawad Ziani","position":"milieu","jerseyNumber":23,"isStarter":true},{"playerId":283,"name":"Fouad Ait Ali","position":"milieu","jerseyNumber":8,"isStarter":true},{"playerId":285,"name":"Taha Bouzidi","position":"attaquant","jerseyNumber":28,"isStarter":true},{"playerId":287,"name":"Hakim Sqalli","position":"attaquant","jerseyNumber":4,"isStarter":true},{"playerId":288,"name":"Nabil Fassi","position":"attaquant","jerseyNumber":29,"isStarter":true},{"playerId":271,"name":"Omar Moutaouakil","position":"gardien","jerseyNumber":1,"isStarter":false},{"playerId":274,"name":"Karim Rahimi","position":"defenseur","jerseyNumber":15,"isStarter":false},{"playerId":278,"name":"Hakim Rahimi","position":"defenseur","jerseyNumber":30,"isStarter":false},{"playerId":280,"name":"Imad Haddad","position":"milieu","jerseyNumber":27,"isStarter":false},{"playerId":281,"name":"Omar Amallah","position":"milieu","jerseyNumber":22,"isStarter":false},{"playerId":284,"name":"Tarik Naciri","position":"milieu","jerseyNumber":5,"isStarter":false},{"playerId":286,"name":"Nabil Jabrane","position":"attaquant","jerseyNumber":31,"isStarter":false}]	published	2026-11-23 16:10:10.705+00	2026-11-23 16:10:10.705+00
\.


--
-- Data for Name: Matches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Matches" (id, "tournamentId", "roundNumber", "matchIndex", "homeTeamId", "awayTeamId", date, location, status, "homeTeamScore", "awayTeamScore", "winnerTeamId", "advancesToMatchId", "halfTimeHomeScore", "halfTimeAwayScore", referee, "assistantReferee1", "assistantReferee2", "fourthOfficial", weather, attendance, notes, "reminderSent", "notifSoonSent", "minutesComputed", "createdAt", "updatedAt") FROM stdin;
1	1	1	0	1	8	2026-10-14 16:10:09.478+00	Stade Mohammed V	completed	1	0	1	\N	1	0	Ayoub Bennani	Ismail Jabrane	Ilyas Seddiki	\N	Ensoleillé	2909	\N	t	t	f	2026-11-23 16:10:09.478+00	2026-11-23 16:10:09.521+00
19	1	5	2	6	2	2026-11-23 15:20:10.225+00	Stade El Bachir	in_progress	2	2	\N	\N	0	0	Redouane Jiyed	Zakaria Aguerd	Hicham Ouazzani	\N	Nuageux	\N	\N	t	t	f	2026-11-23 16:10:10.225+00	2026-11-23 16:33:26.214+00
20	1	5	3	7	8	2026-11-23 15:20:10.234+00	Complexe Oasis	in_progress	2	2	\N	\N	0	0	Samir Guezzaz	Zakaria Amrabat	Imad Naciri	\N	Ensoleillé	\N	\N	t	t	f	2026-11-23 16:10:10.234+00	2026-11-23 16:33:26.232+00
23	1	6	2	8	5	2026-12-03 16:10:10.267+00	Stade Ain Chock	scheduled	0	0	\N	\N	0	0	Mustapha Kechchaf	Taha Amrabat	Khalid Moutaouakil	\N	Venteux	\N	\N	f	f	f	2026-11-23 16:10:10.267+00	2026-11-23 16:33:26.284+00
6	1	2	1	6	8	2026-10-24 16:10:09.708+00	Stade El Bachir	completed	1	1	\N	\N	0	1	Ayman Rami	Karim Seddiki	Omar Lahlou	\N	Nuageux	844	\N	t	t	f	2026-11-23 16:10:09.708+00	2026-11-23 16:10:09.746+00
13	1	4	0	5	1	2026-11-13 16:10:10.004+00	Terrain Sidi Moumen	completed	0	3	1	\N	0	3	Nabil Naciri	Hicham Tazi	Reda Mansouri	\N	Pluie légère	642	\N	t	t	f	2026-11-23 16:10:10.004+00	2026-11-23 16:10:10.044+00
21	1	6	0	3	1	2026-12-03 16:10:10.242+00	Complexe Al Amal	scheduled	0	0	\N	\N	0	0	Amine Fassi	Amine Ait Ali	Tarik Ouchen	\N	Venteux	\N	\N	f	f	f	2026-11-23 16:10:10.242+00	2026-11-23 16:10:10.242+00
22	1	6	1	2	4	2026-12-03 16:10:10.255+00	Stade Père Jégo	scheduled	0	0	\N	\N	0	0	Bilal Sqalli	Zakaria Belhaj	Jawad El Idrissi	\N	Venteux	\N	\N	f	f	f	2026-11-23 16:10:10.255+00	2026-11-23 16:10:10.255+00
24	1	6	3	7	6	2026-12-03 16:10:10.284+00	Complexe Oasis	scheduled	0	0	\N	\N	0	0	Ismail Aguerd	Mohamed Ouchen	Marouane Hakimi	\N	Pluie légère	\N	\N	f	f	f	2026-11-23 16:10:10.285+00	2026-11-23 16:10:10.285+00
2	1	1	1	2	7	2026-10-14 16:10:09.524+00	Stade Père Jégo	completed	0	1	7	\N	0	1	Redouane Jiyed	Fouad Benali	Zakaria Ounahi	\N	Venteux	3321	\N	t	t	f	2026-11-23 16:10:09.525+00	2026-11-23 16:33:25.46+00
3	1	1	2	3	6	2026-10-14 16:10:09.556+00	Complexe Al Amal	completed	1	2	6	\N	1	0	Samir Guezzaz	Jawad Benali	Driss Berrada	\N	Venteux	3287	\N	t	t	f	2026-11-23 16:10:09.556+00	2026-11-23 16:33:25.489+00
4	1	1	3	4	5	2026-10-14 16:10:09.587+00	Stade Larbi Zaouli	completed	3	1	4	\N	2	0	Noureddine El Jaafari	Hicham Chraibi	Badr Rahimi	\N	Nuageux	2076	\N	t	t	f	2026-11-23 16:10:09.587+00	2026-11-23 16:33:25.514+00
5	1	2	0	7	1	2026-10-24 16:10:09.653+00	Complexe Oasis	completed	2	3	1	\N	1	3	Samir Guezzaz	Noureddine Berrada	Othmane Mazraoui	\N	Nuageux	1214	\N	t	t	f	2026-11-23 16:10:09.653+00	2026-11-23 16:33:25.665+00
7	1	2	2	5	2	2026-10-24 16:10:09.748+00	Terrain Sidi Moumen	completed	3	3	\N	\N	2	2	Bouchra Karboubi	Badr Fassi	Imad Bennani	\N	Venteux	2069	\N	t	t	f	2026-11-23 16:10:09.749+00	2026-11-23 16:33:25.724+00
8	1	2	3	4	3	2026-10-24 16:10:09.793+00	Stade Larbi Zaouli	completed	2	2	\N	\N	0	0	Mustapha Kechchaf	Walid Ouazzani	Ayman Zerouali	\N	Pluie légère	1200	\N	t	t	f	2026-11-23 16:10:09.793+00	2026-11-23 16:33:25.752+00
9	1	3	0	1	6	2026-11-03 16:10:09.85+00	Stade Mohammed V	completed	3	0	1	\N	1	0	Karim Arbitre	Reda Tazi	Omar Aguerd	\N	Nuageux	529	\N	t	t	f	2026-11-23 16:10:09.851+00	2026-11-23 16:33:25.774+00
10	1	3	1	7	5	2026-11-03 16:10:09.902+00	Complexe Oasis	completed	2	1	7	\N	2	0	Redouane Jiyed	Rachid Ait Ali	Hakim Jabrane	\N	Nuageux	685	\N	t	t	f	2026-11-23 16:10:09.902+00	2026-11-23 16:33:25.805+00
11	1	3	2	8	4	2026-11-03 16:10:09.934+00	Stade Ain Chock	completed	0	0	\N	\N	0	0	Samir Guezzaz	Achraf Ziani	Jawad El Khattabi	\N	Ensoleillé	3274	\N	t	t	f	2026-11-23 16:10:09.934+00	2026-11-23 16:33:25.839+00
12	1	3	3	2	3	2026-11-03 16:10:09.97+00	Stade Père Jégo	completed	3	0	2	\N	2	0	Noureddine El Jaafari	Said Ezzalzouli	Youssef Mansouri	\N	Nuageux	1203	\N	t	t	f	2026-11-23 16:10:09.971+00	2026-11-23 16:33:25.866+00
14	1	4	1	4	6	2026-11-13 16:10:10.047+00	Stade Larbi Zaouli	completed	0	1	6	\N	0	1	Redouane Jiyed	Tarik El Khattabi	Soufiane Berrada	\N	Nuageux	3288	\N	t	t	f	2026-11-23 16:10:10.047+00	2026-11-23 16:33:25.992+00
15	1	4	2	3	7	2026-11-13 16:10:10.109+00	Complexe Al Amal	completed	2	3	7	\N	0	1	Samir Guezzaz	Hamza Seddiki	Said Alaoui	\N	Nuageux	2009	\N	t	t	f	2026-11-23 16:10:10.109+00	2026-11-23 16:33:26.029+00
16	1	4	3	2	8	2026-11-13 16:10:10.163+00	Stade Père Jégo	completed	4	1	2	\N	4	0	Noureddine El Jaafari	Marouane Chraibi	Badr Berrada	\N	Ensoleillé	1718	\N	t	t	f	2026-11-23 16:10:10.163+00	2026-11-23 16:33:26.061+00
17	1	5	0	1	4	2026-11-23 15:20:10.202+00	Stade Mohammed V	in_progress	2	1	\N	\N	0	0	Mustapha Kechchaf	Ayman Moutaouakil	Badr Berrada	\N	Ensoleillé	\N	\N	t	t	f	2026-11-23 16:10:10.203+00	2026-11-23 16:33:26.121+00
18	1	5	1	5	3	2026-11-23 15:20:10.212+00	Terrain Sidi Moumen	in_progress	1	0	\N	\N	0	0	Karim Arbitre	Imad Ounahi	Mounir Amrabat	\N	Nuageux	\N	\N	t	t	f	2026-11-23 16:10:10.212+00	2026-11-23 16:33:26.176+00
27	1	7	2	4	7	2026-12-13 16:10:10.314+00	Stade Larbi Zaouli	scheduled	0	0	\N	\N	0	0	Omar Ounahi	Bilal Lahlou	Mehdi Rahimi	\N	Venteux	\N	\N	f	f	f	2026-11-23 16:10:10.315+00	2026-11-23 16:10:10.315+00
32	2	1	0	9	12	2026-10-14 16:10:10.34+00	Stade Mohammed V	completed	2	0	9	30	0	0	Bouchra Karboubi	Mehdi El Idrissi	Mohamed Saiss	\N	Venteux	2134	\N	t	t	f	2026-11-23 16:10:10.34+00	2026-11-23 16:33:25.542+00
33	2	1	1	14	10	2026-10-15 16:10:10.368+00	Stade Père Jégo	completed	3	3	10	30	3	3	Mustapha Kechchaf	Imad Fassi	Driss El Amrani	\N	Nuageux	1400	\N	t	t	f	2026-11-23 16:10:10.368+00	2026-11-23 16:33:25.576+00
34	2	1	2	13	15	2026-10-16 16:10:10.424+00	Complexe Al Amal	completed	2	1	13	31	1	0	Karim Arbitre	Yassine Benali	Reda El Idrissi	\N	Pluie légère	559	\N	t	t	f	2026-11-23 16:10:10.424+00	2026-11-23 16:33:25.613+00
35	2	1	3	16	11	2026-10-17 16:10:10.462+00	Stade Larbi Zaouli	completed	1	0	16	31	0	0	Redouane Jiyed	Ismail Benali	Fouad Haddad	\N	Pluie légère	829	\N	t	t	f	2026-11-23 16:10:10.462+00	2026-11-23 16:33:25.64+00
30	2	2	0	9	10	2026-11-03 16:10:10.334+00	Complexe Oasis	completed	2	1	9	29	1	1	Bouchra Karboubi	Taha Haddad	Reda Tazi	\N	Pluie légère	695	\N	t	t	f	2026-11-23 16:10:10.334+00	2026-11-23 16:33:25.894+00
31	2	2	1	13	16	2026-11-03 16:10:10.337+00	Complexe Oasis	completed	3	3	16	29	2	2	Mustapha Kechchaf	Imad Haddad	Rachid Rahimi	\N	Nuageux	1855	\N	t	t	f	2026-11-23 16:10:10.337+00	2026-11-23 16:33:25.929+00
29	2	3	0	9	16	2026-11-13 16:10:10.332+00	Complexe Oasis	completed	4	2	9	\N	4	0	Bouchra Karboubi	Youssef Mansouri	Khalid Boufal	\N	Ensoleillé	2013	\N	t	t	f	2026-11-23 16:10:10.332+00	2026-11-23 16:33:26.087+00
25	1	7	0	1	2	2026-12-13 16:10:10.301+00	Stade Mohammed V	scheduled	0	0	\N	\N	0	0	Redouane Jiyed	Mohamed Haddad	Hamza Ouazzani	\N	Venteux	\N	\N	f	f	f	2026-11-23 16:10:10.301+00	2026-11-23 16:33:26.333+00
26	1	7	1	3	8	2026-12-13 16:10:10.308+00	Complexe Al Amal	scheduled	0	0	\N	\N	0	0	Samir Guezzaz	Rachid Harit	Ayoub Seddiki	\N	Pluie légère	\N	\N	f	f	f	2026-11-23 16:10:10.308+00	2026-11-23 16:33:26.369+00
28	1	7	3	5	6	2026-12-13 16:10:10.325+00	Terrain Sidi Moumen	scheduled	0	0	\N	\N	0	0	Bouchra Karboubi	Adil Haddad	Rachid El Kaabi	\N	Ensoleillé	\N	\N	f	f	f	2026-11-23 16:10:10.326+00	2026-11-23 16:33:26.425+00
\.


--
-- Data for Name: PlayerBadges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PlayerBadges" (id, "playerId", name, type, rarity, description, count, source, icon, "awardedById", "tournamentId", "createdAt", "updatedAt") FROM stdin;
1	36	Meilleur buteur	excellence	legendary	5 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.685+00	2026-11-23 16:10:13.685+00
2	16	Buteur en série	excellence	epic	3 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.689+00	2026-11-23 16:10:13.689+00
3	111	Buteur en série	excellence	epic	3 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.691+00	2026-11-23 16:10:13.691+00
4	4	Buteur en série	excellence	rare	2 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.692+00	2026-11-23 16:10:13.692+00
5	80	Buteur en série	excellence	rare	2 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.694+00	2026-11-23 16:10:13.694+00
6	283	Buteur en série	excellence	rare	2 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.695+00	2026-11-23 16:10:13.695+00
7	7	Buteur en série	excellence	rare	1 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.697+00	2026-11-23 16:10:13.697+00
8	9	Buteur en série	excellence	rare	1 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.699+00	2026-11-23 16:10:13.699+00
9	11	Buteur en série	excellence	rare	1 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.7+00	2026-11-23 16:10:13.7+00
10	15	Buteur en série	excellence	rare	1 buts cette saison	1	system	⚽	\N	1	2026-11-23 16:10:13.702+00	2026-11-23 16:10:13.702+00
11	145	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.703+00	2026-11-23 16:10:13.703+00
12	146	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.707+00	2026-11-23 16:10:13.707+00
13	147	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.712+00	2026-11-23 16:10:13.712+00
14	148	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.716+00	2026-11-23 16:10:13.716+00
15	149	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.721+00	2026-11-23 16:10:13.721+00
16	150	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.724+00	2026-11-23 16:10:13.724+00
17	151	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.728+00	2026-11-23 16:10:13.728+00
18	152	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.735+00	2026-11-23 16:10:13.735+00
19	153	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.739+00	2026-11-23 16:10:13.739+00
20	154	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.742+00	2026-11-23 16:10:13.742+00
21	155	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.746+00	2026-11-23 16:10:13.746+00
22	156	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.749+00	2026-11-23 16:10:13.749+00
23	157	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.752+00	2026-11-23 16:10:13.752+00
24	158	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.755+00	2026-11-23 16:10:13.755+00
25	159	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.757+00	2026-11-23 16:10:13.757+00
26	160	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.76+00	2026-11-23 16:10:13.76+00
27	161	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.763+00	2026-11-23 16:10:13.763+00
28	162	Vainqueur de la Coupe	tournament	epic	Vainqueur de la Coupe Raja Academy U23	1	tournament	🏆	\N	2	2026-11-23 16:10:13.767+00	2026-11-23 16:10:13.767+00
29	3	Esprit d'équipe	training	uncommon	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.771+00	2026-11-23 16:10:13.771+00
30	4	Esprit d'équipe	participation	rare	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.772+00	2026-11-23 16:10:13.772+00
31	5	Esprit d'équipe	training	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.774+00	2026-11-23 16:10:13.774+00
32	6	Assidu à l'entraînement	achievement	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.777+00	2026-11-23 16:10:13.777+00
33	8	Assidu à l'entraînement	training	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:13.78+00	2026-11-23 16:10:13.78+00
34	9	Progression du mois	participation	rare	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.782+00	2026-11-23 16:10:13.782+00
35	11	Progression du mois	achievement	rare	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.786+00	2026-11-23 16:10:13.786+00
36	14	Progression du mois	training	common	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.79+00	2026-11-23 16:10:13.79+00
37	17	Assidu à l'entraînement	participation	rare	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.791+00	2026-11-23 16:10:13.791+00
38	18	Assidu à l'entraînement	training	uncommon	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.792+00	2026-11-23 16:10:13.792+00
39	21	Esprit d'équipe	training	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.794+00	2026-11-23 16:10:13.794+00
40	22	Assidu à l'entraînement	participation	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.795+00	2026-11-23 16:10:13.795+00
41	23	Esprit d'équipe	training	uncommon	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.798+00	2026-11-23 16:10:13.798+00
42	25	Esprit d'équipe	training	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.8+00	2026-11-23 16:10:13.8+00
43	26	Progression du mois	participation	rare	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:13.803+00	2026-11-23 16:10:13.803+00
44	31	Esprit d'équipe	participation	uncommon	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.808+00	2026-11-23 16:10:13.808+00
45	33	Assidu à l'entraînement	training	common	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.81+00	2026-11-23 16:10:13.81+00
46	34	Assidu à l'entraînement	participation	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.811+00	2026-11-23 16:10:13.811+00
47	39	Esprit d'équipe	training	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.813+00	2026-11-23 16:10:13.813+00
48	40	Assidu à l'entraînement	participation	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.816+00	2026-11-23 16:10:13.816+00
49	44	Esprit d'équipe	participation	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.821+00	2026-11-23 16:10:13.821+00
50	45	Assidu à l'entraînement	participation	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.824+00	2026-11-23 16:10:13.824+00
51	49	Assidu à l'entraînement	training	rare	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.829+00	2026-11-23 16:10:13.829+00
52	51	Esprit d'équipe	training	uncommon	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.832+00	2026-11-23 16:10:13.832+00
53	55	Assidu à l'entraînement	achievement	rare	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.847+00	2026-11-23 16:10:13.847+00
54	57	Esprit d'équipe	participation	rare	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.853+00	2026-11-23 16:10:13.853+00
55	60	Esprit d'équipe	achievement	rare	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.866+00	2026-11-23 16:10:13.866+00
56	64	Esprit d'équipe	training	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.878+00	2026-11-23 16:10:13.878+00
57	67	Assidu à l'entraînement	achievement	rare	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.881+00	2026-11-23 16:10:13.881+00
58	68	Esprit d'équipe	achievement	uncommon	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.886+00	2026-11-23 16:10:13.886+00
59	70	Assidu à l'entraînement	training	common	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.889+00	2026-11-23 16:10:13.889+00
60	71	Assidu à l'entraînement	achievement	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.89+00	2026-11-23 16:10:13.89+00
61	74	Assidu à l'entraînement	training	rare	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.893+00	2026-11-23 16:10:13.893+00
62	78	Esprit d'équipe	achievement	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.896+00	2026-11-23 16:10:13.896+00
63	81	Esprit d'équipe	achievement	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.898+00	2026-11-23 16:10:13.898+00
64	82	Esprit d'équipe	achievement	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:13.901+00	2026-11-23 16:10:13.901+00
65	83	Progression du mois	achievement	common	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.904+00	2026-11-23 16:10:13.904+00
66	85	Assidu à l'entraînement	participation	common	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:13.906+00	2026-11-23 16:10:13.906+00
67	86	Assidu à l'entraînement	achievement	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.908+00	2026-11-23 16:10:13.908+00
68	87	Progression du mois	participation	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.911+00	2026-11-23 16:10:13.911+00
69	90	Assidu à l'entraînement	achievement	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.915+00	2026-11-23 16:10:13.915+00
70	91	Assidu à l'entraînement	participation	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.92+00	2026-11-23 16:10:13.92+00
71	92	Esprit d'équipe	participation	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:13.921+00	2026-11-23 16:10:13.921+00
72	94	Esprit d'équipe	participation	uncommon	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.923+00	2026-11-23 16:10:13.923+00
73	98	Esprit d'équipe	participation	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.926+00	2026-11-23 16:10:13.926+00
74	99	Progression du mois	participation	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.93+00	2026-11-23 16:10:13.93+00
75	100	Esprit d'équipe	participation	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.931+00	2026-11-23 16:10:13.931+00
76	104	Esprit d'équipe	achievement	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.933+00	2026-11-23 16:10:13.933+00
77	107	Esprit d'équipe	training	uncommon	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:13.936+00	2026-11-23 16:10:13.936+00
78	109	Progression du mois	achievement	uncommon	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:13.938+00	2026-11-23 16:10:13.938+00
79	112	Esprit d'équipe	training	rare	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.942+00	2026-11-23 16:10:13.942+00
80	114	Assidu à l'entraînement	participation	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:13.943+00	2026-11-23 16:10:13.943+00
81	119	Progression du mois	training	uncommon	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.945+00	2026-11-23 16:10:13.945+00
82	120	Assidu à l'entraînement	training	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.946+00	2026-11-23 16:10:13.946+00
83	121	Progression du mois	participation	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.95+00	2026-11-23 16:10:13.95+00
84	124	Assidu à l'entraînement	participation	rare	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.955+00	2026-11-23 16:10:13.955+00
85	126	Assidu à l'entraînement	achievement	common	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.958+00	2026-11-23 16:10:13.958+00
86	130	Esprit d'équipe	participation	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.96+00	2026-11-23 16:10:13.96+00
87	132	Progression du mois	training	uncommon	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:13.962+00	2026-11-23 16:10:13.962+00
88	134	Assidu à l'entraînement	training	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.967+00	2026-11-23 16:10:13.967+00
89	142	Assidu à l'entraînement	participation	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.972+00	2026-11-23 16:10:13.972+00
90	147	Esprit d'équipe	participation	common	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:13.978+00	2026-11-23 16:10:13.978+00
91	151	Assidu à l'entraînement	achievement	common	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:13.983+00	2026-11-23 16:10:13.983+00
92	154	Progression du mois	achievement	rare	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:13.99+00	2026-11-23 16:10:13.99+00
93	158	Assidu à l'entraînement	training	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:13.993+00	2026-11-23 16:10:13.993+00
94	160	Assidu à l'entraînement	training	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:13.997+00	2026-11-23 16:10:13.997+00
95	161	Assidu à l'entraînement	participation	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.002+00	2026-11-23 16:10:14.002+00
96	163	Progression du mois	participation	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:14.004+00	2026-11-23 16:10:14.004+00
97	165	Progression du mois	achievement	rare	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:14.006+00	2026-11-23 16:10:14.006+00
98	170	Assidu à l'entraînement	achievement	rare	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:14.009+00	2026-11-23 16:10:14.009+00
99	172	Esprit d'équipe	training	uncommon	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:14.013+00	2026-11-23 16:10:14.013+00
100	175	Assidu à l'entraînement	achievement	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.016+00	2026-11-23 16:10:14.016+00
101	179	Esprit d'équipe	training	rare	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.019+00	2026-11-23 16:10:14.019+00
102	180	Esprit d'équipe	achievement	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:14.02+00	2026-11-23 16:10:14.02+00
103	186	Esprit d'équipe	achievement	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:14.026+00	2026-11-23 16:10:14.026+00
104	188	Progression du mois	participation	rare	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:14.028+00	2026-11-23 16:10:14.028+00
105	190	Assidu à l'entraînement	achievement	rare	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:14.031+00	2026-11-23 16:10:14.031+00
106	199	Esprit d'équipe	participation	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:14.036+00	2026-11-23 16:10:14.036+00
107	201	Assidu à l'entraînement	training	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:14.037+00	2026-11-23 16:10:14.037+00
108	206	Progression du mois	participation	rare	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:14.04+00	2026-11-23 16:10:14.04+00
109	212	Assidu à l'entraînement	achievement	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:14.048+00	2026-11-23 16:10:14.048+00
110	216	Assidu à l'entraînement	training	uncommon	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.054+00	2026-11-23 16:10:14.054+00
111	217	Esprit d'équipe	achievement	common	Attribué par le coach	3	coach	📈	\N	\N	2026-11-23 16:10:14.057+00	2026-11-23 16:10:14.057+00
112	220	Assidu à l'entraînement	participation	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:14.065+00	2026-11-23 16:10:14.065+00
113	221	Progression du mois	training	uncommon	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.069+00	2026-11-23 16:10:14.069+00
114	222	Progression du mois	participation	common	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:14.074+00	2026-11-23 16:10:14.074+00
115	223	Progression du mois	participation	common	Attribué par le coach	2	coach	📈	\N	\N	2026-11-23 16:10:14.077+00	2026-11-23 16:10:14.077+00
116	225	Esprit d'équipe	participation	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:14.088+00	2026-11-23 16:10:14.088+00
117	230	Esprit d'équipe	achievement	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.09+00	2026-11-23 16:10:14.09+00
118	237	Progression du mois	participation	rare	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:14.099+00	2026-11-23 16:10:14.099+00
119	239	Assidu à l'entraînement	training	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.102+00	2026-11-23 16:10:14.102+00
120	248	Esprit d'équipe	participation	common	Attribué par le coach	3	coach	🤝	\N	\N	2026-11-23 16:10:14.105+00	2026-11-23 16:10:14.105+00
121	253	Esprit d'équipe	achievement	common	Attribué par le coach	2	coach	🔥	\N	\N	2026-11-23 16:10:14.11+00	2026-11-23 16:10:14.11+00
122	256	Progression du mois	participation	uncommon	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:14.111+00	2026-11-23 16:10:14.111+00
123	265	Assidu à l'entraînement	participation	common	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:14.119+00	2026-11-23 16:10:14.119+00
124	272	Esprit d'équipe	training	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.124+00	2026-11-23 16:10:14.124+00
125	273	Assidu à l'entraînement	training	rare	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.125+00	2026-11-23 16:10:14.125+00
126	277	Assidu à l'entraînement	training	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.126+00	2026-11-23 16:10:14.126+00
127	281	Progression du mois	participation	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.132+00	2026-11-23 16:10:14.132+00
128	284	Esprit d'équipe	training	common	Attribué par le coach	3	coach	🔥	\N	\N	2026-11-23 16:10:14.135+00	2026-11-23 16:10:14.135+00
129	285	Esprit d'équipe	training	common	Attribué par le coach	1	coach	🔥	\N	\N	2026-11-23 16:10:14.136+00	2026-11-23 16:10:14.136+00
130	286	Esprit d'équipe	achievement	common	Attribué par le coach	1	coach	🤝	\N	\N	2026-11-23 16:10:14.138+00	2026-11-23 16:10:14.138+00
131	287	Esprit d'équipe	achievement	common	Attribué par le coach	2	coach	🤝	\N	\N	2026-11-23 16:10:14.141+00	2026-11-23 16:10:14.141+00
132	288	Esprit d'équipe	participation	common	Attribué par le coach	1	coach	📈	\N	\N	2026-11-23 16:10:14.144+00	2026-11-23 16:10:14.144+00
133	1	Mur infranchissable	excellence	legendary	3 clean sheets cette saison	1	system	🧱	\N	1	2026-11-09 09:38:46.812273+00	2026-11-09 09:38:46.812273+00
134	1	Arrêt réflexe	match	epic	Penalty arrêté en match officiel	1	coach	🧤	2	\N	2026-11-22 09:38:46.812273+00	2026-11-22 09:38:46.812273+00
135	1	Homme du match	match	rare	Élu meilleur joueur du match	2	coach	⭐	2	\N	2026-11-04 09:38:46.812273+00	2026-11-04 09:38:46.812273+00
136	1	Assidu	training	uncommon	100 % de présence aux entraînements du mois	1	coach	🏋️	2	\N	2026-11-15 09:38:46.812273+00	2026-11-15 09:38:46.812273+00
137	1	Leader de la défense	achievement	rare	Organise sa défense avec autorité	1	coach	🛡️	2	\N	2026-11-17 09:38:46.812273+00	2026-11-17 09:38:46.812273+00
138	1	Premier tournoi	participation	common	A participé à son premier tournoi	1	tournament	🏆	\N	1	2026-10-25 09:38:46.812273+00	2026-10-25 09:38:46.812273+00
\.


--
-- Data for Name: PlayerClubHistories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PlayerClubHistories" (id, "playerId", "teamId", "teamName", "teamLogo", "startDate", "endDate", goals, assists, matches, "minutesPlayed", "yellowCards", "redCards", "cleanSheets", saves, tackles, "createdAt", "updatedAt") FROM stdin;
1	1	1	Wydad Athletic Club	\N	2023-03-25	\N	0	0	1	90	0	0	0	3	0	2026-11-23 16:10:10.787+00	2026-11-23 16:10:10.787+00
2	2	1	Wydad Athletic Club	\N	2023-07-20	\N	0	0	3	270	0	0	3	10	0	2026-11-23 16:10:10.794+00	2026-11-23 16:10:10.794+00
3	3	15	Al Ahram Riadi	\N	2023-01-23	2023-11-17	10	8	21	929	0	0	0	0	0	2026-11-23 16:10:10.797+00	2026-11-23 16:10:10.797+00
4	3	1	Wydad Athletic Club	\N	2023-11-17	\N	0	1	4	192	1	0	0	0	0	2026-11-23 16:10:10.799+00	2026-11-23 16:10:10.799+00
5	4	1	Wydad Athletic Club	\N	2023-01-06	\N	2	1	4	329	0	0	0	0	0	2026-11-23 16:10:10.803+00	2026-11-23 16:10:10.803+00
6	5	1	Wydad Athletic Club	\N	2025-07-27	\N	0	0	4	302	0	0	0	0	0	2026-11-23 16:10:10.808+00	2026-11-23 16:10:10.808+00
7	6	1	Wydad Athletic Club	\N	2024-10-28	\N	0	4	4	221	0	0	0	0	0	2026-11-23 16:10:10.812+00	2026-11-23 16:10:10.812+00
8	7	1	Wydad Athletic Club	\N	2022-12-27	\N	1	0	4	245	0	0	0	0	0	2026-11-23 16:10:10.819+00	2026-11-23 16:10:10.819+00
9	8	1	Wydad Athletic Club	\N	2023-09-25	\N	0	0	4	151	0	0	0	0	0	2026-11-23 16:10:10.827+00	2026-11-23 16:10:10.827+00
10	9	11	Racing Athletic Sportif	\N	2023-01-23	2024-11-11	0	1	19	2431	1	1	0	0	0	2026-11-23 16:10:10.839+00	2026-11-23 16:10:10.839+00
11	9	1	Wydad Athletic Club	\N	2024-11-11	\N	1	0	4	284	0	0	0	0	0	2026-11-23 16:10:10.846+00	2026-11-23 16:10:10.846+00
12	10	4	Sporting Chabab Mohammadia	\N	2023-01-23	2025-10-17	6	6	39	2772	3	1	0	0	0	2026-11-23 16:10:10.859+00	2026-11-23 16:10:10.859+00
13	10	1	Wydad Athletic Club	\N	2025-10-17	\N	0	1	3	242	0	0	0	0	0	2026-11-23 16:10:10.863+00	2026-11-23 16:10:10.863+00
14	11	2	Raja Club Athletic	\N	2023-01-23	2024-03-27	0	2	32	1274	5	0	0	0	0	2026-11-23 16:10:10.874+00	2026-11-23 16:10:10.874+00
15	11	1	Wydad Athletic Club	\N	2024-03-27	\N	1	0	4	207	0	0	0	0	0	2026-11-23 16:10:10.876+00	2026-11-23 16:10:10.876+00
16	12	5	Union Sportive Mohammadia	\N	2023-01-23	2026-09-11	2	7	13	2729	3	0	0	0	0	2026-11-23 16:10:10.882+00	2026-11-23 16:10:10.882+00
17	12	1	Wydad Athletic Club	\N	2026-09-11	\N	0	1	2	98	0	0	0	0	0	2026-11-23 16:10:10.884+00	2026-11-23 16:10:10.884+00
18	13	1	Wydad Athletic Club	\N	2023-02-26	\N	0	0	1	76	0	0	0	0	0	2026-11-23 16:10:10.89+00	2026-11-23 16:10:10.89+00
19	14	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2026-07-04	4	7	17	2790	6	0	0	0	0	2026-11-23 16:10:10.896+00	2026-11-23 16:10:10.896+00
20	14	1	Wydad Athletic Club	\N	2026-07-04	\N	0	0	2	173	0	0	0	0	0	2026-11-23 16:10:10.899+00	2026-11-23 16:10:10.899+00
21	15	1	Wydad Athletic Club	\N	2026-04-15	\N	1	0	4	360	1	0	0	0	0	2026-11-23 16:10:10.903+00	2026-11-23 16:10:10.903+00
22	16	1	Wydad Athletic Club	\N	2025-04-23	\N	3	0	2	180	1	0	0	0	0	2026-11-23 16:10:10.906+00	2026-11-23 16:10:10.906+00
23	17	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2023-04-30	12	6	23	1167	0	1	0	0	0	2026-11-23 16:10:10.909+00	2026-11-23 16:10:10.909+00
24	17	1	Wydad Athletic Club	\N	2023-04-30	\N	0	0	4	360	0	0	0	0	0	2026-11-23 16:10:10.911+00	2026-11-23 16:10:10.911+00
25	18	8	Rachad Bernoussi	\N	2023-01-23	2025-05-02	8	1	27	644	3	0	0	0	0	2026-11-23 16:10:10.917+00	2026-11-23 16:10:10.917+00
26	18	1	Wydad Athletic Club	\N	2025-05-02	\N	1	0	2	180	0	0	0	0	0	2026-11-23 16:10:10.921+00	2026-11-23 16:10:10.921+00
27	19	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2023-09-16	2	0	15	1050	3	0	0	0	0	2026-11-23 16:10:10.926+00	2026-11-23 16:10:10.926+00
28	19	2	Raja Club Athletic	\N	2023-09-16	\N	0	0	1	90	0	0	0	7	0	2026-11-23 16:10:10.931+00	2026-11-23 16:10:10.931+00
29	20	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2023-03-03	0	8	21	1141	5	1	0	0	0	2026-11-23 16:10:10.939+00	2026-11-23 16:10:10.939+00
30	20	2	Raja Club Athletic	\N	2023-03-03	\N	0	0	3	270	0	0	1	11	0	2026-11-23 16:10:10.945+00	2026-11-23 16:10:10.945+00
31	21	4	Sporting Chabab Mohammadia	\N	2023-01-23	2026-06-18	11	7	22	714	0	0	0	0	0	2026-11-23 16:10:10.951+00	2026-11-23 16:10:10.951+00
32	21	2	Raja Club Athletic	\N	2026-06-18	\N	1	0	4	234	1	0	0	0	0	2026-11-23 16:10:10.956+00	2026-11-23 16:10:10.956+00
33	22	13	Chabab Fida	\N	2023-01-23	2026-09-07	8	5	17	2815	3	0	0	0	0	2026-11-23 16:10:10.963+00	2026-11-23 16:10:10.963+00
34	22	2	Raja Club Athletic	\N	2026-09-07	\N	0	0	4	263	0	0	0	0	0	2026-11-23 16:10:10.966+00	2026-11-23 16:10:10.966+00
35	23	8	Rachad Bernoussi	\N	2023-01-23	2023-02-04	0	6	35	1911	0	0	0	0	0	2026-11-23 16:10:10.97+00	2026-11-23 16:10:10.97+00
36	23	2	Raja Club Athletic	\N	2023-02-04	\N	1	0	4	249	1	0	0	0	0	2026-11-23 16:10:10.972+00	2026-11-23 16:10:10.972+00
37	24	15	Al Ahram Riadi	\N	2023-01-23	2025-11-19	8	7	13	2041	0	0	0	0	0	2026-11-23 16:10:10.976+00	2026-11-23 16:10:10.976+00
38	24	2	Raja Club Athletic	\N	2025-11-19	\N	0	0	4	186	0	0	0	0	0	2026-11-23 16:10:10.977+00	2026-11-23 16:10:10.977+00
39	25	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2026-07-09	7	0	16	1531	1	0	0	0	0	2026-11-23 16:10:10.981+00	2026-11-23 16:10:10.981+00
40	25	2	Raja Club Athletic	\N	2026-07-09	\N	0	0	4	262	0	0	0	0	0	2026-11-23 16:10:10.982+00	2026-11-23 16:10:10.982+00
41	26	2	Raja Club Athletic	\N	2025-05-17	\N	0	0	4	246	0	0	0	0	0	2026-11-23 16:10:10.986+00	2026-11-23 16:10:10.986+00
42	27	16	Mejd Ancienne Medina	\N	2023-01-23	2024-11-18	10	6	19	1218	3	0	0	0	0	2026-11-23 16:10:10.989+00	2026-11-23 16:10:10.989+00
43	27	2	Raja Club Athletic	\N	2024-11-18	\N	0	0	3	130	0	0	0	0	0	2026-11-23 16:10:10.991+00	2026-11-23 16:10:10.991+00
44	28	2	Raja Club Athletic	\N	2026-03-01	\N	1	1	4	302	0	0	0	0	0	2026-11-23 16:10:10.995+00	2026-11-23 16:10:10.995+00
45	29	12	Hayat Athletic	\N	2023-01-23	2022-12-29	12	4	31	1424	0	0	0	0	0	2026-11-23 16:10:10.998+00	2026-11-23 16:10:10.998+00
46	29	2	Raja Club Athletic	\N	2022-12-29	\N	1	0	4	288	0	0	0	0	0	2026-11-23 16:10:11+00	2026-11-23 16:10:11+00
47	30	2	Raja Club Athletic	\N	2026-07-19	\N	0	0	2	96	0	0	0	0	0	2026-11-23 16:10:11.004+00	2026-11-23 16:10:11.004+00
48	31	16	Mejd Ancienne Medina	\N	2023-01-23	2024-02-28	4	5	22	882	1	0	0	0	0	2026-11-23 16:10:11.008+00	2026-11-23 16:10:11.008+00
49	31	2	Raja Club Athletic	\N	2024-02-28	\N	0	2	4	264	0	0	0	0	0	2026-11-23 16:10:11.009+00	2026-11-23 16:10:11.009+00
50	32	2	Raja Club Athletic	\N	2025-06-07	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.014+00	2026-11-23 16:10:11.014+00
51	33	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2023-07-31	8	2	31	2897	3	1	0	0	0	2026-11-23 16:10:11.021+00	2026-11-23 16:10:11.021+00
52	33	2	Raja Club Athletic	\N	2023-07-31	\N	0	1	3	270	0	0	0	0	0	2026-11-23 16:10:11.023+00	2026-11-23 16:10:11.023+00
53	34	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2024-12-01	4	1	22	1671	2	0	0	0	0	2026-11-23 16:10:11.026+00	2026-11-23 16:10:11.026+00
54	34	2	Raja Club Athletic	\N	2024-12-01	\N	1	1	4	360	0	0	0	0	0	2026-11-23 16:10:11.028+00	2026-11-23 16:10:11.028+00
55	35	12	Hayat Athletic	\N	2023-01-23	2026-02-17	5	4	23	1337	4	0	0	0	0	2026-11-23 16:10:11.033+00	2026-11-23 16:10:11.033+00
56	35	2	Raja Club Athletic	\N	2026-02-17	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:11.035+00	2026-11-23 16:10:11.035+00
57	36	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2023-11-11	6	7	32	1603	1	1	0	0	0	2026-11-23 16:10:11.042+00	2026-11-23 16:10:11.042+00
58	36	2	Raja Club Athletic	\N	2023-11-11	\N	5	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.046+00	2026-11-23 16:10:11.046+00
59	37	3	AS Lafarge Maroc	\N	2022-12-08	\N	0	0	3	270	0	0	0	13	0	2026-11-23 16:10:11.054+00	2026-11-23 16:10:11.054+00
60	38	3	AS Lafarge Maroc	\N	2025-08-19	\N	0	0	1	90	0	0	0	1	0	2026-11-23 16:10:11.066+00	2026-11-23 16:10:11.066+00
61	39	15	Al Ahram Riadi	\N	2023-01-23	2023-05-11	3	4	23	2461	0	1	0	0	0	2026-11-23 16:10:11.075+00	2026-11-23 16:10:11.075+00
62	39	3	AS Lafarge Maroc	\N	2023-05-11	\N	1	0	4	202	0	0	0	0	0	2026-11-23 16:10:11.078+00	2026-11-23 16:10:11.078+00
63	40	3	AS Lafarge Maroc	\N	2023-01-08	\N	0	1	4	290	0	0	0	0	0	2026-11-23 16:10:11.085+00	2026-11-23 16:10:11.085+00
64	41	5	Union Sportive Mohammadia	\N	2023-01-23	2023-03-26	9	4	31	2944	3	1	0	0	0	2026-11-23 16:10:11.092+00	2026-11-23 16:10:11.092+00
65	41	3	AS Lafarge Maroc	\N	2023-03-26	\N	0	0	4	262	0	0	0	0	0	2026-11-23 16:10:11.095+00	2026-11-23 16:10:11.095+00
66	42	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2023-01-13	7	6	16	1851	6	0	0	0	0	2026-11-23 16:10:11.102+00	2026-11-23 16:10:11.102+00
67	42	3	AS Lafarge Maroc	\N	2023-01-13	\N	1	0	4	295	0	0	0	0	0	2026-11-23 16:10:11.105+00	2026-11-23 16:10:11.105+00
68	43	3	AS Lafarge Maroc	\N	2022-11-30	\N	0	0	4	205	0	0	0	0	0	2026-11-23 16:10:11.112+00	2026-11-23 16:10:11.112+00
69	44	6	Tihad Athletic Sportif	\N	2023-01-23	2023-09-02	1	5	24	1595	1	0	0	0	0	2026-11-23 16:10:11.121+00	2026-11-23 16:10:11.121+00
70	44	3	AS Lafarge Maroc	\N	2023-09-02	\N	1	0	4	186	1	0	0	0	0	2026-11-23 16:10:11.124+00	2026-11-23 16:10:11.124+00
71	45	4	Sporting Chabab Mohammadia	\N	2023-01-23	2024-09-14	4	5	30	1289	6	1	0	0	0	2026-11-23 16:10:11.129+00	2026-11-23 16:10:11.129+00
72	45	3	AS Lafarge Maroc	\N	2024-09-14	\N	0	1	2	170	1	0	0	0	0	2026-11-23 16:10:11.132+00	2026-11-23 16:10:11.132+00
73	46	3	AS Lafarge Maroc	\N	2026-08-06	\N	0	1	2	100	0	0	0	0	0	2026-11-23 16:10:11.139+00	2026-11-23 16:10:11.139+00
74	47	3	AS Lafarge Maroc	\N	2023-03-12	\N	0	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.143+00	2026-11-23 16:10:11.143+00
75	48	4	Sporting Chabab Mohammadia	\N	2023-01-23	2024-11-16	6	4	19	2005	5	1	0	0	0	2026-11-23 16:10:11.147+00	2026-11-23 16:10:11.147+00
76	48	3	AS Lafarge Maroc	\N	2024-11-16	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:11.15+00	2026-11-23 16:10:11.15+00
77	49	3	AS Lafarge Maroc	\N	2022-12-03	\N	0	0	3	270	1	0	0	0	0	2026-11-23 16:10:11.155+00	2026-11-23 16:10:11.155+00
78	50	3	AS Lafarge Maroc	\N	2025-06-02	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:11.165+00	2026-11-23 16:10:11.165+00
79	51	16	Mejd Ancienne Medina	\N	2023-01-23	2026-01-30	0	2	15	2120	5	1	0	0	0	2026-11-23 16:10:11.171+00	2026-11-23 16:10:11.171+00
80	51	3	AS Lafarge Maroc	\N	2026-01-30	\N	1	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.174+00	2026-11-23 16:10:11.174+00
81	52	3	AS Lafarge Maroc	\N	2024-12-11	\N	0	1	3	270	1	0	0	0	0	2026-11-23 16:10:11.178+00	2026-11-23 16:10:11.178+00
82	53	3	AS Lafarge Maroc	\N	2024-03-16	\N	1	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.184+00	2026-11-23 16:10:11.184+00
83	54	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2024-02-22	2	4	19	732	2	0	0	0	0	2026-11-23 16:10:11.189+00	2026-11-23 16:10:11.189+00
84	54	3	AS Lafarge Maroc	\N	2024-02-22	\N	0	0	4	360	0	0	0	0	0	2026-11-23 16:10:11.191+00	2026-11-23 16:10:11.191+00
85	55	3	AS Lafarge Maroc	\N	2023-01-23	2023-12-10	6	2	27	3003	3	1	0	0	0	2026-11-23 16:10:11.196+00	2026-11-23 16:10:11.196+00
86	55	4	Sporting Chabab Mohammadia	\N	2023-12-10	\N	0	0	2	180	0	0	1	5	0	2026-11-23 16:10:11.199+00	2026-11-23 16:10:11.199+00
87	56	11	Racing Athletic Sportif	\N	2023-01-23	2024-01-26	10	0	31	1635	0	1	0	0	0	2026-11-23 16:10:11.203+00	2026-11-23 16:10:11.203+00
88	56	4	Sporting Chabab Mohammadia	\N	2024-01-26	\N	0	0	2	180	0	0	0	6	0	2026-11-23 16:10:11.206+00	2026-11-23 16:10:11.206+00
89	57	3	AS Lafarge Maroc	\N	2023-01-23	2024-09-15	9	5	39	1075	6	1	0	0	0	2026-11-23 16:10:11.211+00	2026-11-23 16:10:11.211+00
90	57	4	Sporting Chabab Mohammadia	\N	2024-09-15	\N	0	1	4	239	0	0	0	0	0	2026-11-23 16:10:11.213+00	2026-11-23 16:10:11.213+00
91	58	4	Sporting Chabab Mohammadia	\N	2023-10-31	\N	1	0	4	183	0	0	0	0	0	2026-11-23 16:10:11.217+00	2026-11-23 16:10:11.217+00
92	59	4	Sporting Chabab Mohammadia	\N	2026-08-29	\N	1	0	4	355	0	0	0	0	0	2026-11-23 16:10:11.223+00	2026-11-23 16:10:11.223+00
93	60	4	Sporting Chabab Mohammadia	\N	2023-08-31	\N	0	0	4	326	0	0	0	0	0	2026-11-23 16:10:11.227+00	2026-11-23 16:10:11.227+00
94	61	4	Sporting Chabab Mohammadia	\N	2024-09-26	\N	0	0	4	161	0	0	0	0	0	2026-11-23 16:10:11.231+00	2026-11-23 16:10:11.231+00
95	62	12	Hayat Athletic	\N	2023-01-23	2023-09-25	0	1	24	2740	6	1	0	0	0	2026-11-23 16:10:11.235+00	2026-11-23 16:10:11.235+00
96	62	4	Sporting Chabab Mohammadia	\N	2023-09-25	\N	1	0	4	176	0	0	0	0	0	2026-11-23 16:10:11.237+00	2026-11-23 16:10:11.237+00
97	63	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2026-02-10	6	8	8	2454	3	0	0	0	0	2026-11-23 16:10:11.242+00	2026-11-23 16:10:11.242+00
98	63	4	Sporting Chabab Mohammadia	\N	2026-02-10	\N	0	0	4	61	0	0	0	0	0	2026-11-23 16:10:11.244+00	2026-11-23 16:10:11.244+00
99	64	15	Al Ahram Riadi	\N	2023-01-23	2025-05-17	6	5	26	2499	4	0	0	0	0	2026-11-23 16:10:11.248+00	2026-11-23 16:10:11.248+00
100	64	4	Sporting Chabab Mohammadia	\N	2025-05-17	\N	0	0	3	186	0	0	0	0	0	2026-11-23 16:10:11.252+00	2026-11-23 16:10:11.252+00
101	65	4	Sporting Chabab Mohammadia	\N	2025-07-22	\N	0	1	4	294	0	0	0	0	0	2026-11-23 16:10:11.259+00	2026-11-23 16:10:11.259+00
102	66	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2025-12-14	3	4	11	1425	0	0	0	0	0	2026-11-23 16:10:11.265+00	2026-11-23 16:10:11.265+00
103	66	4	Sporting Chabab Mohammadia	\N	2025-12-14	\N	0	0	2	159	2	0	0	0	0	2026-11-23 16:10:11.268+00	2026-11-23 16:10:11.268+00
104	67	15	Al Ahram Riadi	\N	2023-01-23	2026-03-20	12	4	14	2864	5	1	0	0	0	2026-11-23 16:10:11.279+00	2026-11-23 16:10:11.279+00
105	67	4	Sporting Chabab Mohammadia	\N	2026-03-20	\N	0	0	2	168	0	0	0	0	0	2026-11-23 16:10:11.286+00	2026-11-23 16:10:11.286+00
106	68	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2025-05-28	10	3	38	1287	0	1	0	0	0	2026-11-23 16:10:11.298+00	2026-11-23 16:10:11.298+00
107	68	4	Sporting Chabab Mohammadia	\N	2025-05-28	\N	0	0	3	212	2	0	0	0	0	2026-11-23 16:10:11.302+00	2026-11-23 16:10:11.302+00
108	69	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2023-01-19	10	5	17	2239	1	0	0	0	0	2026-11-23 16:10:11.311+00	2026-11-23 16:10:11.311+00
109	69	4	Sporting Chabab Mohammadia	\N	2023-01-19	\N	1	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.312+00	2026-11-23 16:10:11.312+00
110	70	4	Sporting Chabab Mohammadia	\N	2026-06-18	\N	1	0	3	270	1	0	0	0	0	2026-11-23 16:10:11.316+00	2026-11-23 16:10:11.316+00
111	71	12	Hayat Athletic	\N	2023-01-23	2024-02-06	4	2	20	1603	1	1	0	0	0	2026-11-23 16:10:11.32+00	2026-11-23 16:10:11.32+00
112	71	4	Sporting Chabab Mohammadia	\N	2024-02-06	\N	0	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.326+00	2026-11-23 16:10:11.326+00
113	72	4	Sporting Chabab Mohammadia	\N	2026-01-21	\N	0	1	4	360	2	0	0	0	0	2026-11-23 16:10:11.332+00	2026-11-23 16:10:11.332+00
114	73	5	Union Sportive Mohammadia	\N	2024-03-01	\N	0	0	2	180	0	0	0	9	0	2026-11-23 16:10:11.335+00	2026-11-23 16:10:11.335+00
115	74	2	Raja Club Athletic	\N	2023-01-23	2025-10-14	11	3	38	1632	3	1	0	0	0	2026-11-23 16:10:11.339+00	2026-11-23 16:10:11.339+00
116	74	5	Union Sportive Mohammadia	\N	2025-10-14	\N	0	0	2	180	0	0	0	10	0	2026-11-23 16:10:11.341+00	2026-11-23 16:10:11.341+00
117	75	2	Raja Club Athletic	\N	2023-01-23	2025-07-30	10	5	35	806	4	0	0	0	0	2026-11-23 16:10:11.345+00	2026-11-23 16:10:11.345+00
118	75	5	Union Sportive Mohammadia	\N	2025-07-30	\N	0	0	4	169	0	0	0	0	0	2026-11-23 16:10:11.347+00	2026-11-23 16:10:11.347+00
119	76	2	Raja Club Athletic	\N	2023-01-23	2022-12-24	11	3	9	1660	6	1	0	0	0	2026-11-23 16:10:11.352+00	2026-11-23 16:10:11.352+00
120	76	5	Union Sportive Mohammadia	\N	2022-12-24	\N	0	0	4	276	0	0	0	0	0	2026-11-23 16:10:11.354+00	2026-11-23 16:10:11.354+00
121	77	5	Union Sportive Mohammadia	\N	2023-12-13	\N	0	2	4	252	0	0	0	0	0	2026-11-23 16:10:11.358+00	2026-11-23 16:10:11.358+00
122	78	5	Union Sportive Mohammadia	\N	2023-10-01	\N	0	0	4	328	0	0	0	0	0	2026-11-23 16:10:11.365+00	2026-11-23 16:10:11.365+00
123	79	5	Union Sportive Mohammadia	\N	2026-08-05	\N	0	0	4	148	0	0	0	0	0	2026-11-23 16:10:11.369+00	2026-11-23 16:10:11.369+00
124	80	16	Mejd Ancienne Medina	\N	2023-01-23	2024-12-05	11	5	24	3121	6	0	0	0	0	2026-11-23 16:10:11.375+00	2026-11-23 16:10:11.375+00
125	80	5	Union Sportive Mohammadia	\N	2024-12-05	\N	2	0	4	267	0	0	0	0	0	2026-11-23 16:10:11.377+00	2026-11-23 16:10:11.377+00
126	81	5	Union Sportive Mohammadia	\N	2025-07-20	\N	0	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.384+00	2026-11-23 16:10:11.384+00
127	82	5	Union Sportive Mohammadia	\N	2026-01-11	\N	0	0	4	233	0	0	0	0	0	2026-11-23 16:10:11.389+00	2026-11-23 16:10:11.389+00
128	83	13	Chabab Fida	\N	2023-01-23	2022-11-15	12	5	24	2537	4	1	0	0	0	2026-11-23 16:10:11.392+00	2026-11-23 16:10:11.392+00
129	83	5	Union Sportive Mohammadia	\N	2022-11-15	\N	0	1	3	223	0	0	0	0	0	2026-11-23 16:10:11.394+00	2026-11-23 16:10:11.394+00
130	84	5	Union Sportive Mohammadia	\N	2023-05-25	\N	1	0	3	177	0	0	0	0	0	2026-11-23 16:10:11.399+00	2026-11-23 16:10:11.399+00
131	85	12	Hayat Athletic	\N	2023-01-23	2024-05-06	9	3	9	3054	2	1	0	0	0	2026-11-23 16:10:11.406+00	2026-11-23 16:10:11.406+00
132	85	5	Union Sportive Mohammadia	\N	2024-05-06	\N	0	0	1	19	0	0	0	0	0	2026-11-23 16:10:11.409+00	2026-11-23 16:10:11.409+00
133	86	5	Union Sportive Mohammadia	\N	2025-06-28	\N	0	0	2	158	0	0	0	0	0	2026-11-23 16:10:11.42+00	2026-11-23 16:10:11.42+00
134	87	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2026-03-26	4	0	12	2225	4	0	0	0	0	2026-11-23 16:10:11.43+00	2026-11-23 16:10:11.43+00
135	87	5	Union Sportive Mohammadia	\N	2026-03-26	\N	1	0	3	270	0	1	0	0	0	2026-11-23 16:10:11.433+00	2026-11-23 16:10:11.433+00
136	88	16	Mejd Ancienne Medina	\N	2023-01-23	2025-08-12	5	8	27	828	0	1	0	0	0	2026-11-23 16:10:11.439+00	2026-11-23 16:10:11.439+00
137	88	5	Union Sportive Mohammadia	\N	2025-08-12	\N	0	1	3	270	1	0	0	0	0	2026-11-23 16:10:11.442+00	2026-11-23 16:10:11.442+00
138	89	5	Union Sportive Mohammadia	\N	2024-03-28	\N	1	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.448+00	2026-11-23 16:10:11.448+00
139	90	5	Union Sportive Mohammadia	\N	2024-02-04	\N	0	0	4	360	0	0	0	0	0	2026-11-23 16:10:11.455+00	2026-11-23 16:10:11.455+00
140	91	6	Tihad Athletic Sportif	\N	2025-12-22	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.459+00	2026-11-23 16:10:11.459+00
141	92	6	Tihad Athletic Sportif	\N	2023-01-13	\N	0	0	4	360	0	0	1	13	0	2026-11-23 16:10:11.464+00	2026-11-23 16:10:11.464+00
142	93	13	Chabab Fida	\N	2023-01-23	2025-06-07	9	5	18	813	4	0	0	0	0	2026-11-23 16:10:11.469+00	2026-11-23 16:10:11.469+00
143	93	6	Tihad Athletic Sportif	\N	2025-06-07	\N	0	1	4	338	1	0	0	0	0	2026-11-23 16:10:11.474+00	2026-11-23 16:10:11.474+00
144	94	6	Tihad Athletic Sportif	\N	2023-11-10	\N	0	0	4	265	0	0	0	0	0	2026-11-23 16:10:11.485+00	2026-11-23 16:10:11.485+00
145	95	11	Racing Athletic Sportif	\N	2023-01-23	2023-08-28	2	4	14	2434	3	1	0	0	0	2026-11-23 16:10:11.498+00	2026-11-23 16:10:11.498+00
146	95	6	Tihad Athletic Sportif	\N	2023-08-28	\N	0	1	4	283	1	0	0	0	0	2026-11-23 16:10:11.505+00	2026-11-23 16:10:11.505+00
147	96	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2025-02-19	6	8	23	1374	3	1	0	0	0	2026-11-23 16:10:11.514+00	2026-11-23 16:10:11.514+00
148	96	6	Tihad Athletic Sportif	\N	2025-02-19	\N	1	0	4	251	0	0	0	0	0	2026-11-23 16:10:11.518+00	2026-11-23 16:10:11.518+00
149	97	6	Tihad Athletic Sportif	\N	2023-04-19	\N	0	0	4	185	0	0	0	0	0	2026-11-23 16:10:11.525+00	2026-11-23 16:10:11.525+00
150	98	2	Raja Club Athletic	\N	2023-01-23	2025-12-30	10	8	30	2162	2	1	0	0	0	2026-11-23 16:10:11.53+00	2026-11-23 16:10:11.53+00
151	98	6	Tihad Athletic Sportif	\N	2025-12-30	\N	0	0	4	118	0	0	0	0	0	2026-11-23 16:10:11.532+00	2026-11-23 16:10:11.532+00
152	99	6	Tihad Athletic Sportif	\N	2024-07-02	\N	0	0	4	148	0	0	0	0	0	2026-11-23 16:10:11.536+00	2026-11-23 16:10:11.536+00
153	100	6	Tihad Athletic Sportif	\N	2023-11-11	\N	0	1	2	158	2	0	0	0	0	2026-11-23 16:10:11.539+00	2026-11-23 16:10:11.539+00
154	101	11	Racing Athletic Sportif	\N	2023-01-23	2025-03-31	5	4	38	792	3	1	0	0	0	2026-11-23 16:10:11.543+00	2026-11-23 16:10:11.543+00
155	101	6	Tihad Athletic Sportif	\N	2025-03-31	\N	0	0	3	254	1	0	0	0	0	2026-11-23 16:10:11.545+00	2026-11-23 16:10:11.545+00
156	102	6	Tihad Athletic Sportif	\N	2023-03-25	\N	1	0	3	242	0	0	0	0	0	2026-11-23 16:10:11.55+00	2026-11-23 16:10:11.55+00
157	103	6	Tihad Athletic Sportif	\N	2023-06-02	\N	0	0	1	28	0	0	0	0	0	2026-11-23 16:10:11.554+00	2026-11-23 16:10:11.554+00
158	104	4	Sporting Chabab Mohammadia	\N	2023-01-23	2025-08-29	11	7	33	2131	2	1	0	0	0	2026-11-23 16:10:11.558+00	2026-11-23 16:10:11.558+00
159	104	6	Tihad Athletic Sportif	\N	2025-08-29	\N	1	0	3	250	0	0	0	0	0	2026-11-23 16:10:11.56+00	2026-11-23 16:10:11.56+00
160	105	6	Tihad Athletic Sportif	\N	2025-08-19	\N	0	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.564+00	2026-11-23 16:10:11.564+00
161	106	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2024-04-17	8	6	37	2378	0	0	0	0	0	2026-11-23 16:10:11.567+00	2026-11-23 16:10:11.567+00
162	106	6	Tihad Athletic Sportif	\N	2024-04-17	\N	0	0	3	270	1	0	0	0	0	2026-11-23 16:10:11.569+00	2026-11-23 16:10:11.569+00
163	107	1	Wydad Athletic Club	\N	2023-01-23	2024-02-05	8	7	20	1091	4	0	0	0	0	2026-11-23 16:10:11.572+00	2026-11-23 16:10:11.572+00
164	107	6	Tihad Athletic Sportif	\N	2024-02-05	\N	0	0	3	270	1	0	0	0	0	2026-11-23 16:10:11.574+00	2026-11-23 16:10:11.574+00
165	108	11	Racing Athletic Sportif	\N	2023-01-23	2025-05-20	4	6	16	1102	1	1	0	0	0	2026-11-23 16:10:11.578+00	2026-11-23 16:10:11.578+00
166	108	6	Tihad Athletic Sportif	\N	2025-05-20	\N	1	1	4	360	0	0	0	0	0	2026-11-23 16:10:11.581+00	2026-11-23 16:10:11.581+00
167	109	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-10-26	\N	0	0	1	90	0	0	1	5	0	2026-11-23 16:10:11.587+00	2026-11-23 16:10:11.587+00
168	110	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2026-04-14	6	0	40	949	4	1	0	0	0	2026-11-23 16:10:11.593+00	2026-11-23 16:10:11.593+00
169	110	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-04-14	\N	0	0	3	270	0	0	0	9	0	2026-11-23 16:10:11.595+00	2026-11-23 16:10:11.595+00
170	111	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2025-08-07	11	8	29	2551	2	1	0	0	0	2026-11-23 16:10:11.602+00	2026-11-23 16:10:11.602+00
171	111	7	Nadi Difaa Riadi Ain Sebaa	\N	2025-08-07	\N	3	0	4	360	0	0	0	0	0	2026-11-23 16:10:11.604+00	2026-11-23 16:10:11.604+00
172	112	7	Nadi Difaa Riadi Ain Sebaa	\N	2024-04-25	\N	0	0	4	154	0	0	0	0	0	2026-11-23 16:10:11.608+00	2026-11-23 16:10:11.608+00
173	113	4	Sporting Chabab Mohammadia	\N	2023-01-23	2026-01-17	3	6	24	2898	3	1	0	0	0	2026-11-23 16:10:11.612+00	2026-11-23 16:10:11.612+00
174	113	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-01-17	\N	1	0	4	248	0	0	0	0	0	2026-11-23 16:10:11.615+00	2026-11-23 16:10:11.615+00
175	114	7	Nadi Difaa Riadi Ain Sebaa	\N	2025-07-08	\N	1	1	4	325	0	1	0	0	0	2026-11-23 16:10:11.621+00	2026-11-23 16:10:11.621+00
176	115	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-07-19	\N	1	0	4	187	0	0	0	0	0	2026-11-23 16:10:11.625+00	2026-11-23 16:10:11.625+00
177	116	1	Wydad Athletic Club	\N	2023-01-23	2026-01-08	5	6	10	1284	4	0	0	0	0	2026-11-23 16:10:11.629+00	2026-11-23 16:10:11.629+00
178	116	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-01-08	\N	0	1	4	166	0	0	0	0	0	2026-11-23 16:10:11.63+00	2026-11-23 16:10:11.63+00
179	117	5	Union Sportive Mohammadia	\N	2023-01-23	2025-04-10	10	5	15	2509	2	0	0	0	0	2026-11-23 16:10:11.634+00	2026-11-23 16:10:11.634+00
180	117	7	Nadi Difaa Riadi Ain Sebaa	\N	2025-04-10	\N	0	0	3	147	1	0	0	0	0	2026-11-23 16:10:11.636+00	2026-11-23 16:10:11.636+00
181	118	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-05-20	\N	0	0	2	94	0	0	0	0	0	2026-11-23 16:10:11.639+00	2026-11-23 16:10:11.639+00
182	119	7	Nadi Difaa Riadi Ain Sebaa	\N	2025-12-22	\N	1	0	4	299	0	1	0	0	0	2026-11-23 16:10:11.643+00	2026-11-23 16:10:11.643+00
183	120	7	Nadi Difaa Riadi Ain Sebaa	\N	2022-10-16	\N	0	1	4	301	1	0	0	0	0	2026-11-23 16:10:11.647+00	2026-11-23 16:10:11.647+00
184	121	3	AS Lafarge Maroc	\N	2023-01-23	2026-03-08	8	4	12	1488	6	0	0	0	0	2026-11-23 16:10:11.653+00	2026-11-23 16:10:11.653+00
185	121	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-03-08	\N	0	0	3	158	1	0	0	0	0	2026-11-23 16:10:11.655+00	2026-11-23 16:10:11.655+00
186	122	11	Racing Athletic Sportif	\N	2023-01-23	2023-07-20	10	6	39	1959	4	1	0	0	0	2026-11-23 16:10:11.659+00	2026-11-23 16:10:11.659+00
187	122	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-07-20	\N	0	1	1	81	0	0	0	0	0	2026-11-23 16:10:11.661+00	2026-11-23 16:10:11.661+00
188	123	1	Wydad Athletic Club	\N	2023-01-23	2026-04-22	0	8	17	2183	2	0	0	0	0	2026-11-23 16:10:11.665+00	2026-11-23 16:10:11.665+00
189	123	7	Nadi Difaa Riadi Ain Sebaa	\N	2026-04-22	\N	1	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.668+00	2026-11-23 16:10:11.668+00
190	124	7	Nadi Difaa Riadi Ain Sebaa	\N	2024-11-29	\N	0	2	3	270	1	0	0	0	0	2026-11-23 16:10:11.673+00	2026-11-23 16:10:11.673+00
191	125	1	Wydad Athletic Club	\N	2023-01-23	2024-12-18	2	7	19	3103	2	0	0	0	0	2026-11-23 16:10:11.677+00	2026-11-23 16:10:11.677+00
192	125	7	Nadi Difaa Riadi Ain Sebaa	\N	2024-12-18	\N	0	0	2	180	0	1	0	0	0	2026-11-23 16:10:11.68+00	2026-11-23 16:10:11.68+00
193	126	7	Nadi Difaa Riadi Ain Sebaa	\N	2024-08-29	\N	0	0	4	360	0	0	0	0	0	2026-11-23 16:10:11.689+00	2026-11-23 16:10:11.689+00
194	127	4	Sporting Chabab Mohammadia	\N	2023-01-23	2023-09-12	2	7	38	949	5	1	0	0	0	2026-11-23 16:10:11.699+00	2026-11-23 16:10:11.699+00
195	127	8	Rachad Bernoussi	\N	2023-09-12	\N	0	0	1	90	0	0	0	7	0	2026-11-23 16:10:11.702+00	2026-11-23 16:10:11.702+00
196	128	1	Wydad Athletic Club	\N	2023-01-23	2024-09-18	0	4	31	1936	3	0	0	0	0	2026-11-23 16:10:11.71+00	2026-11-23 16:10:11.71+00
197	128	8	Rachad Bernoussi	\N	2024-09-18	\N	0	0	3	270	0	0	1	17	0	2026-11-23 16:10:11.715+00	2026-11-23 16:10:11.715+00
198	129	8	Rachad Bernoussi	\N	2024-02-26	\N	0	0	4	225	0	0	0	0	0	2026-11-23 16:10:11.727+00	2026-11-23 16:10:11.727+00
199	130	8	Rachad Bernoussi	\N	2023-04-24	\N	0	0	4	209	0	0	0	0	0	2026-11-23 16:10:11.734+00	2026-11-23 16:10:11.734+00
200	131	16	Mejd Ancienne Medina	\N	2023-01-23	2023-09-05	3	5	27	1794	1	1	0	0	0	2026-11-23 16:10:11.741+00	2026-11-23 16:10:11.741+00
201	131	8	Rachad Bernoussi	\N	2023-09-05	\N	1	0	4	234	0	0	0	0	0	2026-11-23 16:10:11.743+00	2026-11-23 16:10:11.743+00
202	132	8	Rachad Bernoussi	\N	2024-01-15	\N	0	0	4	322	1	0	0	0	0	2026-11-23 16:10:11.75+00	2026-11-23 16:10:11.75+00
203	133	2	Raja Club Athletic	\N	2023-01-23	2025-11-27	7	8	18	2986	6	0	0	0	0	2026-11-23 16:10:11.754+00	2026-11-23 16:10:11.754+00
204	133	8	Rachad Bernoussi	\N	2025-11-27	\N	0	0	4	175	0	0	0	0	0	2026-11-23 16:10:11.757+00	2026-11-23 16:10:11.757+00
205	134	15	Al Ahram Riadi	\N	2023-01-23	2025-01-24	0	3	21	2929	1	0	0	0	0	2026-11-23 16:10:11.764+00	2026-11-23 16:10:11.764+00
206	134	8	Rachad Bernoussi	\N	2025-01-24	\N	0	0	4	275	0	0	0	0	0	2026-11-23 16:10:11.768+00	2026-11-23 16:10:11.768+00
207	135	8	Rachad Bernoussi	\N	2024-04-17	\N	0	0	4	293	0	1	0	0	0	2026-11-23 16:10:11.772+00	2026-11-23 16:10:11.772+00
208	136	5	Union Sportive Mohammadia	\N	2023-01-23	2025-11-13	8	4	36	2127	6	0	0	0	0	2026-11-23 16:10:11.776+00	2026-11-23 16:10:11.776+00
209	136	8	Rachad Bernoussi	\N	2025-11-13	\N	0	0	4	299	0	0	0	0	0	2026-11-23 16:10:11.779+00	2026-11-23 16:10:11.779+00
210	137	8	Rachad Bernoussi	\N	2024-07-16	\N	0	0	3	71	0	0	0	0	0	2026-11-23 16:10:11.783+00	2026-11-23 16:10:11.783+00
211	138	3	AS Lafarge Maroc	\N	2023-01-23	2024-03-26	3	3	40	2858	6	1	0	0	0	2026-11-23 16:10:11.79+00	2026-11-23 16:10:11.79+00
212	138	8	Rachad Bernoussi	\N	2024-03-26	\N	0	0	3	119	0	0	0	0	0	2026-11-23 16:10:11.793+00	2026-11-23 16:10:11.793+00
213	139	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2024-03-15	1	7	32	704	2	0	0	0	0	2026-11-23 16:10:11.798+00	2026-11-23 16:10:11.798+00
214	139	8	Rachad Bernoussi	\N	2024-03-15	\N	0	0	3	220	0	0	0	0	0	2026-11-23 16:10:11.801+00	2026-11-23 16:10:11.801+00
215	140	8	Rachad Bernoussi	\N	2026-01-28	\N	0	0	1	78	0	0	0	0	0	2026-11-23 16:10:11.805+00	2026-11-23 16:10:11.805+00
216	141	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2023-03-03	4	7	21	1467	1	0	0	0	0	2026-11-23 16:10:11.812+00	2026-11-23 16:10:11.812+00
217	141	8	Rachad Bernoussi	\N	2023-03-03	\N	0	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.816+00	2026-11-23 16:10:11.816+00
218	142	8	Rachad Bernoussi	\N	2024-01-31	\N	0	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.823+00	2026-11-23 16:10:11.823+00
219	143	8	Rachad Bernoussi	\N	2024-10-05	\N	1	0	4	360	1	0	0	0	0	2026-11-23 16:10:11.827+00	2026-11-23 16:10:11.827+00
220	144	8	Rachad Bernoussi	\N	2024-11-18	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:11.832+00	2026-11-23 16:10:11.832+00
221	145	8	Rachad Bernoussi	\N	2023-01-23	2024-06-10	9	7	38	2820	2	1	0	0	0	2026-11-23 16:10:11.838+00	2026-11-23 16:10:11.838+00
222	145	9	Athletic Youssoufia Berrechid	\N	2024-06-10	\N	0	0	1	90	0	0	1	6	0	2026-11-23 16:10:11.84+00	2026-11-23 16:10:11.84+00
223	146	9	Athletic Youssoufia Berrechid	\N	2026-06-06	\N	0	0	2	180	0	0	0	9	0	2026-11-23 16:10:11.846+00	2026-11-23 16:10:11.846+00
224	147	12	Hayat Athletic	\N	2023-01-23	2024-01-01	10	8	39	2616	4	0	0	0	0	2026-11-23 16:10:11.85+00	2026-11-23 16:10:11.85+00
225	147	9	Athletic Youssoufia Berrechid	\N	2024-01-01	\N	1	0	3	175	1	0	0	0	0	2026-11-23 16:10:11.852+00	2026-11-23 16:10:11.852+00
226	148	9	Athletic Youssoufia Berrechid	\N	2025-04-06	\N	0	1	3	159	1	0	0	0	0	2026-11-23 16:10:11.859+00	2026-11-23 16:10:11.859+00
227	149	9	Athletic Youssoufia Berrechid	\N	2025-06-15	\N	0	0	3	190	0	1	0	0	0	2026-11-23 16:10:11.866+00	2026-11-23 16:10:11.866+00
228	150	1	Wydad Athletic Club	\N	2023-01-23	2024-07-15	0	2	32	2156	3	0	0	0	0	2026-11-23 16:10:11.871+00	2026-11-23 16:10:11.871+00
229	150	9	Athletic Youssoufia Berrechid	\N	2024-07-15	\N	0	0	3	214	0	0	0	0	0	2026-11-23 16:10:11.873+00	2026-11-23 16:10:11.873+00
230	151	9	Athletic Youssoufia Berrechid	\N	2024-11-30	\N	0	1	3	127	0	0	0	0	0	2026-11-23 16:10:11.877+00	2026-11-23 16:10:11.877+00
231	152	3	AS Lafarge Maroc	\N	2023-01-23	2026-04-23	2	2	17	1384	1	1	0	0	0	2026-11-23 16:10:11.881+00	2026-11-23 16:10:11.881+00
232	152	9	Athletic Youssoufia Berrechid	\N	2026-04-23	\N	1	1	3	215	0	0	0	0	0	2026-11-23 16:10:11.884+00	2026-11-23 16:10:11.884+00
233	153	4	Sporting Chabab Mohammadia	\N	2023-01-23	2024-02-20	8	1	10	2276	2	0	0	0	0	2026-11-23 16:10:11.888+00	2026-11-23 16:10:11.888+00
234	153	9	Athletic Youssoufia Berrechid	\N	2024-02-20	\N	1	0	3	173	0	0	0	0	0	2026-11-23 16:10:11.89+00	2026-11-23 16:10:11.89+00
235	154	9	Athletic Youssoufia Berrechid	\N	2023-07-30	\N	0	0	1	79	0	0	0	0	0	2026-11-23 16:10:11.893+00	2026-11-23 16:10:11.893+00
236	155	9	Athletic Youssoufia Berrechid	\N	2024-05-01	\N	0	0	3	200	0	0	0	0	0	2026-11-23 16:10:11.897+00	2026-11-23 16:10:11.897+00
237	156	2	Raja Club Athletic	\N	2023-01-23	2023-07-13	2	2	39	618	4	1	0	0	0	2026-11-23 16:10:11.906+00	2026-11-23 16:10:11.906+00
238	156	9	Athletic Youssoufia Berrechid	\N	2023-07-13	\N	1	0	3	191	0	0	0	0	0	2026-11-23 16:10:11.91+00	2026-11-23 16:10:11.91+00
239	157	15	Al Ahram Riadi	\N	2023-01-23	2025-10-12	8	5	30	2136	3	1	0	0	0	2026-11-23 16:10:11.915+00	2026-11-23 16:10:11.915+00
240	157	9	Athletic Youssoufia Berrechid	\N	2025-10-12	\N	1	0	2	167	1	0	0	0	0	2026-11-23 16:10:11.919+00	2026-11-23 16:10:11.919+00
241	158	9	Athletic Youssoufia Berrechid	\N	2026-08-24	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.925+00	2026-11-23 16:10:11.925+00
242	159	9	Athletic Youssoufia Berrechid	\N	2025-08-26	\N	1	1	2	180	1	0	0	0	0	2026-11-23 16:10:11.936+00	2026-11-23 16:10:11.936+00
243	160	9	Athletic Youssoufia Berrechid	\N	2024-06-24	\N	0	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.945+00	2026-11-23 16:10:11.945+00
244	161	9	Athletic Youssoufia Berrechid	\N	2026-01-22	\N	1	0	2	180	0	0	0	0	0	2026-11-23 16:10:11.952+00	2026-11-23 16:10:11.952+00
245	162	9	Athletic Youssoufia Berrechid	\N	2025-11-17	\N	1	0	3	270	0	0	0	0	0	2026-11-23 16:10:11.96+00	2026-11-23 16:10:11.96+00
246	163	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2022-12-22	10	8	40	2755	0	0	0	0	0	2026-11-23 16:10:11.964+00	2026-11-23 16:10:11.964+00
247	163	10	Etoile Jeunesse Sportive Casa	\N	2022-12-22	\N	0	0	1	90	0	0	0	2	0	2026-11-23 16:10:11.967+00	2026-11-23 16:10:11.967+00
248	164	5	Union Sportive Mohammadia	\N	2023-01-23	2026-08-29	7	2	13	2816	3	0	0	0	0	2026-11-23 16:10:11.971+00	2026-11-23 16:10:11.971+00
249	164	10	Etoile Jeunesse Sportive Casa	\N	2026-08-29	\N	0	0	1	90	0	0	0	1	0	2026-11-23 16:10:11.974+00	2026-11-23 16:10:11.974+00
250	165	6	Tihad Athletic Sportif	\N	2023-01-23	2026-01-19	12	1	39	2078	5	0	0	0	0	2026-11-23 16:10:11.98+00	2026-11-23 16:10:11.98+00
251	165	10	Etoile Jeunesse Sportive Casa	\N	2026-01-19	\N	0	0	2	100	0	0	0	0	0	2026-11-23 16:10:11.982+00	2026-11-23 16:10:11.982+00
252	166	10	Etoile Jeunesse Sportive Casa	\N	2023-02-10	\N	0	0	2	170	0	0	0	0	0	2026-11-23 16:10:11.985+00	2026-11-23 16:10:11.985+00
253	167	10	Etoile Jeunesse Sportive Casa	\N	2026-07-28	\N	0	0	2	99	1	0	0	0	0	2026-11-23 16:10:11.988+00	2026-11-23 16:10:11.988+00
254	168	10	Etoile Jeunesse Sportive Casa	\N	2025-05-07	\N	1	0	2	163	0	0	0	0	0	2026-11-23 16:10:11.991+00	2026-11-23 16:10:11.991+00
255	169	1	Wydad Athletic Club	\N	2023-01-23	2024-02-27	11	2	16	3117	6	0	0	0	0	2026-11-23 16:10:11.995+00	2026-11-23 16:10:11.995+00
256	169	10	Etoile Jeunesse Sportive Casa	\N	2024-02-27	\N	0	0	2	104	0	0	0	0	0	2026-11-23 16:10:11.997+00	2026-11-23 16:10:11.997+00
257	170	10	Etoile Jeunesse Sportive Casa	\N	2024-05-05	\N	0	0	2	84	0	0	0	0	0	2026-11-23 16:10:12+00	2026-11-23 16:10:12+00
258	171	10	Etoile Jeunesse Sportive Casa	\N	2025-10-06	\N	1	0	2	157	1	0	0	0	0	2026-11-23 16:10:12.004+00	2026-11-23 16:10:12.004+00
259	172	10	Etoile Jeunesse Sportive Casa	\N	2023-06-29	\N	0	1	2	105	1	0	0	0	0	2026-11-23 16:10:12.008+00	2026-11-23 16:10:12.008+00
260	173	10	Etoile Jeunesse Sportive Casa	\N	2023-03-31	\N	1	0	2	98	0	0	0	0	0	2026-11-23 16:10:12.014+00	2026-11-23 16:10:12.014+00
261	174	15	Al Ahram Riadi	\N	2023-01-23	2024-02-21	12	1	8	1661	3	0	0	0	0	2026-11-23 16:10:12.021+00	2026-11-23 16:10:12.021+00
262	174	10	Etoile Jeunesse Sportive Casa	\N	2024-02-21	\N	0	1	2	154	0	0	0	0	0	2026-11-23 16:10:12.026+00	2026-11-23 16:10:12.026+00
263	175	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2023-01-13	6	4	25	738	0	1	0	0	0	2026-11-23 16:10:12.03+00	2026-11-23 16:10:12.03+00
264	175	10	Etoile Jeunesse Sportive Casa	\N	2023-01-13	\N	0	0	1	26	0	0	0	0	0	2026-11-23 16:10:12.034+00	2026-11-23 16:10:12.034+00
265	176	10	Etoile Jeunesse Sportive Casa	\N	2023-01-04	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.041+00	2026-11-23 16:10:12.041+00
266	177	10	Etoile Jeunesse Sportive Casa	\N	2024-02-21	\N	1	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.046+00	2026-11-23 16:10:12.046+00
267	178	10	Etoile Jeunesse Sportive Casa	\N	2025-06-16	\N	0	0	2	180	0	0	0	0	0	2026-11-23 16:10:12.051+00	2026-11-23 16:10:12.051+00
268	179	10	Etoile Jeunesse Sportive Casa	\N	2025-01-25	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.056+00	2026-11-23 16:10:12.056+00
269	180	10	Etoile Jeunesse Sportive Casa	\N	2026-07-16	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:12.061+00	2026-11-23 16:10:12.061+00
270	181	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2025-02-15	2	8	10	1636	1	1	0	0	0	2026-11-23 16:10:12.064+00	2026-11-23 16:10:12.064+00
271	181	11	Racing Athletic Sportif	\N	2025-02-15	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.066+00	2026-11-23 16:10:12.066+00
272	182	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2025-10-20	7	5	11	2382	2	1	0	0	0	2026-11-23 16:10:12.07+00	2026-11-23 16:10:12.07+00
273	182	11	Racing Athletic Sportif	\N	2025-10-20	\N	0	0	1	90	0	0	0	5	0	2026-11-23 16:10:12.073+00	2026-11-23 16:10:12.073+00
274	183	11	Racing Athletic Sportif	\N	2023-06-25	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.078+00	2026-11-23 16:10:12.078+00
275	184	11	Racing Athletic Sportif	\N	2024-08-24	\N	0	0	1	10	0	0	0	0	0	2026-11-23 16:10:12.083+00	2026-11-23 16:10:12.083+00
276	185	6	Tihad Athletic Sportif	\N	2023-01-23	2025-03-07	3	4	35	1169	4	1	0	0	0	2026-11-23 16:10:12.089+00	2026-11-23 16:10:12.089+00
277	185	11	Racing Athletic Sportif	\N	2025-03-07	\N	0	0	1	80	0	0	0	0	0	2026-11-23 16:10:12.091+00	2026-11-23 16:10:12.091+00
278	186	11	Racing Athletic Sportif	\N	2024-02-14	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.095+00	2026-11-23 16:10:12.095+00
279	187	11	Racing Athletic Sportif	\N	2023-09-29	\N	0	0	1	63	0	0	0	0	0	2026-11-23 16:10:12.1+00	2026-11-23 16:10:12.1+00
280	188	11	Racing Athletic Sportif	\N	2025-04-08	\N	0	0	1	27	0	0	0	0	0	2026-11-23 16:10:12.104+00	2026-11-23 16:10:12.104+00
281	189	11	Racing Athletic Sportif	\N	2023-08-11	\N	0	0	1	35	0	0	0	0	0	2026-11-23 16:10:12.109+00	2026-11-23 16:10:12.109+00
282	190	11	Racing Athletic Sportif	\N	2024-04-10	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.116+00	2026-11-23 16:10:12.116+00
283	191	11	Racing Athletic Sportif	\N	2025-04-20	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.123+00	2026-11-23 16:10:12.123+00
284	192	11	Racing Athletic Sportif	\N	2023-06-23	\N	0	0	1	55	0	0	0	0	0	2026-11-23 16:10:12.129+00	2026-11-23 16:10:12.129+00
285	193	11	Racing Athletic Sportif	\N	2024-11-13	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.135+00	2026-11-23 16:10:12.135+00
286	194	1	Wydad Athletic Club	\N	2023-01-23	2026-01-06	8	6	24	1962	6	0	0	0	0	2026-11-23 16:10:12.144+00	2026-11-23 16:10:12.144+00
287	194	11	Racing Athletic Sportif	\N	2026-01-06	\N	0	0	1	90	1	0	0	0	0	2026-11-23 16:10:12.149+00	2026-11-23 16:10:12.149+00
288	195	11	Racing Athletic Sportif	\N	2024-09-22	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.158+00	2026-11-23 16:10:12.158+00
289	196	8	Rachad Bernoussi	\N	2023-01-23	2026-04-04	6	5	23	2827	5	0	0	0	0	2026-11-23 16:10:12.166+00	2026-11-23 16:10:12.166+00
290	196	11	Racing Athletic Sportif	\N	2026-04-04	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.169+00	2026-11-23 16:10:12.169+00
291	197	12	Hayat Athletic	\N	2023-01-23	2026-07-30	0	0	33	2493	3	1	0	0	0	2026-11-23 16:10:12.177+00	2026-11-23 16:10:12.177+00
292	197	11	Racing Athletic Sportif	\N	2026-07-30	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.18+00	2026-11-23 16:10:12.18+00
293	198	11	Racing Athletic Sportif	\N	2026-05-10	\N	0	0	1	90	1	0	0	0	0	2026-11-23 16:10:12.185+00	2026-11-23 16:10:12.185+00
294	199	12	Hayat Athletic	\N	2023-01-11	\N	0	0	1	90	0	0	0	4	0	2026-11-23 16:10:12.19+00	2026-11-23 16:10:12.19+00
295	200	1	Wydad Athletic Club	\N	2023-01-23	2025-03-13	12	3	21	2699	1	0	0	0	0	2026-11-23 16:10:12.194+00	2026-11-23 16:10:12.194+00
296	200	12	Hayat Athletic	\N	2025-03-13	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.196+00	2026-11-23 16:10:12.196+00
297	201	3	AS Lafarge Maroc	\N	2023-01-23	2023-06-01	3	6	20	671	1	0	0	0	0	2026-11-23 16:10:12.2+00	2026-11-23 16:10:12.2+00
298	201	12	Hayat Athletic	\N	2023-06-01	\N	0	0	1	57	0	0	0	0	0	2026-11-23 16:10:12.202+00	2026-11-23 16:10:12.202+00
299	202	1	Wydad Athletic Club	\N	2023-01-23	2024-08-16	12	8	31	1851	0	0	0	0	0	2026-11-23 16:10:12.207+00	2026-11-23 16:10:12.207+00
300	202	12	Hayat Athletic	\N	2024-08-16	\N	0	0	1	33	0	0	0	0	0	2026-11-23 16:10:12.208+00	2026-11-23 16:10:12.208+00
301	203	12	Hayat Athletic	\N	2023-10-22	\N	0	0	1	66	0	0	0	0	0	2026-11-23 16:10:12.212+00	2026-11-23 16:10:12.212+00
302	204	12	Hayat Athletic	\N	2024-09-12	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.216+00	2026-11-23 16:10:12.216+00
303	205	12	Hayat Athletic	\N	2025-11-27	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.221+00	2026-11-23 16:10:12.221+00
304	206	12	Hayat Athletic	\N	2024-05-06	\N	0	0	1	24	0	0	0	0	0	2026-11-23 16:10:12.226+00	2026-11-23 16:10:12.226+00
305	207	5	Union Sportive Mohammadia	\N	2023-01-23	2024-10-26	9	3	36	1722	0	0	0	0	0	2026-11-23 16:10:12.231+00	2026-11-23 16:10:12.231+00
306	207	12	Hayat Athletic	\N	2024-10-26	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.233+00	2026-11-23 16:10:12.233+00
307	208	12	Hayat Athletic	\N	2024-02-18	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.237+00	2026-11-23 16:10:12.237+00
308	209	12	Hayat Athletic	\N	2023-01-02	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.241+00	2026-11-23 16:10:12.241+00
309	210	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2025-08-13	8	0	30	2398	1	1	0	0	0	2026-11-23 16:10:12.249+00	2026-11-23 16:10:12.249+00
310	210	12	Hayat Athletic	\N	2025-08-13	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.254+00	2026-11-23 16:10:12.254+00
311	211	5	Union Sportive Mohammadia	\N	2023-01-23	2024-09-05	5	6	17	1664	5	1	0	0	0	2026-11-23 16:10:12.26+00	2026-11-23 16:10:12.26+00
312	211	12	Hayat Athletic	\N	2024-09-05	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.263+00	2026-11-23 16:10:12.263+00
313	212	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2025-04-28	0	1	27	2354	1	1	0	0	0	2026-11-23 16:10:12.269+00	2026-11-23 16:10:12.269+00
314	212	12	Hayat Athletic	\N	2025-04-28	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.271+00	2026-11-23 16:10:12.271+00
315	213	16	Mejd Ancienne Medina	\N	2023-01-23	2025-11-13	5	6	26	828	3	1	0	0	0	2026-11-23 16:10:12.274+00	2026-11-23 16:10:12.274+00
316	213	12	Hayat Athletic	\N	2025-11-13	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.277+00	2026-11-23 16:10:12.277+00
317	214	12	Hayat Athletic	\N	2023-12-20	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.282+00	2026-11-23 16:10:12.282+00
318	215	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2026-07-18	7	1	8	2608	6	0	0	0	0	2026-11-23 16:10:12.288+00	2026-11-23 16:10:12.288+00
319	215	12	Hayat Athletic	\N	2026-07-18	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.293+00	2026-11-23 16:10:12.293+00
320	216	12	Hayat Athletic	\N	2026-03-09	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.3+00	2026-11-23 16:10:12.3+00
321	217	15	Al Ahram Riadi	\N	2023-01-23	2024-05-21	0	1	29	2179	6	0	0	0	0	2026-11-23 16:10:12.305+00	2026-11-23 16:10:12.305+00
322	217	13	Chabab Fida	\N	2024-05-21	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.306+00	2026-11-23 16:10:12.306+00
323	218	13	Chabab Fida	\N	2025-03-23	\N	0	0	2	180	0	0	0	10	0	2026-11-23 16:10:12.309+00	2026-11-23 16:10:12.309+00
324	219	2	Raja Club Athletic	\N	2023-01-23	2024-11-02	2	8	26	3148	2	0	0	0	0	2026-11-23 16:10:12.314+00	2026-11-23 16:10:12.314+00
325	219	13	Chabab Fida	\N	2024-11-02	\N	0	0	2	40	0	0	0	0	0	2026-11-23 16:10:12.317+00	2026-11-23 16:10:12.317+00
326	220	8	Rachad Bernoussi	\N	2023-01-23	2025-06-25	4	1	32	2285	2	0	0	0	0	2026-11-23 16:10:12.32+00	2026-11-23 16:10:12.32+00
327	220	13	Chabab Fida	\N	2025-06-25	\N	1	0	2	158	1	0	0	0	0	2026-11-23 16:10:12.321+00	2026-11-23 16:10:12.321+00
328	221	13	Chabab Fida	\N	2024-12-09	\N	0	0	2	151	0	0	0	0	0	2026-11-23 16:10:12.325+00	2026-11-23 16:10:12.325+00
329	222	13	Chabab Fida	\N	2025-08-13	\N	0	0	2	119	0	0	0	0	0	2026-11-23 16:10:12.329+00	2026-11-23 16:10:12.329+00
330	223	11	Racing Athletic Sportif	\N	2023-01-23	2024-10-12	2	6	35	2464	4	1	0	0	0	2026-11-23 16:10:12.332+00	2026-11-23 16:10:12.332+00
331	223	13	Chabab Fida	\N	2024-10-12	\N	1	1	2	149	0	0	0	0	0	2026-11-23 16:10:12.334+00	2026-11-23 16:10:12.334+00
332	224	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2024-01-25	6	7	12	683	1	0	0	0	0	2026-11-23 16:10:12.337+00	2026-11-23 16:10:12.337+00
333	224	13	Chabab Fida	\N	2024-01-25	\N	0	0	2	103	0	0	0	0	0	2026-11-23 16:10:12.339+00	2026-11-23 16:10:12.339+00
334	225	13	Chabab Fida	\N	2025-03-02	\N	0	1	2	123	0	0	0	0	0	2026-11-23 16:10:12.346+00	2026-11-23 16:10:12.346+00
335	226	13	Chabab Fida	\N	2026-07-25	\N	0	0	2	79	1	0	0	0	0	2026-11-23 16:10:12.355+00	2026-11-23 16:10:12.355+00
336	227	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2023-03-24	3	5	24	3001	3	1	0	0	0	2026-11-23 16:10:12.362+00	2026-11-23 16:10:12.362+00
337	227	13	Chabab Fida	\N	2023-03-24	\N	1	0	2	110	1	0	0	0	0	2026-11-23 16:10:12.369+00	2026-11-23 16:10:12.369+00
338	228	2	Raja Club Athletic	\N	2023-01-23	2023-06-12	2	8	18	3080	3	0	0	0	0	2026-11-23 16:10:12.379+00	2026-11-23 16:10:12.379+00
339	228	13	Chabab Fida	\N	2023-06-12	\N	0	1	1	81	0	0	0	0	0	2026-11-23 16:10:12.383+00	2026-11-23 16:10:12.383+00
340	229	13	Chabab Fida	\N	2024-01-01	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.389+00	2026-11-23 16:10:12.389+00
341	230	13	Chabab Fida	\N	2026-06-09	\N	0	0	2	147	1	0	0	0	0	2026-11-23 16:10:12.396+00	2026-11-23 16:10:12.396+00
342	231	2	Raja Club Athletic	\N	2023-01-23	2025-03-09	1	3	10	907	6	0	0	0	0	2026-11-23 16:10:12.4+00	2026-11-23 16:10:12.4+00
343	231	13	Chabab Fida	\N	2025-03-09	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:12.402+00	2026-11-23 16:10:12.402+00
344	232	13	Chabab Fida	\N	2023-10-25	\N	1	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.406+00	2026-11-23 16:10:12.406+00
345	233	8	Rachad Bernoussi	\N	2023-01-23	2024-04-30	9	2	18	829	3	0	0	0	0	2026-11-23 16:10:12.41+00	2026-11-23 16:10:12.41+00
346	233	13	Chabab Fida	\N	2024-04-30	\N	0	0	2	180	0	0	0	0	0	2026-11-23 16:10:12.412+00	2026-11-23 16:10:12.412+00
347	234	1	Wydad Athletic Club	\N	2023-01-23	2024-06-12	8	2	29	1314	2	0	0	0	0	2026-11-23 16:10:12.419+00	2026-11-23 16:10:12.419+00
348	234	13	Chabab Fida	\N	2024-06-12	\N	1	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.421+00	2026-11-23 16:10:12.421+00
349	235	14	Ennajjah Ryadi Mediouna	\N	2026-07-31	\N	0	0	1	90	0	0	0	7	0	2026-11-23 16:10:12.424+00	2026-11-23 16:10:12.424+00
350	236	11	Racing Athletic Sportif	\N	2023-01-23	2024-09-10	8	6	33	896	1	1	0	0	0	2026-11-23 16:10:12.427+00	2026-11-23 16:10:12.427+00
351	236	14	Ennajjah Ryadi Mediouna	\N	2024-09-10	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.429+00	2026-11-23 16:10:12.429+00
352	237	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2023-02-08	1	3	20	2853	2	1	0	0	0	2026-11-23 16:10:12.433+00	2026-11-23 16:10:12.433+00
353	237	14	Ennajjah Ryadi Mediouna	\N	2023-02-08	\N	0	0	1	72	0	0	0	0	0	2026-11-23 16:10:12.434+00	2026-11-23 16:10:12.434+00
354	238	3	AS Lafarge Maroc	\N	2023-01-23	2022-11-06	11	2	20	3068	0	1	0	0	0	2026-11-23 16:10:12.439+00	2026-11-23 16:10:12.439+00
355	238	14	Ennajjah Ryadi Mediouna	\N	2022-11-06	\N	0	0	1	62	0	0	0	0	0	2026-11-23 16:10:12.441+00	2026-11-23 16:10:12.441+00
356	239	14	Ennajjah Ryadi Mediouna	\N	2024-12-07	\N	0	0	1	28	0	0	0	0	0	2026-11-23 16:10:12.444+00	2026-11-23 16:10:12.444+00
357	240	13	Chabab Fida	\N	2023-01-23	2024-04-13	5	2	39	1924	3	1	0	0	0	2026-11-23 16:10:12.449+00	2026-11-23 16:10:12.449+00
358	240	14	Ennajjah Ryadi Mediouna	\N	2024-04-13	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.451+00	2026-11-23 16:10:12.451+00
359	241	15	Al Ahram Riadi	\N	2023-01-23	2024-01-02	11	2	17	2572	4	0	0	0	0	2026-11-23 16:10:12.454+00	2026-11-23 16:10:12.454+00
360	241	14	Ennajjah Ryadi Mediouna	\N	2024-01-02	\N	1	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.456+00	2026-11-23 16:10:12.456+00
361	242	14	Ennajjah Ryadi Mediouna	\N	2024-09-16	\N	0	0	1	18	0	0	0	0	0	2026-11-23 16:10:12.464+00	2026-11-23 16:10:12.464+00
362	243	14	Ennajjah Ryadi Mediouna	\N	2023-01-12	\N	1	0	1	83	0	0	0	0	0	2026-11-23 16:10:12.469+00	2026-11-23 16:10:12.469+00
363	244	14	Ennajjah Ryadi Mediouna	\N	2024-02-08	\N	0	0	1	7	0	0	0	0	0	2026-11-23 16:10:12.474+00	2026-11-23 16:10:12.474+00
364	245	4	Sporting Chabab Mohammadia	\N	2023-01-23	2022-11-12	8	1	26	2009	6	1	0	0	0	2026-11-23 16:10:12.48+00	2026-11-23 16:10:12.48+00
365	245	14	Ennajjah Ryadi Mediouna	\N	2022-11-12	\N	0	0	1	71	0	0	0	0	0	2026-11-23 16:10:12.483+00	2026-11-23 16:10:12.483+00
366	246	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2026-09-23	3	0	28	630	6	1	0	0	0	2026-11-23 16:10:12.487+00	2026-11-23 16:10:12.487+00
367	246	14	Ennajjah Ryadi Mediouna	\N	2026-09-23	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.49+00	2026-11-23 16:10:12.49+00
368	247	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2025-07-15	9	0	37	1089	3	0	0	0	0	2026-11-23 16:10:12.494+00	2026-11-23 16:10:12.494+00
369	247	14	Ennajjah Ryadi Mediouna	\N	2025-07-15	\N	0	0	1	19	0	0	0	0	0	2026-11-23 16:10:12.496+00	2026-11-23 16:10:12.496+00
370	248	14	Ennajjah Ryadi Mediouna	\N	2025-05-09	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.501+00	2026-11-23 16:10:12.501+00
371	249	14	Ennajjah Ryadi Mediouna	\N	2025-05-29	\N	0	1	1	90	0	0	0	0	0	2026-11-23 16:10:12.504+00	2026-11-23 16:10:12.504+00
372	250	14	Ennajjah Ryadi Mediouna	\N	2024-12-05	\N	1	0	1	90	1	0	0	0	0	2026-11-23 16:10:12.509+00	2026-11-23 16:10:12.509+00
373	251	2	Raja Club Athletic	\N	2023-01-23	2026-01-28	1	6	27	620	0	1	0	0	0	2026-11-23 16:10:12.513+00	2026-11-23 16:10:12.513+00
374	251	14	Ennajjah Ryadi Mediouna	\N	2026-01-28	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.514+00	2026-11-23 16:10:12.514+00
375	252	14	Ennajjah Ryadi Mediouna	\N	2023-09-21	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.518+00	2026-11-23 16:10:12.518+00
376	253	15	Al Ahram Riadi	\N	2023-05-07	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.521+00	2026-11-23 16:10:12.521+00
377	254	3	AS Lafarge Maroc	\N	2023-01-23	2022-12-06	4	5	20	3189	2	0	0	0	0	2026-11-23 16:10:12.525+00	2026-11-23 16:10:12.525+00
378	254	15	Al Ahram Riadi	\N	2022-12-06	\N	0	0	1	90	0	0	0	3	0	2026-11-23 16:10:12.526+00	2026-11-23 16:10:12.526+00
379	255	15	Al Ahram Riadi	\N	2023-05-05	\N	0	0	1	80	0	0	0	0	0	2026-11-23 16:10:12.53+00	2026-11-23 16:10:12.53+00
380	256	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2025-01-31	7	8	20	2197	1	0	0	0	0	2026-11-23 16:10:12.534+00	2026-11-23 16:10:12.534+00
381	256	15	Al Ahram Riadi	\N	2025-01-31	\N	0	0	1	10	0	0	0	0	0	2026-11-23 16:10:12.537+00	2026-11-23 16:10:12.537+00
382	257	15	Al Ahram Riadi	\N	2022-12-14	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.542+00	2026-11-23 16:10:12.542+00
383	258	15	Al Ahram Riadi	\N	2026-03-07	\N	0	0	1	83	0	0	0	0	0	2026-11-23 16:10:12.545+00	2026-11-23 16:10:12.545+00
384	259	13	Chabab Fida	\N	2023-01-23	2024-07-13	7	4	12	603	0	0	0	0	0	2026-11-23 16:10:12.549+00	2026-11-23 16:10:12.549+00
385	259	15	Al Ahram Riadi	\N	2024-07-13	\N	0	0	1	7	0	0	0	0	0	2026-11-23 16:10:12.552+00	2026-11-23 16:10:12.552+00
386	260	15	Al Ahram Riadi	\N	2023-05-23	\N	1	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.56+00	2026-11-23 16:10:12.56+00
387	261	15	Al Ahram Riadi	\N	2023-05-22	\N	0	0	1	55	0	0	0	0	0	2026-11-23 16:10:12.566+00	2026-11-23 16:10:12.566+00
388	262	15	Al Ahram Riadi	\N	2024-01-21	\N	0	0	1	13	0	0	0	0	0	2026-11-23 16:10:12.57+00	2026-11-23 16:10:12.57+00
389	263	15	Al Ahram Riadi	\N	2026-04-17	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.575+00	2026-11-23 16:10:12.575+00
390	264	12	Hayat Athletic	\N	2023-01-23	2025-10-09	10	3	25	2113	0	0	0	0	0	2026-11-23 16:10:12.584+00	2026-11-23 16:10:12.584+00
391	264	15	Al Ahram Riadi	\N	2025-10-09	\N	0	0	1	35	0	0	0	0	0	2026-11-23 16:10:12.588+00	2026-11-23 16:10:12.588+00
392	265	11	Racing Athletic Sportif	\N	2023-01-23	2024-11-18	5	2	21	1145	5	1	0	0	0	2026-11-23 16:10:12.596+00	2026-11-23 16:10:12.596+00
393	265	15	Al Ahram Riadi	\N	2024-11-18	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.598+00	2026-11-23 16:10:12.598+00
394	266	5	Union Sportive Mohammadia	\N	2023-01-23	2025-11-12	8	3	31	798	0	1	0	0	0	2026-11-23 16:10:12.605+00	2026-11-23 16:10:12.605+00
395	266	15	Al Ahram Riadi	\N	2025-11-12	\N	0	1	1	77	0	0	0	0	0	2026-11-23 16:10:12.607+00	2026-11-23 16:10:12.607+00
396	267	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2024-05-07	0	5	31	1683	0	1	0	0	0	2026-11-23 16:10:12.612+00	2026-11-23 16:10:12.612+00
397	267	15	Al Ahram Riadi	\N	2024-05-07	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.615+00	2026-11-23 16:10:12.615+00
398	268	15	Al Ahram Riadi	\N	2023-04-13	\N	0	0	1	90	1	0	0	0	0	2026-11-23 16:10:12.62+00	2026-11-23 16:10:12.62+00
399	269	12	Hayat Athletic	\N	2023-01-23	2024-12-28	2	0	18	1037	3	0	0	0	0	2026-11-23 16:10:12.625+00	2026-11-23 16:10:12.625+00
400	269	15	Al Ahram Riadi	\N	2024-12-28	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.628+00	2026-11-23 16:10:12.628+00
401	270	4	Sporting Chabab Mohammadia	\N	2023-01-23	2024-03-23	2	7	30	781	2	1	0	0	0	2026-11-23 16:10:12.634+00	2026-11-23 16:10:12.634+00
402	270	15	Al Ahram Riadi	\N	2024-03-23	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.636+00	2026-11-23 16:10:12.636+00
403	271	10	Etoile Jeunesse Sportive Casa	\N	2023-01-23	2024-11-06	2	2	31	2697	0	0	0	0	0	2026-11-23 16:10:12.64+00	2026-11-23 16:10:12.64+00
404	271	16	Mejd Ancienne Medina	\N	2024-11-06	\N	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.641+00	2026-11-23 16:10:12.641+00
405	272	15	Al Ahram Riadi	\N	2023-01-23	2025-03-24	1	0	40	2675	3	1	0	0	0	2026-11-23 16:10:12.646+00	2026-11-23 16:10:12.646+00
406	272	16	Mejd Ancienne Medina	\N	2025-03-24	\N	0	0	3	270	0	0	1	13	0	2026-11-23 16:10:12.649+00	2026-11-23 16:10:12.649+00
407	273	8	Rachad Bernoussi	\N	2023-01-23	2023-03-15	2	3	20	1653	6	0	0	0	0	2026-11-23 16:10:12.653+00	2026-11-23 16:10:12.653+00
408	273	16	Mejd Ancienne Medina	\N	2023-03-15	\N	0	0	3	192	1	0	0	0	0	2026-11-23 16:10:12.655+00	2026-11-23 16:10:12.655+00
409	274	16	Mejd Ancienne Medina	\N	2024-11-14	\N	1	1	3	170	0	0	0	0	0	2026-11-23 16:10:12.659+00	2026-11-23 16:10:12.659+00
410	275	16	Mejd Ancienne Medina	\N	2022-11-02	\N	0	0	3	154	0	0	0	0	0	2026-11-23 16:10:12.662+00	2026-11-23 16:10:12.662+00
411	276	16	Mejd Ancienne Medina	\N	2022-11-30	\N	0	1	3	178	0	0	0	0	0	2026-11-23 16:10:12.665+00	2026-11-23 16:10:12.665+00
412	277	6	Tihad Athletic Sportif	\N	2023-01-23	2026-07-05	11	8	26	1697	1	0	0	0	0	2026-11-23 16:10:12.668+00	2026-11-23 16:10:12.668+00
413	277	16	Mejd Ancienne Medina	\N	2026-07-05	\N	1	0	3	210	0	0	0	0	0	2026-11-23 16:10:12.671+00	2026-11-23 16:10:12.671+00
414	278	9	Athletic Youssoufia Berrechid	\N	2023-01-23	2023-09-23	9	5	13	3104	3	0	0	0	0	2026-11-23 16:10:12.675+00	2026-11-23 16:10:12.675+00
415	278	16	Mejd Ancienne Medina	\N	2023-09-23	\N	0	0	3	176	0	0	0	0	0	2026-11-23 16:10:12.677+00	2026-11-23 16:10:12.677+00
416	279	13	Chabab Fida	\N	2023-01-23	2024-12-31	10	3	35	1829	6	0	0	0	0	2026-11-23 16:10:12.681+00	2026-11-23 16:10:12.681+00
417	279	16	Mejd Ancienne Medina	\N	2024-12-31	\N	0	0	2	107	0	0	0	0	0	2026-11-23 16:10:12.683+00	2026-11-23 16:10:12.683+00
418	280	13	Chabab Fida	\N	2023-01-23	2024-08-30	6	6	19	1461	0	0	0	0	0	2026-11-23 16:10:12.687+00	2026-11-23 16:10:12.687+00
419	280	16	Mejd Ancienne Medina	\N	2024-08-30	\N	1	0	2	103	0	0	0	0	0	2026-11-23 16:10:12.688+00	2026-11-23 16:10:12.688+00
420	281	14	Ennajjah Ryadi Mediouna	\N	2023-01-23	2025-02-28	11	5	25	1333	5	0	0	0	0	2026-11-23 16:10:12.691+00	2026-11-23 16:10:12.691+00
421	281	16	Mejd Ancienne Medina	\N	2025-02-28	\N	0	0	3	206	0	0	0	0	0	2026-11-23 16:10:12.692+00	2026-11-23 16:10:12.692+00
422	282	16	Mejd Ancienne Medina	\N	2024-03-09	\N	0	0	2	150	0	0	0	0	0	2026-11-23 16:10:12.695+00	2026-11-23 16:10:12.695+00
423	283	15	Al Ahram Riadi	\N	2023-01-23	2024-11-28	10	5	36	1445	2	0	0	0	0	2026-11-23 16:10:12.698+00	2026-11-23 16:10:12.698+00
424	283	16	Mejd Ancienne Medina	\N	2024-11-28	\N	2	0	2	154	0	0	0	0	0	2026-11-23 16:10:12.699+00	2026-11-23 16:10:12.699+00
425	284	8	Rachad Bernoussi	\N	2023-01-23	2024-11-16	10	7	27	2036	6	1	0	0	0	2026-11-23 16:10:12.703+00	2026-11-23 16:10:12.703+00
426	284	16	Mejd Ancienne Medina	\N	2024-11-16	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.704+00	2026-11-23 16:10:12.704+00
427	285	7	Nadi Difaa Riadi Ain Sebaa	\N	2023-01-23	2026-01-03	5	2	21	3108	5	0	0	0	0	2026-11-23 16:10:12.707+00	2026-11-23 16:10:12.707+00
428	285	16	Mejd Ancienne Medina	\N	2026-01-03	\N	0	2	3	270	1	0	0	0	0	2026-11-23 16:10:12.709+00	2026-11-23 16:10:12.709+00
429	286	12	Hayat Athletic	\N	2023-01-23	2025-11-18	9	8	22	3083	5	0	0	0	0	2026-11-23 16:10:12.713+00	2026-11-23 16:10:12.713+00
430	286	16	Mejd Ancienne Medina	\N	2025-11-18	\N	0	0	1	90	0	0	0	0	0	2026-11-23 16:10:12.715+00	2026-11-23 16:10:12.715+00
431	287	16	Mejd Ancienne Medina	\N	2023-02-05	\N	1	0	3	270	0	0	0	0	0	2026-11-23 16:10:12.72+00	2026-11-23 16:10:12.72+00
432	288	4	Sporting Chabab Mohammadia	\N	2023-01-23	2022-12-12	12	0	13	2144	3	1	0	0	0	2026-11-23 16:10:12.723+00	2026-11-23 16:10:12.723+00
433	288	16	Mejd Ancienne Medina	\N	2022-12-12	\N	0	1	2	180	0	0	0	0	0	2026-11-23 16:10:12.724+00	2026-11-23 16:10:12.724+00
\.


--
-- Data for Name: PlayerRewards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PlayerRewards" (id, "playerId", name, description, type, category, value, icon, "awardedById", "tournamentId", "createdAt", "updatedAt") FROM stdin;
1	145	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.704+00	2026-11-23 16:10:13.704+00
2	146	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.709+00	2026-11-23 16:10:13.709+00
3	147	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.714+00	2026-11-23 16:10:13.714+00
4	148	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.719+00	2026-11-23 16:10:13.719+00
5	149	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.723+00	2026-11-23 16:10:13.723+00
6	150	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.726+00	2026-11-23 16:10:13.726+00
7	151	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.731+00	2026-11-23 16:10:13.731+00
8	152	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.737+00	2026-11-23 16:10:13.737+00
9	153	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.741+00	2026-11-23 16:10:13.741+00
10	154	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.744+00	2026-11-23 16:10:13.744+00
11	155	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.747+00	2026-11-23 16:10:13.747+00
12	156	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.751+00	2026-11-23 16:10:13.751+00
13	157	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.754+00	2026-11-23 16:10:13.754+00
14	158	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.756+00	2026-11-23 16:10:13.756+00
15	159	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.759+00	2026-11-23 16:10:13.759+00
16	160	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.761+00	2026-11-23 16:10:13.761+00
17	161	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.766+00	2026-11-23 16:10:13.766+00
18	162	Prime de victoire	Prime collective Coupe U23	tournament	tournament	500	💰	\N	2	2026-11-23 16:10:13.769+00	2026-11-23 16:10:13.769+00
19	5	Joueur de la semaine	Récompense attribuée par le staff	milestone	special	100	🎖️	\N	\N	2026-11-23 16:10:13.775+00	2026-11-23 16:10:13.775+00
20	7	Joueur de la semaine	Récompense attribuée par le staff	milestone	milestone	100	🎖️	\N	\N	2026-11-23 16:10:13.778+00	2026-11-23 16:10:13.778+00
21	9	10 entraînements consécutifs	Récompense attribuée par le staff	training	milestone	150	🎖️	\N	\N	2026-11-23 16:10:13.784+00	2026-11-23 16:10:13.784+00
22	12	Joueur de la semaine	Récompense attribuée par le staff	training	special	100	🎖️	\N	\N	2026-11-23 16:10:13.788+00	2026-11-23 16:10:13.788+00
23	22	10 entraînements consécutifs	Récompense attribuée par le staff	special	special	200	🎖️	\N	\N	2026-11-23 16:10:13.797+00	2026-11-23 16:10:13.797+00
24	26	Premier but	Récompense attribuée par le staff	training	special	100	🎖️	\N	\N	2026-11-23 16:10:13.805+00	2026-11-23 16:10:13.805+00
25	28	Joueur de la semaine	Récompense attribuée par le staff	training	milestone	150	🎖️	\N	\N	2026-11-23 16:10:13.807+00	2026-11-23 16:10:13.807+00
26	41	Premier but	Récompense attribuée par le staff	training	milestone	50	🎖️	\N	\N	2026-11-23 16:10:13.819+00	2026-11-23 16:10:13.819+00
27	44	10 entraînements consécutifs	Récompense attribuée par le staff	training	milestone	150	🎖️	\N	\N	2026-11-23 16:10:13.822+00	2026-11-23 16:10:13.822+00
28	48	Premier but	Récompense attribuée par le staff	milestone	special	150	🎖️	\N	\N	2026-11-23 16:10:13.827+00	2026-11-23 16:10:13.827+00
29	49	Premier but	Récompense attribuée par le staff	special	milestone	150	🎖️	\N	\N	2026-11-23 16:10:13.83+00	2026-11-23 16:10:13.83+00
30	51	10 entraînements consécutifs	Récompense attribuée par le staff	special	special	100	🎖️	\N	\N	2026-11-23 16:10:13.838+00	2026-11-23 16:10:13.838+00
31	52	10 entraînements consécutifs	Récompense attribuée par le staff	training	training	100	🎖️	\N	\N	2026-11-23 16:10:13.84+00	2026-11-23 16:10:13.84+00
32	53	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:13.843+00	2026-11-23 16:10:13.843+00
33	57	Joueur de la semaine	Récompense attribuée par le staff	special	training	50	🎖️	\N	\N	2026-11-23 16:10:13.857+00	2026-11-23 16:10:13.857+00
34	58	Premier but	Récompense attribuée par le staff	milestone	milestone	100	🎖️	\N	\N	2026-11-23 16:10:13.861+00	2026-11-23 16:10:13.861+00
35	60	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:13.87+00	2026-11-23 16:10:13.87+00
36	61	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:13.872+00	2026-11-23 16:10:13.872+00
37	63	Joueur de la semaine	Récompense attribuée par le staff	milestone	milestone	200	🎖️	\N	\N	2026-11-23 16:10:13.875+00	2026-11-23 16:10:13.875+00
38	67	Premier but	Récompense attribuée par le staff	training	special	50	🎖️	\N	\N	2026-11-23 16:10:13.884+00	2026-11-23 16:10:13.884+00
39	72	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	milestone	50	🎖️	\N	\N	2026-11-23 16:10:13.892+00	2026-11-23 16:10:13.892+00
40	76	Premier but	Récompense attribuée par le staff	special	training	50	🎖️	\N	\N	2026-11-23 16:10:13.895+00	2026-11-23 16:10:13.895+00
41	83	Joueur de la semaine	Récompense attribuée par le staff	milestone	milestone	100	🎖️	\N	\N	2026-11-23 16:10:13.905+00	2026-11-23 16:10:13.905+00
42	87	Premier but	Récompense attribuée par le staff	special	training	150	🎖️	\N	\N	2026-11-23 16:10:13.913+00	2026-11-23 16:10:13.913+00
43	90	Premier but	Récompense attribuée par le staff	special	training	150	🎖️	\N	\N	2026-11-23 16:10:13.918+00	2026-11-23 16:10:13.918+00
44	94	Premier but	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:13.924+00	2026-11-23 16:10:13.924+00
45	96	Joueur de la semaine	Récompense attribuée par le staff	special	training	100	🎖️	\N	\N	2026-11-23 16:10:13.925+00	2026-11-23 16:10:13.925+00
46	98	Joueur de la semaine	Récompense attribuée par le staff	special	special	50	🎖️	\N	\N	2026-11-23 16:10:13.928+00	2026-11-23 16:10:13.928+00
47	104	10 entraînements consécutifs	Récompense attribuée par le staff	training	special	150	🎖️	\N	\N	2026-11-23 16:10:13.934+00	2026-11-23 16:10:13.934+00
48	108	10 entraînements consécutifs	Récompense attribuée par le staff	training	training	200	🎖️	\N	\N	2026-11-23 16:10:13.937+00	2026-11-23 16:10:13.937+00
49	110	10 entraînements consécutifs	Récompense attribuée par le staff	special	training	150	🎖️	\N	\N	2026-11-23 16:10:13.94+00	2026-11-23 16:10:13.94+00
50	115	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	200	🎖️	\N	\N	2026-11-23 16:10:13.944+00	2026-11-23 16:10:13.944+00
51	120	Joueur de la semaine	Récompense attribuée par le staff	special	special	200	🎖️	\N	\N	2026-11-23 16:10:13.948+00	2026-11-23 16:10:13.948+00
52	121	Joueur de la semaine	Récompense attribuée par le staff	special	special	50	🎖️	\N	\N	2026-11-23 16:10:13.953+00	2026-11-23 16:10:13.953+00
53	125	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:13.956+00	2026-11-23 16:10:13.956+00
54	132	Premier but	Récompense attribuée par le staff	milestone	training	100	🎖️	\N	\N	2026-11-23 16:10:13.964+00	2026-11-23 16:10:13.964+00
55	137	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	milestone	100	🎖️	\N	\N	2026-11-23 16:10:13.968+00	2026-11-23 16:10:13.968+00
56	138	Premier but	Récompense attribuée par le staff	milestone	training	100	🎖️	\N	\N	2026-11-23 16:10:13.97+00	2026-11-23 16:10:13.97+00
57	144	Joueur de la semaine	Récompense attribuée par le staff	special	training	150	🎖️	\N	\N	2026-11-23 16:10:13.974+00	2026-11-23 16:10:13.974+00
58	146	Joueur de la semaine	Récompense attribuée par le staff	training	milestone	150	🎖️	\N	\N	2026-11-23 16:10:13.976+00	2026-11-23 16:10:13.976+00
59	148	10 entraînements consécutifs	Récompense attribuée par le staff	special	special	50	🎖️	\N	\N	2026-11-23 16:10:13.98+00	2026-11-23 16:10:13.98+00
60	151	10 entraînements consécutifs	Récompense attribuée par le staff	special	training	200	🎖️	\N	\N	2026-11-23 16:10:13.986+00	2026-11-23 16:10:13.986+00
61	153	Premier but	Récompense attribuée par le staff	training	special	100	🎖️	\N	\N	2026-11-23 16:10:13.988+00	2026-11-23 16:10:13.988+00
62	155	Premier but	Récompense attribuée par le staff	training	training	150	🎖️	\N	\N	2026-11-23 16:10:13.991+00	2026-11-23 16:10:13.991+00
63	158	Joueur de la semaine	Récompense attribuée par le staff	special	special	50	🎖️	\N	\N	2026-11-23 16:10:13.994+00	2026-11-23 16:10:13.994+00
64	160	10 entraînements consécutifs	Récompense attribuée par le staff	special	training	50	🎖️	\N	\N	2026-11-23 16:10:14+00	2026-11-23 16:10:14+00
65	162	Premier but	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:14.003+00	2026-11-23 16:10:14.003+00
66	163	Premier but	Récompense attribuée par le staff	training	special	50	🎖️	\N	\N	2026-11-23 16:10:14.005+00	2026-11-23 16:10:14.005+00
67	165	Premier but	Récompense attribuée par le staff	training	special	150	🎖️	\N	\N	2026-11-23 16:10:14.007+00	2026-11-23 16:10:14.007+00
68	169	10 entraînements consécutifs	Récompense attribuée par le staff	training	milestone	100	🎖️	\N	\N	2026-11-23 16:10:14.008+00	2026-11-23 16:10:14.008+00
69	170	Premier but	Récompense attribuée par le staff	special	milestone	50	🎖️	\N	\N	2026-11-23 16:10:14.011+00	2026-11-23 16:10:14.011+00
70	172	Joueur de la semaine	Récompense attribuée par le staff	training	milestone	50	🎖️	\N	\N	2026-11-23 16:10:14.014+00	2026-11-23 16:10:14.014+00
71	177	Premier but	Récompense attribuée par le staff	training	milestone	50	🎖️	\N	\N	2026-11-23 16:10:14.017+00	2026-11-23 16:10:14.017+00
72	183	Joueur de la semaine	Récompense attribuée par le staff	training	milestone	50	🎖️	\N	\N	2026-11-23 16:10:14.023+00	2026-11-23 16:10:14.023+00
73	184	Joueur de la semaine	Récompense attribuée par le staff	milestone	special	50	🎖️	\N	\N	2026-11-23 16:10:14.025+00	2026-11-23 16:10:14.025+00
74	188	Joueur de la semaine	Récompense attribuée par le staff	milestone	training	100	🎖️	\N	\N	2026-11-23 16:10:14.029+00	2026-11-23 16:10:14.029+00
75	189	Premier but	Récompense attribuée par le staff	special	special	200	🎖️	\N	\N	2026-11-23 16:10:14.03+00	2026-11-23 16:10:14.03+00
76	190	10 entraînements consécutifs	Récompense attribuée par le staff	special	special	200	🎖️	\N	\N	2026-11-23 16:10:14.033+00	2026-11-23 16:10:14.033+00
77	195	Premier but	Récompense attribuée par le staff	training	special	150	🎖️	\N	\N	2026-11-23 16:10:14.034+00	2026-11-23 16:10:14.034+00
78	196	10 entraînements consécutifs	Récompense attribuée par le staff	special	special	50	🎖️	\N	\N	2026-11-23 16:10:14.035+00	2026-11-23 16:10:14.035+00
79	203	Joueur de la semaine	Récompense attribuée par le staff	special	milestone	150	🎖️	\N	\N	2026-11-23 16:10:14.038+00	2026-11-23 16:10:14.038+00
80	208	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	milestone	200	🎖️	\N	\N	2026-11-23 16:10:14.042+00	2026-11-23 16:10:14.042+00
81	209	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:14.043+00	2026-11-23 16:10:14.043+00
82	210	Premier but	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:14.045+00	2026-11-23 16:10:14.045+00
83	211	10 entraînements consécutifs	Récompense attribuée par le staff	special	milestone	150	🎖️	\N	\N	2026-11-23 16:10:14.046+00	2026-11-23 16:10:14.046+00
84	214	Joueur de la semaine	Récompense attribuée par le staff	special	special	100	🎖️	\N	\N	2026-11-23 16:10:14.051+00	2026-11-23 16:10:14.051+00
85	218	Joueur de la semaine	Récompense attribuée par le staff	milestone	training	150	🎖️	\N	\N	2026-11-23 16:10:14.059+00	2026-11-23 16:10:14.059+00
86	219	Joueur de la semaine	Récompense attribuée par le staff	training	training	50	🎖️	\N	\N	2026-11-23 16:10:14.062+00	2026-11-23 16:10:14.062+00
87	224	Joueur de la semaine	Récompense attribuée par le staff	milestone	milestone	100	🎖️	\N	\N	2026-11-23 16:10:14.082+00	2026-11-23 16:10:14.082+00
88	233	Premier but	Récompense attribuée par le staff	training	training	200	🎖️	\N	\N	2026-11-23 16:10:14.092+00	2026-11-23 16:10:14.092+00
89	235	Premier but	Récompense attribuée par le staff	training	special	50	🎖️	\N	\N	2026-11-23 16:10:14.096+00	2026-11-23 16:10:14.096+00
90	239	Joueur de la semaine	Récompense attribuée par le staff	special	training	200	🎖️	\N	\N	2026-11-23 16:10:14.103+00	2026-11-23 16:10:14.103+00
91	251	10 entraînements consécutifs	Récompense attribuée par le staff	training	training	150	🎖️	\N	\N	2026-11-23 16:10:14.108+00	2026-11-23 16:10:14.108+00
92	260	Premier but	Récompense attribuée par le staff	training	special	150	🎖️	\N	\N	2026-11-23 16:10:14.113+00	2026-11-23 16:10:14.113+00
93	261	10 entraînements consécutifs	Récompense attribuée par le staff	special	training	200	🎖️	\N	\N	2026-11-23 16:10:14.114+00	2026-11-23 16:10:14.114+00
94	264	Premier but	Récompense attribuée par le staff	training	training	50	🎖️	\N	\N	2026-11-23 16:10:14.117+00	2026-11-23 16:10:14.117+00
95	268	Premier but	Récompense attribuée par le staff	special	special	150	🎖️	\N	\N	2026-11-23 16:10:14.121+00	2026-11-23 16:10:14.121+00
96	270	10 entraînements consécutifs	Récompense attribuée par le staff	milestone	milestone	200	🎖️	\N	\N	2026-11-23 16:10:14.122+00	2026-11-23 16:10:14.122+00
97	277	10 entraînements consécutifs	Récompense attribuée par le staff	training	milestone	100	🎖️	\N	\N	2026-11-23 16:10:14.128+00	2026-11-23 16:10:14.128+00
98	278	Premier but	Récompense attribuée par le staff	milestone	special	100	🎖️	\N	\N	2026-11-23 16:10:14.13+00	2026-11-23 16:10:14.13+00
99	282	Joueur de la semaine	Récompense attribuée par le staff	training	training	150	🎖️	\N	\N	2026-11-23 16:10:14.133+00	2026-11-23 16:10:14.133+00
100	286	Joueur de la semaine	Récompense attribuée par le staff	milestone	training	50	🎖️	\N	\N	2026-11-23 16:10:14.14+00	2026-11-23 16:10:14.14+00
101	287	10 entraînements consécutifs	Récompense attribuée par le staff	training	milestone	150	🎖️	\N	\N	2026-11-23 16:10:14.143+00	2026-11-23 16:10:14.143+00
102	1	Homme du match	Meilleur joueur face au Raja Club Athletic	special	special	300	⭐	2	\N	2026-11-04 09:33:40.306081+00	2026-11-04 09:33:40.306081+00
103	1	Clean sheet	Aucun but encaissé sur 2 matchs consécutifs	milestone	milestone	200	🧤	2	\N	2026-11-10 09:33:40.306081+00	2026-11-10 09:33:40.306081+00
104	1	Assiduité exemplaire	100 % de présence aux entraînements du mois	training	training	150	🏋️	2	\N	2026-11-15 09:33:40.306081+00	2026-11-15 09:33:40.306081+00
105	1	Prime de victoire	Prime collective Championnat Amateur Casablanca 2026	tournament	tournament	500	💰	2	2	2026-11-19 09:33:40.306081+00	2026-11-19 09:33:40.306081+00
106	1	Arrêt décisif	Penalty arrêté en fin de match	special	special	250	🛡️	2	\N	2026-11-22 09:33:40.306081+00	2026-11-22 09:33:40.306081+00
\.


--
-- Data for Name: PlayerStats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PlayerStats" (id, "playerId", goals, assists, shots, "shotsOnTarget", passes, "keyPasses", tackles, interceptions, clearances, dribbles, "foulsCommitted", "foulsSuffered", offsides, saves, "cleanSheets", "goalsConceded", "penaltiesSaved", "duelsWon", "aerialDuelsWon", "minutesPlayed", "yellowCards", "redCards", "createdAt", "updatedAt") FROM stdin;
1	1	0	0	1	0	37	0	1	3	0	1	0	1	0	3	0	2	1	3	3	90	0	0	2026-11-23 16:10:10.784+00	2026-11-23 16:10:10.784+00
2	2	0	0	6	3	84	6	3	6	0	0	6	6	0	10	3	0	0	21	9	270	0	0	2026-11-23 16:10:10.791+00	2026-11-23 16:10:10.791+00
3	3	0	1	0	0	77	2	6	2	4	0	4	2	0	0	0	0	0	13	6	192	1	0	2026-11-23 16:10:10.795+00	2026-11-23 16:10:10.795+00
4	4	2	1	2	2	201	4	7	0	18	4	7	7	0	0	0	0	0	15	11	329	0	0	2026-11-23 16:10:10.8+00	2026-11-23 16:10:10.8+00
5	5	0	0	0	0	148	7	7	0	7	3	7	0	0	0	0	0	0	17	3	302	0	0	2026-11-23 16:10:10.805+00	2026-11-23 16:10:10.805+00
6	6	0	4	0	2	106	2	10	5	10	0	5	0	0	0	0	0	0	5	7	221	0	0	2026-11-23 16:10:10.81+00	2026-11-23 16:10:10.81+00
7	7	1	0	9	1	57	5	14	3	8	3	5	3	0	0	0	0	0	5	5	245	0	0	2026-11-23 16:10:10.815+00	2026-11-23 16:10:10.815+00
8	8	0	0	0	2	49	3	8	2	5	0	0	3	0	0	0	0	0	13	5	151	0	0	2026-11-23 16:10:10.824+00	2026-11-23 16:10:10.824+00
9	9	1	0	10	4	142	0	0	3	0	0	3	6	0	0	0	0	0	25	9	284	0	0	2026-11-23 16:10:10.833+00	2026-11-23 16:10:10.833+00
10	10	0	1	8	0	148	5	3	5	0	3	0	3	0	0	0	0	0	13	11	242	0	0	2026-11-23 16:10:10.851+00	2026-11-23 16:10:10.851+00
11	11	1	0	1	3	62	0	2	5	0	0	2	5	0	0	0	0	0	9	0	207	0	0	2026-11-23 16:10:10.868+00	2026-11-23 16:10:10.868+00
12	12	0	1	0	1	60	0	0	3	0	1	2	0	0	0	0	0	0	9	1	98	0	0	2026-11-23 16:10:10.879+00	2026-11-23 16:10:10.879+00
13	13	0	0	0	1	38	0	1	0	0	1	0	0	0	0	0	0	0	2	3	76	0	0	2026-11-23 16:10:10.887+00	2026-11-23 16:10:10.887+00
14	14	0	0	0	0	96	0	2	2	0	0	2	2	0	0	0	0	0	8	2	173	0	0	2026-11-23 16:10:10.893+00	2026-11-23 16:10:10.893+00
15	15	1	0	1	1	160	8	0	12	0	16	4	0	0	0	0	0	0	8	16	360	1	0	2026-11-23 16:10:10.901+00	2026-11-23 16:10:10.901+00
16	16	3	0	7	5	68	2	2	2	0	4	4	2	2	0	0	0	0	14	6	180	1	0	2026-11-23 16:10:10.904+00	2026-11-23 16:10:10.904+00
17	17	0	0	8	4	212	8	8	0	0	8	0	0	0	0	0	0	0	28	4	360	0	0	2026-11-23 16:10:10.908+00	2026-11-23 16:10:10.908+00
18	18	1	0	1	1	100	2	0	0	0	8	0	2	0	0	0	0	0	14	8	180	0	0	2026-11-23 16:10:10.914+00	2026-11-23 16:10:10.914+00
19	19	0	0	1	1	48	1	2	3	0	1	1	0	0	7	0	1	0	2	3	90	0	0	2026-11-23 16:10:10.924+00	2026-11-23 16:10:10.924+00
20	20	0	0	9	0	105	6	3	9	0	3	3	3	0	11	1	4	0	6	6	270	0	0	2026-11-23 16:10:10.934+00	2026-11-23 16:10:10.934+00
21	21	1	0	9	4	68	5	5	8	5	3	0	0	0	0	0	0	0	8	10	234	1	0	2026-11-23 16:10:10.947+00	2026-11-23 16:10:10.947+00
22	22	0	0	6	3	76	0	6	9	15	0	6	6	0	0	0	0	0	12	3	263	0	0	2026-11-23 16:10:10.961+00	2026-11-23 16:10:10.961+00
23	23	1	0	1	1	58	6	6	8	6	0	6	0	0	0	0	0	0	19	6	249	1	0	2026-11-23 16:10:10.968+00	2026-11-23 16:10:10.968+00
24	24	0	0	2	2	50	4	4	4	12	0	4	4	0	0	0	0	0	8	6	186	0	0	2026-11-23 16:10:10.974+00	2026-11-23 16:10:10.974+00
25	25	0	0	3	0	70	3	6	6	9	3	3	0	0	0	0	0	0	17	0	262	0	0	2026-11-23 16:10:10.979+00	2026-11-23 16:10:10.979+00
26	26	0	0	3	3	148	3	8	8	14	3	3	3	0	0	0	0	0	11	11	246	0	0	2026-11-23 16:10:10.984+00	2026-11-23 16:10:10.984+00
27	27	0	0	0	0	75	3	0	1	0	0	0	1	0	0	0	0	0	6	3	130	0	0	2026-11-23 16:10:10.988+00	2026-11-23 16:10:10.988+00
28	28	1	1	4	1	178	3	0	0	0	3	7	7	0	0	0	0	0	27	3	302	0	0	2026-11-23 16:10:10.993+00	2026-11-23 16:10:10.993+00
29	29	1	0	7	4	80	0	0	3	0	3	3	6	0	0	0	0	0	22	13	288	0	0	2026-11-23 16:10:10.997+00	2026-11-23 16:10:10.997+00
30	30	0	0	0	1	50	0	1	3	0	0	2	1	0	0	0	0	0	3	3	96	0	0	2026-11-23 16:10:11.002+00	2026-11-23 16:10:11.002+00
31	31	0	2	0	3	67	3	6	9	0	3	3	0	0	0	0	0	0	6	3	264	0	0	2026-11-23 16:10:11.006+00	2026-11-23 16:10:11.006+00
32	32	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.011+00	2026-11-23 16:10:11.011+00
33	33	0	1	3	3	153	0	6	9	0	3	3	6	0	0	0	0	0	24	6	270	0	0	2026-11-23 16:10:11.018+00	2026-11-23 16:10:11.018+00
34	34	1	1	13	5	108	0	4	12	0	4	0	4	4	0	0	0	0	28	16	360	0	0	2026-11-23 16:10:11.024+00	2026-11-23 16:10:11.024+00
35	35	0	1	2	0	68	0	2	0	0	4	2	4	0	0	0	0	0	6	4	180	0	0	2026-11-23 16:10:11.03+00	2026-11-23 16:10:11.03+00
36	36	5	0	11	8	111	0	6	9	0	12	3	6	0	0	0	0	0	6	12	270	0	0	2026-11-23 16:10:11.037+00	2026-11-23 16:10:11.037+00
37	37	0	0	6	3	99	6	0	6	0	0	0	3	0	13	0	7	1	6	0	270	0	0	2026-11-23 16:10:11.05+00	2026-11-23 16:10:11.05+00
38	38	0	0	3	0	47	1	0	2	0	0	2	2	0	1	0	3	1	4	4	90	0	0	2026-11-23 16:10:11.06+00	2026-11-23 16:10:11.06+00
39	39	1	0	8	1	76	0	11	2	13	2	0	0	0	0	0	0	0	16	9	202	0	0	2026-11-23 16:10:11.072+00	2026-11-23 16:10:11.072+00
40	40	0	1	0	3	84	6	13	3	10	0	0	6	0	0	0	0	0	16	6	290	0	0	2026-11-23 16:10:11.082+00	2026-11-23 16:10:11.082+00
41	41	0	0	3	0	137	6	15	0	12	0	0	6	0	0	0	0	0	20	0	262	0	0	2026-11-23 16:10:11.088+00	2026-11-23 16:10:11.088+00
42	42	1	0	11	1	138	0	10	7	20	0	0	3	0	0	0	0	0	26	3	295	0	0	2026-11-23 16:10:11.1+00	2026-11-23 16:10:11.1+00
43	43	0	0	7	0	62	2	7	7	14	0	5	0	0	0	0	0	0	9	7	205	0	0	2026-11-23 16:10:11.107+00	2026-11-23 16:10:11.107+00
44	44	1	0	7	1	68	4	4	0	10	0	2	0	0	0	0	0	0	14	8	186	1	0	2026-11-23 16:10:11.117+00	2026-11-23 16:10:11.117+00
45	45	0	1	2	2	85	2	0	0	0	2	0	0	0	0	0	0	0	11	4	170	1	0	2026-11-23 16:10:11.126+00	2026-11-23 16:10:11.126+00
46	46	0	1	3	1	44	0	1	2	0	1	2	0	0	0	0	0	0	8	2	100	0	0	2026-11-23 16:10:11.135+00	2026-11-23 16:10:11.135+00
47	47	0	0	0	0	75	3	3	9	0	0	6	3	0	0	0	0	0	21	6	270	0	0	2026-11-23 16:10:11.141+00	2026-11-23 16:10:11.141+00
48	48	0	0	1	0	52	0	2	0	0	1	2	0	0	0	0	0	0	8	3	90	0	0	2026-11-23 16:10:11.144+00	2026-11-23 16:10:11.144+00
49	49	0	0	6	3	81	6	0	6	0	3	0	6	0	0	0	0	0	24	6	270	1	0	2026-11-23 16:10:11.152+00	2026-11-23 16:10:11.152+00
50	50	0	1	4	2	44	4	4	4	0	0	2	2	0	0	0	0	0	6	6	180	0	0	2026-11-23 16:10:11.16+00	2026-11-23 16:10:11.16+00
51	51	1	0	7	1	147	0	6	9	0	3	3	3	0	0	0	0	0	18	0	270	0	0	2026-11-23 16:10:11.168+00	2026-11-23 16:10:11.168+00
52	52	0	1	3	0	147	3	6	6	0	3	0	6	3	0	0	0	0	6	0	270	1	0	2026-11-23 16:10:11.176+00	2026-11-23 16:10:11.176+00
53	53	1	0	5	1	102	2	0	2	0	8	0	0	0	0	0	0	0	6	0	180	0	0	2026-11-23 16:10:11.18+00	2026-11-23 16:10:11.18+00
54	54	0	0	12	4	164	8	0	8	0	4	0	8	4	0	0	0	0	24	8	360	0	0	2026-11-23 16:10:11.186+00	2026-11-23 16:10:11.186+00
55	55	0	0	6	2	82	2	2	4	0	0	0	4	0	5	1	1	1	16	6	180	0	0	2026-11-23 16:10:11.194+00	2026-11-23 16:10:11.194+00
56	56	0	0	6	2	96	2	4	4	0	0	0	2	0	6	0	3	1	12	6	180	0	0	2026-11-23 16:10:11.201+00	2026-11-23 16:10:11.201+00
57	57	0	1	3	0	109	3	11	8	5	0	0	5	0	0	0	0	0	19	0	239	0	0	2026-11-23 16:10:11.208+00	2026-11-23 16:10:11.208+00
58	58	1	0	3	1	104	4	8	4	6	2	0	0	0	0	0	0	0	6	6	183	0	0	2026-11-23 16:10:11.215+00	2026-11-23 16:10:11.215+00
59	59	1	0	13	1	189	0	8	0	24	0	0	0	0	0	0	0	0	12	8	355	0	0	2026-11-23 16:10:11.22+00	2026-11-23 16:10:11.22+00
60	60	0	0	0	0	120	0	11	11	18	0	7	0	0	0	0	0	0	18	7	326	0	0	2026-11-23 16:10:11.225+00	2026-11-23 16:10:11.225+00
61	61	0	0	0	0	36	4	9	5	11	0	4	4	0	0	0	0	0	13	5	161	0	0	2026-11-23 16:10:11.229+00	2026-11-23 16:10:11.229+00
62	62	1	0	3	1	61	2	6	2	10	2	0	2	0	0	0	0	0	12	0	176	0	0	2026-11-23 16:10:11.233+00	2026-11-23 16:10:11.233+00
63	63	0	0	1	0	18	1	0	2	0	1	1	1	0	0	0	0	0	1	1	61	0	0	2026-11-23 16:10:11.239+00	2026-11-23 16:10:11.239+00
64	64	0	0	0	0	93	0	0	2	0	2	2	0	0	0	0	0	0	10	6	186	0	0	2026-11-23 16:10:11.246+00	2026-11-23 16:10:11.246+00
65	65	0	1	0	0	88	3	0	3	0	3	7	3	0	0	0	0	0	13	7	294	0	0	2026-11-23 16:10:11.257+00	2026-11-23 16:10:11.257+00
66	66	0	0	2	0	48	4	2	0	0	0	0	4	0	0	0	0	0	5	2	159	2	0	2026-11-23 16:10:11.261+00	2026-11-23 16:10:11.261+00
67	67	0	0	6	2	71	0	4	6	0	2	2	0	0	0	0	0	0	9	7	168	0	0	2026-11-23 16:10:11.273+00	2026-11-23 16:10:11.273+00
68	68	0	0	0	0	113	5	2	0	0	2	2	0	0	0	0	0	0	19	7	212	2	0	2026-11-23 16:10:11.291+00	2026-11-23 16:10:11.291+00
69	69	1	0	10	4	126	3	6	6	0	6	6	6	3	0	0	0	0	9	3	270	0	0	2026-11-23 16:10:11.307+00	2026-11-23 16:10:11.307+00
70	70	1	0	4	4	144	6	3	3	0	3	6	6	3	0	0	0	0	15	0	270	1	0	2026-11-23 16:10:11.314+00	2026-11-23 16:10:11.314+00
71	71	0	0	2	0	54	2	4	0	0	6	0	2	0	0	0	0	0	12	6	180	0	0	2026-11-23 16:10:11.318+00	2026-11-23 16:10:11.318+00
72	72	0	1	12	0	180	0	4	12	0	12	8	4	4	0	0	0	0	12	16	360	2	0	2026-11-23 16:10:11.33+00	2026-11-23 16:10:11.33+00
73	73	0	0	0	2	50	0	4	0	0	2	0	4	0	9	0	5	1	12	8	180	0	0	2026-11-23 16:10:11.334+00	2026-11-23 16:10:11.334+00
74	74	0	0	2	2	100	2	2	6	0	2	4	4	0	10	0	6	1	14	4	180	0	0	2026-11-23 16:10:11.337+00	2026-11-23 16:10:11.337+00
75	75	0	0	0	2	90	0	4	0	6	0	2	0	0	0	0	0	0	9	6	169	0	0	2026-11-23 16:10:11.343+00	2026-11-23 16:10:11.343+00
76	76	0	0	3	3	107	6	15	6	12	3	6	3	0	0	0	0	0	6	3	276	0	0	2026-11-23 16:10:11.349+00	2026-11-23 16:10:11.349+00
77	77	0	2	3	3	148	0	6	8	17	0	0	6	0	0	0	0	0	8	6	252	0	0	2026-11-23 16:10:11.356+00	2026-11-23 16:10:11.356+00
78	78	0	0	11	4	179	4	15	7	11	0	4	0	0	0	0	0	0	7	4	328	0	0	2026-11-23 16:10:11.361+00	2026-11-23 16:10:11.361+00
79	79	0	0	5	0	59	0	3	3	3	2	2	2	0	0	0	0	0	10	3	148	0	0	2026-11-23 16:10:11.367+00	2026-11-23 16:10:11.367+00
80	80	2	0	8	5	59	6	12	0	12	0	0	0	0	0	0	0	0	12	6	267	0	0	2026-11-23 16:10:11.373+00	2026-11-23 16:10:11.373+00
81	81	0	0	0	0	138	3	3	3	0	0	3	0	0	0	0	0	0	6	3	270	0	0	2026-11-23 16:10:11.38+00	2026-11-23 16:10:11.38+00
82	82	0	0	0	3	127	3	3	3	0	3	0	0	0	0	0	0	0	10	5	233	0	0	2026-11-23 16:10:11.387+00	2026-11-23 16:10:11.387+00
83	83	0	1	5	0	129	5	2	2	0	0	2	0	0	0	0	0	0	17	10	223	0	0	2026-11-23 16:10:11.39+00	2026-11-23 16:10:11.39+00
84	84	1	0	3	1	55	2	2	2	0	0	2	4	0	0	0	0	0	12	8	177	0	0	2026-11-23 16:10:11.396+00	2026-11-23 16:10:11.396+00
85	85	0	0	1	0	11	0	0	0	0	0	0	0	0	0	0	0	0	1	1	19	0	0	2026-11-23 16:10:11.402+00	2026-11-23 16:10:11.402+00
86	86	0	0	2	0	54	2	2	4	0	0	4	2	0	0	0	0	0	14	4	158	0	0	2026-11-23 16:10:11.411+00	2026-11-23 16:10:11.411+00
87	87	1	0	4	4	150	6	0	0	0	6	6	0	3	0	0	0	0	18	6	270	0	1	2026-11-23 16:10:11.426+00	2026-11-23 16:10:11.426+00
88	88	0	1	9	3	117	6	3	0	0	12	0	6	0	0	0	0	0	9	0	270	1	0	2026-11-23 16:10:11.436+00	2026-11-23 16:10:11.436+00
89	89	1	0	5	1	50	2	2	2	0	2	2	0	0	0	0	0	0	10	0	180	0	0	2026-11-23 16:10:11.445+00	2026-11-23 16:10:11.445+00
90	90	0	0	4	4	132	4	0	0	0	4	8	0	0	0	0	0	0	24	0	360	0	0	2026-11-23 16:10:11.452+00	2026-11-23 16:10:11.452+00
91	91	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.456+00	2026-11-23 16:10:11.456+00
92	92	0	0	8	4	92	8	0	4	0	4	0	0	0	13	1	5	0	20	12	360	0	0	2026-11-23 16:10:11.461+00	2026-11-23 16:10:11.461+00
93	93	0	1	0	0	124	8	11	0	8	4	4	0	0	0	0	0	0	23	15	338	1	0	2026-11-23 16:10:11.466+00	2026-11-23 16:10:11.466+00
94	94	0	0	9	3	150	3	12	9	15	0	6	6	0	0	0	0	0	21	9	265	0	0	2026-11-23 16:10:11.48+00	2026-11-23 16:10:11.48+00
95	95	0	1	0	0	151	6	9	3	6	3	0	6	0	0	0	0	0	22	6	283	1	0	2026-11-23 16:10:11.492+00	2026-11-23 16:10:11.492+00
96	96	1	0	1	4	70	6	6	8	8	3	0	3	0	0	0	0	0	14	8	251	0	0	2026-11-23 16:10:11.508+00	2026-11-23 16:10:11.508+00
97	97	0	0	2	2	84	2	8	6	10	2	4	2	0	0	0	0	0	8	0	185	0	0	2026-11-23 16:10:11.523+00	2026-11-23 16:10:11.523+00
98	98	0	0	0	0	54	0	3	0	7	1	0	0	0	0	0	0	0	4	1	118	0	0	2026-11-23 16:10:11.527+00	2026-11-23 16:10:11.527+00
99	99	0	0	0	2	61	3	3	2	0	2	2	3	0	0	0	0	0	8	7	148	0	0	2026-11-23 16:10:11.534+00	2026-11-23 16:10:11.534+00
100	100	0	1	2	2	79	4	0	4	0	0	0	4	0	0	0	0	0	11	0	158	2	0	2026-11-23 16:10:11.538+00	2026-11-23 16:10:11.538+00
101	101	0	0	8	0	124	0	0	6	0	0	6	6	0	0	0	0	0	8	6	254	1	0	2026-11-23 16:10:11.541+00	2026-11-23 16:10:11.541+00
102	102	1	0	1	1	73	0	5	5	0	0	3	3	0	0	0	0	0	11	11	242	0	0	2026-11-23 16:10:11.547+00	2026-11-23 16:10:11.547+00
103	103	0	0	0	0	15	0	0	0	0	0	0	0	0	0	0	0	0	2	0	28	0	0	2026-11-23 16:10:11.552+00	2026-11-23 16:10:11.552+00
104	104	1	0	4	4	128	3	6	8	0	0	0	6	0	0	0	0	0	11	8	250	0	0	2026-11-23 16:10:11.556+00	2026-11-23 16:10:11.556+00
105	105	0	0	2	2	84	0	2	2	0	2	0	4	2	0	0	0	0	14	0	180	0	0	2026-11-23 16:10:11.562+00	2026-11-23 16:10:11.562+00
106	106	0	0	3	0	156	3	3	9	0	12	0	0	0	0	0	0	0	6	9	270	1	0	2026-11-23 16:10:11.565+00	2026-11-23 16:10:11.565+00
107	107	0	0	9	3	108	3	0	9	0	9	6	3	3	0	0	0	0	21	6	270	1	0	2026-11-23 16:10:11.57+00	2026-11-23 16:10:11.57+00
108	108	1	1	5	1	80	8	0	4	0	16	8	0	4	0	0	0	0	16	0	360	0	0	2026-11-23 16:10:11.575+00	2026-11-23 16:10:11.575+00
109	109	0	0	0	1	28	2	0	1	0	0	1	0	0	5	1	0	0	4	2	90	0	0	2026-11-23 16:10:11.584+00	2026-11-23 16:10:11.584+00
110	110	0	0	3	0	135	0	3	0	0	3	0	6	0	9	0	6	1	12	12	270	0	0	2026-11-23 16:10:11.59+00	2026-11-23 16:10:11.59+00
111	111	3	0	7	7	96	0	8	4	16	0	8	4	0	0	0	0	0	24	4	360	0	0	2026-11-23 16:10:11.599+00	2026-11-23 16:10:11.599+00
112	112	0	0	2	0	63	0	7	0	5	0	2	0	0	0	0	0	0	7	0	154	0	0	2026-11-23 16:10:11.606+00	2026-11-23 16:10:11.606+00
113	113	1	0	1	1	152	3	14	6	11	3	6	0	0	0	0	0	0	11	11	248	0	0	2026-11-23 16:10:11.61+00	2026-11-23 16:10:11.61+00
114	114	1	1	1	1	90	7	18	0	7	0	7	0	0	0	0	0	0	18	4	325	0	1	2026-11-23 16:10:11.619+00	2026-11-23 16:10:11.619+00
115	115	1	0	3	1	89	4	6	0	4	2	0	2	0	0	0	0	0	10	4	187	0	0	2026-11-23 16:10:11.623+00	2026-11-23 16:10:11.623+00
116	116	0	1	4	2	42	2	4	6	7	0	0	4	0	0	0	0	0	9	0	166	0	0	2026-11-23 16:10:11.627+00	2026-11-23 16:10:11.627+00
117	117	0	0	5	2	39	2	3	3	0	2	2	0	0	0	0	0	0	3	2	147	1	0	2026-11-23 16:10:11.632+00	2026-11-23 16:10:11.632+00
118	118	0	0	0	1	22	1	1	3	0	0	1	2	0	0	0	0	0	4	1	94	0	0	2026-11-23 16:10:11.638+00	2026-11-23 16:10:11.638+00
119	119	1	0	1	4	86	3	0	10	0	0	7	0	0	0	0	0	0	27	0	299	0	1	2026-11-23 16:10:11.642+00	2026-11-23 16:10:11.642+00
120	120	0	1	7	3	167	0	0	10	0	0	0	3	0	0	0	0	0	13	0	301	1	0	2026-11-23 16:10:11.645+00	2026-11-23 16:10:11.645+00
121	121	0	0	2	0	77	4	4	2	0	0	2	2	0	0	0	0	0	9	2	158	1	0	2026-11-23 16:10:11.651+00	2026-11-23 16:10:11.651+00
122	122	0	1	2	1	40	1	0	1	0	1	1	0	0	0	0	0	0	7	3	81	0	0	2026-11-23 16:10:11.657+00	2026-11-23 16:10:11.657+00
123	123	1	0	1	1	165	6	3	3	0	6	0	3	0	0	0	0	0	12	3	270	0	0	2026-11-23 16:10:11.663+00	2026-11-23 16:10:11.663+00
124	124	0	2	3	3	84	6	6	6	0	12	6	3	0	0	0	0	0	21	9	270	1	0	2026-11-23 16:10:11.67+00	2026-11-23 16:10:11.67+00
125	125	0	0	2	2	88	0	2	2	0	8	0	2	2	0	0	0	0	8	0	180	0	1	2026-11-23 16:10:11.675+00	2026-11-23 16:10:11.675+00
126	126	0	0	0	0	208	0	0	12	0	4	4	0	0	0	0	0	0	12	8	360	0	0	2026-11-23 16:10:11.684+00	2026-11-23 16:10:11.684+00
127	127	0	0	3	0	48	2	0	1	0	0	0	0	0	7	0	1	0	5	0	90	0	0	2026-11-23 16:10:11.694+00	2026-11-23 16:10:11.694+00
128	128	0	0	9	3	126	3	6	3	0	3	0	6	0	17	1	5	1	15	12	270	0	0	2026-11-23 16:10:11.705+00	2026-11-23 16:10:11.705+00
129	129	0	0	0	0	75	0	5	3	10	0	5	3	0	0	0	0	0	20	8	225	0	0	2026-11-23 16:10:11.721+00	2026-11-23 16:10:11.721+00
130	130	0	0	5	0	77	5	12	7	5	2	5	2	0	0	0	0	0	16	7	209	0	0	2026-11-23 16:10:11.73+00	2026-11-23 16:10:11.73+00
131	131	1	0	6	1	88	0	8	0	13	3	5	3	0	0	0	0	0	13	3	234	0	0	2026-11-23 16:10:11.739+00	2026-11-23 16:10:11.739+00
132	132	0	0	4	0	150	4	18	7	18	4	4	4	0	0	0	0	0	18	14	322	1	0	2026-11-23 16:10:11.747+00	2026-11-23 16:10:11.747+00
133	133	0	0	2	0	88	4	10	0	12	2	0	2	0	0	0	0	0	10	4	175	0	0	2026-11-23 16:10:11.752+00	2026-11-23 16:10:11.752+00
134	134	0	0	3	0	104	6	15	3	6	3	3	6	0	0	0	0	0	18	3	275	0	0	2026-11-23 16:10:11.76+00	2026-11-23 16:10:11.76+00
135	135	0	0	10	0	124	7	0	10	0	0	7	0	0	0	0	0	0	10	10	293	0	1	2026-11-23 16:10:11.77+00	2026-11-23 16:10:11.77+00
136	136	0	0	7	0	100	3	3	7	0	3	0	7	0	0	0	0	0	7	13	299	0	0	2026-11-23 16:10:11.773+00	2026-11-23 16:10:11.773+00
137	137	0	0	1	0	34	2	2	2	0	1	0	0	0	0	0	0	0	6	2	71	0	0	2026-11-23 16:10:11.781+00	2026-11-23 16:10:11.781+00
138	138	0	0	0	0	71	3	3	3	0	0	1	3	0	0	0	0	0	7	3	119	0	0	2026-11-23 16:10:11.785+00	2026-11-23 16:10:11.785+00
139	139	0	0	0	0	51	5	5	5	0	0	0	2	0	0	0	0	0	5	2	220	0	0	2026-11-23 16:10:11.795+00	2026-11-23 16:10:11.795+00
140	140	0	0	0	0	31	0	0	2	0	0	1	2	0	0	0	0	0	3	0	78	0	0	2026-11-23 16:10:11.802+00	2026-11-23 16:10:11.802+00
141	141	0	0	6	3	105	0	3	3	0	6	3	6	3	0	0	0	0	12	9	270	0	0	2026-11-23 16:10:11.809+00	2026-11-23 16:10:11.809+00
142	142	0	0	9	0	84	6	3	6	0	3	3	3	3	0	0	0	0	9	3	270	0	0	2026-11-23 16:10:11.82+00	2026-11-23 16:10:11.82+00
143	143	1	0	5	5	152	8	0	8	0	16	0	8	0	0	0	0	0	32	8	360	1	0	2026-11-23 16:10:11.825+00	2026-11-23 16:10:11.825+00
144	144	0	1	6	2	90	4	0	6	0	2	2	4	0	0	0	0	0	14	2	180	0	0	2026-11-23 16:10:11.829+00	2026-11-23 16:10:11.829+00
145	145	0	0	1	0	51	1	1	0	0	0	1	1	0	6	1	0	1	4	3	90	0	0	2026-11-23 16:10:11.834+00	2026-11-23 16:10:11.834+00
146	146	0	0	2	0	76	0	2	4	0	2	0	2	0	9	0	3	1	12	4	180	0	0	2026-11-23 16:10:11.843+00	2026-11-23 16:10:11.843+00
147	147	1	0	1	1	64	2	10	6	10	0	0	4	0	0	0	0	0	6	8	175	1	0	2026-11-23 16:10:11.847+00	2026-11-23 16:10:11.847+00
148	148	0	1	5	0	49	2	7	5	4	0	0	0	0	0	0	0	0	14	5	159	1	0	2026-11-23 16:10:11.856+00	2026-11-23 16:10:11.856+00
149	149	0	0	0	2	42	4	11	4	6	0	0	4	0	0	0	0	0	17	8	190	0	1	2026-11-23 16:10:11.862+00	2026-11-23 16:10:11.862+00
150	150	0	0	5	2	107	2	10	0	10	2	2	0	0	0	0	0	0	12	0	214	0	0	2026-11-23 16:10:11.869+00	2026-11-23 16:10:11.869+00
151	151	0	1	3	0	65	1	7	3	4	1	1	0	0	0	0	0	0	3	6	127	0	0	2026-11-23 16:10:11.874+00	2026-11-23 16:10:11.874+00
152	152	1	1	1	3	67	5	10	7	5	2	0	2	0	0	0	0	0	10	0	215	0	0	2026-11-23 16:10:11.879+00	2026-11-23 16:10:11.879+00
153	153	1	0	5	3	65	2	0	4	0	2	0	4	0	0	0	0	0	4	4	173	0	0	2026-11-23 16:10:11.886+00	2026-11-23 16:10:11.886+00
154	154	0	0	0	1	40	0	2	3	0	1	2	0	0	0	0	0	0	4	2	79	0	0	2026-11-23 16:10:11.892+00	2026-11-23 16:10:11.892+00
155	155	0	0	2	0	87	0	2	2	0	0	2	4	0	0	0	0	0	7	2	200	0	0	2026-11-23 16:10:11.895+00	2026-11-23 16:10:11.895+00
156	156	1	0	3	3	79	0	0	0	0	0	2	2	0	0	0	0	0	6	2	191	0	0	2026-11-23 16:10:11.903+00	2026-11-23 16:10:11.903+00
157	157	1	0	7	1	59	0	0	2	0	0	4	0	0	0	0	0	0	13	0	167	1	0	2026-11-23 16:10:11.912+00	2026-11-23 16:10:11.912+00
158	158	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:11.921+00	2026-11-23 16:10:11.921+00
159	159	1	1	7	1	84	2	0	6	0	8	0	4	2	0	0	0	0	8	4	180	1	0	2026-11-23 16:10:11.931+00	2026-11-23 16:10:11.931+00
160	160	0	0	2	2	78	0	0	4	0	4	2	0	0	0	0	0	0	16	0	180	0	0	2026-11-23 16:10:11.94+00	2026-11-23 16:10:11.94+00
161	161	1	0	7	1	80	0	4	2	0	6	4	0	0	0	0	0	0	8	8	180	0	0	2026-11-23 16:10:11.947+00	2026-11-23 16:10:11.947+00
162	162	1	0	1	1	60	3	3	0	0	9	3	0	0	0	0	0	0	24	3	270	0	0	2026-11-23 16:10:11.956+00	2026-11-23 16:10:11.956+00
163	163	0	0	3	1	54	2	0	3	0	0	1	2	0	2	0	3	0	4	0	90	0	0	2026-11-23 16:10:11.962+00	2026-11-23 16:10:11.962+00
164	164	0	0	1	1	21	1	2	3	0	1	0	1	0	1	0	2	1	3	3	90	0	0	2026-11-23 16:10:11.968+00	2026-11-23 16:10:11.968+00
165	165	0	0	3	1	28	0	3	3	4	1	2	0	0	0	0	0	0	9	1	100	0	0	2026-11-23 16:10:11.977+00	2026-11-23 16:10:11.977+00
166	166	0	0	0	0	94	4	4	0	11	0	0	4	0	0	0	0	0	13	0	170	0	0	2026-11-23 16:10:11.984+00	2026-11-23 16:10:11.984+00
167	167	0	0	2	0	55	1	3	3	7	0	1	1	0	0	0	0	0	9	4	99	1	0	2026-11-23 16:10:11.987+00	2026-11-23 16:10:11.987+00
168	168	1	0	3	1	71	0	4	0	5	0	0	2	0	0	0	0	0	5	4	163	0	0	2026-11-23 16:10:11.989+00	2026-11-23 16:10:11.989+00
169	169	0	0	0	1	32	1	2	2	2	1	1	1	0	0	0	0	0	9	0	104	0	0	2026-11-23 16:10:11.993+00	2026-11-23 16:10:11.993+00
170	170	0	0	1	0	51	2	2	2	4	1	2	2	0	0	0	0	0	5	0	84	0	0	2026-11-23 16:10:11.999+00	2026-11-23 16:10:11.999+00
171	171	1	0	3	3	45	3	2	3	0	0	2	0	0	0	0	0	0	5	5	157	1	0	2026-11-23 16:10:12.003+00	2026-11-23 16:10:12.003+00
172	172	0	1	0	1	53	1	1	4	0	0	0	2	0	0	0	0	0	9	1	105	1	0	2026-11-23 16:10:12.006+00	2026-11-23 16:10:12.006+00
173	173	1	0	3	1	29	0	2	0	0	1	1	2	0	0	0	0	0	4	4	98	0	0	2026-11-23 16:10:12.01+00	2026-11-23 16:10:12.01+00
174	174	0	1	0	2	84	2	3	3	0	0	0	2	0	0	0	0	0	10	7	154	0	0	2026-11-23 16:10:12.018+00	2026-11-23 16:10:12.018+00
175	175	0	0	0	0	13	0	0	0	0	0	1	0	0	0	0	0	0	1	1	26	0	0	2026-11-23 16:10:12.028+00	2026-11-23 16:10:12.028+00
176	176	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.039+00	2026-11-23 16:10:12.039+00
177	177	1	0	3	1	46	1	2	1	0	3	0	0	0	0	0	0	0	6	1	90	0	0	2026-11-23 16:10:12.044+00	2026-11-23 16:10:12.044+00
178	178	0	0	0	0	68	4	2	6	0	8	4	4	0	0	0	0	0	4	8	180	0	0	2026-11-23 16:10:12.049+00	2026-11-23 16:10:12.049+00
179	179	0	0	0	0	39	1	0	3	0	4	1	1	0	0	0	0	0	2	4	90	0	0	2026-11-23 16:10:12.053+00	2026-11-23 16:10:12.053+00
180	180	0	1	2	2	108	0	4	0	0	6	4	0	0	0	0	0	0	10	4	180	0	0	2026-11-23 16:10:12.059+00	2026-11-23 16:10:12.059+00
181	181	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	2026-11-23 16:10:12.063+00	2026-11-23 16:10:12.063+00
182	182	0	0	1	0	52	0	0	1	0	0	1	1	0	5	0	1	0	8	1	90	0	0	2026-11-23 16:10:12.068+00	2026-11-23 16:10:12.068+00
183	183	0	0	1	1	25	1	2	1	4	0	1	1	0	0	0	0	0	3	4	90	0	0	2026-11-23 16:10:12.075+00	2026-11-23 16:10:12.075+00
184	184	0	0	0	0	2	0	0	0	1	0	0	0	0	0	0	0	0	1	0	10	0	0	2026-11-23 16:10:12.081+00	2026-11-23 16:10:12.081+00
185	185	0	0	2	1	45	1	4	3	4	0	0	2	0	0	0	0	0	3	2	80	0	0	2026-11-23 16:10:12.087+00	2026-11-23 16:10:12.087+00
186	186	0	0	0	0	25	1	3	0	4	0	0	1	0	0	0	0	0	4	0	90	0	0	2026-11-23 16:10:12.093+00	2026-11-23 16:10:12.093+00
187	187	0	0	1	1	38	1	4	0	1	1	0	1	0	0	0	0	0	5	3	63	0	0	2026-11-23 16:10:12.098+00	2026-11-23 16:10:12.098+00
188	188	0	0	0	0	16	0	1	0	1	0	1	0	0	0	0	0	0	1	1	27	0	0	2026-11-23 16:10:12.102+00	2026-11-23 16:10:12.102+00
189	189	0	0	1	0	8	0	0	1	0	0	0	1	0	0	0	0	0	1	2	35	0	0	2026-11-23 16:10:12.107+00	2026-11-23 16:10:12.107+00
190	190	0	0	0	1	39	1	0	1	0	0	2	0	0	0	0	0	0	5	3	90	0	0	2026-11-23 16:10:12.112+00	2026-11-23 16:10:12.112+00
191	191	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.118+00	2026-11-23 16:10:12.118+00
192	192	0	0	1	0	21	1	1	0	0	0	0	1	0	0	0	0	0	3	2	55	0	0	2026-11-23 16:10:12.127+00	2026-11-23 16:10:12.127+00
193	193	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.132+00	2026-11-23 16:10:12.132+00
194	194	0	0	2	0	20	2	0	1	0	0	1	2	0	0	0	0	0	6	1	90	1	0	2026-11-23 16:10:12.138+00	2026-11-23 16:10:12.138+00
195	195	0	0	1	0	42	2	2	0	0	3	1	0	1	0	0	0	0	7	2	90	0	0	2026-11-23 16:10:12.154+00	2026-11-23 16:10:12.154+00
196	196	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.161+00	2026-11-23 16:10:12.161+00
197	197	0	0	3	1	23	0	1	1	0	2	1	2	0	0	0	0	0	3	0	90	0	0	2026-11-23 16:10:12.175+00	2026-11-23 16:10:12.175+00
198	198	0	0	2	1	28	2	1	0	0	1	2	2	0	0	0	0	0	5	4	90	1	0	2026-11-23 16:10:12.183+00	2026-11-23 16:10:12.183+00
199	199	0	0	3	0	41	1	0	0	0	0	2	0	0	4	0	2	0	4	4	90	0	0	2026-11-23 16:10:12.188+00	2026-11-23 16:10:12.188+00
200	200	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.192+00	2026-11-23 16:10:12.192+00
201	201	0	0	1	0	19	1	3	2	2	1	1	1	0	0	0	0	0	1	2	57	0	0	2026-11-23 16:10:12.198+00	2026-11-23 16:10:12.198+00
202	202	0	0	1	0	10	0	2	1	1	0	0	0	0	0	0	0	0	1	1	33	0	0	2026-11-23 16:10:12.204+00	2026-11-23 16:10:12.204+00
203	203	0	0	1	1	25	1	4	0	2	1	1	1	0	0	0	0	0	5	2	66	0	0	2026-11-23 16:10:12.21+00	2026-11-23 16:10:12.21+00
204	204	0	0	0	0	38	2	5	0	3	1	0	0	0	0	0	0	0	2	0	90	0	0	2026-11-23 16:10:12.214+00	2026-11-23 16:10:12.214+00
205	205	0	0	1	1	23	0	4	2	6	0	2	1	0	0	0	0	0	3	4	90	0	0	2026-11-23 16:10:12.218+00	2026-11-23 16:10:12.218+00
206	206	0	0	1	0	7	0	1	0	1	0	1	0	0	0	0	0	0	1	1	24	0	0	2026-11-23 16:10:12.224+00	2026-11-23 16:10:12.224+00
207	207	0	0	0	1	37	2	0	3	0	1	1	2	0	0	0	0	0	6	4	90	0	0	2026-11-23 16:10:12.228+00	2026-11-23 16:10:12.228+00
208	208	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.235+00	2026-11-23 16:10:12.235+00
209	209	0	0	1	0	22	1	0	2	0	1	0	2	0	0	0	0	0	5	3	90	0	0	2026-11-23 16:10:12.239+00	2026-11-23 16:10:12.239+00
210	210	0	0	1	1	48	0	2	2	0	1	2	0	0	0	0	0	0	7	0	90	0	0	2026-11-23 16:10:12.244+00	2026-11-23 16:10:12.244+00
211	211	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.257+00	2026-11-23 16:10:12.257+00
212	212	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.266+00	2026-11-23 16:10:12.266+00
213	213	0	0	0	0	33	2	1	0	0	4	0	0	1	0	0	0	0	3	3	90	0	0	2026-11-23 16:10:12.273+00	2026-11-23 16:10:12.273+00
214	214	0	0	3	1	30	0	0	1	0	2	2	1	0	0	0	0	0	7	4	90	0	0	2026-11-23 16:10:12.279+00	2026-11-23 16:10:12.279+00
215	215	0	0	3	1	20	2	2	3	0	2	1	0	1	0	0	0	0	5	1	90	0	0	2026-11-23 16:10:12.285+00	2026-11-23 16:10:12.285+00
216	216	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.297+00	2026-11-23 16:10:12.297+00
217	217	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	2026-11-23 16:10:12.302+00	2026-11-23 16:10:12.302+00
218	218	0	0	0	2	82	0	4	4	0	0	4	4	0	10	0	4	1	4	8	180	0	0	2026-11-23 16:10:12.307+00	2026-11-23 16:10:12.307+00
219	219	0	0	0	0	20	0	1	0	1	0	1	0	0	0	0	0	0	4	1	40	0	0	2026-11-23 16:10:12.311+00	2026-11-23 16:10:12.311+00
220	220	1	0	5	1	84	4	9	2	4	0	0	2	0	0	0	0	0	4	5	158	1	0	2026-11-23 16:10:12.318+00	2026-11-23 16:10:12.318+00
221	221	0	0	2	2	45	0	7	3	8	2	0	2	0	0	0	0	0	12	2	151	0	0	2026-11-23 16:10:12.323+00	2026-11-23 16:10:12.323+00
222	222	0	0	4	0	45	3	4	1	3	0	3	1	0	0	0	0	0	3	5	119	0	0	2026-11-23 16:10:12.327+00	2026-11-23 16:10:12.327+00
223	223	1	1	6	1	43	3	3	5	7	2	0	0	0	0	0	0	0	5	3	149	0	0	2026-11-23 16:10:12.33+00	2026-11-23 16:10:12.33+00
224	224	0	0	1	1	62	0	5	3	2	0	1	0	0	0	0	0	0	6	5	103	0	0	2026-11-23 16:10:12.335+00	2026-11-23 16:10:12.335+00
225	225	0	1	1	1	49	3	3	3	0	1	1	0	0	0	0	0	0	8	5	123	0	0	2026-11-23 16:10:12.341+00	2026-11-23 16:10:12.341+00
226	226	0	0	0	0	32	0	2	1	0	0	2	2	0	0	0	0	0	4	4	79	1	0	2026-11-23 16:10:12.35+00	2026-11-23 16:10:12.35+00
227	227	1	0	5	2	62	0	0	1	0	1	0	1	0	0	0	0	0	6	2	110	1	0	2026-11-23 16:10:12.359+00	2026-11-23 16:10:12.359+00
228	228	0	1	3	1	19	2	2	3	0	0	1	0	0	0	0	0	0	3	2	81	0	0	2026-11-23 16:10:12.375+00	2026-11-23 16:10:12.375+00
229	229	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.387+00	2026-11-23 16:10:12.387+00
230	230	0	0	5	2	54	3	3	2	0	0	3	2	0	0	0	0	0	11	3	147	1	0	2026-11-23 16:10:12.391+00	2026-11-23 16:10:12.391+00
231	231	0	1	6	2	62	0	2	2	0	4	2	4	2	0	0	0	0	16	6	180	0	0	2026-11-23 16:10:12.399+00	2026-11-23 16:10:12.399+00
232	232	1	0	2	1	51	2	2	3	0	1	1	1	0	0	0	0	0	5	2	90	0	0	2026-11-23 16:10:12.404+00	2026-11-23 16:10:12.404+00
233	233	0	0	2	0	104	0	2	0	0	6	4	0	2	0	0	0	0	10	2	180	0	0	2026-11-23 16:10:12.408+00	2026-11-23 16:10:12.408+00
234	234	1	0	1	2	35	0	2	1	0	3	2	1	0	0	0	0	0	2	4	90	0	0	2026-11-23 16:10:12.416+00	2026-11-23 16:10:12.416+00
235	235	0	0	1	0	27	2	0	1	0	1	0	0	0	7	0	3	1	8	2	90	0	0	2026-11-23 16:10:12.423+00	2026-11-23 16:10:12.423+00
236	236	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.425+00	2026-11-23 16:10:12.425+00
237	237	0	0	2	1	20	1	3	2	5	0	1	0	0	0	0	0	0	5	2	72	0	0	2026-11-23 16:10:12.431+00	2026-11-23 16:10:12.431+00
238	238	0	0	1	1	20	1	1	0	4	0	0	0	0	0	0	0	0	3	1	62	0	0	2026-11-23 16:10:12.436+00	2026-11-23 16:10:12.436+00
239	239	0	0	0	0	8	1	1	1	1	0	0	0	0	0	0	0	0	2	0	28	0	0	2026-11-23 16:10:12.443+00	2026-11-23 16:10:12.443+00
240	240	0	0	3	1	43	0	5	2	5	0	0	0	0	0	0	0	0	4	3	90	0	0	2026-11-23 16:10:12.446+00	2026-11-23 16:10:12.446+00
241	241	1	0	2	2	36	2	5	3	3	1	2	2	0	0	0	0	0	4	2	90	0	0	2026-11-23 16:10:12.452+00	2026-11-23 16:10:12.452+00
242	242	0	0	1	0	6	0	1	0	1	0	0	0	0	0	0	0	0	1	0	18	0	0	2026-11-23 16:10:12.46+00	2026-11-23 16:10:12.46+00
243	243	1	0	2	2	36	1	2	0	0	0	2	1	0	0	0	0	0	5	1	83	0	0	2026-11-23 16:10:12.466+00	2026-11-23 16:10:12.466+00
244	244	0	0	0	0	4	0	0	0	0	0	0	0	0	0	0	0	0	0	0	7	0	0	2026-11-23 16:10:12.471+00	2026-11-23 16:10:12.471+00
245	245	0	0	2	1	26	1	2	2	0	0	2	1	0	0	0	0	0	6	0	71	0	0	2026-11-23 16:10:12.477+00	2026-11-23 16:10:12.477+00
246	246	0	0	0	0	50	0	2	1	0	0	0	0	0	0	0	0	0	5	4	90	0	0	2026-11-23 16:10:12.485+00	2026-11-23 16:10:12.485+00
247	247	0	0	1	0	4	0	0	0	0	0	0	0	0	0	0	0	0	0	1	19	0	0	2026-11-23 16:10:12.491+00	2026-11-23 16:10:12.491+00
248	248	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.498+00	2026-11-23 16:10:12.498+00
249	249	0	1	3	1	37	2	2	1	0	1	0	1	0	0	0	0	0	4	0	90	0	0	2026-11-23 16:10:12.502+00	2026-11-23 16:10:12.502+00
250	250	1	0	1	1	31	1	1	0	0	1	1	1	1	0	0	0	0	2	2	90	1	0	2026-11-23 16:10:12.506+00	2026-11-23 16:10:12.506+00
251	251	0	0	1	1	24	2	2	2	0	1	1	2	1	0	0	0	0	7	4	90	0	0	2026-11-23 16:10:12.511+00	2026-11-23 16:10:12.511+00
252	252	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.516+00	2026-11-23 16:10:12.516+00
253	253	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.52+00	2026-11-23 16:10:12.52+00
254	254	0	0	0	0	26	2	0	3	0	0	2	0	0	3	0	2	0	7	4	90	0	0	2026-11-23 16:10:12.523+00	2026-11-23 16:10:12.523+00
255	255	0	0	1	0	32	1	4	2	3	1	2	2	0	0	0	0	0	6	4	80	0	0	2026-11-23 16:10:12.528+00	2026-11-23 16:10:12.528+00
256	256	0	0	0	0	3	0	1	0	0	0	0	0	0	0	0	0	0	0	0	10	0	0	2026-11-23 16:10:12.532+00	2026-11-23 16:10:12.532+00
257	257	0	0	2	1	40	2	5	0	2	0	0	1	0	0	0	0	0	8	3	90	0	0	2026-11-23 16:10:12.539+00	2026-11-23 16:10:12.539+00
258	258	0	0	1	1	20	1	2	1	2	1	1	2	0	0	0	0	0	2	2	83	0	0	2026-11-23 16:10:12.544+00	2026-11-23 16:10:12.544+00
259	259	0	0	0	0	4	0	0	0	0	0	0	0	0	0	0	0	0	0	0	7	0	0	2026-11-23 16:10:12.547+00	2026-11-23 16:10:12.547+00
260	260	1	0	1	1	55	0	3	3	5	1	1	1	0	0	0	0	0	8	4	90	0	0	2026-11-23 16:10:12.556+00	2026-11-23 16:10:12.556+00
261	261	0	0	2	0	15	1	1	0	0	0	0	0	0	0	0	0	0	1	0	55	0	0	2026-11-23 16:10:12.563+00	2026-11-23 16:10:12.563+00
262	262	0	0	0	0	4	0	0	0	0	0	0	0	0	0	0	0	0	1	0	13	0	0	2026-11-23 16:10:12.568+00	2026-11-23 16:10:12.568+00
263	263	0	0	3	1	27	2	1	1	0	0	2	2	0	0	0	0	0	4	4	90	0	0	2026-11-23 16:10:12.572+00	2026-11-23 16:10:12.572+00
264	264	0	0	0	0	18	0	0	1	0	0	0	1	0	0	0	0	0	2	2	35	0	0	2026-11-23 16:10:12.579+00	2026-11-23 16:10:12.579+00
265	265	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.592+00	2026-11-23 16:10:12.592+00
266	266	0	1	2	1	40	2	2	1	0	0	0	0	0	0	0	0	0	4	1	77	0	0	2026-11-23 16:10:12.602+00	2026-11-23 16:10:12.602+00
267	267	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.61+00	2026-11-23 16:10:12.61+00
268	268	0	0	3	1	52	2	2	3	0	4	1	1	0	0	0	0	0	5	0	90	1	0	2026-11-23 16:10:12.617+00	2026-11-23 16:10:12.617+00
269	269	0	0	0	0	29	1	1	0	0	3	2	0	0	0	0	0	0	3	3	90	0	0	2026-11-23 16:10:12.623+00	2026-11-23 16:10:12.623+00
270	270	0	0	0	1	32	2	2	2	0	2	0	0	0	0	0	0	0	6	1	90	0	0	2026-11-23 16:10:12.631+00	2026-11-23 16:10:12.631+00
271	271	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2026-11-23 16:10:12.638+00	2026-11-23 16:10:12.638+00
272	272	0	0	9	3	165	6	6	0	0	0	6	0	0	13	1	7	1	12	12	270	0	0	2026-11-23 16:10:12.643+00	2026-11-23 16:10:12.643+00
273	273	0	0	6	2	43	2	4	0	11	0	0	4	0	0	0	0	0	13	9	192	1	0	2026-11-23 16:10:12.651+00	2026-11-23 16:10:12.651+00
274	274	1	1	3	1	98	4	8	6	9	0	0	2	0	0	0	0	0	13	8	170	0	0	2026-11-23 16:10:12.657+00	2026-11-23 16:10:12.657+00
275	275	0	0	0	2	39	3	3	5	9	2	2	0	0	0	0	0	0	12	3	154	0	0	2026-11-23 16:10:12.661+00	2026-11-23 16:10:12.661+00
276	276	0	1	0	2	83	4	4	2	4	2	4	2	0	0	0	0	0	12	0	178	0	0	2026-11-23 16:10:12.663+00	2026-11-23 16:10:12.663+00
277	277	1	0	1	3	58	0	5	7	14	2	5	5	0	0	0	0	0	9	9	210	0	0	2026-11-23 16:10:12.666+00	2026-11-23 16:10:12.666+00
278	278	0	0	4	2	47	4	8	4	4	0	0	0	0	0	0	0	0	8	0	176	0	0	2026-11-23 16:10:12.673+00	2026-11-23 16:10:12.673+00
279	279	0	0	0	1	30	2	0	4	0	1	1	1	0	0	0	0	0	5	4	107	0	0	2026-11-23 16:10:12.679+00	2026-11-23 16:10:12.679+00
280	280	1	0	4	2	54	0	1	2	0	1	0	0	0	0	0	0	0	2	3	103	0	0	2026-11-23 16:10:12.685+00	2026-11-23 16:10:12.685+00
281	281	0	0	7	2	96	0	0	7	0	2	5	0	0	0	0	0	0	5	9	206	0	0	2026-11-23 16:10:12.69+00	2026-11-23 16:10:12.69+00
282	282	0	0	3	2	75	3	0	5	0	2	3	2	0	0	0	0	0	7	3	150	0	0	2026-11-23 16:10:12.694+00	2026-11-23 16:10:12.694+00
283	283	2	0	7	2	53	2	2	3	0	0	2	0	0	0	0	0	0	5	5	154	0	0	2026-11-23 16:10:12.696+00	2026-11-23 16:10:12.696+00
284	284	0	0	3	0	51	0	0	2	0	0	1	0	0	0	0	0	0	8	2	90	0	0	2026-11-23 16:10:12.701+00	2026-11-23 16:10:12.701+00
285	285	0	2	6	3	120	3	3	6	0	9	0	6	3	0	0	0	0	9	0	270	1	0	2026-11-23 16:10:12.706+00	2026-11-23 16:10:12.706+00
286	286	0	0	0	1	41	1	1	0	0	4	2	0	0	0	0	0	0	5	2	90	0	0	2026-11-23 16:10:12.711+00	2026-11-23 16:10:12.711+00
287	287	1	0	4	1	120	6	0	9	0	6	3	6	3	0	0	0	0	15	3	270	0	0	2026-11-23 16:10:12.717+00	2026-11-23 16:10:12.717+00
288	288	0	1	4	2	78	4	2	4	0	4	0	0	2	0	0	0	0	4	8	180	0	0	2026-11-23 16:10:12.721+00	2026-11-23 16:10:12.721+00
\.


--
-- Data for Name: Players; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Players" (id, name, "position", "jerseyNumber", "teamId", "userId", "dateOfBirth", height, weight, nationality, "preferredFoot", "isCaptain", "isActive", "joinDate", avatar, email, phone, "createdAt", "updatedAt") FROM stdin;
1	Amine Tazi	gardien	1	1	3	2003-08-27	193	85	Marocaine	ambidextre	f	t	2023-03-25	\N	amine.tazi@footpro.ma	+212610000002	2026-11-23 16:10:07.486+00	2026-11-23 16:10:07.486+00
2	Salah Ouazzani	gardien	15	1	4	1995-08-18	188	82	Marocaine	droit	f	t	2023-07-20	\N	salah.ouazzani@footpro.ma	+212610000003	2026-11-23 16:10:07.495+00	2026-11-23 16:10:07.495+00
3	Karim Ounahi	defenseur	26	1	5	2006-05-13	186	72	Marocaine	droit	f	t	2023-11-17	\N	karim.ounahi@footpro.ma	+212610000004	2026-11-23 16:10:07.502+00	2026-11-23 16:10:07.502+00
4	Hamza Boufal	defenseur	30	1	6	1997-06-28	173	87	Marocaine	ambidextre	f	t	2023-01-06	\N	hamza.boufal@footpro.ma	+212610000005	2026-11-23 16:10:07.508+00	2026-11-23 16:10:07.508+00
5	Amine Rahimi	defenseur	13	1	7	2007-02-01	182	69	Marocaine	droit	f	t	2025-07-27	\N	amine.rahimi@footpro.ma	+212610000006	2026-11-23 16:10:07.513+00	2026-11-23 16:10:07.513+00
6	Yassine El Idrissi	defenseur	28	1	8	2001-05-11	178	73	Marocaine	droit	f	t	2024-10-28	\N	yassine.el.idrissi@footpro.ma	+212610000007	2026-11-23 16:10:07.521+00	2026-11-23 16:10:07.521+00
7	Walid Rahimi	defenseur	27	1	9	2007-09-04	174	66	Marocaine	droit	f	t	2022-12-27	\N	walid.rahimi@footpro.ma	+212610000008	2026-11-23 16:10:07.527+00	2026-11-23 16:10:07.527+00
8	Soufiane Tazi	defenseur	12	1	10	1999-06-21	189	72	Marocaine	droit	f	t	2023-09-25	\N	soufiane.tazi@footpro.ma	+212610000009	2026-11-23 16:10:07.535+00	2026-11-23 16:10:07.535+00
9	Said Boufal	milieu	3	1	11	1999-05-07	187	71	Marocaine	gauche	t	t	2024-11-11	\N	said.boufal@footpro.ma	+212610000010	2026-11-23 16:10:07.542+00	2026-11-23 16:10:07.542+00
10	Zakaria El Khattabi	milieu	10	1	12	1996-04-01	182	65	Marocaine	droit	f	t	2025-10-17	\N	zakaria.el.khattabi@footpro.ma	+212610000011	2026-11-23 16:10:07.547+00	2026-11-23 16:10:07.547+00
11	Tarik Seddiki	milieu	6	1	13	2003-12-27	174	73	Marocaine	droit	f	t	2024-03-27	\N	tarik.seddiki@footpro.ma	+212610000012	2026-11-23 16:10:07.553+00	2026-11-23 16:10:07.553+00
12	Khalid El Amrani	milieu	5	1	14	2002-03-18	189	69	Marocaine	droit	f	t	2026-09-11	\N	khalid.el.amrani@footpro.ma	+212610000013	2026-11-23 16:10:07.557+00	2026-11-23 16:10:07.557+00
13	Driss El Kaabi	milieu	25	1	15	2000-04-28	179	66	Marocaine	ambidextre	f	t	2023-02-26	\N	driss.el.kaabi@footpro.ma	+212610000014	2026-11-23 16:10:07.561+00	2026-11-23 16:10:07.561+00
14	Yassine Mazraoui	milieu	19	1	16	2004-03-08	178	85	Marocaine	droit	f	t	2026-07-04	\N	yassine.mazraoui@footpro.ma	+212610000015	2026-11-23 16:10:07.566+00	2026-11-23 16:10:07.566+00
15	Hicham Kettani	attaquant	24	1	17	2001-10-28	187	83	Marocaine	gauche	f	t	2026-04-15	\N	hicham.kettani@footpro.ma	+212610000016	2026-11-23 16:10:07.57+00	2026-11-23 16:10:07.57+00
16	Tarik Harit	attaquant	21	1	18	1995-01-12	175	70	Marocaine	droit	f	t	2025-04-23	\N	tarik.harit@footpro.ma	+212610000017	2026-11-23 16:10:07.575+00	2026-11-23 16:10:07.575+00
17	Taha Moutaouakil	attaquant	4	1	19	2007-07-02	172	74	Marocaine	gauche	f	t	2023-04-30	\N	taha.moutaouakil@footpro.ma	+212610000018	2026-11-23 16:10:07.582+00	2026-11-23 16:10:07.582+00
18	Hakim Benoun	attaquant	16	1	20	1999-11-04	175	69	Marocaine	gauche	f	t	2025-05-02	\N	hakim.benoun@footpro.ma	+212610000019	2026-11-23 16:10:07.587+00	2026-11-23 16:10:07.587+00
19	Anas Jabrane	gardien	1	2	22	1999-05-04	190	78	Malienne	droit	f	t	2023-09-16	\N	anas.jabrane@footpro.ma	+212610000021	2026-11-23 16:10:07.602+00	2026-11-23 16:10:07.602+00
20	Imad Bouzidi	gardien	27	2	23	2005-05-06	195	69	Marocaine	droit	f	t	2023-03-03	\N	imad.bouzidi@footpro.ma	+212610000022	2026-11-23 16:10:07.606+00	2026-11-23 16:10:07.606+00
21	Hicham Berrada	defenseur	31	2	24	1999-01-06	184	79	Marocaine	gauche	f	t	2026-06-18	\N	hicham.berrada@footpro.ma	+212610000023	2026-11-23 16:10:07.61+00	2026-11-23 16:10:07.61+00
22	Khalid Aguerd	defenseur	19	2	25	2002-12-16	186	80	Marocaine	droit	f	t	2026-09-07	\N	khalid.aguerd@footpro.ma	+212610000024	2026-11-23 16:10:07.614+00	2026-11-23 16:10:07.614+00
23	Abdelali Fassi	defenseur	3	2	26	1997-09-14	182	73	Marocaine	ambidextre	f	t	2023-02-04	\N	abdelali.fassi@footpro.ma	+212610000025	2026-11-23 16:10:07.626+00	2026-11-23 16:10:07.626+00
24	Soufiane Mazraoui	defenseur	22	2	27	2003-04-23	182	85	Marocaine	gauche	f	t	2025-11-19	\N	soufiane.mazraoui@footpro.ma	+212610000026	2026-11-23 16:10:07.634+00	2026-11-23 16:10:07.634+00
25	Rachid Aguerd	defenseur	25	2	28	2003-06-25	182	73	Marocaine	ambidextre	f	t	2026-07-09	\N	rachid.aguerd@footpro.ma	+212610000027	2026-11-23 16:10:07.645+00	2026-11-23 16:10:07.645+00
26	Adil Chraibi	defenseur	10	2	29	2000-01-03	170	86	Marocaine	droit	f	t	2025-05-17	\N	adil.chraibi@footpro.ma	+212610000028	2026-11-23 16:10:07.656+00	2026-11-23 16:10:07.656+00
27	Abdelali Jabrane	milieu	9	2	30	2003-09-03	182	73	Algérienne	gauche	t	t	2024-11-18	\N	abdelali.jabrane@footpro.ma	+212610000029	2026-11-23 16:10:07.67+00	2026-11-23 16:10:07.67+00
28	Taha Alaoui	milieu	29	2	31	2005-07-24	186	78	Marocaine	droit	f	t	2026-03-01	\N	taha.alaoui@footpro.ma	+212610000030	2026-11-23 16:10:07.678+00	2026-11-23 16:10:07.678+00
29	Rachid Ouchen	milieu	26	2	32	2007-12-04	170	65	Marocaine	droit	f	t	2022-12-29	\N	rachid.ouchen@footpro.ma	+212610000031	2026-11-23 16:10:07.689+00	2026-11-23 16:10:07.689+00
30	Fouad Hakimi	milieu	7	2	33	1998-06-13	173	70	Marocaine	ambidextre	f	t	2026-07-19	\N	fouad.hakimi@footpro.ma	+212610000032	2026-11-23 16:10:07.695+00	2026-11-23 16:10:07.695+00
31	Mounir Boufal	milieu	16	2	34	2007-12-11	170	65	Marocaine	droit	f	t	2024-02-28	\N	mounir.boufal@footpro.ma	+212610000033	2026-11-23 16:10:07.701+00	2026-11-23 16:10:07.701+00
32	Jawad Alaoui	milieu	13	2	35	1999-12-18	168	69	Sénégalaise	droit	f	t	2025-06-07	\N	jawad.alaoui@footpro.ma	+212610000034	2026-11-23 16:10:07.709+00	2026-11-23 16:10:07.709+00
33	Achraf Ziani	attaquant	2	2	36	2003-05-15	177	86	Marocaine	gauche	f	t	2023-07-31	\N	achraf.ziani@footpro.ma	+212610000035	2026-11-23 16:10:07.715+00	2026-11-23 16:10:07.715+00
34	Youssef Bennani	attaquant	4	2	37	1995-10-03	188	64	Marocaine	droit	f	t	2024-12-01	\N	youssef.bennani@footpro.ma	+212610000036	2026-11-23 16:10:07.721+00	2026-11-23 16:10:07.721+00
35	Amine Alaoui	attaquant	21	2	38	2005-07-16	172	64	Marocaine	ambidextre	f	t	2026-02-17	\N	amine.alaoui@footpro.ma	+212610000037	2026-11-23 16:10:07.726+00	2026-11-23 16:10:07.726+00
36	Ilyas Saiss	attaquant	15	2	39	2007-02-19	168	81	Marocaine	droit	f	t	2023-11-11	\N	ilyas.saiss@footpro.ma	+212610000038	2026-11-23 16:10:07.732+00	2026-11-23 16:10:07.732+00
37	Ismail El Idrissi	gardien	1	3	41	2003-05-23	196	83	Malienne	droit	f	t	2022-12-08	\N	ismail.el.idrissi@footpro.ma	+212610000040	2026-11-23 16:10:07.744+00	2026-11-23 16:10:07.744+00
38	Taha Jabrane	gardien	12	3	42	1999-03-19	184	83	Marocaine	droit	f	t	2025-08-19	\N	taha.jabrane@footpro.ma	+212610000041	2026-11-23 16:10:07.753+00	2026-11-23 16:10:07.753+00
39	Driss El Khattabi	defenseur	20	3	43	2003-11-12	184	66	Marocaine	droit	f	t	2023-05-11	\N	driss.el.khattabi@footpro.ma	+212610000042	2026-11-23 16:10:07.76+00	2026-11-23 16:10:07.76+00
40	Hamza Benali	defenseur	19	3	44	2000-05-24	181	88	Marocaine	gauche	f	t	2023-01-08	\N	hamza.benali@footpro.ma	+212610000043	2026-11-23 16:10:07.765+00	2026-11-23 16:10:07.765+00
41	Rachid El Idrissi	defenseur	26	3	45	1999-06-15	182	84	Marocaine	ambidextre	f	t	2023-03-26	\N	rachid.el.idrissi@footpro.ma	+212610000044	2026-11-23 16:10:07.771+00	2026-11-23 16:10:07.771+00
42	Karim Chraibi	defenseur	6	3	46	2004-06-09	189	73	Marocaine	droit	f	t	2023-01-13	\N	karim.chraibi@footpro.ma	+212610000045	2026-11-23 16:10:07.777+00	2026-11-23 16:10:07.777+00
43	Said Boufal	defenseur	31	3	47	1995-03-06	178	77	Marocaine	droit	f	t	2022-11-30	\N	said.boufal2@footpro.ma	+212610000046	2026-11-23 16:10:07.783+00	2026-11-23 16:10:07.783+00
44	Karim Benoun	defenseur	5	3	48	2000-02-13	174	82	Marocaine	droit	f	t	2023-09-02	\N	karim.benoun@footpro.ma	+212610000047	2026-11-23 16:10:07.787+00	2026-11-23 16:10:07.787+00
45	Hamza El Idrissi	milieu	8	3	49	2007-09-06	176	83	Marocaine	gauche	t	t	2024-09-14	\N	hamza.el.idrissi@footpro.ma	+212610000048	2026-11-23 16:10:07.791+00	2026-11-23 16:10:07.791+00
46	Mehdi Tazi	milieu	7	3	50	1998-10-26	185	82	Marocaine	ambidextre	f	t	2026-08-06	\N	mehdi.tazi@footpro.ma	+212610000049	2026-11-23 16:10:07.798+00	2026-11-23 16:10:07.798+00
47	Salah El Amrani	milieu	4	3	51	2002-12-03	181	73	Marocaine	ambidextre	f	t	2023-03-12	\N	salah.el.amrani@footpro.ma	+212610000050	2026-11-23 16:10:07.804+00	2026-11-23 16:10:07.804+00
48	Mohamed Ziani	milieu	17	3	52	2005-12-12	180	87	Marocaine	ambidextre	f	t	2024-11-16	\N	mohamed.ziani@footpro.ma	+212610000051	2026-11-23 16:10:07.809+00	2026-11-23 16:10:07.809+00
49	Amine Ait Ali	milieu	29	3	53	1996-04-02	173	84	Malienne	gauche	f	t	2022-12-03	\N	amine.ait.ali@footpro.ma	+212610000052	2026-11-23 16:10:07.813+00	2026-11-23 16:10:07.813+00
50	Nabil El Kaabi	milieu	28	3	54	2000-11-21	182	66	Marocaine	droit	f	t	2025-06-02	\N	nabil.el.kaabi@footpro.ma	+212610000053	2026-11-23 16:10:07.817+00	2026-11-23 16:10:07.817+00
51	Ilyas Sqalli	attaquant	11	3	55	2000-12-19	174	70	Marocaine	droit	f	t	2026-01-30	\N	ilyas.sqalli@footpro.ma	+212610000054	2026-11-23 16:10:07.823+00	2026-11-23 16:10:07.823+00
52	Taha Sqalli	attaquant	18	3	56	2005-04-15	181	87	Marocaine	droit	f	t	2024-12-11	\N	taha.sqalli@footpro.ma	+212610000055	2026-11-23 16:10:07.826+00	2026-11-23 16:10:07.826+00
53	Nabil Berrada	attaquant	2	3	57	1996-06-27	183	70	Marocaine	gauche	f	t	2024-03-16	\N	nabil.berrada@footpro.ma	+212610000056	2026-11-23 16:10:07.832+00	2026-11-23 16:10:07.832+00
54	Driss Ezzalzouli	attaquant	10	3	58	1998-10-02	171	67	Marocaine	droit	f	t	2024-02-22	\N	driss.ezzalzouli@footpro.ma	+212610000057	2026-11-23 16:10:07.836+00	2026-11-23 16:10:07.836+00
55	Jawad Ouchen	gardien	1	4	60	1997-07-19	195	85	Marocaine	ambidextre	f	t	2023-12-10	\N	jawad.ouchen@footpro.ma	+212610000059	2026-11-23 16:10:07.858+00	2026-11-23 16:10:07.858+00
56	Badr Belhaj	gardien	6	4	61	2002-01-26	196	77	Marocaine	gauche	f	t	2024-01-26	\N	badr.belhaj@footpro.ma	+212610000060	2026-11-23 16:10:07.868+00	2026-11-23 16:10:07.868+00
57	Salah Jabrane	defenseur	12	4	62	2004-03-01	170	75	Marocaine	droit	f	t	2024-09-15	\N	salah.jabrane@footpro.ma	+212610000061	2026-11-23 16:10:07.876+00	2026-11-23 16:10:07.876+00
58	Fouad Chraibi	defenseur	23	4	63	2006-05-15	171	64	Marocaine	droit	f	t	2023-10-31	\N	fouad.chraibi@footpro.ma	+212610000062	2026-11-23 16:10:07.885+00	2026-11-23 16:10:07.885+00
59	Khalid Benoun	defenseur	22	4	64	2000-03-15	175	75	Marocaine	droit	f	t	2026-08-29	\N	khalid.benoun@footpro.ma	+212610000063	2026-11-23 16:10:07.89+00	2026-11-23 16:10:07.89+00
60	Karim Moutaouakil	defenseur	24	4	65	2007-06-26	176	81	Marocaine	droit	f	t	2023-08-31	\N	karim.moutaouakil@footpro.ma	+212610000064	2026-11-23 16:10:07.894+00	2026-11-23 16:10:07.894+00
61	Mohamed Lahlou	defenseur	7	4	66	2004-01-22	187	85	Marocaine	droit	f	t	2024-09-26	\N	mohamed.lahlou@footpro.ma	+212610000065	2026-11-23 16:10:07.898+00	2026-11-23 16:10:07.898+00
62	Nassim Alaoui	defenseur	16	4	67	2000-01-15	174	65	Marocaine	droit	f	t	2023-09-25	\N	nassim.alaoui@footpro.ma	+212610000066	2026-11-23 16:10:07.901+00	2026-11-23 16:10:07.901+00
63	Hicham Fassi	milieu	10	4	68	2006-01-16	180	74	Marocaine	droit	t	t	2026-02-10	\N	hicham.fassi@footpro.ma	+212610000067	2026-11-23 16:10:07.906+00	2026-11-23 16:10:07.906+00
64	Mehdi Ziani	milieu	26	4	69	1998-03-28	173	77	Marocaine	droit	f	t	2025-05-17	\N	mehdi.ziani@footpro.ma	+212610000068	2026-11-23 16:10:07.91+00	2026-11-23 16:10:07.91+00
65	Bilal Naciri	milieu	21	4	70	1995-08-26	174	65	Marocaine	droit	f	t	2025-07-22	\N	bilal.naciri@footpro.ma	+212610000069	2026-11-23 16:10:07.916+00	2026-11-23 16:10:07.916+00
66	Salah Benali	milieu	14	4	71	2007-06-05	190	73	Marocaine	droit	f	t	2025-12-14	\N	salah.benali@footpro.ma	+212610000070	2026-11-23 16:10:07.922+00	2026-11-23 16:10:07.922+00
67	Jawad Mazraoui	milieu	11	4	72	2004-05-19	172	86	Marocaine	droit	f	t	2026-03-20	\N	jawad.mazraoui@footpro.ma	+212610000071	2026-11-23 16:10:07.93+00	2026-11-23 16:10:07.93+00
68	Badr Ait Ali	milieu	5	4	73	2004-02-15	175	81	Malienne	droit	f	t	2025-05-28	\N	badr.ait.ali@footpro.ma	+212610000072	2026-11-23 16:10:07.938+00	2026-11-23 16:10:07.938+00
69	Achraf El Kaabi	attaquant	25	4	74	1997-06-08	174	81	Algérienne	gauche	f	t	2023-01-19	\N	achraf.el.kaabi@footpro.ma	+212610000073	2026-11-23 16:10:07.942+00	2026-11-23 16:10:07.942+00
70	Amine Ziani	attaquant	29	4	75	2007-07-16	177	88	Marocaine	gauche	f	t	2026-06-18	\N	amine.ziani@footpro.ma	+212610000074	2026-11-23 16:10:07.949+00	2026-11-23 16:10:07.949+00
71	Mounir Moutaouakil	attaquant	31	4	76	1998-07-16	180	70	Marocaine	gauche	f	t	2024-02-06	\N	mounir.moutaouakil@footpro.ma	+212610000075	2026-11-23 16:10:07.958+00	2026-11-23 16:10:07.958+00
72	Said Ouchen	attaquant	17	4	77	2000-11-26	172	76	Marocaine	ambidextre	f	t	2026-01-21	\N	said.ouchen@footpro.ma	+212610000076	2026-11-23 16:10:07.966+00	2026-11-23 16:10:07.966+00
73	Taha Saiss	gardien	1	5	79	2006-01-09	192	84	Marocaine	droit	f	t	2024-03-01	\N	taha.saiss@footpro.ma	+212610000078	2026-11-23 16:10:07.979+00	2026-11-23 16:10:07.979+00
74	Nassim Mazraoui	gardien	27	5	80	2001-07-23	194	64	Marocaine	droit	f	t	2025-10-14	\N	nassim.mazraoui@footpro.ma	+212610000079	2026-11-23 16:10:07.984+00	2026-11-23 16:10:07.984+00
75	Said Rami	defenseur	29	5	81	1997-04-22	178	66	Marocaine	droit	f	t	2025-07-30	\N	said.rami@footpro.ma	+212610000080	2026-11-23 16:10:07.99+00	2026-11-23 16:10:07.99+00
76	Achraf Harit	defenseur	13	5	82	2001-01-04	181	70	Marocaine	gauche	f	t	2022-12-24	\N	achraf.harit@footpro.ma	+212610000081	2026-11-23 16:10:07.996+00	2026-11-23 16:10:07.996+00
77	Hamza Boufal	defenseur	10	5	83	2000-03-13	188	83	Marocaine	gauche	f	t	2023-12-13	\N	hamza.boufal2@footpro.ma	+212610000082	2026-11-23 16:10:08+00	2026-11-23 16:10:08+00
78	Said Ounahi	defenseur	25	5	84	2002-11-10	178	71	Sénégalaise	ambidextre	f	t	2023-10-01	\N	said.ounahi@footpro.ma	+212610000083	2026-11-23 16:10:08.007+00	2026-11-23 16:10:08.007+00
79	Othmane El Kaabi	defenseur	14	5	85	2006-10-01	190	77	Marocaine	droit	f	t	2026-08-05	\N	othmane.el.kaabi@footpro.ma	+212610000084	2026-11-23 16:10:08.013+00	2026-11-23 16:10:08.013+00
80	Bilal Ouchen	defenseur	28	5	86	1996-10-01	183	84	Marocaine	droit	f	t	2024-12-05	\N	bilal.ouchen@footpro.ma	+212610000085	2026-11-23 16:10:08.022+00	2026-11-23 16:10:08.022+00
81	Tarik Jabrane	milieu	6	5	87	2000-11-15	190	70	Marocaine	gauche	t	t	2025-07-20	\N	tarik.jabrane@footpro.ma	+212610000086	2026-11-23 16:10:08.029+00	2026-11-23 16:10:08.029+00
82	Fouad Boufal	milieu	11	5	88	1995-06-18	168	72	Ivoirienne	droit	f	t	2026-01-11	\N	fouad.boufal@footpro.ma	+212610000087	2026-11-23 16:10:08.035+00	2026-11-23 16:10:08.035+00
83	Salah Amallah	milieu	26	5	89	2006-10-09	171	85	Marocaine	droit	f	t	2022-11-15	\N	salah.amallah@footpro.ma	+212610000088	2026-11-23 16:10:08.039+00	2026-11-23 16:10:08.039+00
84	Mehdi Kettani	milieu	21	5	90	2001-07-15	182	81	Marocaine	droit	f	t	2023-05-25	\N	mehdi.kettani@footpro.ma	+212610000089	2026-11-23 16:10:08.042+00	2026-11-23 16:10:08.042+00
85	Abdelali Harit	milieu	22	5	91	2000-04-18	178	78	Ivoirienne	droit	f	t	2024-05-06	\N	abdelali.harit@footpro.ma	+212610000090	2026-11-23 16:10:08.046+00	2026-11-23 16:10:08.046+00
86	Soufiane Ait Ali	milieu	23	5	92	1998-12-26	169	68	Marocaine	droit	f	t	2025-06-28	\N	soufiane.ait.ali@footpro.ma	+212610000091	2026-11-23 16:10:08.053+00	2026-11-23 16:10:08.053+00
87	Salah Ounahi	attaquant	15	5	93	2006-11-04	172	79	Marocaine	gauche	f	t	2026-03-26	\N	salah.ounahi@footpro.ma	+212610000092	2026-11-23 16:10:08.061+00	2026-11-23 16:10:08.061+00
88	Jawad Amallah	attaquant	3	5	94	1999-08-11	189	68	Marocaine	droit	f	t	2025-08-12	\N	jawad.amallah@footpro.ma	+212610000093	2026-11-23 16:10:08.072+00	2026-11-23 16:10:08.072+00
89	Nabil Zerouali	attaquant	9	5	95	1997-05-21	168	65	Marocaine	gauche	f	t	2024-03-28	\N	nabil.zerouali@footpro.ma	+212610000094	2026-11-23 16:10:08.08+00	2026-11-23 16:10:08.08+00
90	Walid Tazi	attaquant	8	5	96	2003-04-15	187	80	Sénégalaise	gauche	f	t	2024-02-04	\N	walid.tazi@footpro.ma	+212610000095	2026-11-23 16:10:08.093+00	2026-11-23 16:10:08.093+00
91	Othmane Boufal	gardien	1	6	98	2000-04-10	189	82	Algérienne	droit	f	t	2025-12-22	\N	othmane.boufal@footpro.ma	+212610000097	2026-11-23 16:10:08.11+00	2026-11-23 16:10:08.11+00
92	Ilyas Alaoui	gardien	13	6	99	2000-03-08	189	66	Marocaine	droit	f	t	2023-01-13	\N	ilyas.alaoui@footpro.ma	+212610000098	2026-11-23 16:10:08.117+00	2026-11-23 16:10:08.117+00
93	Abdelali El Idrissi	defenseur	29	6	100	1996-06-12	177	84	Marocaine	droit	f	t	2025-06-07	\N	abdelali.el.idrissi@footpro.ma	+212610000099	2026-11-23 16:10:08.124+00	2026-11-23 16:10:08.124+00
94	Khalid Kettani	defenseur	23	6	101	1999-06-23	190	64	Marocaine	droit	f	t	2023-11-10	\N	khalid.kettani@footpro.ma	+212610000100	2026-11-23 16:10:08.129+00	2026-11-23 16:10:08.129+00
95	Omar Ziani	defenseur	22	6	102	2006-06-10	188	84	Sénégalaise	ambidextre	f	t	2023-08-28	\N	omar.ziani@footpro.ma	+212610000101	2026-11-23 16:10:08.137+00	2026-11-23 16:10:08.137+00
96	Soufiane Tazi	defenseur	6	6	103	2004-01-15	168	70	Marocaine	droit	f	t	2025-02-19	\N	soufiane.tazi2@footpro.ma	+212610000102	2026-11-23 16:10:08.143+00	2026-11-23 16:10:08.143+00
97	Mohamed Bouzidi	defenseur	7	6	104	1995-05-21	170	69	Marocaine	gauche	f	t	2023-04-19	\N	mohamed.bouzidi@footpro.ma	+212610000103	2026-11-23 16:10:08.153+00	2026-11-23 16:10:08.153+00
98	Zakaria Bouzidi	defenseur	14	6	105	2007-11-06	176	79	Marocaine	droit	f	t	2025-12-30	\N	zakaria.bouzidi@footpro.ma	+212610000104	2026-11-23 16:10:08.161+00	2026-11-23 16:10:08.161+00
99	Driss Aguerd	milieu	25	6	106	1997-03-14	187	86	Marocaine	droit	t	t	2024-07-02	\N	driss.aguerd@footpro.ma	+212610000105	2026-11-23 16:10:08.17+00	2026-11-23 16:10:08.17+00
100	Abdelali Harit	milieu	21	6	107	1996-12-26	171	70	Marocaine	droit	f	t	2023-11-11	\N	abdelali.harit2@footpro.ma	+212610000106	2026-11-23 16:10:08.178+00	2026-11-23 16:10:08.178+00
101	Adil Berrada	milieu	18	6	108	1998-09-01	184	70	Marocaine	droit	f	t	2025-03-31	\N	adil.berrada@footpro.ma	+212610000107	2026-11-23 16:10:08.185+00	2026-11-23 16:10:08.185+00
102	Adil Rahimi	milieu	19	6	109	2006-04-16	170	67	Marocaine	droit	f	t	2023-03-25	\N	adil.rahimi@footpro.ma	+212610000108	2026-11-23 16:10:08.19+00	2026-11-23 16:10:08.19+00
103	Taha El Kaabi	milieu	9	6	110	1996-05-21	185	67	Marocaine	droit	f	t	2023-06-02	\N	taha.el.kaabi@footpro.ma	+212610000109	2026-11-23 16:10:08.195+00	2026-11-23 16:10:08.195+00
104	Fouad Ounahi	milieu	28	6	111	1999-08-09	180	64	Marocaine	gauche	f	t	2025-08-29	\N	fouad.ounahi@footpro.ma	+212610000110	2026-11-23 16:10:08.2+00	2026-11-23 16:10:08.2+00
105	Ismail Tazi	attaquant	31	6	112	2001-08-27	179	72	Marocaine	droit	f	t	2025-08-19	\N	ismail.tazi@footpro.ma	+212610000111	2026-11-23 16:10:08.205+00	2026-11-23 16:10:08.205+00
106	Walid Benoun	attaquant	24	6	113	1997-12-11	178	72	Marocaine	droit	f	t	2024-04-17	\N	walid.benoun@footpro.ma	+212610000112	2026-11-23 16:10:08.21+00	2026-11-23 16:10:08.21+00
107	Hamza Naciri	attaquant	11	6	114	1997-11-08	168	78	Malienne	droit	f	t	2024-02-05	\N	hamza.naciri@footpro.ma	+212610000113	2026-11-23 16:10:08.215+00	2026-11-23 16:10:08.215+00
108	Ayman Benali	attaquant	5	6	115	2007-07-11	185	74	Marocaine	droit	f	t	2025-05-20	\N	ayman.benali@footpro.ma	+212610000114	2026-11-23 16:10:08.223+00	2026-11-23 16:10:08.223+00
109	Bilal Ait Ali	gardien	1	7	117	1999-02-21	186	82	Marocaine	droit	f	t	2023-10-26	\N	bilal.ait.ali@footpro.ma	+212610000116	2026-11-23 16:10:08.235+00	2026-11-23 16:10:08.235+00
110	Karim Rahimi	gardien	3	7	118	1998-02-08	189	87	Marocaine	ambidextre	f	t	2026-04-14	\N	karim.rahimi@footpro.ma	+212610000117	2026-11-23 16:10:08.239+00	2026-11-23 16:10:08.239+00
111	Walid Zerouali	defenseur	21	7	119	2007-01-11	174	69	Marocaine	ambidextre	f	t	2025-08-07	\N	walid.zerouali@footpro.ma	+212610000118	2026-11-23 16:10:08.245+00	2026-11-23 16:10:08.245+00
112	Nabil Moutaouakil	defenseur	22	7	120	1996-02-26	169	84	Malienne	ambidextre	f	t	2024-04-25	\N	nabil.moutaouakil@footpro.ma	+212610000119	2026-11-23 16:10:08.249+00	2026-11-23 16:10:08.249+00
113	Zakaria El Khattabi	defenseur	18	7	121	2007-08-11	178	67	Marocaine	droit	f	t	2026-01-17	\N	zakaria.el.khattabi2@footpro.ma	+212610000120	2026-11-23 16:10:08.257+00	2026-11-23 16:10:08.257+00
114	Ayman Mazraoui	defenseur	19	7	122	2006-12-16	176	70	Marocaine	droit	f	t	2025-07-08	\N	ayman.mazraoui@footpro.ma	+212610000121	2026-11-23 16:10:08.266+00	2026-11-23 16:10:08.266+00
115	Mohamed Ouazzani	defenseur	16	7	123	1999-08-06	171	69	Marocaine	droit	f	t	2026-07-19	\N	mohamed.ouazzani@footpro.ma	+212610000122	2026-11-23 16:10:08.274+00	2026-11-23 16:10:08.274+00
116	Tarik Berrada	defenseur	29	7	124	1998-03-09	176	74	Marocaine	droit	f	t	2026-01-08	\N	tarik.berrada@footpro.ma	+212610000123	2026-11-23 16:10:08.283+00	2026-11-23 16:10:08.283+00
117	Omar Sqalli	milieu	30	7	125	1998-03-04	168	78	Marocaine	gauche	t	t	2025-04-10	\N	omar.sqalli@footpro.ma	+212610000124	2026-11-23 16:10:08.3+00	2026-11-23 16:10:08.3+00
118	Noureddine Fassi	milieu	20	7	126	2007-02-06	184	66	Marocaine	droit	f	t	2026-05-20	\N	noureddine.fassi@footpro.ma	+212610000125	2026-11-23 16:10:08.309+00	2026-11-23 16:10:08.309+00
119	Jawad Haddad	milieu	8	7	127	2005-07-19	181	75	Marocaine	droit	f	t	2025-12-22	\N	jawad.haddad@footpro.ma	+212610000126	2026-11-23 16:10:08.322+00	2026-11-23 16:10:08.322+00
120	Taha Benali	milieu	13	7	128	2004-01-04	173	86	Marocaine	gauche	f	t	2022-10-16	\N	taha.benali@footpro.ma	+212610000127	2026-11-23 16:10:08.329+00	2026-11-23 16:10:08.329+00
121	Ilyas Amallah	milieu	4	7	129	2004-10-19	179	73	Marocaine	droit	f	t	2026-03-08	\N	ilyas.amallah@footpro.ma	+212610000128	2026-11-23 16:10:08.335+00	2026-11-23 16:10:08.335+00
122	Walid Belhaj	milieu	27	7	130	2002-08-24	172	74	Marocaine	droit	f	t	2023-07-20	\N	walid.belhaj@footpro.ma	+212610000129	2026-11-23 16:10:08.342+00	2026-11-23 16:10:08.342+00
123	Nassim Lahlou	attaquant	2	7	131	2003-08-10	177	74	Algérienne	gauche	f	t	2026-04-22	\N	nassim.lahlou@footpro.ma	+212610000130	2026-11-23 16:10:08.347+00	2026-11-23 16:10:08.347+00
124	Karim Moutaouakil	attaquant	10	7	132	2002-11-12	177	81	Marocaine	droit	f	t	2024-11-29	\N	karim.moutaouakil2@footpro.ma	+212610000131	2026-11-23 16:10:08.351+00	2026-11-23 16:10:08.351+00
125	Nabil Ounahi	attaquant	12	7	133	2003-06-23	189	71	Marocaine	ambidextre	f	t	2024-12-18	\N	nabil.ounahi@footpro.ma	+212610000132	2026-11-23 16:10:08.356+00	2026-11-23 16:10:08.356+00
126	Ayoub Haddad	attaquant	11	7	134	2003-08-03	179	73	Marocaine	ambidextre	f	t	2024-08-29	\N	ayoub.haddad@footpro.ma	+212610000133	2026-11-23 16:10:08.362+00	2026-11-23 16:10:08.362+00
127	Said Alaoui	gardien	1	8	136	2001-11-26	194	81	Marocaine	droit	f	t	2023-09-12	\N	said.alaoui@footpro.ma	+212610000135	2026-11-23 16:10:08.374+00	2026-11-23 16:10:08.374+00
128	Ilyas Seddiki	gardien	25	8	137	2006-01-28	195	69	Marocaine	droit	f	t	2024-09-18	\N	ilyas.seddiki@footpro.ma	+212610000136	2026-11-23 16:10:08.38+00	2026-11-23 16:10:08.38+00
129	Anas Rahimi	defenseur	28	8	138	2006-09-06	181	81	Marocaine	gauche	f	t	2024-02-26	\N	anas.rahimi@footpro.ma	+212610000137	2026-11-23 16:10:08.387+00	2026-11-23 16:10:08.387+00
130	Tarik Ezzalzouli	defenseur	20	8	139	2004-01-15	177	70	Ivoirienne	droit	f	t	2023-04-24	\N	tarik.ezzalzouli@footpro.ma	+212610000138	2026-11-23 16:10:08.395+00	2026-11-23 16:10:08.395+00
131	Khalid Saiss	defenseur	13	8	140	1999-02-17	172	71	Marocaine	droit	f	t	2023-09-05	\N	khalid.saiss@footpro.ma	+212610000139	2026-11-23 16:10:08.402+00	2026-11-23 16:10:08.402+00
132	Karim Jabrane	defenseur	21	8	141	1996-05-25	178	87	Marocaine	droit	f	t	2024-01-15	\N	karim.jabrane@footpro.ma	+212610000140	2026-11-23 16:10:08.408+00	2026-11-23 16:10:08.408+00
133	Adil Boufal	defenseur	22	8	142	2000-10-12	168	76	Marocaine	droit	f	t	2025-11-27	\N	adil.boufal@footpro.ma	+212610000141	2026-11-23 16:10:08.414+00	2026-11-23 16:10:08.414+00
134	Mehdi Harit	defenseur	24	8	143	2007-03-10	185	68	Malienne	ambidextre	f	t	2025-01-24	\N	mehdi.harit@footpro.ma	+212610000142	2026-11-23 16:10:08.419+00	2026-11-23 16:10:08.419+00
135	Tarik Moutaouakil	milieu	31	8	144	2005-10-14	180	73	Marocaine	gauche	t	t	2024-04-17	\N	tarik.moutaouakil@footpro.ma	+212610000143	2026-11-23 16:10:08.427+00	2026-11-23 16:10:08.427+00
136	Fouad Bouzidi	milieu	23	8	145	2003-05-24	168	72	Marocaine	droit	f	t	2025-11-13	\N	fouad.bouzidi@footpro.ma	+212610000144	2026-11-23 16:10:08.431+00	2026-11-23 16:10:08.431+00
137	Zakaria Boufal	milieu	15	8	146	2006-06-03	187	73	Marocaine	ambidextre	f	t	2024-07-16	\N	zakaria.boufal@footpro.ma	+212610000145	2026-11-23 16:10:08.436+00	2026-11-23 16:10:08.436+00
138	Mehdi Ezzalzouli	milieu	5	8	147	2001-04-08	186	80	Marocaine	ambidextre	f	t	2024-03-26	\N	mehdi.ezzalzouli@footpro.ma	+212610000146	2026-11-23 16:10:08.443+00	2026-11-23 16:10:08.443+00
139	Fouad Amrabat	milieu	2	8	148	2003-10-14	185	83	Marocaine	ambidextre	f	t	2024-03-15	\N	fouad.amrabat@footpro.ma	+212610000147	2026-11-23 16:10:08.448+00	2026-11-23 16:10:08.448+00
140	Rachid Rahimi	milieu	3	8	149	2007-05-21	190	74	Marocaine	ambidextre	f	t	2026-01-28	\N	rachid.rahimi@footpro.ma	+212610000148	2026-11-23 16:10:08.452+00	2026-11-23 16:10:08.452+00
141	Jawad Ait Ali	attaquant	29	8	150	1997-12-19	181	81	Marocaine	droit	f	t	2023-03-03	\N	jawad.ait.ali@footpro.ma	+212610000149	2026-11-23 16:10:08.459+00	2026-11-23 16:10:08.459+00
142	Ismail Ezzalzouli	attaquant	10	8	151	2005-07-21	169	83	Marocaine	droit	f	t	2024-01-31	\N	ismail.ezzalzouli@footpro.ma	+212610000150	2026-11-23 16:10:08.466+00	2026-11-23 16:10:08.466+00
143	Jawad Aguerd	attaquant	6	8	152	1999-12-26	168	65	Marocaine	gauche	f	t	2024-10-05	\N	jawad.aguerd@footpro.ma	+212610000151	2026-11-23 16:10:08.471+00	2026-11-23 16:10:08.471+00
144	Mehdi Ezzalzouli	attaquant	16	8	153	1997-09-28	181	74	Ivoirienne	droit	f	t	2024-11-18	\N	mehdi.ezzalzouli2@footpro.ma	+212610000152	2026-11-23 16:10:08.475+00	2026-11-23 16:10:08.475+00
145	Yassine Amallah	gardien	1	9	155	2001-02-09	196	77	Ivoirienne	ambidextre	f	t	2024-06-10	\N	yassine.amallah@footpro.ma	+212610000154	2026-11-23 16:10:08.49+00	2026-11-23 16:10:08.49+00
146	Bilal El Kaabi	gardien	13	9	156	2001-07-25	185	83	Marocaine	ambidextre	f	t	2026-06-06	\N	bilal.el.kaabi@footpro.ma	+212610000155	2026-11-23 16:10:08.499+00	2026-11-23 16:10:08.499+00
147	Khalid Aguerd	defenseur	28	9	157	2005-05-02	175	81	Ivoirienne	ambidextre	f	t	2024-01-01	\N	khalid.aguerd2@footpro.ma	+212610000156	2026-11-23 16:10:08.507+00	2026-11-23 16:10:08.507+00
148	Tarik Seddiki	defenseur	17	9	158	2004-12-06	174	81	Marocaine	gauche	f	t	2025-04-06	\N	tarik.seddiki2@footpro.ma	+212610000157	2026-11-23 16:10:08.517+00	2026-11-23 16:10:08.517+00
149	Hicham Mansouri	defenseur	26	9	159	1995-09-01	175	67	Marocaine	droit	f	t	2025-06-15	\N	hicham.mansouri@footpro.ma	+212610000158	2026-11-23 16:10:08.529+00	2026-11-23 16:10:08.529+00
150	Tarik Ezzalzouli	defenseur	27	9	160	1995-07-26	189	71	Marocaine	droit	f	t	2024-07-15	\N	tarik.ezzalzouli2@footpro.ma	+212610000159	2026-11-23 16:10:08.536+00	2026-11-23 16:10:08.536+00
151	Badr Amrabat	defenseur	23	9	161	2003-03-12	182	68	Marocaine	gauche	f	t	2024-11-30	\N	badr.amrabat@footpro.ma	+212610000160	2026-11-23 16:10:08.542+00	2026-11-23 16:10:08.542+00
152	Karim Ouchen	defenseur	4	9	162	2007-12-07	171	75	Marocaine	droit	f	t	2026-04-23	\N	karim.ouchen@footpro.ma	+212610000161	2026-11-23 16:10:08.548+00	2026-11-23 16:10:08.548+00
153	Amine Chraibi	milieu	7	9	163	1999-04-09	181	68	Marocaine	droit	t	t	2024-02-20	\N	amine.chraibi@footpro.ma	+212610000162	2026-11-23 16:10:08.553+00	2026-11-23 16:10:08.553+00
154	Rachid Bouzidi	milieu	18	9	164	1998-12-10	190	85	Marocaine	gauche	f	t	2023-07-30	\N	rachid.bouzidi@footpro.ma	+212610000163	2026-11-23 16:10:08.558+00	2026-11-23 16:10:08.558+00
155	Anas Zerouali	milieu	15	9	165	2003-12-25	182	84	Marocaine	droit	f	t	2024-05-01	\N	anas.zerouali@footpro.ma	+212610000164	2026-11-23 16:10:08.562+00	2026-11-23 16:10:08.562+00
156	Anas Seddiki	milieu	20	9	166	2003-12-18	182	84	Marocaine	droit	f	t	2023-07-13	\N	anas.seddiki@footpro.ma	+212610000165	2026-11-23 16:10:08.567+00	2026-11-23 16:10:08.567+00
157	Adil Zerouali	milieu	24	9	167	2005-04-10	173	72	Marocaine	droit	f	t	2025-10-12	\N	adil.zerouali@footpro.ma	+212610000166	2026-11-23 16:10:08.571+00	2026-11-23 16:10:08.571+00
158	Youssef El Khattabi	milieu	30	9	168	2004-02-14	183	70	Marocaine	droit	f	t	2026-08-24	\N	youssef.el.khattabi@footpro.ma	+212610000167	2026-11-23 16:10:08.575+00	2026-11-23 16:10:08.575+00
159	Imad Alaoui	attaquant	6	9	169	2007-02-24	174	79	Marocaine	gauche	f	t	2025-08-26	\N	imad.alaoui@footpro.ma	+212610000168	2026-11-23 16:10:08.579+00	2026-11-23 16:10:08.579+00
160	Zakaria Fassi	attaquant	16	9	170	2004-10-26	168	81	Marocaine	droit	f	t	2024-06-24	\N	zakaria.fassi@footpro.ma	+212610000169	2026-11-23 16:10:08.584+00	2026-11-23 16:10:08.584+00
161	Taha Saiss	attaquant	9	9	171	2002-03-19	185	64	Marocaine	droit	f	t	2026-01-22	\N	taha.saiss2@footpro.ma	+212610000170	2026-11-23 16:10:08.589+00	2026-11-23 16:10:08.589+00
162	Nabil Amallah	attaquant	29	9	172	2005-02-27	189	79	Malienne	droit	f	t	2025-11-17	\N	nabil.amallah@footpro.ma	+212610000171	2026-11-23 16:10:08.593+00	2026-11-23 16:10:08.593+00
163	Walid Seddiki	gardien	1	10	174	1997-05-20	187	71	Marocaine	droit	f	t	2022-12-22	\N	walid.seddiki@footpro.ma	+212610000173	2026-11-23 16:10:08.603+00	2026-11-23 16:10:08.603+00
164	Omar Hakimi	gardien	11	10	175	1996-12-15	191	66	Marocaine	droit	f	t	2026-08-29	\N	omar.hakimi@footpro.ma	+212610000174	2026-11-23 16:10:08.609+00	2026-11-23 16:10:08.609+00
165	Mounir Alaoui	defenseur	13	10	176	2007-10-07	190	76	Marocaine	droit	f	t	2026-01-19	\N	mounir.alaoui@footpro.ma	+212610000175	2026-11-23 16:10:08.616+00	2026-11-23 16:10:08.616+00
166	Adil Amrabat	defenseur	12	10	177	2006-08-22	186	69	Marocaine	droit	f	t	2023-02-10	\N	adil.amrabat@footpro.ma	+212610000176	2026-11-23 16:10:08.625+00	2026-11-23 16:10:08.625+00
167	Ayoub El Amrani	defenseur	9	10	178	1997-09-18	185	65	Marocaine	droit	f	t	2026-07-28	\N	ayoub.el.amrani@footpro.ma	+212610000177	2026-11-23 16:10:08.63+00	2026-11-23 16:10:08.63+00
168	Noureddine Naciri	defenseur	5	10	179	1995-02-25	170	83	Marocaine	droit	f	t	2025-05-07	\N	noureddine.naciri@footpro.ma	+212610000178	2026-11-23 16:10:08.635+00	2026-11-23 16:10:08.635+00
169	Nabil El Kaabi	defenseur	16	10	180	2003-09-05	179	84	Marocaine	droit	f	t	2024-02-27	\N	nabil.el.kaabi2@footpro.ma	+212610000179	2026-11-23 16:10:08.638+00	2026-11-23 16:10:08.638+00
170	Ilyas Ouchen	defenseur	10	10	181	2006-04-02	172	71	Marocaine	droit	f	t	2024-05-05	\N	ilyas.ouchen@footpro.ma	+212610000180	2026-11-23 16:10:08.642+00	2026-11-23 16:10:08.642+00
171	Othmane Moutaouakil	milieu	22	10	182	1998-09-09	184	75	Marocaine	droit	t	t	2025-10-06	\N	othmane.moutaouakil@footpro.ma	+212610000181	2026-11-23 16:10:08.647+00	2026-11-23 16:10:08.647+00
172	Khalid Bennani	milieu	19	10	183	2002-11-26	190	87	Marocaine	droit	f	t	2023-06-29	\N	khalid.bennani@footpro.ma	+212610000182	2026-11-23 16:10:08.651+00	2026-11-23 16:10:08.651+00
173	Tarik Hakimi	milieu	30	10	184	2006-11-28	181	71	Algérienne	droit	f	t	2023-03-31	\N	tarik.hakimi@footpro.ma	+212610000183	2026-11-23 16:10:08.655+00	2026-11-23 16:10:08.655+00
174	Driss Rahimi	milieu	8	10	185	1995-05-27	180	68	Marocaine	ambidextre	f	t	2024-02-21	\N	driss.rahimi@footpro.ma	+212610000184	2026-11-23 16:10:08.66+00	2026-11-23 16:10:08.66+00
175	Nassim Fassi	milieu	17	10	186	2003-06-09	174	75	Marocaine	droit	f	t	2023-01-13	\N	nassim.fassi@footpro.ma	+212610000185	2026-11-23 16:10:08.665+00	2026-11-23 16:10:08.665+00
176	Badr Tazi	milieu	28	10	187	2007-04-04	182	70	Marocaine	gauche	f	t	2023-01-04	\N	badr.tazi@footpro.ma	+212610000186	2026-11-23 16:10:08.672+00	2026-11-23 16:10:08.672+00
177	Noureddine Harit	attaquant	18	10	188	1998-06-26	188	66	Algérienne	gauche	f	t	2024-02-21	\N	noureddine.harit@footpro.ma	+212610000187	2026-11-23 16:10:08.676+00	2026-11-23 16:10:08.676+00
178	Hakim Lahlou	attaquant	15	10	189	1998-01-19	182	83	Marocaine	gauche	f	t	2025-06-16	\N	hakim.lahlou@footpro.ma	+212610000188	2026-11-23 16:10:08.681+00	2026-11-23 16:10:08.681+00
179	Zakaria Berrada	attaquant	25	10	190	1996-05-18	178	77	Marocaine	droit	f	t	2025-01-25	\N	zakaria.berrada@footpro.ma	+212610000189	2026-11-23 16:10:08.687+00	2026-11-23 16:10:08.687+00
180	Adil Ait Ali	attaquant	26	10	191	2006-03-03	177	76	Marocaine	gauche	f	t	2026-07-16	\N	adil.ait.ali@footpro.ma	+212610000190	2026-11-23 16:10:08.691+00	2026-11-23 16:10:08.691+00
181	Nabil Lahlou	gardien	1	11	193	1995-01-27	196	88	Marocaine	droit	f	t	2025-02-15	\N	nabil.lahlou@footpro.ma	+212610000192	2026-11-23 16:10:08.701+00	2026-11-23 16:10:08.701+00
182	Mounir El Amrani	gardien	26	11	194	2002-12-21	196	86	Marocaine	droit	f	t	2025-10-20	\N	mounir.el.amrani@footpro.ma	+212610000193	2026-11-23 16:10:08.708+00	2026-11-23 16:10:08.708+00
183	Zakaria Zerouali	defenseur	28	11	195	2006-05-09	179	73	Marocaine	gauche	f	t	2023-06-25	\N	zakaria.zerouali@footpro.ma	+212610000194	2026-11-23 16:10:08.716+00	2026-11-23 16:10:08.716+00
184	Ayoub Tazi	defenseur	27	11	196	1999-02-21	169	84	Marocaine	droit	f	t	2024-08-24	\N	ayoub.tazi@footpro.ma	+212610000195	2026-11-23 16:10:08.727+00	2026-11-23 16:10:08.727+00
185	Tarik Mazraoui	defenseur	6	11	197	1998-02-16	179	87	Marocaine	droit	f	t	2025-03-07	\N	tarik.mazraoui@footpro.ma	+212610000196	2026-11-23 16:10:08.739+00	2026-11-23 16:10:08.739+00
186	Rachid Bouzidi	defenseur	30	11	198	2000-12-02	171	79	Marocaine	droit	f	t	2024-02-14	\N	rachid.bouzidi2@footpro.ma	+212610000197	2026-11-23 16:10:08.746+00	2026-11-23 16:10:08.746+00
187	Ismail El Kaabi	defenseur	31	11	199	2002-11-02	186	76	Marocaine	ambidextre	f	t	2023-09-29	\N	ismail.el.kaabi@footpro.ma	+212610000198	2026-11-23 16:10:08.756+00	2026-11-23 16:10:08.756+00
188	Reda Aguerd	defenseur	20	11	200	2005-01-13	189	75	Marocaine	droit	f	t	2025-04-08	\N	reda.aguerd@footpro.ma	+212610000199	2026-11-23 16:10:08.765+00	2026-11-23 16:10:08.765+00
189	Abdelali Rahimi	milieu	7	11	201	1996-09-13	189	72	Marocaine	gauche	t	t	2023-08-11	\N	abdelali.rahimi@footpro.ma	+212610000200	2026-11-23 16:10:08.771+00	2026-11-23 16:10:08.771+00
190	Badr Zerouali	milieu	8	11	202	1996-12-02	176	66	Marocaine	droit	f	t	2024-04-10	\N	badr.zerouali@footpro.ma	+212610000201	2026-11-23 16:10:08.774+00	2026-11-23 16:10:08.774+00
191	Nassim Amallah	milieu	3	11	203	1995-04-03	189	67	Marocaine	ambidextre	f	t	2025-04-20	\N	nassim.amallah@footpro.ma	+212610000202	2026-11-23 16:10:08.781+00	2026-11-23 16:10:08.781+00
192	Achraf Fassi	milieu	17	11	204	1997-09-21	181	80	Marocaine	droit	f	t	2023-06-23	\N	achraf.fassi@footpro.ma	+212610000203	2026-11-23 16:10:08.788+00	2026-11-23 16:10:08.788+00
193	Reda El Amrani	milieu	18	11	205	2000-02-13	190	84	Marocaine	gauche	f	t	2024-11-13	\N	reda.el.amrani@footpro.ma	+212610000204	2026-11-23 16:10:08.793+00	2026-11-23 16:10:08.793+00
194	Mounir Ouchen	milieu	19	11	206	2006-04-23	190	64	Marocaine	ambidextre	f	t	2026-01-06	\N	mounir.ouchen@footpro.ma	+212610000205	2026-11-23 16:10:08.798+00	2026-11-23 16:10:08.798+00
195	Soufiane Bouzidi	attaquant	9	11	207	1995-12-17	185	71	Marocaine	droit	f	t	2024-09-22	\N	soufiane.bouzidi@footpro.ma	+212610000206	2026-11-23 16:10:08.806+00	2026-11-23 16:10:08.806+00
196	Ismail Kettani	attaquant	2	11	208	2000-01-28	189	81	Marocaine	droit	f	t	2026-04-04	\N	ismail.kettani@footpro.ma	+212610000207	2026-11-23 16:10:08.81+00	2026-11-23 16:10:08.81+00
197	Reda Boufal	attaquant	29	11	209	2004-06-09	180	68	Marocaine	droit	f	t	2026-07-30	\N	reda.boufal@footpro.ma	+212610000208	2026-11-23 16:10:08.817+00	2026-11-23 16:10:08.817+00
198	Achraf Hakimi	attaquant	12	11	210	2006-05-13	170	88	Marocaine	gauche	f	t	2026-05-10	\N	achraf.hakimi@footpro.ma	+212610000209	2026-11-23 16:10:08.823+00	2026-11-23 16:10:08.823+00
199	Salah Boufal	gardien	1	12	212	2002-12-26	190	77	Marocaine	gauche	f	t	2023-01-11	\N	salah.boufal@footpro.ma	+212610000211	2026-11-23 16:10:08.841+00	2026-11-23 16:10:08.841+00
200	Hamza Jabrane	gardien	14	12	213	2002-09-24	187	79	Marocaine	ambidextre	f	t	2025-03-13	\N	hamza.jabrane@footpro.ma	+212610000212	2026-11-23 16:10:08.848+00	2026-11-23 16:10:08.848+00
201	Anas Ouchen	defenseur	26	12	214	2006-03-15	189	86	Marocaine	ambidextre	f	t	2023-06-01	\N	anas.ouchen@footpro.ma	+212610000213	2026-11-23 16:10:08.852+00	2026-11-23 16:10:08.852+00
202	Youssef Benoun	defenseur	12	12	215	2000-08-12	188	65	Marocaine	ambidextre	f	t	2024-08-16	\N	youssef.benoun@footpro.ma	+212610000214	2026-11-23 16:10:08.858+00	2026-11-23 16:10:08.858+00
203	Karim Ouchen	defenseur	30	12	216	1995-12-08	182	73	Marocaine	ambidextre	f	t	2023-10-22	\N	karim.ouchen2@footpro.ma	+212610000215	2026-11-23 16:10:08.864+00	2026-11-23 16:10:08.864+00
204	Ayoub Haddad	defenseur	24	12	217	2007-10-19	179	85	Marocaine	droit	f	t	2024-09-12	\N	ayoub.haddad2@footpro.ma	+212610000216	2026-11-23 16:10:08.869+00	2026-11-23 16:10:08.869+00
205	Ismail Alaoui	defenseur	18	12	218	2002-01-16	183	71	Marocaine	droit	f	t	2025-11-27	\N	ismail.alaoui@footpro.ma	+212610000217	2026-11-23 16:10:08.872+00	2026-11-23 16:10:08.872+00
206	Badr Alaoui	defenseur	9	12	219	1999-05-08	181	87	Marocaine	gauche	f	t	2024-05-06	\N	badr.alaoui@footpro.ma	+212610000218	2026-11-23 16:10:08.878+00	2026-11-23 16:10:08.878+00
207	Yassine Tazi	milieu	5	12	220	2002-12-11	184	80	Marocaine	gauche	t	t	2024-10-26	\N	yassine.tazi@footpro.ma	+212610000219	2026-11-23 16:10:08.884+00	2026-11-23 16:10:08.884+00
208	Taha Benali	milieu	6	12	221	1999-04-12	170	82	Marocaine	ambidextre	f	t	2024-02-18	\N	taha.benali2@footpro.ma	+212610000220	2026-11-23 16:10:08.887+00	2026-11-23 16:10:08.887+00
209	Mohamed El Amrani	milieu	10	12	222	1998-05-07	168	72	Marocaine	droit	f	t	2023-01-02	\N	mohamed.el.amrani@footpro.ma	+212610000221	2026-11-23 16:10:08.892+00	2026-11-23 16:10:08.892+00
210	Youssef Ouazzani	milieu	25	12	223	2002-07-17	181	84	Marocaine	ambidextre	f	t	2025-08-13	\N	youssef.ouazzani@footpro.ma	+212610000222	2026-11-23 16:10:08.897+00	2026-11-23 16:10:08.897+00
211	Mehdi Rahimi	milieu	15	12	224	1996-04-17	184	74	Marocaine	gauche	f	t	2024-09-05	\N	mehdi.rahimi@footpro.ma	+212610000223	2026-11-23 16:10:08.903+00	2026-11-23 16:10:08.903+00
212	Bilal Fassi	milieu	13	12	225	2000-12-18	172	78	Marocaine	droit	f	t	2025-04-28	\N	bilal.fassi@footpro.ma	+212610000224	2026-11-23 16:10:08.909+00	2026-11-23 16:10:08.909+00
213	Said Ezzalzouli	attaquant	4	12	226	1997-09-23	187	64	Marocaine	ambidextre	f	t	2025-11-13	\N	said.ezzalzouli@footpro.ma	+212610000225	2026-11-23 16:10:08.913+00	2026-11-23 16:10:08.913+00
214	Driss Alaoui	attaquant	28	12	227	2001-09-10	180	80	Marocaine	droit	f	t	2023-12-20	\N	driss.alaoui@footpro.ma	+212610000226	2026-11-23 16:10:08.918+00	2026-11-23 16:10:08.918+00
215	Taha Amrabat	attaquant	29	12	228	2005-08-05	176	80	Marocaine	droit	f	t	2026-07-18	\N	taha.amrabat@footpro.ma	+212610000227	2026-11-23 16:10:08.926+00	2026-11-23 16:10:08.926+00
216	Othmane Ziani	attaquant	27	12	229	1999-01-15	190	86	Marocaine	droit	f	t	2026-03-09	\N	othmane.ziani@footpro.ma	+212610000228	2026-11-23 16:10:08.934+00	2026-11-23 16:10:08.934+00
217	Marouane Haddad	gardien	1	13	231	2000-04-14	195	64	Marocaine	droit	f	t	2024-05-21	\N	marouane.haddad@footpro.ma	+212610000230	2026-11-23 16:10:08.947+00	2026-11-23 16:10:08.947+00
218	Hakim Kettani	gardien	6	13	232	2006-06-27	186	82	Marocaine	droit	f	t	2025-03-23	\N	hakim.kettani@footpro.ma	+212610000231	2026-11-23 16:10:08.957+00	2026-11-23 16:10:08.957+00
219	Imad Tazi	defenseur	10	13	233	2000-01-15	172	70	Marocaine	droit	f	t	2024-11-02	\N	imad.tazi@footpro.ma	+212610000232	2026-11-23 16:10:08.966+00	2026-11-23 16:10:08.966+00
220	Mounir Harit	defenseur	22	13	234	1998-09-12	173	64	Marocaine	droit	f	t	2025-06-25	\N	mounir.harit@footpro.ma	+212610000233	2026-11-23 16:10:08.976+00	2026-11-23 16:10:08.976+00
221	Salah Aguerd	defenseur	14	13	235	2004-11-17	186	79	Marocaine	droit	f	t	2024-12-09	\N	salah.aguerd@footpro.ma	+212610000234	2026-11-23 16:10:08.984+00	2026-11-23 16:10:08.984+00
222	Abdelali Chraibi	defenseur	21	13	236	2006-06-20	188	82	Marocaine	droit	f	t	2025-08-13	\N	abdelali.chraibi@footpro.ma	+212610000235	2026-11-23 16:10:08.988+00	2026-11-23 16:10:08.988+00
223	Hamza Berrada	defenseur	31	13	237	1995-12-15	190	67	Marocaine	droit	f	t	2024-10-12	\N	hamza.berrada@footpro.ma	+212610000236	2026-11-23 16:10:08.992+00	2026-11-23 16:10:08.992+00
224	Walid Jabrane	defenseur	7	13	238	2005-05-01	186	72	Marocaine	ambidextre	f	t	2024-01-25	\N	walid.jabrane@footpro.ma	+212610000237	2026-11-23 16:10:08.999+00	2026-11-23 16:10:08.999+00
225	Zakaria Chraibi	milieu	8	13	239	2002-12-01	175	85	Marocaine	ambidextre	t	t	2025-03-02	\N	zakaria.chraibi@footpro.ma	+212610000238	2026-11-23 16:10:09.004+00	2026-11-23 16:10:09.004+00
226	Rachid El Kaabi	milieu	19	13	240	2004-12-09	187	76	Marocaine	gauche	f	t	2026-07-25	\N	rachid.el.kaabi@footpro.ma	+212610000239	2026-11-23 16:10:09.007+00	2026-11-23 16:10:09.007+00
227	Karim Alaoui	milieu	12	13	241	2000-07-06	173	83	Marocaine	droit	f	t	2023-03-24	\N	karim.alaoui@footpro.ma	+212610000240	2026-11-23 16:10:09.01+00	2026-11-23 16:10:09.01+00
228	Youssef Moutaouakil	milieu	24	13	242	2002-01-04	182	69	Marocaine	droit	f	t	2023-06-12	\N	youssef.moutaouakil@footpro.ma	+212610000241	2026-11-23 16:10:09.015+00	2026-11-23 16:10:09.015+00
229	Noureddine Benali	milieu	25	13	243	2006-01-06	182	73	Marocaine	droit	f	t	2024-01-01	\N	noureddine.benali@footpro.ma	+212610000242	2026-11-23 16:10:09.019+00	2026-11-23 16:10:09.019+00
230	Abdelali Belhaj	milieu	13	13	244	2002-11-10	173	78	Marocaine	gauche	f	t	2026-06-09	\N	abdelali.belhaj@footpro.ma	+212610000243	2026-11-23 16:10:09.024+00	2026-11-23 16:10:09.024+00
231	Khalid Rami	attaquant	28	13	245	1997-02-18	173	86	Marocaine	droit	f	t	2025-03-09	\N	khalid.rami@footpro.ma	+212610000244	2026-11-23 16:10:09.028+00	2026-11-23 16:10:09.028+00
232	Rachid Tazi	attaquant	5	13	246	2002-02-18	173	76	Marocaine	droit	f	t	2023-10-25	\N	rachid.tazi@footpro.ma	+212610000245	2026-11-23 16:10:09.031+00	2026-11-23 16:10:09.031+00
233	Rachid Ouchen	attaquant	15	13	247	2007-08-02	171	67	Sénégalaise	ambidextre	f	t	2024-04-30	\N	rachid.ouchen2@footpro.ma	+212610000246	2026-11-23 16:10:09.037+00	2026-11-23 16:10:09.037+00
234	Hamza Mazraoui	attaquant	26	13	248	1998-12-13	185	70	Marocaine	gauche	f	t	2024-06-12	\N	hamza.mazraoui@footpro.ma	+212610000247	2026-11-23 16:10:09.04+00	2026-11-23 16:10:09.04+00
235	Hakim El Kaabi	gardien	1	14	250	2006-12-17	186	80	Marocaine	ambidextre	f	t	2026-07-31	\N	hakim.el.kaabi@footpro.ma	+212610000249	2026-11-23 16:10:09.053+00	2026-11-23 16:10:09.053+00
236	Marouane El Amrani	gardien	3	14	251	1995-02-21	194	73	Marocaine	droit	f	t	2024-09-10	\N	marouane.el.amrani@footpro.ma	+212610000250	2026-11-23 16:10:09.06+00	2026-11-23 16:10:09.06+00
237	Othmane Chraibi	defenseur	14	14	252	1997-03-01	177	72	Marocaine	gauche	f	t	2023-02-08	\N	othmane.chraibi@footpro.ma	+212610000251	2026-11-23 16:10:09.064+00	2026-11-23 16:10:09.064+00
238	Amine Boufal	defenseur	30	14	253	2007-01-08	181	71	Marocaine	droit	f	t	2022-11-06	\N	amine.boufal@footpro.ma	+212610000252	2026-11-23 16:10:09.068+00	2026-11-23 16:10:09.068+00
239	Mehdi Moutaouakil	defenseur	11	14	254	2000-07-24	171	80	Marocaine	ambidextre	f	t	2024-12-07	\N	mehdi.moutaouakil@footpro.ma	+212610000253	2026-11-23 16:10:09.071+00	2026-11-23 16:10:09.071+00
240	Reda El Kaabi	defenseur	13	14	255	2000-08-25	187	68	Marocaine	droit	f	t	2024-04-13	\N	reda.el.kaabi@footpro.ma	+212610000254	2026-11-23 16:10:09.074+00	2026-11-23 16:10:09.074+00
241	Zakaria El Khattabi	defenseur	7	14	256	1996-01-07	184	67	Marocaine	droit	f	t	2024-01-02	\N	zakaria.el.khattabi3@footpro.ma	+212610000255	2026-11-23 16:10:09.078+00	2026-11-23 16:10:09.078+00
242	Mounir Sqalli	defenseur	6	14	257	2007-10-25	178	71	Marocaine	ambidextre	f	t	2024-09-16	\N	mounir.sqalli@footpro.ma	+212610000256	2026-11-23 16:10:09.082+00	2026-11-23 16:10:09.082+00
243	Omar Ait Ali	milieu	2	14	258	1997-02-20	185	78	Marocaine	droit	t	t	2023-01-12	\N	omar.ait.ali@footpro.ma	+212610000257	2026-11-23 16:10:09.087+00	2026-11-23 16:10:09.087+00
244	Yassine Haddad	milieu	23	14	259	1996-12-07	187	80	Sénégalaise	gauche	f	t	2024-02-08	\N	yassine.haddad@footpro.ma	+212610000258	2026-11-23 16:10:09.091+00	2026-11-23 16:10:09.091+00
245	Hakim Naciri	milieu	19	14	260	2002-06-27	169	75	Marocaine	droit	f	t	2022-11-12	\N	hakim.naciri@footpro.ma	+212610000259	2026-11-23 16:10:09.095+00	2026-11-23 16:10:09.095+00
246	Hicham Naciri	milieu	21	14	261	1998-11-28	186	66	Marocaine	droit	f	t	2026-09-23	\N	hicham.naciri@footpro.ma	+212610000260	2026-11-23 16:10:09.1+00	2026-11-23 16:10:09.1+00
247	Fouad Harit	milieu	24	14	262	2006-04-19	170	72	Marocaine	ambidextre	f	t	2025-07-15	\N	fouad.harit@footpro.ma	+212610000261	2026-11-23 16:10:09.103+00	2026-11-23 16:10:09.103+00
248	Salah Jabrane	milieu	9	14	263	1999-05-04	182	70	Marocaine	droit	f	t	2025-05-09	\N	salah.jabrane2@footpro.ma	+212610000262	2026-11-23 16:10:09.106+00	2026-11-23 16:10:09.106+00
249	Abdelali Belhaj	attaquant	4	14	264	2005-03-22	182	65	Marocaine	ambidextre	f	t	2025-05-29	\N	abdelali.belhaj2@footpro.ma	+212610000263	2026-11-23 16:10:09.11+00	2026-11-23 16:10:09.11+00
250	Amine Rahimi	attaquant	5	14	265	1999-06-14	179	71	Marocaine	ambidextre	f	t	2024-12-05	\N	amine.rahimi2@footpro.ma	+212610000264	2026-11-23 16:10:09.113+00	2026-11-23 16:10:09.113+00
251	Driss Tazi	attaquant	22	14	266	2003-02-26	186	64	Marocaine	gauche	f	t	2026-01-28	\N	driss.tazi@footpro.ma	+212610000265	2026-11-23 16:10:09.117+00	2026-11-23 16:10:09.117+00
252	Anas Moutaouakil	attaquant	15	14	267	2007-03-23	190	76	Marocaine	droit	f	t	2023-09-21	\N	anas.moutaouakil@footpro.ma	+212610000266	2026-11-23 16:10:09.12+00	2026-11-23 16:10:09.12+00
253	Hakim Seddiki	gardien	1	15	269	1999-07-02	196	88	Marocaine	droit	f	t	2023-05-07	\N	hakim.seddiki@footpro.ma	+212610000268	2026-11-23 16:10:09.128+00	2026-11-23 16:10:09.128+00
254	Hakim Benoun	gardien	17	15	270	2002-03-07	185	81	Marocaine	droit	f	t	2022-12-06	\N	hakim.benoun2@footpro.ma	+212610000269	2026-11-23 16:10:09.135+00	2026-11-23 16:10:09.135+00
255	Adil Naciri	defenseur	14	15	271	2002-03-02	185	64	Marocaine	gauche	f	t	2023-05-05	\N	adil.naciri@footpro.ma	+212610000270	2026-11-23 16:10:09.141+00	2026-11-23 16:10:09.141+00
256	Ayoub Alaoui	defenseur	26	15	272	2003-02-05	173	66	Marocaine	droit	f	t	2025-01-31	\N	ayoub.alaoui@footpro.ma	+212610000271	2026-11-23 16:10:09.155+00	2026-11-23 16:10:09.155+00
257	Khalid Seddiki	defenseur	31	15	273	2002-12-07	172	73	Marocaine	droit	f	t	2022-12-14	\N	khalid.seddiki@footpro.ma	+212610000272	2026-11-23 16:10:09.166+00	2026-11-23 16:10:09.166+00
258	Ismail Ouazzani	defenseur	4	15	274	1998-01-16	179	64	Marocaine	ambidextre	f	t	2026-03-07	\N	ismail.ouazzani@footpro.ma	+212610000273	2026-11-23 16:10:09.178+00	2026-11-23 16:10:09.178+00
259	Mounir Rahimi	defenseur	15	15	275	2003-07-03	180	68	Marocaine	droit	f	t	2024-07-13	\N	mounir.rahimi@footpro.ma	+212610000274	2026-11-23 16:10:09.189+00	2026-11-23 16:10:09.189+00
260	Mehdi El Idrissi	defenseur	23	15	276	1995-08-01	170	80	Marocaine	droit	f	t	2023-05-23	\N	mehdi.el.idrissi@footpro.ma	+212610000275	2026-11-23 16:10:09.201+00	2026-11-23 16:10:09.201+00
261	Zakaria Tazi	milieu	24	15	277	2007-06-22	180	76	Marocaine	droit	t	t	2023-05-22	\N	zakaria.tazi@footpro.ma	+212610000276	2026-11-23 16:10:09.209+00	2026-11-23 16:10:09.209+00
262	Nabil Seddiki	milieu	28	15	278	1995-10-10	176	79	Marocaine	droit	f	t	2024-01-21	\N	nabil.seddiki@footpro.ma	+212610000277	2026-11-23 16:10:09.215+00	2026-11-23 16:10:09.215+00
263	Othmane Moutaouakil	milieu	2	15	279	2001-11-26	173	72	Marocaine	droit	f	t	2026-04-17	\N	othmane.moutaouakil2@footpro.ma	+212610000278	2026-11-23 16:10:09.221+00	2026-11-23 16:10:09.221+00
264	Ayman Zerouali	milieu	6	15	280	2002-09-16	173	82	Marocaine	ambidextre	f	t	2025-10-09	\N	ayman.zerouali@footpro.ma	+212610000279	2026-11-23 16:10:09.228+00	2026-11-23 16:10:09.228+00
265	Reda Kettani	milieu	20	15	281	2007-06-05	176	87	Marocaine	droit	f	t	2024-11-18	\N	reda.kettani@footpro.ma	+212610000280	2026-11-23 16:10:09.235+00	2026-11-23 16:10:09.235+00
266	Hicham Hakimi	milieu	21	15	282	2002-10-09	181	87	Marocaine	ambidextre	f	t	2025-11-12	\N	hicham.hakimi@footpro.ma	+212610000281	2026-11-23 16:10:09.24+00	2026-11-23 16:10:09.24+00
267	Hamza El Kaabi	attaquant	9	15	283	2002-09-17	184	64	Marocaine	droit	f	t	2024-05-07	\N	hamza.el.kaabi@footpro.ma	+212610000282	2026-11-23 16:10:09.247+00	2026-11-23 16:10:09.247+00
268	Hicham Benoun	attaquant	10	15	284	2002-12-03	173	73	Marocaine	ambidextre	f	t	2023-04-13	\N	hicham.benoun@footpro.ma	+212610000283	2026-11-23 16:10:09.252+00	2026-11-23 16:10:09.252+00
269	Reda Lahlou	attaquant	27	15	285	2001-07-22	179	77	Marocaine	ambidextre	f	t	2024-12-28	\N	reda.lahlou@footpro.ma	+212610000284	2026-11-23 16:10:09.259+00	2026-11-23 16:10:09.259+00
270	Youssef Kettani	attaquant	7	15	286	1999-07-21	169	71	Marocaine	ambidextre	f	t	2024-03-23	\N	youssef.kettani@footpro.ma	+212610000285	2026-11-23 16:10:09.271+00	2026-11-23 16:10:09.271+00
271	Omar Moutaouakil	gardien	1	16	288	2005-08-22	190	86	Marocaine	droit	f	t	2024-11-06	\N	omar.moutaouakil@footpro.ma	+212610000287	2026-11-23 16:10:09.291+00	2026-11-23 16:10:09.291+00
272	Ilyas Zerouali	gardien	26	16	289	2006-01-12	185	85	Malienne	ambidextre	f	t	2025-03-24	\N	ilyas.zerouali@footpro.ma	+212610000288	2026-11-23 16:10:09.298+00	2026-11-23 16:10:09.298+00
273	Tarik Amrabat	defenseur	16	16	290	1998-05-27	172	75	Marocaine	ambidextre	f	t	2023-03-15	\N	tarik.amrabat@footpro.ma	+212610000289	2026-11-23 16:10:09.303+00	2026-11-23 16:10:09.303+00
274	Karim Rahimi	defenseur	15	16	291	2005-05-25	186	73	Malienne	droit	f	t	2024-11-14	\N	karim.rahimi2@footpro.ma	+212610000290	2026-11-23 16:10:09.311+00	2026-11-23 16:10:09.311+00
275	Noureddine Saiss	defenseur	24	16	292	2000-09-04	189	68	Marocaine	ambidextre	f	t	2022-11-02	\N	noureddine.saiss@footpro.ma	+212610000291	2026-11-23 16:10:09.318+00	2026-11-23 16:10:09.318+00
276	Tarik Ouazzani	defenseur	21	16	293	1996-02-06	170	84	Marocaine	droit	f	t	2022-11-30	\N	tarik.ouazzani@footpro.ma	+212610000292	2026-11-23 16:10:09.322+00	2026-11-23 16:10:09.322+00
277	Salah Seddiki	defenseur	19	16	294	2004-08-25	179	70	Marocaine	droit	f	t	2026-07-05	\N	salah.seddiki@footpro.ma	+212610000293	2026-11-23 16:10:09.331+00	2026-11-23 16:10:09.331+00
278	Hakim Rahimi	defenseur	30	16	295	2004-07-12	182	69	Marocaine	ambidextre	f	t	2023-09-23	\N	hakim.rahimi@footpro.ma	+212610000294	2026-11-23 16:10:09.338+00	2026-11-23 16:10:09.338+00
279	Jawad Ziani	milieu	23	16	296	2003-05-04	168	70	Marocaine	droit	t	t	2024-12-31	\N	jawad.ziani@footpro.ma	+212610000295	2026-11-23 16:10:09.345+00	2026-11-23 16:10:09.345+00
280	Imad Haddad	milieu	27	16	297	2001-07-26	183	69	Marocaine	droit	f	t	2024-08-30	\N	imad.haddad@footpro.ma	+212610000296	2026-11-23 16:10:09.356+00	2026-11-23 16:10:09.356+00
281	Omar Amallah	milieu	22	16	298	2007-03-09	171	87	Marocaine	ambidextre	f	t	2025-02-28	\N	omar.amallah@footpro.ma	+212610000297	2026-11-23 16:10:09.362+00	2026-11-23 16:10:09.362+00
282	Said Boufal	milieu	20	16	299	2004-03-12	185	82	Marocaine	droit	f	t	2024-03-09	\N	said.boufal3@footpro.ma	+212610000298	2026-11-23 16:10:09.37+00	2026-11-23 16:10:09.37+00
283	Fouad Ait Ali	milieu	8	16	300	1997-05-09	168	82	Marocaine	gauche	f	t	2024-11-28	\N	fouad.ait.ali@footpro.ma	+212610000299	2026-11-23 16:10:09.377+00	2026-11-23 16:10:09.377+00
284	Tarik Naciri	milieu	5	16	301	2007-12-26	186	88	Marocaine	droit	f	t	2024-11-16	\N	tarik.naciri@footpro.ma	+212610000300	2026-11-23 16:10:09.383+00	2026-11-23 16:10:09.383+00
285	Taha Bouzidi	attaquant	28	16	302	1997-02-25	185	73	Marocaine	droit	f	t	2026-01-03	\N	taha.bouzidi@footpro.ma	+212610000301	2026-11-23 16:10:09.389+00	2026-11-23 16:10:09.389+00
286	Nabil Jabrane	attaquant	31	16	303	2001-09-15	189	80	Marocaine	droit	f	t	2025-11-18	\N	nabil.jabrane@footpro.ma	+212610000302	2026-11-23 16:10:09.397+00	2026-11-23 16:10:09.397+00
287	Hakim Sqalli	attaquant	4	16	304	2005-03-15	175	72	Sénégalaise	ambidextre	f	t	2023-02-05	\N	hakim.sqalli@footpro.ma	+212610000303	2026-11-23 16:10:09.404+00	2026-11-23 16:10:09.404+00
288	Nabil Fassi	attaquant	29	16	305	2004-09-09	174	67	Marocaine	droit	f	t	2022-12-12	\N	nabil.fassi@footpro.ma	+212610000304	2026-11-23 16:10:09.412+00	2026-11-23 16:10:09.412+00
\.


--
-- Data for Name: RefereeMissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."RefereeMissions" (id, "matchId", "refereeId", role, status, "respondedAt", "declineReason", "presenceSheetUrl", "matchSheetUrl", "assignedById", "createdAt", "updatedAt") FROM stdin;
1	1	306	main	declined	2026-10-11 16:10:09.478+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.405+00	2026-11-23 16:33:25.405+00
2	1	307	assistant	accepted	2026-10-11 16:10:09.478+00	\N	\N	\N	1	2026-11-23 16:33:25.421+00	2026-11-23 16:33:25.421+00
3	1	308	assistant	accepted	2026-10-11 16:10:09.478+00	\N	\N	\N	1	2026-11-23 16:33:25.428+00	2026-11-23 16:33:25.428+00
4	1	309	fourth	accepted	2026-10-11 16:10:09.478+00	\N	\N	\N	1	2026-11-23 16:33:25.438+00	2026-11-23 16:33:25.438+00
5	2	307	main	accepted	2026-10-11 16:10:09.524+00	\N	\N	\N	1	2026-11-23 16:33:25.451+00	2026-11-23 16:33:25.451+00
6	2	308	assistant	accepted	2026-10-11 16:10:09.524+00	\N	\N	\N	1	2026-11-23 16:33:25.465+00	2026-11-23 16:33:25.465+00
7	2	309	assistant	accepted	2026-10-11 16:10:09.524+00	\N	\N	\N	1	2026-11-23 16:33:25.472+00	2026-11-23 16:33:25.472+00
8	2	310	fourth	accepted	2026-10-11 16:10:09.524+00	\N	\N	\N	1	2026-11-23 16:33:25.476+00	2026-11-23 16:33:25.476+00
9	3	308	main	accepted	2026-10-11 16:10:09.556+00	\N	\N	\N	1	2026-11-23 16:33:25.484+00	2026-11-23 16:33:25.484+00
10	3	309	assistant	accepted	2026-10-11 16:10:09.556+00	\N	\N	\N	1	2026-11-23 16:33:25.493+00	2026-11-23 16:33:25.493+00
11	3	310	assistant	accepted	2026-10-11 16:10:09.556+00	\N	\N	\N	1	2026-11-23 16:33:25.498+00	2026-11-23 16:33:25.498+00
12	3	311	fourth	accepted	2026-10-11 16:10:09.556+00	\N	\N	\N	1	2026-11-23 16:33:25.504+00	2026-11-23 16:33:25.504+00
13	4	309	main	accepted	2026-10-11 16:10:09.587+00	\N	\N	\N	1	2026-11-23 16:33:25.509+00	2026-11-23 16:33:25.509+00
14	4	310	assistant	accepted	2026-10-11 16:10:09.587+00	\N	\N	\N	1	2026-11-23 16:33:25.518+00	2026-11-23 16:33:25.518+00
15	4	311	assistant	accepted	2026-10-11 16:10:09.587+00	\N	\N	\N	1	2026-11-23 16:33:25.524+00	2026-11-23 16:33:25.524+00
16	4	306	fourth	accepted	2026-10-11 16:10:09.587+00	\N	\N	\N	1	2026-11-23 16:33:25.527+00	2026-11-23 16:33:25.527+00
17	32	310	main	accepted	2026-10-11 16:10:10.34+00	\N	\N	\N	1	2026-11-23 16:33:25.532+00	2026-11-23 16:33:25.532+00
18	32	311	assistant	accepted	2026-10-11 16:10:10.34+00	\N	\N	\N	1	2026-11-23 16:33:25.549+00	2026-11-23 16:33:25.549+00
19	32	306	assistant	accepted	2026-10-11 16:10:10.34+00	\N	\N	\N	1	2026-11-23 16:33:25.553+00	2026-11-23 16:33:25.553+00
20	32	307	fourth	accepted	2026-10-11 16:10:10.34+00	\N	\N	\N	1	2026-11-23 16:33:25.564+00	2026-11-23 16:33:25.564+00
21	33	311	main	accepted	2026-10-12 16:10:10.368+00	\N	\N	\N	1	2026-11-23 16:33:25.569+00	2026-11-23 16:33:25.569+00
22	33	306	assistant	accepted	2026-10-12 16:10:10.368+00	\N	\N	\N	1	2026-11-23 16:33:25.586+00	2026-11-23 16:33:25.586+00
23	33	307	assistant	accepted	2026-10-12 16:10:10.368+00	\N	\N	\N	1	2026-11-23 16:33:25.592+00	2026-11-23 16:33:25.592+00
24	33	308	fourth	accepted	2026-10-12 16:10:10.368+00	\N	\N	\N	1	2026-11-23 16:33:25.599+00	2026-11-23 16:33:25.599+00
25	34	306	main	accepted	2026-10-13 16:10:10.424+00	\N	\N	\N	1	2026-11-23 16:33:25.606+00	2026-11-23 16:33:25.606+00
26	34	307	assistant	accepted	2026-10-13 16:10:10.424+00	\N	\N	\N	1	2026-11-23 16:33:25.62+00	2026-11-23 16:33:25.62+00
27	34	308	assistant	accepted	2026-10-13 16:10:10.424+00	\N	\N	\N	1	2026-11-23 16:33:25.626+00	2026-11-23 16:33:25.626+00
28	34	309	fourth	declined	2026-10-13 16:10:10.424+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.63+00	2026-11-23 16:33:25.63+00
29	35	307	main	accepted	2026-10-14 16:10:10.462+00	\N	\N	\N	1	2026-11-23 16:33:25.635+00	2026-11-23 16:33:25.635+00
30	35	308	assistant	accepted	2026-10-14 16:10:10.462+00	\N	\N	\N	1	2026-11-23 16:33:25.646+00	2026-11-23 16:33:25.646+00
31	35	309	assistant	declined	2026-10-14 16:10:10.462+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.649+00	2026-11-23 16:33:25.649+00
32	35	310	fourth	accepted	2026-10-14 16:10:10.462+00	\N	\N	\N	1	2026-11-23 16:33:25.653+00	2026-11-23 16:33:25.653+00
33	5	308	main	accepted	2026-10-21 16:10:09.653+00	\N	\N	\N	1	2026-11-23 16:33:25.657+00	2026-11-23 16:33:25.657+00
34	5	309	assistant	declined	2026-10-21 16:10:09.653+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.67+00	2026-11-23 16:33:25.67+00
35	5	310	assistant	accepted	2026-10-21 16:10:09.653+00	\N	\N	\N	1	2026-11-23 16:33:25.674+00	2026-11-23 16:33:25.674+00
36	5	311	fourth	accepted	2026-10-21 16:10:09.653+00	\N	\N	\N	1	2026-11-23 16:33:25.678+00	2026-11-23 16:33:25.678+00
37	6	309	main	declined	2026-10-21 16:10:09.708+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.687+00	2026-11-23 16:33:25.687+00
38	6	310	assistant	accepted	2026-10-21 16:10:09.708+00	\N	\N	\N	1	2026-11-23 16:33:25.692+00	2026-11-23 16:33:25.692+00
39	6	311	assistant	accepted	2026-10-21 16:10:09.708+00	\N	\N	\N	1	2026-11-23 16:33:25.696+00	2026-11-23 16:33:25.696+00
40	6	306	fourth	accepted	2026-10-21 16:10:09.708+00	\N	\N	\N	1	2026-11-23 16:33:25.706+00	2026-11-23 16:33:25.706+00
41	7	310	main	accepted	2026-10-21 16:10:09.748+00	\N	\N	\N	1	2026-11-23 16:33:25.716+00	2026-11-23 16:33:25.716+00
42	7	311	assistant	accepted	2026-10-21 16:10:09.748+00	\N	\N	\N	1	2026-11-23 16:33:25.728+00	2026-11-23 16:33:25.728+00
43	7	306	assistant	accepted	2026-10-21 16:10:09.748+00	\N	\N	\N	1	2026-11-23 16:33:25.736+00	2026-11-23 16:33:25.736+00
44	7	307	fourth	accepted	2026-10-21 16:10:09.748+00	\N	\N	\N	1	2026-11-23 16:33:25.741+00	2026-11-23 16:33:25.741+00
45	8	311	main	accepted	2026-10-21 16:10:09.793+00	\N	\N	\N	1	2026-11-23 16:33:25.748+00	2026-11-23 16:33:25.748+00
46	8	306	assistant	accepted	2026-10-21 16:10:09.793+00	\N	\N	\N	1	2026-11-23 16:33:25.756+00	2026-11-23 16:33:25.756+00
47	8	307	assistant	accepted	2026-10-21 16:10:09.793+00	\N	\N	\N	1	2026-11-23 16:33:25.761+00	2026-11-23 16:33:25.761+00
48	8	308	fourth	accepted	2026-10-21 16:10:09.793+00	\N	\N	\N	1	2026-11-23 16:33:25.765+00	2026-11-23 16:33:25.765+00
49	9	306	main	accepted	2026-10-31 16:10:09.85+00	\N	\N	\N	1	2026-11-23 16:33:25.771+00	2026-11-23 16:33:25.771+00
50	9	307	assistant	accepted	2026-10-31 16:10:09.85+00	\N	\N	\N	1	2026-11-23 16:33:25.778+00	2026-11-23 16:33:25.778+00
51	9	308	assistant	accepted	2026-10-31 16:10:09.85+00	\N	\N	\N	1	2026-11-23 16:33:25.783+00	2026-11-23 16:33:25.783+00
52	9	309	fourth	accepted	2026-10-31 16:10:09.85+00	\N	\N	\N	1	2026-11-23 16:33:25.789+00	2026-11-23 16:33:25.789+00
53	10	307	main	accepted	2026-10-31 16:10:09.902+00	\N	\N	\N	1	2026-11-23 16:33:25.795+00	2026-11-23 16:33:25.795+00
54	10	308	assistant	accepted	2026-10-31 16:10:09.902+00	\N	\N	\N	1	2026-11-23 16:33:25.811+00	2026-11-23 16:33:25.811+00
55	10	309	assistant	accepted	2026-10-31 16:10:09.902+00	\N	\N	\N	1	2026-11-23 16:33:25.819+00	2026-11-23 16:33:25.819+00
56	10	310	fourth	accepted	2026-10-31 16:10:09.902+00	\N	\N	\N	1	2026-11-23 16:33:25.825+00	2026-11-23 16:33:25.825+00
57	11	308	main	accepted	2026-10-31 16:10:09.934+00	\N	\N	\N	1	2026-11-23 16:33:25.832+00	2026-11-23 16:33:25.832+00
58	11	309	assistant	accepted	2026-10-31 16:10:09.934+00	\N	\N	\N	1	2026-11-23 16:33:25.844+00	2026-11-23 16:33:25.844+00
59	11	310	assistant	accepted	2026-10-31 16:10:09.934+00	\N	\N	\N	1	2026-11-23 16:33:25.849+00	2026-11-23 16:33:25.849+00
60	11	311	fourth	accepted	2026-10-31 16:10:09.934+00	\N	\N	\N	1	2026-11-23 16:33:25.855+00	2026-11-23 16:33:25.855+00
61	12	309	main	accepted	2026-10-31 16:10:09.97+00	\N	\N	\N	1	2026-11-23 16:33:25.862+00	2026-11-23 16:33:25.862+00
62	12	310	assistant	accepted	2026-10-31 16:10:09.97+00	\N	\N	\N	1	2026-11-23 16:33:25.871+00	2026-11-23 16:33:25.871+00
63	12	311	assistant	accepted	2026-10-31 16:10:09.97+00	\N	\N	\N	1	2026-11-23 16:33:25.876+00	2026-11-23 16:33:25.876+00
64	12	306	fourth	declined	2026-10-31 16:10:09.97+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.881+00	2026-11-23 16:33:25.881+00
65	30	310	main	accepted	2026-10-31 16:10:10.334+00	\N	\N	\N	1	2026-11-23 16:33:25.885+00	2026-11-23 16:33:25.885+00
66	30	311	assistant	accepted	2026-10-31 16:10:10.334+00	\N	\N	\N	1	2026-11-23 16:33:25.899+00	2026-11-23 16:33:25.899+00
67	30	306	assistant	declined	2026-10-31 16:10:10.334+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.909+00	2026-11-23 16:33:25.909+00
68	30	307	fourth	accepted	2026-10-31 16:10:10.334+00	\N	\N	\N	1	2026-11-23 16:33:25.919+00	2026-11-23 16:33:25.919+00
69	31	311	main	accepted	2026-10-31 16:10:10.337+00	\N	\N	\N	1	2026-11-23 16:33:25.923+00	2026-11-23 16:33:25.923+00
70	31	306	assistant	declined	2026-10-31 16:10:10.337+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.935+00	2026-11-23 16:33:25.935+00
71	31	307	assistant	accepted	2026-10-31 16:10:10.337+00	\N	\N	\N	1	2026-11-23 16:33:25.943+00	2026-11-23 16:33:25.943+00
72	31	308	fourth	accepted	2026-10-31 16:10:10.337+00	\N	\N	\N	1	2026-11-23 16:33:25.948+00	2026-11-23 16:33:25.948+00
73	13	306	main	declined	2026-11-10 16:10:10.004+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:25.954+00	2026-11-23 16:33:25.954+00
74	13	307	assistant	accepted	2026-11-10 16:10:10.004+00	\N	\N	\N	1	2026-11-23 16:33:25.958+00	2026-11-23 16:33:25.958+00
75	13	308	assistant	accepted	2026-11-10 16:10:10.004+00	\N	\N	\N	1	2026-11-23 16:33:25.964+00	2026-11-23 16:33:25.964+00
76	13	309	fourth	accepted	2026-11-10 16:10:10.004+00	\N	\N	\N	1	2026-11-23 16:33:25.98+00	2026-11-23 16:33:25.98+00
77	14	307	main	accepted	2026-11-10 16:10:10.047+00	\N	\N	\N	1	2026-11-23 16:33:25.988+00	2026-11-23 16:33:25.988+00
78	14	308	assistant	accepted	2026-11-10 16:10:10.047+00	\N	\N	\N	1	2026-11-23 16:33:25.997+00	2026-11-23 16:33:25.997+00
79	14	309	assistant	accepted	2026-11-10 16:10:10.047+00	\N	\N	\N	1	2026-11-23 16:33:26.005+00	2026-11-23 16:33:26.005+00
80	14	310	fourth	accepted	2026-11-10 16:10:10.047+00	\N	\N	\N	1	2026-11-23 16:33:26.013+00	2026-11-23 16:33:26.013+00
81	15	308	main	accepted	2026-11-10 16:10:10.109+00	\N	\N	\N	1	2026-11-23 16:33:26.017+00	2026-11-23 16:33:26.017+00
82	15	309	assistant	accepted	2026-11-10 16:10:10.109+00	\N	\N	\N	1	2026-11-23 16:33:26.033+00	2026-11-23 16:33:26.033+00
83	15	310	assistant	accepted	2026-11-10 16:10:10.109+00	\N	\N	\N	1	2026-11-23 16:33:26.038+00	2026-11-23 16:33:26.038+00
84	15	311	fourth	accepted	2026-11-10 16:10:10.109+00	\N	\N	\N	1	2026-11-23 16:33:26.049+00	2026-11-23 16:33:26.049+00
85	16	309	main	accepted	2026-11-10 16:10:10.163+00	\N	\N	\N	1	2026-11-23 16:33:26.055+00	2026-11-23 16:33:26.055+00
86	16	310	assistant	accepted	2026-11-10 16:10:10.163+00	\N	\N	\N	1	2026-11-23 16:33:26.067+00	2026-11-23 16:33:26.067+00
87	16	311	assistant	accepted	2026-11-10 16:10:10.163+00	\N	\N	\N	1	2026-11-23 16:33:26.073+00	2026-11-23 16:33:26.073+00
88	16	306	fourth	accepted	2026-11-10 16:10:10.163+00	\N	\N	\N	1	2026-11-23 16:33:26.078+00	2026-11-23 16:33:26.078+00
89	29	310	main	accepted	2026-11-10 16:10:10.332+00	\N	\N	\N	1	2026-11-23 16:33:26.083+00	2026-11-23 16:33:26.083+00
90	29	311	assistant	accepted	2026-11-10 16:10:10.332+00	\N	\N	\N	1	2026-11-23 16:33:26.09+00	2026-11-23 16:33:26.09+00
91	29	306	assistant	accepted	2026-11-10 16:10:10.332+00	\N	\N	\N	1	2026-11-23 16:33:26.1+00	2026-11-23 16:33:26.1+00
92	29	307	fourth	accepted	2026-11-10 16:10:10.332+00	\N	\N	\N	1	2026-11-23 16:33:26.104+00	2026-11-23 16:33:26.104+00
93	17	311	main	accepted	2026-11-20 15:20:10.202+00	\N	\N	\N	1	2026-11-23 16:33:26.109+00	2026-11-23 16:33:26.109+00
94	17	306	assistant	accepted	2026-11-20 15:20:10.202+00	\N	\N	\N	1	2026-11-23 16:33:26.137+00	2026-11-23 16:33:26.137+00
95	17	307	assistant	accepted	2026-11-20 15:20:10.202+00	\N	\N	\N	1	2026-11-23 16:33:26.146+00	2026-11-23 16:33:26.146+00
96	17	308	fourth	accepted	2026-11-20 15:20:10.202+00	\N	\N	\N	1	2026-11-23 16:33:26.155+00	2026-11-23 16:33:26.155+00
97	18	306	main	accepted	2026-11-20 15:20:10.212+00	\N	\N	\N	1	2026-11-23 16:33:26.164+00	2026-11-23 16:33:26.164+00
98	18	307	assistant	accepted	2026-11-20 15:20:10.212+00	\N	\N	\N	1	2026-11-23 16:33:26.191+00	2026-11-23 16:33:26.191+00
99	18	308	assistant	accepted	2026-11-20 15:20:10.212+00	\N	\N	\N	1	2026-11-23 16:33:26.195+00	2026-11-23 16:33:26.195+00
100	18	309	fourth	declined	2026-11-20 15:20:10.212+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.205+00	2026-11-23 16:33:26.205+00
101	19	307	main	accepted	2026-11-20 15:20:10.225+00	\N	\N	\N	1	2026-11-23 16:33:26.209+00	2026-11-23 16:33:26.209+00
102	19	308	assistant	accepted	2026-11-20 15:20:10.225+00	\N	\N	\N	1	2026-11-23 16:33:26.218+00	2026-11-23 16:33:26.218+00
103	19	309	assistant	declined	2026-11-20 15:20:10.225+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.221+00	2026-11-23 16:33:26.221+00
104	19	310	fourth	accepted	2026-11-20 15:20:10.225+00	\N	\N	\N	1	2026-11-23 16:33:26.225+00	2026-11-23 16:33:26.225+00
105	20	308	main	accepted	2026-11-20 15:20:10.234+00	\N	\N	\N	1	2026-11-23 16:33:26.228+00	2026-11-23 16:33:26.228+00
106	20	309	assistant	declined	2026-11-20 15:20:10.234+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.235+00	2026-11-23 16:33:26.235+00
107	20	310	assistant	accepted	2026-11-20 15:20:10.234+00	\N	\N	\N	1	2026-11-23 16:33:26.239+00	2026-11-23 16:33:26.239+00
108	20	311	fourth	accepted	2026-11-20 15:20:10.234+00	\N	\N	\N	1	2026-11-23 16:33:26.242+00	2026-11-23 16:33:26.242+00
109	21	309	main	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.246+00	2026-11-23 16:33:26.246+00
110	21	310	assistant	declined	2026-11-30 16:10:10.242+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.249+00	2026-11-23 16:33:26.249+00
111	21	311	assistant	accepted	2026-11-30 16:10:10.242+00	\N	\N	\N	1	2026-11-23 16:33:26.253+00	2026-11-23 16:33:26.253+00
113	22	310	main	declined	2026-11-30 16:10:10.255+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.261+00	2026-11-23 16:33:26.261+00
114	22	311	assistant	accepted	2026-11-30 16:10:10.255+00	\N	\N	\N	1	2026-11-23 16:33:26.266+00	2026-11-23 16:33:26.266+00
115	22	306	assistant	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.27+00	2026-11-23 16:33:26.27+00
116	22	307	fourth	accepted	2026-11-30 16:10:10.255+00	\N	\N	\N	1	2026-11-23 16:33:26.275+00	2026-11-23 16:33:26.275+00
117	23	311	main	accepted	2026-11-30 16:10:10.267+00	\N	\N	\N	1	2026-11-23 16:33:26.278+00	2026-11-23 16:33:26.278+00
118	23	306	assistant	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.288+00	2026-11-23 16:33:26.288+00
119	23	307	assistant	accepted	2026-11-30 16:10:10.267+00	\N	\N	\N	1	2026-11-23 16:33:26.292+00	2026-11-23 16:33:26.292+00
120	23	308	fourth	accepted	2026-11-30 16:10:10.267+00	\N	\N	\N	1	2026-11-23 16:33:26.298+00	2026-11-23 16:33:26.298+00
121	24	306	main	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.305+00	2026-11-23 16:33:26.305+00
122	24	307	assistant	accepted	2026-11-30 16:10:10.284+00	\N	\N	\N	1	2026-11-23 16:33:26.311+00	2026-11-23 16:33:26.311+00
123	24	308	assistant	accepted	2026-11-30 16:10:10.284+00	\N	\N	\N	1	2026-11-23 16:33:26.315+00	2026-11-23 16:33:26.315+00
124	24	309	fourth	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.321+00	2026-11-23 16:33:26.321+00
125	25	307	main	accepted	2026-12-10 16:10:10.301+00	\N	\N	\N	1	2026-11-23 16:33:26.329+00	2026-11-23 16:33:26.329+00
126	25	308	assistant	accepted	2026-12-10 16:10:10.301+00	\N	\N	\N	1	2026-11-23 16:33:26.341+00	2026-11-23 16:33:26.341+00
127	25	309	assistant	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.351+00	2026-11-23 16:33:26.351+00
128	25	310	fourth	accepted	2026-12-10 16:10:10.301+00	\N	\N	\N	1	2026-11-23 16:33:26.359+00	2026-11-23 16:33:26.359+00
129	26	308	main	accepted	2026-12-10 16:10:10.308+00	\N	\N	\N	1	2026-11-23 16:33:26.364+00	2026-11-23 16:33:26.364+00
130	26	309	assistant	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.373+00	2026-11-23 16:33:26.373+00
131	26	310	assistant	accepted	2026-12-10 16:10:10.308+00	\N	\N	\N	1	2026-11-23 16:33:26.383+00	2026-11-23 16:33:26.383+00
132	26	311	fourth	declined	2026-12-10 16:10:10.308+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.388+00	2026-11-23 16:33:26.388+00
133	27	309	main	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.395+00	2026-11-23 16:33:26.395+00
134	27	310	assistant	accepted	2026-12-10 16:10:10.314+00	\N	\N	\N	1	2026-11-23 16:33:26.399+00	2026-11-23 16:33:26.399+00
135	27	311	assistant	declined	2026-12-10 16:10:10.314+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.407+00	2026-11-23 16:33:26.407+00
136	27	306	fourth	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.416+00	2026-11-23 16:33:26.416+00
137	28	310	main	accepted	2026-12-10 16:10:10.325+00	\N	\N	\N	1	2026-11-23 16:33:26.421+00	2026-11-23 16:33:26.421+00
138	28	311	assistant	declined	2026-12-10 16:10:10.325+00	Indisponible à cette date	\N	\N	1	2026-11-23 16:33:26.431+00	2026-11-23 16:33:26.431+00
139	28	306	assistant	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.435+00	2026-11-23 16:33:26.435+00
140	28	307	fourth	accepted	2026-12-10 16:10:10.325+00	\N	\N	\N	1	2026-11-23 16:33:26.44+00	2026-11-23 16:33:26.44+00
112	21	306	fourth	pending	\N	\N	\N	\N	1	2026-11-23 16:33:26.257+00	2026-11-23 16:33:43.783+00
\.


--
-- Data for Name: ScoutEvaluations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ScoutEvaluations" (id, "scoutId", "playerId", date, "overallRating", "technicalScore", "physicalScore", "mentalScore", "tacticalScore", recommendation, potential, notes, "position", "createdAt", "updatedAt") FROM stdin;
1	1	267	2026-11-11	6.8	6.3	6.4	8.2	6.1	watch	medium	Technique au-dessus de la moyenne.	attaquant	2026-11-23 16:10:14.146+00	2026-11-23 16:10:14.146+00
2	1	124	2026-10-31	7.2	8.8	5.6	6.1	8.3	watch	medium	Très rapide, doit progresser dans les duels.	attaquant	2026-11-23 16:10:14.152+00	2026-11-23 16:10:14.152+00
3	1	147	2026-11-13	6.8	5.9	5.6	6.7	8.8	watch	medium	Très rapide, doit progresser dans les duels.	defenseur	2026-11-23 16:10:14.161+00	2026-11-23 16:10:14.161+00
4	1	255	2026-11-08	8.2	7.6	8	8.6	8.6	sign	high	Bonne lecture du jeu.	defenseur	2026-11-23 16:10:14.165+00	2026-11-23 16:10:14.165+00
5	1	46	2026-11-13	6.5	5.1	7.9	6.7	6.3	watch	medium	Très rapide, doit progresser dans les duels.	milieu	2026-11-23 16:10:14.172+00	2026-11-23 16:10:14.172+00
6	1	171	2026-10-17	6.8	6.2	6.2	8.2	6.6	watch	medium	Bonne lecture du jeu.	milieu	2026-11-23 16:10:14.178+00	2026-11-23 16:10:14.178+00
7	1	98	2026-11-13	6.8	6.4	6.3	6.9	7.7	watch	medium	Leader naturel.	defenseur	2026-11-23 16:10:14.18+00	2026-11-23 16:10:14.18+00
8	1	148	2026-10-20	6.4	6.8	5.5	7	6.4	reject	medium	À revoir sur un match à enjeu.	defenseur	2026-11-23 16:10:14.182+00	2026-11-23 16:10:14.182+00
9	1	132	2026-10-25	7.9	6.9	8	9	7.8	watch	high	Très rapide, doit progresser dans les duels.	defenseur	2026-11-23 16:10:14.185+00	2026-11-23 16:10:14.185+00
10	1	232	2026-10-19	8.1	8.7	7.6	8.4	7.8	sign	high	Technique au-dessus de la moyenne.	attaquant	2026-11-23 16:10:14.189+00	2026-11-23 16:10:14.189+00
11	1	110	2026-10-18	7	7.4	5.2	7.4	7.9	watch	medium	Leader naturel.	gardien	2026-11-23 16:10:14.192+00	2026-11-23 16:10:14.192+00
12	1	269	2026-10-14	8	8.5	5.2	8.7	9.4	sign	high	Bonne lecture du jeu.	attaquant	2026-11-23 16:10:14.196+00	2026-11-23 16:10:14.196+00
13	1	100	2026-11-01	7.3	7.9	8.6	7	5.6	watch	medium	Leader naturel.	milieu	2026-11-23 16:10:14.2+00	2026-11-23 16:10:14.2+00
14	1	222	2026-11-18	7.4	7	6.4	7.2	8.8	watch	medium	À revoir sur un match à enjeu.	defenseur	2026-11-23 16:10:14.203+00	2026-11-23 16:10:14.203+00
15	1	22	2026-10-15	6.9	9.3	5.5	7.8	5.1	watch	medium	Technique au-dessus de la moyenne.	defenseur	2026-11-23 16:10:14.205+00	2026-11-23 16:10:14.205+00
16	1	224	2026-10-19	6.3	5.5	6.8	7.6	5.3	reject	medium	Leader naturel.	defenseur	2026-11-23 16:10:14.207+00	2026-11-23 16:10:14.207+00
17	1	194	2026-10-22	7.6	5.9	9.3	9.4	5.9	watch	high	À revoir sur un match à enjeu.	milieu	2026-11-23 16:10:14.209+00	2026-11-23 16:10:14.209+00
18	1	131	2026-11-04	7.9	8.4	8.3	8	6.8	watch	high	Leader naturel.	defenseur	2026-11-23 16:10:14.212+00	2026-11-23 16:10:14.212+00
19	1	145	2026-11-05	6.5	6.2	6.7	6.9	6	watch	medium	Très rapide, doit progresser dans les duels.	gardien	2026-11-23 16:10:14.216+00	2026-11-23 16:10:14.216+00
20	1	273	2026-11-06	6.8	6.4	7.8	5.2	7.9	watch	medium	Bonne lecture du jeu.	defenseur	2026-11-23 16:10:14.218+00	2026-11-23 16:10:14.218+00
21	1	33	2026-11-16	7.1	7	8.6	5.4	7.5	watch	medium	Très rapide, doit progresser dans les duels.	attaquant	2026-11-23 16:10:14.221+00	2026-11-23 16:10:14.221+00
22	1	92	2026-11-09	7	8.1	6.1	5	8.6	watch	medium	Très rapide, doit progresser dans les duels.	gardien	2026-11-23 16:10:14.223+00	2026-11-23 16:10:14.223+00
23	1	54	2026-10-29	7.6	9.1	9.5	6.7	5.2	watch	high	Leader naturel.	attaquant	2026-11-23 16:10:14.226+00	2026-11-23 16:10:14.226+00
24	1	189	2026-11-04	7	5.2	8.5	9.3	5.1	watch	medium	Leader naturel.	milieu	2026-11-23 16:10:14.229+00	2026-11-23 16:10:14.229+00
25	1	70	2026-11-04	7.4	9.1	8	7.2	5.1	watch	medium	Leader naturel.	attaquant	2026-11-23 16:10:14.232+00	2026-11-23 16:10:14.232+00
26	1	183	2026-11-02	7.5	8.5	8.7	5.1	7.5	watch	high	Leader naturel.	defenseur	2026-11-23 16:10:14.235+00	2026-11-23 16:10:14.235+00
27	1	134	2026-10-18	7.4	8.6	6.2	8.1	6.6	watch	medium	À revoir sur un match à enjeu.	defenseur	2026-11-23 16:10:14.238+00	2026-11-23 16:10:14.238+00
28	1	242	2026-10-31	6.5	6	7.4	5.3	7.1	watch	medium	Technique au-dessus de la moyenne.	defenseur	2026-11-23 16:10:14.242+00	2026-11-23 16:10:14.242+00
29	1	106	2026-11-17	7.6	9.1	8.2	5.6	7.4	watch	high	Bonne lecture du jeu.	attaquant	2026-11-23 16:10:14.244+00	2026-11-23 16:10:14.244+00
30	1	156	2026-11-09	7.1	5.7	7.5	8.7	6.6	watch	medium	À revoir sur un match à enjeu.	milieu	2026-11-23 16:10:14.247+00	2026-11-23 16:10:14.247+00
31	1	251	2026-11-09	7.8	9.4	5.1	9.4	7.1	watch	high	Bonne lecture du jeu.	attaquant	2026-11-23 16:10:14.251+00	2026-11-23 16:10:14.251+00
32	1	177	2026-10-20	7.2	9.2	7.8	6.2	5.4	watch	medium	À revoir sur un match à enjeu.	attaquant	2026-11-23 16:10:14.257+00	2026-11-23 16:10:14.257+00
33	1	240	2026-10-19	7.4	8.5	6.8	7	7.4	watch	medium	Très rapide, doit progresser dans les duels.	defenseur	2026-11-23 16:10:14.261+00	2026-11-23 16:10:14.261+00
34	1	82	2026-10-14	6.9	9.2	6.8	6.2	5.2	watch	medium	Leader naturel.	milieu	2026-11-23 16:10:14.264+00	2026-11-23 16:10:14.264+00
35	1	227	2026-11-13	8.9	8.3	9.4	9.2	8.5	sign	elite	Très rapide, doit progresser dans les duels.	milieu	2026-11-23 16:10:14.266+00	2026-11-23 16:10:14.266+00
36	1	287	2026-10-21	7.7	8.6	6.3	8.9	7.1	watch	high	Leader naturel.	attaquant	2026-11-23 16:10:14.273+00	2026-11-23 16:10:14.273+00
37	1	185	2026-11-14	6.9	8.9	6.1	7.5	5.1	watch	medium	Bonne lecture du jeu.	defenseur	2026-11-23 16:10:14.278+00	2026-11-23 16:10:14.278+00
38	1	68	2026-11-08	8.1	7.8	8.6	7	8.8	sign	high	Leader naturel.	milieu	2026-11-23 16:10:14.283+00	2026-11-23 16:10:14.283+00
39	1	129	2026-11-07	6.7	9.4	5.9	5.4	6.1	watch	medium	Très rapide, doit progresser dans les duels.	defenseur	2026-11-23 16:10:14.293+00	2026-11-23 16:10:14.293+00
40	1	75	2026-11-19	6.4	6.1	7.4	5.3	6.9	reject	medium	À revoir sur un match à enjeu.	defenseur	2026-11-23 16:10:14.298+00	2026-11-23 16:10:14.298+00
\.


--
-- Data for Name: ScoutWatchlists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ScoutWatchlists" (id, "scoutId", "playerId", notes, "createdAt", "updatedAt") FROM stdin;
1	1	124	À suivre de près	2026-11-23 16:10:14.156+00	2026-11-23 16:10:14.156+00
2	1	255	À suivre de près	2026-11-23 16:10:14.167+00	2026-11-23 16:10:14.167+00
3	1	132	À suivre de près	2026-11-23 16:10:14.186+00	2026-11-23 16:10:14.186+00
4	1	232	À suivre de près	2026-11-23 16:10:14.19+00	2026-11-23 16:10:14.19+00
5	1	110	À suivre de près	2026-11-23 16:10:14.194+00	2026-11-23 16:10:14.194+00
6	1	269	À suivre de près	2026-11-23 16:10:14.198+00	2026-11-23 16:10:14.198+00
7	1	100	À suivre de près	2026-11-23 16:10:14.201+00	2026-11-23 16:10:14.201+00
8	1	222	À suivre de près	2026-11-23 16:10:14.204+00	2026-11-23 16:10:14.204+00
9	1	194	À suivre de près	2026-11-23 16:10:14.21+00	2026-11-23 16:10:14.21+00
10	1	131	À suivre de près	2026-11-23 16:10:14.214+00	2026-11-23 16:10:14.214+00
11	1	33	À suivre de près	2026-11-23 16:10:14.222+00	2026-11-23 16:10:14.222+00
12	1	92	À suivre de près	2026-11-23 16:10:14.225+00	2026-11-23 16:10:14.225+00
13	1	54	À suivre de près	2026-11-23 16:10:14.227+00	2026-11-23 16:10:14.227+00
14	1	189	À suivre de près	2026-11-23 16:10:14.23+00	2026-11-23 16:10:14.23+00
15	1	70	À suivre de près	2026-11-23 16:10:14.234+00	2026-11-23 16:10:14.234+00
16	1	183	À suivre de près	2026-11-23 16:10:14.236+00	2026-11-23 16:10:14.236+00
17	1	134	À suivre de près	2026-11-23 16:10:14.24+00	2026-11-23 16:10:14.24+00
18	1	106	À suivre de près	2026-11-23 16:10:14.245+00	2026-11-23 16:10:14.245+00
19	1	156	À suivre de près	2026-11-23 16:10:14.249+00	2026-11-23 16:10:14.249+00
20	1	251	À suivre de près	2026-11-23 16:10:14.254+00	2026-11-23 16:10:14.254+00
21	1	177	À suivre de près	2026-11-23 16:10:14.26+00	2026-11-23 16:10:14.26+00
22	1	240	À suivre de près	2026-11-23 16:10:14.263+00	2026-11-23 16:10:14.263+00
23	1	227	À suivre de près	2026-11-23 16:10:14.269+00	2026-11-23 16:10:14.269+00
24	1	287	À suivre de près	2026-11-23 16:10:14.276+00	2026-11-23 16:10:14.276+00
25	1	68	À suivre de près	2026-11-23 16:10:14.288+00	2026-11-23 16:10:14.288+00
\.


--
-- Data for Name: Teams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Teams" (id, name, "coachId", "tournamentId", "shortName", description, logo, colors, "foundedYear", "homeGround", "isActive", "createdAt", "updatedAt") FROM stdin;
1	Wydad Athletic Club	2	1	WAC	Wydad Athletic Club, club amateur affilié à la Ligue de Casablanca.	\N	["#d32f2f","#ffffff"]	1969	Stade Mohammed V	t	2026-11-23 16:10:07.458+00	2026-11-23 16:10:07.471+00
2	Raja Club Athletic	21	1	RCA	Raja Club Athletic, club amateur affilié à la Ligue de Casablanca.	\N	["#2e7d32","#ffffff"]	1946	Stade Père Jégo	t	2026-11-23 16:10:07.592+00	2026-11-23 16:10:07.596+00
3	AS Lafarge Maroc	40	1	ASLM	AS Lafarge Maroc, club amateur affilié à la Ligue de Casablanca.	\N	["#1565c0","#ffeb3b"]	1972	Complexe Al Amal	t	2026-11-23 16:10:07.734+00	2026-11-23 16:10:07.739+00
4	Sporting Chabab Mohammadia	59	1	SCCM	Sporting Chabab Mohammadia, club amateur affilié à la Ligue de Casablanca.	\N	["#000000","#ffffff"]	1979	Stade Larbi Zaouli	t	2026-11-23 16:10:07.839+00	2026-11-23 16:10:07.846+00
5	Union Sportive Mohammadia	78	1	USM	Union Sportive Mohammadia, club amateur affilié à la Ligue de Casablanca.	\N	["#6a1b9a","#ffffff"]	1993	Terrain Sidi Moumen	t	2026-11-23 16:10:07.969+00	2026-11-23 16:10:07.974+00
6	Tihad Athletic Sportif	97	1	TAS	Tihad Athletic Sportif, club amateur affilié à la Ligue de Casablanca.	\N	["#ef6c00","#000000"]	1943	Stade El Bachir	t	2026-11-23 16:10:08.099+00	2026-11-23 16:10:08.105+00
7	Nadi Difaa Riadi Ain Sebaa	116	1	NDR	Nadi Difaa Riadi Ain Sebaa, club amateur affilié à la Ligue de Casablanca.	\N	["#00838f","#ffffff"]	1964	Complexe Oasis	t	2026-11-23 16:10:08.226+00	2026-11-23 16:10:08.23+00
8	Rachad Bernoussi	135	1	RB	Rachad Bernoussi, club amateur affilié à la Ligue de Casablanca.	\N	["#c62828","#000000"]	1994	Stade Ain Chock	t	2026-11-23 16:10:08.366+00	2026-11-23 16:10:08.371+00
9	Athletic Youssoufia Berrechid	154	2	CAYB	Athletic Youssoufia Berrechid, club amateur affilié à la Ligue de Casablanca.	\N	["#d32f2f","#ffffff"]	1972	Stade Mohammed V	t	2026-11-23 16:10:08.477+00	2026-11-23 16:10:08.481+00
10	Etoile Jeunesse Sportive Casa	173	2	EJSC	Etoile Jeunesse Sportive Casa, club amateur affilié à la Ligue de Casablanca.	\N	["#2e7d32","#ffffff"]	2009	Stade Père Jégo	t	2026-11-23 16:10:08.594+00	2026-11-23 16:10:08.6+00
11	Racing Athletic Sportif	192	2	RAC	Racing Athletic Sportif, club amateur affilié à la Ligue de Casablanca.	\N	["#1565c0","#ffeb3b"]	1957	Complexe Al Amal	t	2026-11-23 16:10:08.693+00	2026-11-23 16:10:08.696+00
12	Hayat Athletic	211	2	HAC	Hayat Athletic, club amateur affilié à la Ligue de Casablanca.	\N	["#000000","#ffffff"]	1980	Stade Larbi Zaouli	t	2026-11-23 16:10:08.826+00	2026-11-23 16:10:08.835+00
13	Chabab Fida	230	2	CCF	Chabab Fida, club amateur affilié à la Ligue de Casablanca.	\N	["#6a1b9a","#ffffff"]	1942	Terrain Sidi Moumen	t	2026-11-23 16:10:08.936+00	2026-11-23 16:10:08.941+00
14	Ennajjah Ryadi Mediouna	249	2	ERM	Ennajjah Ryadi Mediouna, club amateur affilié à la Ligue de Casablanca.	\N	["#ef6c00","#000000"]	1990	Stade El Bachir	t	2026-11-23 16:10:09.042+00	2026-11-23 16:10:09.049+00
15	Al Ahram Riadi	268	2	AHRAM	Al Ahram Riadi, club amateur affilié à la Ligue de Casablanca.	\N	["#00838f","#ffffff"]	1977	Complexe Oasis	t	2026-11-23 16:10:09.122+00	2026-11-23 16:10:09.125+00
16	Mejd Ancienne Medina	287	2	MCAM	Mejd Ancienne Medina, club amateur affilié à la Ligue de Casablanca.	\N	["#c62828","#000000"]	1963	Stade Ain Chock	t	2026-11-23 16:10:09.274+00	2026-11-23 16:10:09.285+00
\.


--
-- Data for Name: TournamentApplications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."TournamentApplications" (id, "teamId", "tournamentId", status, "appliedAt", "reviewedAt", "reviewedBy", notes, "createdAt", "updatedAt") FROM stdin;
1	1	1	approved	2026-09-09 16:10:09.418+00	2026-09-12 16:10:09.418+00	1	Dossier complet.	2026-11-23 16:10:09.419+00	2026-11-23 16:10:09.419+00
2	2	1	approved	2026-09-09 16:10:09.425+00	2026-09-12 16:10:09.425+00	1	Dossier complet.	2026-11-23 16:10:09.425+00	2026-11-23 16:10:09.425+00
3	3	1	approved	2026-09-09 16:10:09.429+00	2026-09-12 16:10:09.429+00	1	Dossier complet.	2026-11-23 16:10:09.429+00	2026-11-23 16:10:09.429+00
4	4	1	approved	2026-09-09 16:10:09.433+00	2026-09-12 16:10:09.433+00	1	Dossier complet.	2026-11-23 16:10:09.433+00	2026-11-23 16:10:09.433+00
5	5	1	approved	2026-09-09 16:10:09.437+00	2026-09-12 16:10:09.437+00	1	Dossier complet.	2026-11-23 16:10:09.437+00	2026-11-23 16:10:09.437+00
6	6	1	approved	2026-09-09 16:10:09.441+00	2026-09-12 16:10:09.441+00	1	Dossier complet.	2026-11-23 16:10:09.441+00	2026-11-23 16:10:09.441+00
7	7	1	approved	2026-09-09 16:10:09.445+00	2026-09-12 16:10:09.445+00	1	Dossier complet.	2026-11-23 16:10:09.445+00	2026-11-23 16:10:09.445+00
8	8	1	approved	2026-09-09 16:10:09.447+00	2026-09-12 16:10:09.447+00	1	Dossier complet.	2026-11-23 16:10:09.447+00	2026-11-23 16:10:09.447+00
9	9	2	approved	2026-09-09 16:10:09.45+00	2026-09-12 16:10:09.45+00	1	Dossier complet.	2026-11-23 16:10:09.45+00	2026-11-23 16:10:09.45+00
10	10	2	approved	2026-09-09 16:10:09.452+00	2026-09-12 16:10:09.452+00	1	Dossier complet.	2026-11-23 16:10:09.452+00	2026-11-23 16:10:09.452+00
11	11	2	approved	2026-09-09 16:10:09.454+00	2026-09-12 16:10:09.454+00	1	Dossier complet.	2026-11-23 16:10:09.454+00	2026-11-23 16:10:09.454+00
12	12	2	approved	2026-09-09 16:10:09.456+00	2026-09-12 16:10:09.456+00	1	Dossier complet.	2026-11-23 16:10:09.457+00	2026-11-23 16:10:09.457+00
13	13	2	approved	2026-09-09 16:10:09.46+00	2026-09-12 16:10:09.46+00	1	Dossier complet.	2026-11-23 16:10:09.46+00	2026-11-23 16:10:09.46+00
14	14	2	approved	2026-09-09 16:10:09.462+00	2026-09-12 16:10:09.462+00	1	Dossier complet.	2026-11-23 16:10:09.462+00	2026-11-23 16:10:09.462+00
15	15	2	approved	2026-09-09 16:10:09.465+00	2026-09-12 16:10:09.465+00	1	Dossier complet.	2026-11-23 16:10:09.465+00	2026-11-23 16:10:09.465+00
16	16	2	approved	2026-09-09 16:10:09.467+00	2026-09-12 16:10:09.467+00	1	Dossier complet.	2026-11-23 16:10:09.467+00	2026-11-23 16:10:09.467+00
17	1	3	pending	2026-11-21 16:10:09.469+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.469+00	2026-11-23 16:10:09.469+00
18	2	3	approved	2026-11-13 16:10:09.47+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.47+00	2026-11-23 16:10:09.47+00
19	3	3	approved	2026-11-22 16:10:09.471+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.471+00	2026-11-23 16:10:09.471+00
20	4	3	approved	2026-11-14 16:10:09.472+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.473+00	2026-11-23 16:10:09.473+00
21	5	3	approved	2026-11-16 16:10:09.474+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.474+00	2026-11-23 16:10:09.474+00
22	6	3	rejected	2026-11-13 16:10:09.476+00	\N	\N	Candidature en attente de validation.	2026-11-23 16:10:09.476+00	2026-11-23 16:10:09.476+00
\.


--
-- Data for Name: Tournaments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Tournaments" (id, name, description, "startDate", "endDate", status, "maxTeams", location, rules, "registrationDeadline", "prizePool", "entryFee", format, "isPublic", "createdAt", "updatedAt") FROM stdin;
1	Championnat Amateur Casablanca 2026	Championnat en matchs aller simple entre 8 clubs du Grand Casablanca.	2026-09-24 16:10:07.427+00	2027-01-22 16:10:07.427+00	active	8	Casablanca	3 points victoire, 1 point nul. Matchs de 90 minutes. 5 remplacements autorisés.	2026-09-14 16:10:07.427+00	50000.00	1500.00	league	t	2026-11-23 16:10:07.428+00	2026-11-23 16:10:07.428+00
2	Coupe Raja Academy U23	Tournoi à élimination directe pour 8 équipes.	2026-10-09 16:10:07.442+00	2026-11-13 16:10:07.442+00	completed	8	Casablanca — Oasis	Élimination directe. Tirs au but en cas d'égalité.	2026-09-29 16:10:07.442+00	30000.00	1000.00	knockout	t	2026-11-23 16:10:07.443+00	2026-11-23 16:10:07.443+00
3	Tournoi Ramadan 2027	Tournoi de nuit, phase de groupes puis élimination directe.	2027-02-21 16:10:07.45+00	2027-03-23 16:10:07.45+00	draft	16	Mohammedia	Groupes de 4, les deux premiers qualifiés.	2027-02-06 16:10:07.45+00	20000.00	800.00	group_then_knockout	t	2026-11-23 16:10:07.451+00	2026-11-23 16:10:07.451+00
\.


--
-- Data for Name: TrainingAttendances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."TrainingAttendances" (id, "trainingSessionId", "playerId", status, note, "createdAt", "updatedAt") FROM stdin;
1	1	1	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
2	1	2	excused	Raison familiale	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
3	1	3	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
4	1	4	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
5	1	5	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
6	1	6	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
7	1	7	excused	Raison familiale	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
8	1	8	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
9	1	9	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
10	1	10	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
11	1	11	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
12	1	12	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
13	1	13	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
14	1	14	excused	Raison familiale	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
15	1	15	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
16	1	16	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
17	1	17	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
18	1	18	present	\N	2026-11-23 16:10:12.73+00	2026-11-23 16:10:12.73+00
19	3	1	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
20	3	2	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
21	3	3	absent	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
22	3	4	excused	Examen	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
23	3	5	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
24	3	6	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
25	3	7	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
26	3	8	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
27	3	9	excused	Blessure légère	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
28	3	10	excused	Raison familiale	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
29	3	11	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
30	3	12	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
31	3	13	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
32	3	14	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
33	3	15	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
34	3	16	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
35	3	17	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
36	3	18	present	\N	2026-11-23 16:10:12.741+00	2026-11-23 16:10:12.741+00
37	5	1	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
38	5	2	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
39	5	3	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
40	5	4	excused	Examen	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
41	5	5	excused	Examen	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
42	5	6	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
43	5	7	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
44	5	8	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
45	5	9	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
46	5	10	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
47	5	11	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
48	5	12	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
49	5	13	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
50	5	14	excused	Raison familiale	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
51	5	15	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
52	5	16	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
53	5	17	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
54	5	18	present	\N	2026-11-23 16:10:12.746+00	2026-11-23 16:10:12.746+00
55	6	1	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
56	6	2	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
57	6	3	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
58	6	4	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
59	6	5	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
60	6	6	absent	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
61	6	7	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
62	6	8	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
63	6	9	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
64	6	10	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
65	6	11	excused	Blessure légère	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
66	6	12	absent	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
67	6	13	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
68	6	14	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
69	6	15	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
70	6	16	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
71	6	17	excused	Blessure légère	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
72	6	18	present	\N	2026-11-23 16:10:12.752+00	2026-11-23 16:10:12.752+00
73	7	1	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
74	7	2	absent	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
75	7	3	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
76	7	4	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
77	7	5	absent	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
78	7	6	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
79	7	7	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
80	7	8	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
81	7	9	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
82	7	10	excused	Raison familiale	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
83	7	11	excused	Examen	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
84	7	12	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
85	7	13	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
86	7	14	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
87	7	15	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
88	7	16	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
89	7	17	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
90	7	18	present	\N	2026-11-23 16:10:12.762+00	2026-11-23 16:10:12.762+00
91	11	19	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
92	11	20	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
93	11	21	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
94	11	22	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
95	11	23	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
96	11	24	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
97	11	25	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
98	11	26	excused	Examen	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
99	11	27	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
100	11	28	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
101	11	29	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
102	11	30	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
103	11	31	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
104	11	32	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
105	11	33	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
106	11	34	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
107	11	35	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
108	11	36	present	\N	2026-11-23 16:10:12.783+00	2026-11-23 16:10:12.783+00
109	12	19	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
110	12	20	absent	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
111	12	21	absent	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
112	12	22	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
113	12	23	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
114	12	24	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
115	12	25	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
116	12	26	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
117	12	27	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
118	12	28	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
119	12	29	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
120	12	30	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
121	12	31	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
122	12	32	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
123	12	33	excused	Examen	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
124	12	34	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
125	12	35	present	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
126	12	36	absent	\N	2026-11-23 16:10:12.793+00	2026-11-23 16:10:12.793+00
127	13	19	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
128	13	20	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
129	13	21	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
130	13	22	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
131	13	23	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
132	13	24	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
133	13	25	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
134	13	26	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
135	13	27	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
136	13	28	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
137	13	29	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
138	13	30	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
139	13	31	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
140	13	32	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
141	13	33	present	\N	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
142	13	34	excused	Raison familiale	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
143	13	35	excused	Raison familiale	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
144	13	36	excused	Blessure légère	2026-11-23 16:10:12.803+00	2026-11-23 16:10:12.803+00
145	14	19	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
146	14	20	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
147	14	21	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
148	14	22	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
149	14	23	absent	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
150	14	24	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
151	14	25	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
152	14	26	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
153	14	27	absent	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
154	14	28	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
155	14	29	excused	Examen	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
156	14	30	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
157	14	31	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
158	14	32	absent	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
159	14	33	absent	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
160	14	34	excused	Raison familiale	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
161	14	35	absent	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
162	14	36	present	\N	2026-11-23 16:10:12.811+00	2026-11-23 16:10:12.811+00
163	15	19	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
164	15	20	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
165	15	21	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
166	15	22	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
167	15	23	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
168	15	24	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
169	15	25	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
170	15	26	excused	Examen	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
171	15	27	absent	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
172	15	28	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
173	15	29	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
174	15	30	absent	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
175	15	31	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
176	15	32	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
177	15	33	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
178	15	34	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
179	15	35	absent	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
180	15	36	present	\N	2026-11-23 16:10:12.818+00	2026-11-23 16:10:12.818+00
181	16	19	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
182	16	20	excused	Examen	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
183	16	21	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
184	16	22	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
185	16	23	absent	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
186	16	24	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
187	16	25	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
188	16	26	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
189	16	27	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
190	16	28	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
191	16	29	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
192	16	30	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
193	16	31	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
194	16	32	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
195	16	33	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
196	16	34	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
197	16	35	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
198	16	36	present	\N	2026-11-23 16:10:12.827+00	2026-11-23 16:10:12.827+00
199	21	37	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
200	21	38	excused	Examen	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
201	21	39	excused	Raison familiale	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
202	21	40	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
203	21	41	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
204	21	42	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
205	21	43	excused	Blessure légère	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
206	21	44	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
207	21	45	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
208	21	46	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
209	21	47	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
210	21	48	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
211	21	49	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
212	21	50	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
213	21	51	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
214	21	52	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
215	21	53	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
216	21	54	present	\N	2026-11-23 16:10:12.842+00	2026-11-23 16:10:12.842+00
217	22	37	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
218	22	38	absent	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
219	22	39	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
220	22	40	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
221	22	41	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
222	22	42	excused	Blessure légère	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
223	22	43	absent	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
224	22	44	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
225	22	45	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
226	22	46	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
227	22	47	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
228	22	48	absent	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
229	22	49	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
230	22	50	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
231	22	51	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
232	22	52	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
233	22	53	excused	Blessure légère	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
234	22	54	present	\N	2026-11-23 16:10:12.849+00	2026-11-23 16:10:12.849+00
235	23	37	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
236	23	38	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
237	23	39	excused	Examen	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
238	23	40	excused	Raison familiale	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
239	23	41	excused	Raison familiale	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
240	23	42	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
241	23	43	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
242	23	44	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
243	23	45	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
244	23	46	excused	Examen	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
245	23	47	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
246	23	48	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
247	23	49	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
248	23	50	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
249	23	51	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
250	23	52	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
251	23	53	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
252	23	54	present	\N	2026-11-23 16:10:12.857+00	2026-11-23 16:10:12.857+00
253	24	37	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
254	24	38	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
255	24	39	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
256	24	40	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
257	24	41	absent	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
258	24	42	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
259	24	43	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
260	24	44	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
261	24	45	absent	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
262	24	46	excused	Examen	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
263	24	47	absent	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
264	24	48	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
265	24	49	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
266	24	50	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
267	24	51	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
268	24	52	present	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
269	24	53	absent	\N	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
270	24	54	excused	Blessure légère	2026-11-23 16:10:12.866+00	2026-11-23 16:10:12.866+00
271	25	37	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
272	25	38	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
273	25	39	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
274	25	40	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
275	25	41	excused	Blessure légère	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
276	25	42	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
277	25	43	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
278	25	44	absent	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
279	25	45	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
280	25	46	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
281	25	47	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
282	25	48	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
283	25	49	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
284	25	50	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
285	25	51	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
286	25	52	excused	Examen	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
287	25	53	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
288	25	54	present	\N	2026-11-23 16:10:12.873+00	2026-11-23 16:10:12.873+00
289	26	37	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
290	26	38	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
291	26	39	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
292	26	40	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
293	26	41	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
294	26	42	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
295	26	43	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
296	26	44	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
297	26	45	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
298	26	46	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
299	26	47	excused	Examen	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
300	26	48	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
301	26	49	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
302	26	50	absent	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
303	26	51	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
304	26	52	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
305	26	53	present	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
306	26	54	absent	\N	2026-11-23 16:10:12.881+00	2026-11-23 16:10:12.881+00
307	27	37	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
308	27	38	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
309	27	39	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
310	27	40	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
311	27	41	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
312	27	42	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
313	27	43	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
314	27	44	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
315	27	45	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
316	27	46	absent	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
317	27	47	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
318	27	48	absent	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
319	27	49	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
320	27	50	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
321	27	51	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
322	27	52	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
323	27	53	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
324	27	54	present	\N	2026-11-23 16:10:12.891+00	2026-11-23 16:10:12.891+00
325	31	55	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
326	31	56	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
327	31	57	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
328	31	58	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
329	31	59	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
330	31	60	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
331	31	61	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
332	31	62	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
333	31	63	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
334	31	64	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
335	31	65	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
336	31	66	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
337	31	67	excused	Raison familiale	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
338	31	68	absent	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
339	31	69	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
340	31	70	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
341	31	71	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
342	31	72	present	\N	2026-11-23 16:10:12.904+00	2026-11-23 16:10:12.904+00
343	32	55	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
344	32	56	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
345	32	57	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
346	32	58	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
347	32	59	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
348	32	60	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
349	32	61	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
350	32	62	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
351	32	63	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
352	32	64	absent	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
353	32	65	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
354	32	66	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
355	32	67	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
356	32	68	excused	Examen	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
357	32	69	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
358	32	70	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
359	32	71	absent	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
360	32	72	present	\N	2026-11-23 16:10:12.91+00	2026-11-23 16:10:12.91+00
361	33	55	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
362	33	56	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
363	33	57	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
364	33	58	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
365	33	59	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
366	33	60	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
367	33	61	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
368	33	62	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
369	33	63	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
370	33	64	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
371	33	65	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
372	33	66	absent	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
373	33	67	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
374	33	68	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
375	33	69	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
376	33	70	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
377	33	71	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
378	33	72	present	\N	2026-11-23 16:10:12.916+00	2026-11-23 16:10:12.916+00
379	34	55	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
380	34	56	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
381	34	57	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
382	34	58	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
383	34	59	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
384	34	60	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
385	34	61	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
386	34	62	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
387	34	63	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
388	34	64	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
389	34	65	excused	Raison familiale	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
390	34	66	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
391	34	67	absent	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
392	34	68	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
393	34	69	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
394	34	70	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
395	34	71	excused	Raison familiale	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
396	34	72	present	\N	2026-11-23 16:10:12.923+00	2026-11-23 16:10:12.923+00
397	35	55	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
398	35	56	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
399	35	57	absent	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
400	35	58	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
401	35	59	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
402	35	60	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
403	35	61	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
404	35	62	absent	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
405	35	63	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
406	35	64	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
407	35	65	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
408	35	66	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
409	35	67	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
410	35	68	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
411	35	69	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
412	35	70	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
413	35	71	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
414	35	72	present	\N	2026-11-23 16:10:12.932+00	2026-11-23 16:10:12.932+00
415	36	55	excused	Blessure légère	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
416	36	56	absent	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
417	36	57	absent	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
418	36	58	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
419	36	59	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
420	36	60	excused	Blessure légère	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
421	36	61	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
422	36	62	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
423	36	63	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
424	36	64	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
425	36	65	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
426	36	66	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
427	36	67	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
428	36	68	absent	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
429	36	69	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
430	36	70	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
431	36	71	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
432	36	72	present	\N	2026-11-23 16:10:12.938+00	2026-11-23 16:10:12.938+00
433	37	55	absent	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
434	37	56	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
435	37	57	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
436	37	58	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
437	37	59	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
438	37	60	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
439	37	61	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
440	37	62	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
441	37	63	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
442	37	64	absent	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
443	37	65	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
444	37	66	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
445	37	67	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
446	37	68	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
447	37	69	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
448	37	70	present	\N	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
449	37	71	excused	Raison familiale	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
450	37	72	excused	Raison familiale	2026-11-23 16:10:12.944+00	2026-11-23 16:10:12.944+00
451	41	73	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
452	41	74	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
453	41	75	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
454	41	76	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
455	41	77	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
456	41	78	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
457	41	79	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
458	41	80	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
459	41	81	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
460	41	82	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
461	41	83	absent	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
462	41	84	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
463	41	85	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
464	41	86	absent	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
465	41	87	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
466	41	88	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
467	41	89	excused	Examen	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
468	41	90	present	\N	2026-11-23 16:10:12.957+00	2026-11-23 16:10:12.957+00
469	42	73	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
470	42	74	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
471	42	75	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
472	42	76	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
473	42	77	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
474	42	78	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
475	42	79	absent	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
476	42	80	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
477	42	81	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
478	42	82	absent	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
479	42	83	absent	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
480	42	84	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
481	42	85	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
482	42	86	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
483	42	87	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
484	42	88	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
485	42	89	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
486	42	90	present	\N	2026-11-23 16:10:12.963+00	2026-11-23 16:10:12.963+00
487	43	73	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
488	43	74	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
489	43	75	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
490	43	76	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
491	43	77	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
492	43	78	excused	Raison familiale	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
493	43	79	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
494	43	80	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
495	43	81	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
496	43	82	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
497	43	83	excused	Raison familiale	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
498	43	84	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
499	43	85	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
500	43	86	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
501	43	87	absent	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
502	43	88	absent	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
503	43	89	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
504	43	90	present	\N	2026-11-23 16:10:12.974+00	2026-11-23 16:10:12.974+00
505	44	73	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
506	44	74	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
507	44	75	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
508	44	76	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
509	44	77	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
510	44	78	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
511	44	79	excused	Raison familiale	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
512	44	80	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
513	44	81	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
514	44	82	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
515	44	83	excused	Raison familiale	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
516	44	84	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
517	44	85	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
518	44	86	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
519	44	87	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
520	44	88	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
521	44	89	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
522	44	90	present	\N	2026-11-23 16:10:12.984+00	2026-11-23 16:10:12.984+00
523	45	73	absent	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
524	45	74	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
525	45	75	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
526	45	76	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
527	45	77	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
528	45	78	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
529	45	79	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
530	45	80	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
531	45	81	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
532	45	82	excused	Examen	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
533	45	83	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
534	45	84	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
535	45	85	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
536	45	86	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
537	45	87	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
538	45	88	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
539	45	89	absent	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
540	45	90	present	\N	2026-11-23 16:10:12.997+00	2026-11-23 16:10:12.997+00
541	46	73	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
542	46	74	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
543	46	75	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
544	46	76	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
545	46	77	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
546	46	78	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
547	46	79	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
548	46	80	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
549	46	81	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
550	46	82	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
551	46	83	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
552	46	84	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
553	46	85	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
554	46	86	absent	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
555	46	87	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
556	46	88	excused	Raison familiale	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
557	46	89	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
558	46	90	present	\N	2026-11-23 16:10:13.007+00	2026-11-23 16:10:13.007+00
559	47	73	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
560	47	74	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
561	47	75	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
562	47	76	excused	Raison familiale	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
563	47	77	excused	Examen	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
564	47	78	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
565	47	79	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
566	47	80	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
567	47	81	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
568	47	82	excused	Blessure légère	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
569	47	83	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
570	47	84	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
571	47	85	absent	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
572	47	86	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
573	47	87	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
574	47	88	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
575	47	89	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
576	47	90	present	\N	2026-11-23 16:10:13.019+00	2026-11-23 16:10:13.019+00
577	52	91	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
578	52	92	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
579	52	93	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
580	52	94	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
581	52	95	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
582	52	96	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
583	52	97	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
584	52	98	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
585	52	99	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
586	52	100	excused	Raison familiale	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
587	52	101	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
588	52	102	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
589	52	103	excused	Examen	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
590	52	104	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
591	52	105	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
592	52	106	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
593	52	107	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
594	52	108	present	\N	2026-11-23 16:10:13.033+00	2026-11-23 16:10:13.033+00
595	53	91	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
596	53	92	absent	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
597	53	93	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
598	53	94	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
599	53	95	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
600	53	96	excused	Examen	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
601	53	97	absent	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
602	53	98	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
603	53	99	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
604	53	100	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
605	53	101	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
606	53	102	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
607	53	103	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
608	53	104	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
609	53	105	absent	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
610	53	106	absent	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
611	53	107	present	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
612	53	108	absent	\N	2026-11-23 16:10:13.039+00	2026-11-23 16:10:13.039+00
613	54	91	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
614	54	92	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
615	54	93	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
616	54	94	absent	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
617	54	95	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
618	54	96	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
619	54	97	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
620	54	98	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
621	54	99	excused	Raison familiale	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
622	54	100	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
623	54	101	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
624	54	102	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
625	54	103	excused	Examen	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
626	54	104	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
627	54	105	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
628	54	106	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
629	54	107	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
630	54	108	present	\N	2026-11-23 16:10:13.045+00	2026-11-23 16:10:13.045+00
631	55	91	absent	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
632	55	92	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
633	55	93	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
634	55	94	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
635	55	95	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
636	55	96	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
637	55	97	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
638	55	98	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
639	55	99	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
640	55	100	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
641	55	101	excused	Raison familiale	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
642	55	102	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
643	55	103	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
644	55	104	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
645	55	105	absent	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
646	55	106	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
647	55	107	excused	Raison familiale	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
648	55	108	present	\N	2026-11-23 16:10:13.051+00	2026-11-23 16:10:13.051+00
649	56	91	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
650	56	92	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
651	56	93	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
652	56	94	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
653	56	95	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
654	56	96	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
655	56	97	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
656	56	98	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
657	56	99	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
658	56	100	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
659	56	101	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
660	56	102	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
661	56	103	absent	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
662	56	104	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
663	56	105	excused	Blessure légère	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
664	56	106	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
665	56	107	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
666	56	108	present	\N	2026-11-23 16:10:13.057+00	2026-11-23 16:10:13.057+00
667	57	91	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
668	57	92	excused	Examen	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
669	57	93	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
670	57	94	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
671	57	95	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
672	57	96	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
673	57	97	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
674	57	98	absent	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
675	57	99	excused	Blessure légère	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
676	57	100	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
677	57	101	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
678	57	102	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
679	57	103	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
680	57	104	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
681	57	105	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
682	57	106	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
683	57	107	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
684	57	108	present	\N	2026-11-23 16:10:13.062+00	2026-11-23 16:10:13.062+00
685	61	109	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
686	61	110	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
687	61	111	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
688	61	112	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
689	61	113	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
690	61	114	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
691	61	115	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
692	61	116	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
693	61	117	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
694	61	118	absent	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
695	61	119	excused	Blessure légère	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
696	61	120	absent	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
697	61	121	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
698	61	122	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
699	61	123	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
700	61	124	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
701	61	125	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
702	61	126	present	\N	2026-11-23 16:10:13.075+00	2026-11-23 16:10:13.075+00
703	62	109	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
704	62	110	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
705	62	111	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
706	62	112	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
707	62	113	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
708	62	114	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
709	62	115	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
710	62	116	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
711	62	117	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
712	62	118	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
713	62	119	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
714	62	120	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
715	62	121	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
716	62	122	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
717	62	123	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
718	62	124	excused	Raison familiale	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
719	62	125	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
720	62	126	present	\N	2026-11-23 16:10:13.086+00	2026-11-23 16:10:13.086+00
721	63	109	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
722	63	110	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
723	63	111	absent	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
724	63	112	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
725	63	113	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
726	63	114	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
727	63	115	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
728	63	116	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
729	63	117	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
730	63	118	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
731	63	119	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
732	63	120	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
733	63	121	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
734	63	122	absent	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
735	63	123	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
736	63	124	excused	Raison familiale	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
737	63	125	present	\N	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
738	63	126	excused	Examen	2026-11-23 16:10:13.095+00	2026-11-23 16:10:13.095+00
739	64	109	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
740	64	110	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
741	64	111	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
742	64	112	absent	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
743	64	113	absent	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
744	64	114	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
745	64	115	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
746	64	116	excused	Raison familiale	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
747	64	117	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
748	64	118	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
749	64	119	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
750	64	120	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
751	64	121	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
752	64	122	excused	Blessure légère	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
753	64	123	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
754	64	124	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
755	64	125	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
756	64	126	present	\N	2026-11-23 16:10:13.104+00	2026-11-23 16:10:13.104+00
757	65	109	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
758	65	110	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
759	65	111	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
760	65	112	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
761	65	113	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
762	65	114	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
763	65	115	excused	Blessure légère	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
764	65	116	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
765	65	117	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
766	65	118	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
767	65	119	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
768	65	120	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
769	65	121	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
770	65	122	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
771	65	123	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
772	65	124	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
773	65	125	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
774	65	126	present	\N	2026-11-23 16:10:13.11+00	2026-11-23 16:10:13.11+00
775	66	109	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
776	66	110	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
777	66	111	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
778	66	112	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
779	66	113	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
780	66	114	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
781	66	115	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
782	66	116	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
783	66	117	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
784	66	118	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
785	66	119	absent	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
786	66	120	excused	Blessure légère	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
787	66	121	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
788	66	122	excused	Examen	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
789	66	123	excused	Blessure légère	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
790	66	124	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
791	66	125	present	\N	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
792	66	126	excused	Raison familiale	2026-11-23 16:10:13.117+00	2026-11-23 16:10:13.117+00
793	67	109	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
794	67	110	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
795	67	111	absent	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
796	67	112	absent	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
797	67	113	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
798	67	114	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
799	67	115	excused	Blessure légère	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
800	67	116	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
801	67	117	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
802	67	118	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
803	67	119	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
804	67	120	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
805	67	121	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
806	67	122	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
807	67	123	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
808	67	124	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
809	67	125	present	\N	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
810	67	126	excused	Blessure légère	2026-11-23 16:10:13.124+00	2026-11-23 16:10:13.124+00
811	71	127	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
812	71	128	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
813	71	129	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
814	71	130	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
815	71	131	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
816	71	132	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
817	71	133	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
818	71	134	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
819	71	135	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
820	71	136	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
821	71	137	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
822	71	138	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
823	71	139	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
824	71	140	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
825	71	141	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
826	71	142	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
827	71	143	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
828	71	144	present	\N	2026-11-23 16:10:13.133+00	2026-11-23 16:10:13.133+00
829	72	127	absent	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
830	72	128	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
831	72	129	excused	Examen	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
832	72	130	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
833	72	131	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
834	72	132	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
835	72	133	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
836	72	134	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
837	72	135	excused	Raison familiale	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
838	72	136	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
839	72	137	excused	Examen	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
840	72	138	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
841	72	139	excused	Raison familiale	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
842	72	140	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
843	72	141	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
844	72	142	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
845	72	143	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
846	72	144	present	\N	2026-11-23 16:10:13.137+00	2026-11-23 16:10:13.137+00
847	73	127	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
848	73	128	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
849	73	129	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
850	73	130	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
851	73	131	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
852	73	132	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
853	73	133	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
854	73	134	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
855	73	135	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
856	73	136	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
857	73	137	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
858	73	138	absent	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
859	73	139	absent	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
860	73	140	excused	Examen	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
861	73	141	excused	Blessure légère	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
862	73	142	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
863	73	143	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
864	73	144	present	\N	2026-11-23 16:10:13.142+00	2026-11-23 16:10:13.142+00
865	74	127	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
866	74	128	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
867	74	129	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
868	74	130	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
869	74	131	absent	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
870	74	132	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
871	74	133	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
872	74	134	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
873	74	135	excused	Raison familiale	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
874	74	136	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
875	74	137	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
876	74	138	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
877	74	139	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
878	74	140	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
879	74	141	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
880	74	142	excused	Raison familiale	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
881	74	143	present	\N	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
882	74	144	excused	Raison familiale	2026-11-23 16:10:13.147+00	2026-11-23 16:10:13.147+00
883	75	127	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
884	75	128	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
885	75	129	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
886	75	130	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
887	75	131	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
888	75	132	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
889	75	133	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
890	75	134	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
891	75	135	excused	Raison familiale	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
892	75	136	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
893	75	137	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
894	75	138	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
895	75	139	excused	Blessure légère	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
896	75	140	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
897	75	141	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
898	75	142	absent	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
899	75	143	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
900	75	144	present	\N	2026-11-23 16:10:13.154+00	2026-11-23 16:10:13.154+00
901	76	127	excused	Raison familiale	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
902	76	128	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
903	76	129	excused	Raison familiale	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
904	76	130	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
905	76	131	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
906	76	132	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
907	76	133	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
908	76	134	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
909	76	135	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
910	76	136	excused	Raison familiale	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
911	76	137	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
912	76	138	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
913	76	139	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
914	76	140	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
915	76	141	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
916	76	142	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
917	76	143	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
918	76	144	present	\N	2026-11-23 16:10:13.162+00	2026-11-23 16:10:13.162+00
919	81	145	excused	Raison familiale	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
920	81	146	absent	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
921	81	147	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
922	81	148	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
923	81	149	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
924	81	150	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
925	81	151	excused	Raison familiale	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
926	81	152	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
927	81	153	excused	Raison familiale	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
928	81	154	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
929	81	155	excused	Examen	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
930	81	156	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
931	81	157	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
932	81	158	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
933	81	159	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
934	81	160	excused	Blessure légère	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
935	81	161	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
936	81	162	present	\N	2026-11-23 16:10:13.176+00	2026-11-23 16:10:13.176+00
937	82	145	excused	Blessure légère	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
938	82	146	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
939	82	147	absent	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
940	82	148	excused	Blessure légère	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
941	82	149	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
942	82	150	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
943	82	151	absent	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
944	82	152	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
945	82	153	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
946	82	154	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
947	82	155	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
948	82	156	absent	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
949	82	157	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
950	82	158	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
951	82	159	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
952	82	160	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
953	82	161	absent	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
954	82	162	present	\N	2026-11-23 16:10:13.181+00	2026-11-23 16:10:13.181+00
955	83	145	absent	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
956	83	146	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
957	83	147	absent	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
958	83	148	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
959	83	149	absent	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
960	83	150	excused	Raison familiale	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
961	83	151	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
962	83	152	excused	Examen	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
963	83	153	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
964	83	154	excused	Raison familiale	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
965	83	155	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
966	83	156	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
967	83	157	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
968	83	158	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
969	83	159	excused	Blessure légère	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
970	83	160	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
971	83	161	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
972	83	162	present	\N	2026-11-23 16:10:13.191+00	2026-11-23 16:10:13.191+00
973	85	145	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
974	85	146	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
975	85	147	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
976	85	148	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
977	85	149	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
978	85	150	excused	Raison familiale	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
979	85	151	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
980	85	152	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
981	85	153	absent	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
982	85	154	excused	Blessure légère	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
983	85	155	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
984	85	156	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
985	85	157	absent	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
986	85	158	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
987	85	159	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
988	85	160	present	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
989	85	161	excused	Blessure légère	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
990	85	162	absent	\N	2026-11-23 16:10:13.204+00	2026-11-23 16:10:13.204+00
991	86	145	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
992	86	146	excused	Raison familiale	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
993	86	147	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
994	86	148	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
995	86	149	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
996	86	150	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
997	86	151	absent	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
998	86	152	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
999	86	153	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1000	86	154	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1001	86	155	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1002	86	156	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1003	86	157	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1004	86	158	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1005	86	159	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1006	86	160	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1007	86	161	excused	Raison familiale	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1008	86	162	present	\N	2026-11-23 16:10:13.212+00	2026-11-23 16:10:13.212+00
1009	87	145	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1010	87	146	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1011	87	147	excused	Examen	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1012	87	148	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1013	87	149	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1014	87	150	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1015	87	151	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1016	87	152	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1017	87	153	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1018	87	154	excused	Blessure légère	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1019	87	155	absent	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1020	87	156	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1021	87	157	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1022	87	158	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1023	87	159	absent	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1024	87	160	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1025	87	161	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1026	87	162	present	\N	2026-11-23 16:10:13.223+00	2026-11-23 16:10:13.223+00
1027	91	163	excused	Blessure légère	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1028	91	164	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1029	91	165	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1030	91	166	absent	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1031	91	167	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1032	91	168	excused	Blessure légère	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1033	91	169	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1034	91	170	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1035	91	171	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1036	91	172	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1037	91	173	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1038	91	174	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1039	91	175	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1040	91	176	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1041	91	177	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1042	91	178	excused	Examen	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1043	91	179	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1044	91	180	present	\N	2026-11-23 16:10:13.238+00	2026-11-23 16:10:13.238+00
1045	92	163	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1046	92	164	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1047	92	165	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1048	92	166	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1049	92	167	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1050	92	168	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1051	92	169	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1052	92	170	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1053	92	171	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1054	92	172	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1055	92	173	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1056	92	174	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1057	92	175	excused	Raison familiale	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1058	92	176	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1059	92	177	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1060	92	178	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1061	92	179	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1062	92	180	present	\N	2026-11-23 16:10:13.244+00	2026-11-23 16:10:13.244+00
1063	94	163	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1064	94	164	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1065	94	165	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1066	94	166	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1067	94	167	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1068	94	168	excused	Raison familiale	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1069	94	169	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1070	94	170	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1071	94	171	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1072	94	172	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1073	94	173	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1074	94	174	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1075	94	175	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1076	94	176	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1077	94	177	excused	Examen	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1078	94	178	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1079	94	179	present	\N	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1080	94	180	excused	Blessure légère	2026-11-23 16:10:13.254+00	2026-11-23 16:10:13.254+00
1081	95	163	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1082	95	164	excused	Raison familiale	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1083	95	165	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1084	95	166	excused	Raison familiale	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1085	95	167	excused	Blessure légère	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1086	95	168	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1087	95	169	absent	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1088	95	170	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1089	95	171	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1090	95	172	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1091	95	173	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1092	95	174	excused	Examen	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1093	95	175	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1094	95	176	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1095	95	177	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1096	95	178	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1097	95	179	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1098	95	180	present	\N	2026-11-23 16:10:13.26+00	2026-11-23 16:10:13.26+00
1099	96	163	excused	Examen	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1100	96	164	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1101	96	165	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1102	96	166	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1103	96	167	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1104	96	168	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1105	96	169	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1106	96	170	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1107	96	171	absent	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1108	96	172	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1109	96	173	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1110	96	174	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1111	96	175	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1112	96	176	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1113	96	177	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1114	96	178	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1115	96	179	absent	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1116	96	180	present	\N	2026-11-23 16:10:13.267+00	2026-11-23 16:10:13.267+00
1117	97	163	absent	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1118	97	164	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1119	97	165	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1120	97	166	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1121	97	167	excused	Blessure légère	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1122	97	168	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1123	97	169	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1124	97	170	excused	Blessure légère	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1125	97	171	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1126	97	172	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1127	97	173	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1128	97	174	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1129	97	175	absent	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1130	97	176	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1131	97	177	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1132	97	178	absent	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1133	97	179	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1134	97	180	present	\N	2026-11-23 16:10:13.272+00	2026-11-23 16:10:13.272+00
1135	101	181	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1136	101	182	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1137	101	183	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1138	101	184	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1139	101	185	excused	Examen	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1140	101	186	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1141	101	187	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1142	101	188	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1143	101	189	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1144	101	190	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1145	101	191	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1146	101	192	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1147	101	193	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1148	101	194	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1149	101	195	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1150	101	196	excused	Examen	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1151	101	197	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1152	101	198	present	\N	2026-11-23 16:10:13.289+00	2026-11-23 16:10:13.289+00
1153	102	181	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1154	102	182	excused	Raison familiale	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1155	102	183	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1156	102	184	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1157	102	185	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1158	102	186	absent	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1159	102	187	absent	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1160	102	188	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1161	102	189	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1162	102	190	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1163	102	191	absent	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1164	102	192	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1165	102	193	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1166	102	194	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1167	102	195	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1168	102	196	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1169	102	197	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1170	102	198	present	\N	2026-11-23 16:10:13.296+00	2026-11-23 16:10:13.296+00
1171	104	181	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1172	104	182	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1173	104	183	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1174	104	184	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1175	104	185	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1176	104	186	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1177	104	187	absent	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1178	104	188	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1179	104	189	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1180	104	190	excused	Raison familiale	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1181	104	191	absent	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1182	104	192	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1183	104	193	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1184	104	194	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1185	104	195	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1186	104	196	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1187	104	197	present	\N	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1188	104	198	excused	Raison familiale	2026-11-23 16:10:13.307+00	2026-11-23 16:10:13.307+00
1189	105	181	excused	Blessure légère	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1190	105	182	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1191	105	183	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1192	105	184	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1193	105	185	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1194	105	186	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1195	105	187	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1196	105	188	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1197	105	189	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1198	105	190	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1199	105	191	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1200	105	192	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1201	105	193	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1202	105	194	absent	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1203	105	195	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1204	105	196	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1205	105	197	excused	Raison familiale	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1206	105	198	present	\N	2026-11-23 16:10:13.313+00	2026-11-23 16:10:13.313+00
1207	106	181	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1208	106	182	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1209	106	183	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1210	106	184	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1211	106	185	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1212	106	186	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1213	106	187	excused	Blessure légère	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1214	106	188	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1215	106	189	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1216	106	190	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1217	106	191	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1218	106	192	excused	Blessure légère	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1219	106	193	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1220	106	194	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1221	106	195	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1222	106	196	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1223	106	197	absent	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1224	106	198	present	\N	2026-11-23 16:10:13.322+00	2026-11-23 16:10:13.322+00
1225	107	181	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1226	107	182	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1227	107	183	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1228	107	184	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1229	107	185	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1230	107	186	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1231	107	187	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1232	107	188	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1233	107	189	absent	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1234	107	190	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1235	107	191	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1236	107	192	excused	Examen	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1237	107	193	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1238	107	194	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1239	107	195	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1240	107	196	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1241	107	197	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1242	107	198	present	\N	2026-11-23 16:10:13.328+00	2026-11-23 16:10:13.328+00
1243	111	199	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1244	111	200	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1245	111	201	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1246	111	202	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1247	111	203	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1248	111	204	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1249	111	205	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1250	111	206	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1251	111	207	absent	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1252	111	208	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1253	111	209	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1254	111	210	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1255	111	211	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1256	111	212	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1257	111	213	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1258	111	214	excused	Raison familiale	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1259	111	215	present	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1260	111	216	absent	\N	2026-11-23 16:10:13.337+00	2026-11-23 16:10:13.337+00
1261	112	199	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1262	112	200	excused	Raison familiale	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1263	112	201	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1264	112	202	absent	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1265	112	203	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1266	112	204	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1267	112	205	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1268	112	206	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1269	112	207	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1270	112	208	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1271	112	209	absent	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1272	112	210	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1273	112	211	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1274	112	212	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1275	112	213	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1276	112	214	absent	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1277	112	215	present	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1278	112	216	absent	\N	2026-11-23 16:10:13.341+00	2026-11-23 16:10:13.341+00
1279	113	199	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1280	113	200	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1281	113	201	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1282	113	202	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1283	113	203	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1284	113	204	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1285	113	205	absent	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1286	113	206	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1287	113	207	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1288	113	208	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1289	113	209	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1290	113	210	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1291	113	211	excused	Blessure légère	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1292	113	212	absent	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1293	113	213	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1294	113	214	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1295	113	215	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1296	113	216	present	\N	2026-11-23 16:10:13.346+00	2026-11-23 16:10:13.346+00
1297	114	199	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1298	114	200	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1299	114	201	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1300	114	202	excused	Blessure légère	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1301	114	203	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1302	114	204	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1303	114	205	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1304	114	206	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1305	114	207	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1306	114	208	excused	Raison familiale	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1307	114	209	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1308	114	210	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1309	114	211	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1310	114	212	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1311	114	213	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1312	114	214	excused	Blessure légère	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1313	114	215	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1314	114	216	present	\N	2026-11-23 16:10:13.351+00	2026-11-23 16:10:13.351+00
1315	115	199	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1316	115	200	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1317	115	201	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1318	115	202	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1319	115	203	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1320	115	204	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1321	115	205	excused	Examen	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1322	115	206	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1323	115	207	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1324	115	208	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1325	115	209	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1326	115	210	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1327	115	211	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1328	115	212	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1329	115	213	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1330	115	214	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1331	115	215	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1332	115	216	present	\N	2026-11-23 16:10:13.359+00	2026-11-23 16:10:13.359+00
1333	116	199	absent	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1334	116	200	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1335	116	201	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1336	116	202	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1337	116	203	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1338	116	204	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1339	116	205	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1340	116	206	absent	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1341	116	207	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1342	116	208	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1343	116	209	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1344	116	210	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1345	116	211	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1346	116	212	absent	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1347	116	213	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1348	116	214	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1349	116	215	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1350	116	216	present	\N	2026-11-23 16:10:13.366+00	2026-11-23 16:10:13.366+00
1351	117	199	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1352	117	200	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1353	117	201	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1354	117	202	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1355	117	203	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1356	117	204	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1357	117	205	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1358	117	206	excused	Examen	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1359	117	207	absent	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1360	117	208	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1361	117	209	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1362	117	210	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1363	117	211	absent	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1364	117	212	excused	Examen	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1365	117	213	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1366	117	214	excused	Raison familiale	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1367	117	215	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1368	117	216	present	\N	2026-11-23 16:10:13.375+00	2026-11-23 16:10:13.375+00
1369	121	217	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1370	121	218	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1371	121	219	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1372	121	220	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1373	121	221	absent	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1374	121	222	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1375	121	223	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1376	121	224	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1377	121	225	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1378	121	226	excused	Examen	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1379	121	227	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1380	121	228	excused	Examen	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1381	121	229	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1382	121	230	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1383	121	231	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1384	121	232	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1385	121	233	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1386	121	234	present	\N	2026-11-23 16:10:13.386+00	2026-11-23 16:10:13.386+00
1387	123	217	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1388	123	218	excused	Examen	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1389	123	219	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1390	123	220	absent	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1391	123	221	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1392	123	222	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1393	123	223	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1394	123	224	absent	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1395	123	225	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1396	123	226	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1397	123	227	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1398	123	228	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1399	123	229	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1400	123	230	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1401	123	231	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1402	123	232	excused	Examen	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1403	123	233	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1404	123	234	present	\N	2026-11-23 16:10:13.392+00	2026-11-23 16:10:13.392+00
1405	124	217	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1406	124	218	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1407	124	219	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1408	124	220	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1409	124	221	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1410	124	222	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1411	124	223	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1412	124	224	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1413	124	225	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1414	124	226	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1415	124	227	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1416	124	228	excused	Blessure légère	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1417	124	229	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1418	124	230	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1419	124	231	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1420	124	232	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1421	124	233	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1422	124	234	present	\N	2026-11-23 16:10:13.401+00	2026-11-23 16:10:13.401+00
1423	126	217	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1424	126	218	excused	Blessure légère	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1425	126	219	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1426	126	220	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1427	126	221	absent	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1428	126	222	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1429	126	223	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1430	126	224	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1431	126	225	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1432	126	226	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1433	126	227	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1434	126	228	excused	Examen	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1435	126	229	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1436	126	230	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1437	126	231	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1438	126	232	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1439	126	233	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1440	126	234	present	\N	2026-11-23 16:10:13.411+00	2026-11-23 16:10:13.411+00
1441	127	217	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1442	127	218	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1443	127	219	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1444	127	220	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1445	127	221	absent	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1446	127	222	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1447	127	223	absent	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1448	127	224	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1449	127	225	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1450	127	226	absent	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1451	127	227	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1452	127	228	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1453	127	229	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1454	127	230	excused	Raison familiale	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1455	127	231	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1456	127	232	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1457	127	233	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1458	127	234	present	\N	2026-11-23 16:10:13.423+00	2026-11-23 16:10:13.423+00
1459	131	235	excused	Blessure légère	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1460	131	236	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1461	131	237	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1462	131	238	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1463	131	239	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1464	131	240	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1465	131	241	absent	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1466	131	242	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1467	131	243	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1468	131	244	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1469	131	245	excused	Blessure légère	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1470	131	246	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1471	131	247	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1472	131	248	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1473	131	249	absent	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1474	131	250	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1475	131	251	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1476	131	252	present	\N	2026-11-23 16:10:13.448+00	2026-11-23 16:10:13.448+00
1477	132	235	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1478	132	236	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1479	132	237	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1480	132	238	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1481	132	239	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1482	132	240	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1483	132	241	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1484	132	242	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1485	132	243	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1486	132	244	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1487	132	245	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1488	132	246	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1489	132	247	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1490	132	248	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1491	132	249	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1492	132	250	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1493	132	251	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1494	132	252	present	\N	2026-11-23 16:10:13.456+00	2026-11-23 16:10:13.456+00
1495	134	235	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1496	134	236	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1497	134	237	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1498	134	238	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1499	134	239	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1500	134	240	absent	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1501	134	241	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1502	134	242	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1503	134	243	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1504	134	244	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1505	134	245	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1506	134	246	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1507	134	247	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1508	134	248	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1509	134	249	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1510	134	250	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1511	134	251	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1512	134	252	present	\N	2026-11-23 16:10:13.468+00	2026-11-23 16:10:13.468+00
1513	135	235	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1514	135	236	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1515	135	237	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1516	135	238	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1517	135	239	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1518	135	240	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1519	135	241	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1520	135	242	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1521	135	243	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1522	135	244	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1523	135	245	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1524	135	246	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1525	135	247	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1526	135	248	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1527	135	249	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1528	135	250	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1529	135	251	present	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1530	135	252	absent	\N	2026-11-23 16:10:13.475+00	2026-11-23 16:10:13.475+00
1531	136	235	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1532	136	236	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1533	136	237	absent	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1534	136	238	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1535	136	239	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1536	136	240	excused	Raison familiale	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1537	136	241	absent	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1538	136	242	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1539	136	243	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1540	136	244	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1541	136	245	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1542	136	246	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1543	136	247	absent	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1544	136	248	absent	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1545	136	249	excused	Examen	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1546	136	250	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1547	136	251	present	\N	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1548	136	252	excused	Blessure légère	2026-11-23 16:10:13.48+00	2026-11-23 16:10:13.48+00
1549	137	235	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1550	137	236	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1551	137	237	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1552	137	238	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1553	137	239	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1554	137	240	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1555	137	241	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1556	137	242	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1557	137	243	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1558	137	244	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1559	137	245	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1560	137	246	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1561	137	247	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1562	137	248	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1563	137	249	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1564	137	250	present	\N	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1565	137	251	excused	Blessure légère	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1566	137	252	excused	Blessure légère	2026-11-23 16:10:13.486+00	2026-11-23 16:10:13.486+00
1567	141	253	excused	Examen	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1568	141	254	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1569	141	255	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1570	141	256	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1571	141	257	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1572	141	258	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1573	141	259	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1574	141	260	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1575	141	261	excused	Blessure légère	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1576	141	262	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1577	141	263	excused	Blessure légère	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1578	141	264	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1579	141	265	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1580	141	266	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1581	141	267	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1582	141	268	excused	Raison familiale	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1583	141	269	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1584	141	270	present	\N	2026-11-23 16:10:13.499+00	2026-11-23 16:10:13.499+00
1585	142	253	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1586	142	254	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1587	142	255	absent	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1588	142	256	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1589	142	257	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1590	142	258	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1591	142	259	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1592	142	260	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1593	142	261	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1594	142	262	excused	Raison familiale	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1595	142	263	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1596	142	264	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1597	142	265	absent	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1598	142	266	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1599	142	267	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1600	142	268	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1601	142	269	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1602	142	270	present	\N	2026-11-23 16:10:13.504+00	2026-11-23 16:10:13.504+00
1603	143	253	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1604	143	254	excused	Blessure légère	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1605	143	255	excused	Examen	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1606	143	256	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1607	143	257	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1608	143	258	absent	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1609	143	259	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1610	143	260	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1611	143	261	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1612	143	262	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1613	143	263	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1614	143	264	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1615	143	265	absent	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1616	143	266	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1617	143	267	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1618	143	268	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1619	143	269	present	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1620	143	270	absent	\N	2026-11-23 16:10:13.511+00	2026-11-23 16:10:13.511+00
1621	144	253	absent	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1622	144	254	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1623	144	255	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1624	144	256	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1625	144	257	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1626	144	258	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1627	144	259	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1628	144	260	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1629	144	261	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1630	144	262	excused	Raison familiale	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1631	144	263	absent	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1632	144	264	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1633	144	265	excused	Raison familiale	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1634	144	266	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1635	144	267	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1636	144	268	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1637	144	269	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1638	144	270	present	\N	2026-11-23 16:10:13.519+00	2026-11-23 16:10:13.519+00
1639	145	253	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1640	145	254	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1641	145	255	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1642	145	256	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1643	145	257	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1644	145	258	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1645	145	259	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1646	145	260	excused	Examen	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1647	145	261	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1648	145	262	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1649	145	263	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1650	145	264	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1651	145	265	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1652	145	266	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1653	145	267	absent	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1654	145	268	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1655	145	269	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1656	145	270	present	\N	2026-11-23 16:10:13.524+00	2026-11-23 16:10:13.524+00
1657	146	253	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1658	146	254	absent	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1659	146	255	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1660	146	256	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1661	146	257	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1662	146	258	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1663	146	259	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1664	146	260	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1665	146	261	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1666	146	262	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1667	146	263	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1668	146	264	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1669	146	265	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1670	146	266	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1671	146	267	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1672	146	268	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1673	146	269	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1674	146	270	present	\N	2026-11-23 16:10:13.53+00	2026-11-23 16:10:13.53+00
1675	147	253	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1676	147	254	absent	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1677	147	255	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1678	147	256	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1679	147	257	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1680	147	258	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1681	147	259	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1682	147	260	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1683	147	261	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1684	147	262	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1685	147	263	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1686	147	264	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1687	147	265	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1688	147	266	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1689	147	267	absent	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1690	147	268	present	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1691	147	269	absent	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1692	147	270	absent	\N	2026-11-23 16:10:13.536+00	2026-11-23 16:10:13.536+00
1693	151	271	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1694	151	272	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1695	151	273	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1696	151	274	excused	Blessure légère	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1697	151	275	excused	Examen	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1698	151	276	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1699	151	277	excused	Blessure légère	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1700	151	278	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1701	151	279	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1702	151	280	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1703	151	281	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1704	151	282	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1705	151	283	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1706	151	284	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1707	151	285	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1708	151	286	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1709	151	287	excused	Examen	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1710	151	288	present	\N	2026-11-23 16:10:13.546+00	2026-11-23 16:10:13.546+00
1711	152	271	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1712	152	272	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1713	152	273	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1714	152	274	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1715	152	275	absent	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1716	152	276	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1717	152	277	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1718	152	278	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1719	152	279	excused	Examen	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1720	152	280	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1721	152	281	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1722	152	282	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1723	152	283	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1724	152	284	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1725	152	285	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1726	152	286	absent	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1727	152	287	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1728	152	288	present	\N	2026-11-23 16:10:13.554+00	2026-11-23 16:10:13.554+00
1729	153	271	excused	Blessure légère	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1730	153	272	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1731	153	273	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1732	153	274	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1733	153	275	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1734	153	276	excused	Blessure légère	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1735	153	277	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1736	153	278	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1737	153	279	absent	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1738	153	280	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1739	153	281	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1740	153	282	absent	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1741	153	283	excused	Raison familiale	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1742	153	284	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1743	153	285	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1744	153	286	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1745	153	287	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1746	153	288	present	\N	2026-11-23 16:10:13.559+00	2026-11-23 16:10:13.559+00
1747	154	271	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1748	154	272	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1749	154	273	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1750	154	274	absent	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1751	154	275	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1752	154	276	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1753	154	277	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1754	154	278	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1755	154	279	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1756	154	280	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1757	154	281	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1758	154	282	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1759	154	283	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1760	154	284	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1761	154	285	excused	Blessure légère	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1762	154	286	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1763	154	287	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1764	154	288	present	\N	2026-11-23 16:10:13.563+00	2026-11-23 16:10:13.563+00
1765	155	271	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1766	155	272	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1767	155	273	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1768	155	274	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1769	155	275	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1770	155	276	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1771	155	277	absent	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1772	155	278	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1773	155	279	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1774	155	280	excused	Examen	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1775	155	281	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1776	155	282	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1777	155	283	excused	Raison familiale	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1778	155	284	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1779	155	285	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1780	155	286	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1781	155	287	present	\N	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1782	155	288	excused	Blessure légère	2026-11-23 16:10:13.57+00	2026-11-23 16:10:13.57+00
1783	156	271	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1784	156	272	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1785	156	273	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1786	156	274	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1787	156	275	absent	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1788	156	276	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1789	156	277	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1790	156	278	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1791	156	279	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1792	156	280	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1793	156	281	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1794	156	282	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1795	156	283	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1796	156	284	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1797	156	285	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1798	156	286	absent	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1799	156	287	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1800	156	288	present	\N	2026-11-23 16:10:13.576+00	2026-11-23 16:10:13.576+00
1801	157	271	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1802	157	272	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1803	157	273	excused	Examen	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1804	157	274	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1805	157	275	absent	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1806	157	276	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1807	157	277	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1808	157	278	excused	Raison familiale	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1809	157	279	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1810	157	280	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1811	157	281	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1812	157	282	absent	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1813	157	283	excused	Blessure légère	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1814	157	284	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1815	157	285	excused	Blessure légère	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1816	157	286	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1817	157	287	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
1818	157	288	present	\N	2026-11-23 16:10:13.581+00	2026-11-23 16:10:13.581+00
\.


--
-- Data for Name: TrainingSessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."TrainingSessions" (id, "teamId", "coachId", title, description, type, date, duration, location, status, notes, "createdAt", "updatedAt") FROM stdin;
1	1	2	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:12.726+00	90	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.726+00	2026-11-23 16:10:12.726+00
2	1	2	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:12.738+00	90	Stade Mohammed V	cancelled	\N	2026-11-23 16:10:12.738+00	2026-11-23 16:10:12.738+00
3	1	2	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:12.739+00	60	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.739+00	2026-11-23 16:10:12.739+00
4	1	2	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:12.743+00	105	Stade Mohammed V	cancelled	\N	2026-11-23 16:10:12.744+00	2026-11-23 16:10:12.744+00
5	1	2	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:12.745+00	60	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.745+00	2026-11-23 16:10:12.745+00
6	1	2	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:12.75+00	60	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.75+00	2026-11-23 16:10:12.75+00
7	1	2	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:12.758+00	90	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.758+00	2026-11-23 16:10:12.758+00
9	1	2	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:12.771+00	75	Stade Mohammed V	scheduled	\N	2026-11-23 16:10:12.771+00	2026-11-23 16:10:12.771+00
10	1	2	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:12.775+00	105	Stade Mohammed V	scheduled	\N	2026-11-23 16:10:12.775+00	2026-11-23 16:10:12.775+00
11	2	21	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:12.779+00	75	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.779+00	2026-11-23 16:10:12.779+00
12	2	21	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:12.789+00	90	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.789+00	2026-11-23 16:10:12.789+00
13	2	21	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:12.798+00	60	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.798+00	2026-11-23 16:10:12.798+00
14	2	21	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:12.809+00	105	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.809+00	2026-11-23 16:10:12.809+00
15	2	21	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:12.816+00	75	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.817+00	2026-11-23 16:10:12.817+00
16	2	21	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:12.823+00	60	Stade Père Jégo	completed	\N	2026-11-23 16:10:12.824+00	2026-11-23 16:10:12.824+00
17	2	21	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:12.832+00	90	Stade Père Jégo	cancelled	\N	2026-11-23 16:10:12.832+00	2026-11-23 16:10:12.832+00
18	2	21	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:12.834+00	60	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:12.834+00	2026-11-23 16:10:12.834+00
19	2	21	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:12.837+00	60	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:12.837+00	2026-11-23 16:10:12.837+00
20	2	21	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:12.839+00	105	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:12.839+00	2026-11-23 16:10:12.839+00
21	3	40	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:12.84+00	60	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.841+00	2026-11-23 16:10:12.841+00
22	3	40	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:12.847+00	90	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.847+00	2026-11-23 16:10:12.847+00
23	3	40	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:12.854+00	60	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.854+00	2026-11-23 16:10:12.854+00
24	3	40	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:12.862+00	90	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.862+00	2026-11-23 16:10:12.862+00
25	3	40	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:12.87+00	105	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.87+00	2026-11-23 16:10:12.87+00
26	3	40	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:12.879+00	60	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.879+00	2026-11-23 16:10:12.879+00
27	3	40	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:12.887+00	75	Complexe Al Amal	completed	\N	2026-11-23 16:10:12.888+00	2026-11-23 16:10:12.888+00
28	3	40	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:12.897+00	75	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:12.897+00	2026-11-23 16:10:12.897+00
29	3	40	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:12.899+00	90	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:12.899+00	2026-11-23 16:10:12.899+00
30	3	40	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:12.901+00	90	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:12.901+00	2026-11-23 16:10:12.901+00
31	4	59	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:12.902+00	105	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.902+00	2026-11-23 16:10:12.902+00
32	4	59	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:12.907+00	75	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.907+00	2026-11-23 16:10:12.907+00
33	4	59	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:12.914+00	60	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.914+00	2026-11-23 16:10:12.914+00
34	4	59	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:12.921+00	75	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.921+00	2026-11-23 16:10:12.921+00
35	4	59	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:12.928+00	75	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.928+00	2026-11-23 16:10:12.928+00
36	4	59	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:12.936+00	75	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.936+00	2026-11-23 16:10:12.936+00
37	4	59	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:12.942+00	90	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:12.942+00	2026-11-23 16:10:12.942+00
38	4	59	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:12.949+00	105	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:12.949+00	2026-11-23 16:10:12.949+00
39	4	59	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:12.952+00	60	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:12.952+00	2026-11-23 16:10:12.952+00
40	4	59	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:12.953+00	90	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:12.954+00	2026-11-23 16:10:12.954+00
41	5	78	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:12.955+00	60	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:12.955+00	2026-11-23 16:10:12.955+00
42	5	78	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:12.961+00	60	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:12.961+00	2026-11-23 16:10:12.961+00
43	5	78	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:12.969+00	75	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:12.969+00	2026-11-23 16:10:12.969+00
44	5	78	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:12.98+00	90	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:12.98+00	2026-11-23 16:10:12.98+00
45	5	78	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:12.994+00	105	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:12.994+00	2026-11-23 16:10:12.994+00
46	5	78	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.004+00	75	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.004+00	2026-11-23 16:10:13.004+00
47	5	78	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.013+00	105	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.014+00	2026-11-23 16:10:13.014+00
48	5	78	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.023+00	90	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.023+00	2026-11-23 16:10:13.023+00
49	5	78	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.025+00	75	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.025+00	2026-11-23 16:10:13.025+00
50	5	78	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.027+00	75	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.027+00	2026-11-23 16:10:13.027+00
51	6	97	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.029+00	60	Stade El Bachir	cancelled	\N	2026-11-23 16:10:13.029+00	2026-11-23 16:10:13.029+00
52	6	97	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.031+00	105	Stade El Bachir	completed	\N	2026-11-23 16:10:13.031+00	2026-11-23 16:10:13.031+00
53	6	97	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.037+00	90	Stade El Bachir	completed	\N	2026-11-23 16:10:13.037+00	2026-11-23 16:10:13.037+00
54	6	97	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.043+00	75	Stade El Bachir	completed	\N	2026-11-23 16:10:13.044+00	2026-11-23 16:10:13.044+00
55	6	97	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.049+00	60	Stade El Bachir	completed	\N	2026-11-23 16:10:13.049+00	2026-11-23 16:10:13.049+00
56	6	97	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.055+00	75	Stade El Bachir	completed	\N	2026-11-23 16:10:13.055+00	2026-11-23 16:10:13.055+00
57	6	97	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.06+00	105	Stade El Bachir	completed	\N	2026-11-23 16:10:13.06+00	2026-11-23 16:10:13.06+00
58	6	97	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.066+00	75	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.066+00	2026-11-23 16:10:13.066+00
59	6	97	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.068+00	90	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.069+00	2026-11-23 16:10:13.069+00
60	6	97	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.07+00	60	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.071+00	2026-11-23 16:10:13.071+00
61	7	116	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.073+00	90	Complexe Oasis	completed	\N	2026-11-23 16:10:13.073+00	2026-11-23 16:10:13.073+00
62	7	116	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.081+00	105	Complexe Oasis	completed	\N	2026-11-23 16:10:13.081+00	2026-11-23 16:10:13.081+00
63	7	116	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.092+00	105	Complexe Oasis	completed	\N	2026-11-23 16:10:13.092+00	2026-11-23 16:10:13.092+00
64	7	116	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.102+00	60	Complexe Oasis	completed	\N	2026-11-23 16:10:13.102+00	2026-11-23 16:10:13.102+00
65	7	116	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.108+00	90	Complexe Oasis	completed	\N	2026-11-23 16:10:13.108+00	2026-11-23 16:10:13.108+00
66	7	116	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.114+00	105	Complexe Oasis	completed	\N	2026-11-23 16:10:13.114+00	2026-11-23 16:10:13.114+00
67	7	116	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.122+00	60	Complexe Oasis	completed	\N	2026-11-23 16:10:13.122+00	2026-11-23 16:10:13.122+00
68	7	116	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.127+00	105	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.127+00	2026-11-23 16:10:13.127+00
69	7	116	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.129+00	60	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.129+00	2026-11-23 16:10:13.129+00
70	7	116	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.13+00	75	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.13+00	2026-11-23 16:10:13.13+00
71	8	135	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.131+00	90	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.131+00	2026-11-23 16:10:13.131+00
72	8	135	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.136+00	60	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.136+00	2026-11-23 16:10:13.136+00
73	8	135	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.14+00	60	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.14+00	2026-11-23 16:10:13.14+00
74	8	135	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.145+00	75	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.145+00	2026-11-23 16:10:13.145+00
75	8	135	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.151+00	75	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.152+00	2026-11-23 16:10:13.152+00
76	8	135	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.16+00	105	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.16+00	2026-11-23 16:10:13.16+00
77	8	135	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.167+00	105	Stade Ain Chock	cancelled	\N	2026-11-23 16:10:13.167+00	2026-11-23 16:10:13.167+00
78	8	135	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.169+00	105	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.169+00	2026-11-23 16:10:13.169+00
79	8	135	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.171+00	105	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.171+00	2026-11-23 16:10:13.171+00
80	8	135	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.173+00	90	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.173+00	2026-11-23 16:10:13.173+00
81	9	154	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.175+00	105	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.175+00	2026-11-23 16:10:13.175+00
82	9	154	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.179+00	75	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.179+00	2026-11-23 16:10:13.179+00
83	9	154	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.188+00	60	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.188+00	2026-11-23 16:10:13.188+00
84	9	154	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.195+00	75	Stade Mohammed V	cancelled	\N	2026-11-23 16:10:13.195+00	2026-11-23 16:10:13.195+00
85	9	154	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.199+00	90	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.199+00	2026-11-23 16:10:13.199+00
86	9	154	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.209+00	90	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.209+00	2026-11-23 16:10:13.209+00
87	9	154	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.219+00	75	Stade Mohammed V	completed	\N	2026-11-23 16:10:13.219+00	2026-11-23 16:10:13.219+00
88	9	154	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.228+00	105	Stade Mohammed V	scheduled	\N	2026-11-23 16:10:13.228+00	2026-11-23 16:10:13.228+00
89	9	154	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.232+00	75	Stade Mohammed V	scheduled	\N	2026-11-23 16:10:13.232+00	2026-11-23 16:10:13.232+00
90	9	154	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.234+00	75	Stade Mohammed V	scheduled	\N	2026-11-23 16:10:13.234+00	2026-11-23 16:10:13.234+00
91	10	173	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.236+00	90	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.236+00	2026-11-23 16:10:13.236+00
92	10	173	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.242+00	75	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.242+00	2026-11-23 16:10:13.242+00
93	10	173	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.248+00	60	Stade Père Jégo	cancelled	\N	2026-11-23 16:10:13.248+00	2026-11-23 16:10:13.248+00
94	10	173	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.251+00	60	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.251+00	2026-11-23 16:10:13.251+00
95	10	173	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.258+00	75	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.258+00	2026-11-23 16:10:13.258+00
96	10	173	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.265+00	60	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.265+00	2026-11-23 16:10:13.265+00
97	10	173	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.27+00	60	Stade Père Jégo	completed	\N	2026-11-23 16:10:13.27+00	2026-11-23 16:10:13.27+00
98	10	173	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.277+00	105	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:13.277+00	2026-11-23 16:10:13.277+00
99	10	173	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.279+00	75	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:13.279+00	2026-11-23 16:10:13.279+00
100	10	173	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.283+00	60	Stade Père Jégo	scheduled	\N	2026-11-23 16:10:13.283+00	2026-11-23 16:10:13.283+00
101	11	192	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.287+00	75	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.287+00	2026-11-23 16:10:13.287+00
102	11	192	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.293+00	75	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.294+00	2026-11-23 16:10:13.294+00
103	11	192	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.3+00	90	Complexe Al Amal	cancelled	\N	2026-11-23 16:10:13.3+00	2026-11-23 16:10:13.3+00
104	11	192	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.304+00	75	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.304+00	2026-11-23 16:10:13.304+00
105	11	192	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.31+00	60	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.311+00	2026-11-23 16:10:13.311+00
106	11	192	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.319+00	90	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.319+00	2026-11-23 16:10:13.319+00
107	11	192	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.326+00	60	Complexe Al Amal	completed	\N	2026-11-23 16:10:13.326+00	2026-11-23 16:10:13.326+00
108	11	192	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.331+00	105	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:13.332+00	2026-11-23 16:10:13.332+00
109	11	192	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.333+00	75	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:13.333+00	2026-11-23 16:10:13.333+00
110	11	192	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.334+00	105	Complexe Al Amal	scheduled	\N	2026-11-23 16:10:13.334+00	2026-11-23 16:10:13.334+00
111	12	211	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.335+00	90	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.335+00	2026-11-23 16:10:13.335+00
112	12	211	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.34+00	90	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.34+00	2026-11-23 16:10:13.34+00
113	12	211	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.344+00	60	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.344+00	2026-11-23 16:10:13.344+00
114	12	211	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.349+00	60	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.35+00	2026-11-23 16:10:13.35+00
115	12	211	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.356+00	90	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.356+00	2026-11-23 16:10:13.356+00
116	12	211	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.364+00	105	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.364+00	2026-11-23 16:10:13.364+00
117	12	211	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.372+00	60	Stade Larbi Zaouli	completed	\N	2026-11-23 16:10:13.372+00	2026-11-23 16:10:13.372+00
118	12	211	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.378+00	60	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:13.378+00	2026-11-23 16:10:13.378+00
119	12	211	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.38+00	60	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:13.38+00	2026-11-23 16:10:13.38+00
120	12	211	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.382+00	75	Stade Larbi Zaouli	scheduled	\N	2026-11-23 16:10:13.382+00	2026-11-23 16:10:13.382+00
121	13	230	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.384+00	90	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.384+00	2026-11-23 16:10:13.384+00
122	13	230	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.389+00	90	Terrain Sidi Moumen	cancelled	\N	2026-11-23 16:10:13.389+00	2026-11-23 16:10:13.389+00
123	13	230	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.391+00	60	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.391+00	2026-11-23 16:10:13.391+00
124	13	230	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.398+00	75	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.398+00	2026-11-23 16:10:13.398+00
125	13	230	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.406+00	60	Terrain Sidi Moumen	cancelled	\N	2026-11-23 16:10:13.406+00	2026-11-23 16:10:13.406+00
126	13	230	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.409+00	90	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.409+00	2026-11-23 16:10:13.409+00
127	13	230	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.417+00	75	Terrain Sidi Moumen	completed	\N	2026-11-23 16:10:13.417+00	2026-11-23 16:10:13.417+00
128	13	230	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.433+00	75	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.433+00	2026-11-23 16:10:13.433+00
129	13	230	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.435+00	60	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.435+00	2026-11-23 16:10:13.435+00
130	13	230	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.441+00	90	Terrain Sidi Moumen	scheduled	\N	2026-11-23 16:10:13.441+00	2026-11-23 16:10:13.441+00
131	14	249	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.444+00	90	Stade El Bachir	completed	\N	2026-11-23 16:10:13.444+00	2026-11-23 16:10:13.444+00
132	14	249	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.454+00	75	Stade El Bachir	completed	\N	2026-11-23 16:10:13.454+00	2026-11-23 16:10:13.454+00
133	14	249	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.462+00	90	Stade El Bachir	cancelled	\N	2026-11-23 16:10:13.462+00	2026-11-23 16:10:13.462+00
134	14	249	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.464+00	60	Stade El Bachir	completed	\N	2026-11-23 16:10:13.464+00	2026-11-23 16:10:13.464+00
135	14	249	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.473+00	90	Stade El Bachir	completed	\N	2026-11-23 16:10:13.473+00	2026-11-23 16:10:13.473+00
136	14	249	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.478+00	90	Stade El Bachir	completed	\N	2026-11-23 16:10:13.478+00	2026-11-23 16:10:13.478+00
137	14	249	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.484+00	60	Stade El Bachir	completed	\N	2026-11-23 16:10:13.484+00	2026-11-23 16:10:13.484+00
138	14	249	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.49+00	105	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.49+00	2026-11-23 16:10:13.49+00
139	14	249	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.493+00	105	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.493+00	2026-11-23 16:10:13.493+00
140	14	249	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.495+00	90	Stade El Bachir	scheduled	\N	2026-11-23 16:10:13.495+00	2026-11-23 16:10:13.495+00
141	15	268	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.497+00	60	Complexe Oasis	completed	\N	2026-11-23 16:10:13.498+00	2026-11-23 16:10:13.498+00
142	15	268	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.502+00	90	Complexe Oasis	completed	\N	2026-11-23 16:10:13.502+00	2026-11-23 16:10:13.502+00
143	15	268	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.508+00	60	Complexe Oasis	completed	\N	2026-11-23 16:10:13.508+00	2026-11-23 16:10:13.508+00
144	15	268	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.517+00	60	Complexe Oasis	completed	\N	2026-11-23 16:10:13.517+00	2026-11-23 16:10:13.517+00
145	15	268	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.523+00	105	Complexe Oasis	completed	\N	2026-11-23 16:10:13.523+00	2026-11-23 16:10:13.523+00
146	15	268	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.528+00	90	Complexe Oasis	completed	\N	2026-11-23 16:10:13.528+00	2026-11-23 16:10:13.528+00
147	15	268	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.534+00	75	Complexe Oasis	completed	\N	2026-11-23 16:10:13.534+00	2026-11-23 16:10:13.534+00
148	15	268	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.54+00	60	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.54+00	2026-11-23 16:10:13.54+00
149	15	268	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.542+00	90	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.542+00	2026-11-23 16:10:13.542+00
150	15	268	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.544+00	90	Complexe Oasis	scheduled	\N	2026-11-23 16:10:13.544+00	2026-11-23 16:10:13.544+00
151	16	287	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-02 16:10:13.545+00	105	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.545+00	2026-11-23 16:10:13.545+00
152	16	287	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-05 16:10:13.55+00	60	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.55+00	2026-11-23 16:10:13.55+00
153	16	287	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-08 16:10:13.557+00	105	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.557+00	2026-11-23 16:10:13.557+00
154	16	287	Match d'application	Séance match — match d'application.	match	2026-11-11 16:10:13.562+00	105	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.562+00	2026-11-23 16:10:13.562+00
155	16	287	Coups de pied arrêtés	Séance tactique — coups de pied arrêtés.	tactique	2026-11-14 16:10:13.568+00	75	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.568+00	2026-11-23 16:10:13.568+00
156	16	287	Finition devant le but	Séance technique — finition devant le but.	technique	2026-11-17 16:10:13.573+00	75	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.574+00	2026-11-23 16:10:13.574+00
157	16	287	Conservation et jeu court	Séance technique — conservation et jeu court.	technique	2026-11-20 16:10:13.579+00	60	Stade Ain Chock	completed	\N	2026-11-23 16:10:13.579+00	2026-11-23 16:10:13.579+00
158	16	287	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:13.585+00	105	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.585+00	2026-11-23 16:10:13.585+00
159	16	287	Endurance et fractionné	Séance physique — endurance et fractionné.	physique	2026-11-27 16:10:13.587+00	105	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.587+00	2026-11-23 16:10:13.587+00
160	16	287	Match d'application	Séance match — match d'application.	match	2026-11-29 16:10:13.588+00	90	Stade Ain Chock	scheduled	\N	2026-11-23 16:10:13.588+00	2026-11-23 16:10:13.588+00
8	1	2	Pressing haut	Séance tactique — pressing haut.	tactique	2026-11-25 16:10:12.767+00	105	Stade Mohammed V	completed	\N	2026-11-23 16:10:12.767+00	2026-11-24 09:28:44.337+00
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Users" (id, email, password, name, role, phone, "teamId", "isActive", "fcmToken", "createdAt", "updatedAt") FROM stdin;
306	arbitre.test@footpro.com	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Karim Arbitre	arbitre	+212661000000	\N	t	\N	2026-11-23 16:33:25.341+00	2026-11-23 16:33:25.341+00
307	redouane.jiyed@footpro.ma	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Redouane Jiyed	arbitre	+212661000001	\N	t	\N	2026-11-23 16:33:25.358+00	2026-11-23 16:33:25.358+00
308	samir.guezzaz@footpro.ma	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Samir Guezzaz	arbitre	+212661000002	\N	t	\N	2026-11-23 16:33:25.365+00	2026-11-23 16:33:25.365+00
309	noureddine.eljaafari@footpro.ma	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Noureddine El Jaafari	arbitre	+212661000003	\N	t	\N	2026-11-23 16:33:25.371+00	2026-11-23 16:33:25.371+00
310	bouchra.karboubi@footpro.ma	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Bouchra Karboubi	arbitre	+212661000004	\N	t	\N	2026-11-23 16:33:25.379+00	2026-11-23 16:33:25.379+00
311	mustapha.kechchaf@footpro.ma	$2a$10$baYE5t0HXMYzqK8JIt0.zuZwSoK1ZXleZ0kdiGqthTckjlM4GFO2C	Mustapha Kechchaf	arbitre	+212661000005	\N	t	\N	2026-11-23 16:33:25.385+00	2026-11-23 16:33:25.385+00
1	admin@gmail.com	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Administrateur FootPro	admin	+212600000000	\N	t	\N	2026-11-23 16:10:07.41+00	2026-11-23 17:51:45.527+00
3	player@gmail.com	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Tazi	joueur	+212610000002	\N	t	\N	2026-11-23 16:10:07.476+00	2026-11-24 10:12:20.28+00
2	coach@gmail.com	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub Ait Ali	coach	+212610000001	1	t	\N	2026-11-23 16:10:07.466+00	2026-11-24 10:12:35.604+00
4	salah.ouazzani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Ouazzani	joueur	+212610000003	\N	t	\N	2026-11-23 16:10:07.492+00	2026-11-23 16:14:32.566+00
5	karim.ounahi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Ounahi	joueur	+212610000004	\N	t	\N	2026-11-23 16:10:07.499+00	2026-11-23 16:14:32.566+00
6	hamza.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Boufal	joueur	+212610000005	\N	t	\N	2026-11-23 16:10:07.506+00	2026-11-23 16:14:32.566+00
7	amine.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Rahimi	joueur	+212610000006	\N	t	\N	2026-11-23 16:10:07.51+00	2026-11-23 16:14:32.566+00
8	yassine.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Yassine El Idrissi	joueur	+212610000007	\N	t	\N	2026-11-23 16:10:07.517+00	2026-11-23 16:14:32.566+00
9	walid.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Rahimi	joueur	+212610000008	\N	t	\N	2026-11-23 16:10:07.524+00	2026-11-23 16:14:32.566+00
10	soufiane.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Soufiane Tazi	joueur	+212610000009	\N	t	\N	2026-11-23 16:10:07.533+00	2026-11-23 16:14:32.566+00
11	said.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Boufal	joueur	+212610000010	\N	t	\N	2026-11-23 16:10:07.539+00	2026-11-23 16:14:32.566+00
12	zakaria.el.khattabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria El Khattabi	joueur	+212610000011	\N	t	\N	2026-11-23 16:10:07.545+00	2026-11-23 16:14:32.566+00
13	tarik.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Seddiki	joueur	+212610000012	\N	t	\N	2026-11-23 16:10:07.551+00	2026-11-23 16:14:32.566+00
14	khalid.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid El Amrani	joueur	+212610000013	\N	t	\N	2026-11-23 16:10:07.555+00	2026-11-23 16:14:32.566+00
15	driss.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss El Kaabi	joueur	+212610000014	\N	t	\N	2026-11-23 16:10:07.559+00	2026-11-23 16:14:32.566+00
16	yassine.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Yassine Mazraoui	joueur	+212610000015	\N	t	\N	2026-11-23 16:10:07.563+00	2026-11-23 16:14:32.566+00
17	hicham.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Kettani	joueur	+212610000016	\N	t	\N	2026-11-23 16:10:07.569+00	2026-11-23 16:14:32.566+00
18	tarik.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Harit	joueur	+212610000017	\N	t	\N	2026-11-23 16:10:07.573+00	2026-11-23 16:14:32.566+00
19	taha.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Moutaouakil	joueur	+212610000018	\N	t	\N	2026-11-23 16:10:07.579+00	2026-11-23 16:14:32.566+00
20	hakim.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Benoun	joueur	+212610000019	\N	t	\N	2026-11-23 16:10:07.585+00	2026-11-23 16:14:32.566+00
21	coach.rca@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Kettani	coach	+212610000020	2	t	\N	2026-11-23 16:10:07.594+00	2026-11-23 16:14:32.566+00
22	anas.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Jabrane	joueur	+212610000021	\N	t	\N	2026-11-23 16:10:07.598+00	2026-11-23 16:14:32.566+00
23	imad.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Imad Bouzidi	joueur	+212610000022	\N	t	\N	2026-11-23 16:10:07.605+00	2026-11-23 16:14:32.566+00
24	hicham.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Berrada	joueur	+212610000023	\N	t	\N	2026-11-23 16:10:07.608+00	2026-11-23 16:14:32.566+00
25	khalid.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Aguerd	joueur	+212610000024	\N	t	\N	2026-11-23 16:10:07.612+00	2026-11-23 16:14:32.566+00
26	abdelali.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Fassi	joueur	+212610000025	\N	t	\N	2026-11-23 16:10:07.621+00	2026-11-23 16:14:32.566+00
27	soufiane.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Soufiane Mazraoui	joueur	+212610000026	\N	t	\N	2026-11-23 16:10:07.63+00	2026-11-23 16:14:32.566+00
28	rachid.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Aguerd	joueur	+212610000027	\N	t	\N	2026-11-23 16:10:07.639+00	2026-11-23 16:14:32.566+00
29	adil.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Chraibi	joueur	+212610000028	\N	t	\N	2026-11-23 16:10:07.651+00	2026-11-23 16:14:32.566+00
30	abdelali.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Jabrane	joueur	+212610000029	\N	t	\N	2026-11-23 16:10:07.664+00	2026-11-23 16:14:32.566+00
31	taha.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Alaoui	joueur	+212610000030	\N	t	\N	2026-11-23 16:10:07.673+00	2026-11-23 16:14:32.566+00
32	rachid.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Ouchen	joueur	+212610000031	\N	t	\N	2026-11-23 16:10:07.683+00	2026-11-23 16:14:32.566+00
33	fouad.hakimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Hakimi	joueur	+212610000032	\N	t	\N	2026-11-23 16:10:07.693+00	2026-11-23 16:14:32.566+00
34	mounir.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Boufal	joueur	+212610000033	\N	t	\N	2026-11-23 16:10:07.698+00	2026-11-23 16:14:32.566+00
35	jawad.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Alaoui	joueur	+212610000034	\N	t	\N	2026-11-23 16:10:07.704+00	2026-11-23 16:14:32.566+00
36	achraf.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Achraf Ziani	joueur	+212610000035	\N	t	\N	2026-11-23 16:10:07.713+00	2026-11-23 16:14:32.566+00
37	youssef.bennani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Bennani	joueur	+212610000036	\N	t	\N	2026-11-23 16:10:07.719+00	2026-11-23 16:14:32.566+00
38	amine.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Alaoui	joueur	+212610000037	\N	t	\N	2026-11-23 16:10:07.724+00	2026-11-23 16:14:32.566+00
39	ilyas.saiss@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Saiss	joueur	+212610000038	\N	t	\N	2026-11-23 16:10:07.729+00	2026-11-23 16:14:32.566+00
40	coach.aslm@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Harit	coach	+212610000039	3	t	\N	2026-11-23 16:10:07.736+00	2026-11-23 16:14:32.566+00
41	ismail.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail El Idrissi	joueur	+212610000040	\N	t	\N	2026-11-23 16:10:07.741+00	2026-11-23 16:14:32.566+00
42	taha.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Jabrane	joueur	+212610000041	\N	t	\N	2026-11-23 16:10:07.747+00	2026-11-23 16:14:32.566+00
43	driss.el.khattabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss El Khattabi	joueur	+212610000042	\N	t	\N	2026-11-23 16:10:07.758+00	2026-11-23 16:14:32.566+00
44	hamza.benali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Benali	joueur	+212610000043	\N	t	\N	2026-11-23 16:10:07.762+00	2026-11-23 16:14:32.566+00
45	rachid.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid El Idrissi	joueur	+212610000044	\N	t	\N	2026-11-23 16:10:07.768+00	2026-11-23 16:14:32.566+00
46	karim.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Chraibi	joueur	+212610000045	\N	t	\N	2026-11-23 16:10:07.774+00	2026-11-23 16:14:32.566+00
47	said.boufal2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Boufal	joueur	+212610000046	\N	t	\N	2026-11-23 16:10:07.779+00	2026-11-23 16:14:32.566+00
48	karim.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Benoun	joueur	+212610000047	\N	t	\N	2026-11-23 16:10:07.785+00	2026-11-23 16:14:32.566+00
49	hamza.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza El Idrissi	joueur	+212610000048	\N	t	\N	2026-11-23 16:10:07.789+00	2026-11-23 16:14:32.566+00
50	mehdi.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Tazi	joueur	+212610000049	\N	t	\N	2026-11-23 16:10:07.794+00	2026-11-23 16:14:32.566+00
51	salah.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah El Amrani	joueur	+212610000050	\N	t	\N	2026-11-23 16:10:07.801+00	2026-11-23 16:14:32.566+00
52	mohamed.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed Ziani	joueur	+212610000051	\N	t	\N	2026-11-23 16:10:07.807+00	2026-11-23 16:14:32.566+00
53	amine.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Ait Ali	joueur	+212610000052	\N	t	\N	2026-11-23 16:10:07.811+00	2026-11-23 16:14:32.566+00
54	nabil.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil El Kaabi	joueur	+212610000053	\N	t	\N	2026-11-23 16:10:07.815+00	2026-11-23 16:14:32.566+00
55	ilyas.sqalli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Sqalli	joueur	+212610000054	\N	t	\N	2026-11-23 16:10:07.82+00	2026-11-23 16:14:32.566+00
56	taha.sqalli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Sqalli	joueur	+212610000055	\N	t	\N	2026-11-23 16:10:07.824+00	2026-11-23 16:14:32.566+00
57	nabil.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Berrada	joueur	+212610000056	\N	t	\N	2026-11-23 16:10:07.829+00	2026-11-23 16:14:32.566+00
58	driss.ezzalzouli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss Ezzalzouli	joueur	+212610000057	\N	t	\N	2026-11-23 16:10:07.834+00	2026-11-23 16:14:32.566+00
59	coach.sccm@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Mansouri	coach	+212610000058	4	t	\N	2026-11-23 16:10:07.842+00	2026-11-23 16:14:32.566+00
60	jawad.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Ouchen	joueur	+212610000059	\N	t	\N	2026-11-23 16:10:07.85+00	2026-11-23 16:14:32.566+00
61	badr.belhaj@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Belhaj	joueur	+212610000060	\N	t	\N	2026-11-23 16:10:07.865+00	2026-11-23 16:14:32.566+00
62	salah.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Jabrane	joueur	+212610000061	\N	t	\N	2026-11-23 16:10:07.873+00	2026-11-23 16:14:32.566+00
63	fouad.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Chraibi	joueur	+212610000062	\N	t	\N	2026-11-23 16:10:07.882+00	2026-11-23 16:14:32.566+00
64	khalid.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Benoun	joueur	+212610000063	\N	t	\N	2026-11-23 16:10:07.888+00	2026-11-23 16:14:32.566+00
65	karim.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Moutaouakil	joueur	+212610000064	\N	t	\N	2026-11-23 16:10:07.892+00	2026-11-23 16:14:32.566+00
66	mohamed.lahlou@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed Lahlou	joueur	+212610000065	\N	t	\N	2026-11-23 16:10:07.895+00	2026-11-23 16:14:32.566+00
67	nassim.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Alaoui	joueur	+212610000066	\N	t	\N	2026-11-23 16:10:07.9+00	2026-11-23 16:14:32.566+00
68	hicham.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Fassi	joueur	+212610000067	\N	t	\N	2026-11-23 16:10:07.904+00	2026-11-23 16:14:32.566+00
69	mehdi.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Ziani	joueur	+212610000068	\N	t	\N	2026-11-23 16:10:07.908+00	2026-11-23 16:14:32.566+00
70	bilal.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Bilal Naciri	joueur	+212610000069	\N	t	\N	2026-11-23 16:10:07.913+00	2026-11-23 16:14:32.566+00
71	salah.benali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Benali	joueur	+212610000070	\N	t	\N	2026-11-23 16:10:07.919+00	2026-11-23 16:14:32.566+00
72	jawad.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Mazraoui	joueur	+212610000071	\N	t	\N	2026-11-23 16:10:07.926+00	2026-11-23 16:14:32.566+00
73	badr.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Ait Ali	joueur	+212610000072	\N	t	\N	2026-11-23 16:10:07.935+00	2026-11-23 16:14:32.566+00
74	achraf.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Achraf El Kaabi	joueur	+212610000073	\N	t	\N	2026-11-23 16:10:07.941+00	2026-11-23 16:14:32.566+00
75	amine.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Ziani	joueur	+212610000074	\N	t	\N	2026-11-23 16:10:07.946+00	2026-11-23 16:14:32.566+00
76	mounir.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Moutaouakil	joueur	+212610000075	\N	t	\N	2026-11-23 16:10:07.952+00	2026-11-23 16:14:32.566+00
77	said.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Ouchen	joueur	+212610000076	\N	t	\N	2026-11-23 16:10:07.962+00	2026-11-23 16:14:32.566+00
78	coach.usm@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Sqalli	coach	+212610000077	5	t	\N	2026-11-23 16:10:07.972+00	2026-11-23 16:14:32.566+00
79	taha.saiss@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Saiss	joueur	+212610000078	\N	t	\N	2026-11-23 16:10:07.976+00	2026-11-23 16:14:32.566+00
80	nassim.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Mazraoui	joueur	+212610000079	\N	t	\N	2026-11-23 16:10:07.982+00	2026-11-23 16:14:32.566+00
81	said.rami@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Rami	joueur	+212610000080	\N	t	\N	2026-11-23 16:10:07.987+00	2026-11-23 16:14:32.566+00
82	achraf.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Achraf Harit	joueur	+212610000081	\N	t	\N	2026-11-23 16:10:07.993+00	2026-11-23 16:14:32.566+00
83	hamza.boufal2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Boufal	joueur	+212610000082	\N	t	\N	2026-11-23 16:10:07.998+00	2026-11-23 16:14:32.566+00
84	said.ounahi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Ounahi	joueur	+212610000083	\N	t	\N	2026-11-23 16:10:08.004+00	2026-11-23 16:14:32.566+00
85	othmane.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane El Kaabi	joueur	+212610000084	\N	t	\N	2026-11-23 16:10:08.011+00	2026-11-23 16:14:32.566+00
86	bilal.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Bilal Ouchen	joueur	+212610000085	\N	t	\N	2026-11-23 16:10:08.018+00	2026-11-23 16:14:32.566+00
87	tarik.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Jabrane	joueur	+212610000086	\N	t	\N	2026-11-23 16:10:08.026+00	2026-11-23 16:14:32.566+00
88	fouad.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Boufal	joueur	+212610000087	\N	t	\N	2026-11-23 16:10:08.032+00	2026-11-23 16:14:32.566+00
89	salah.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Amallah	joueur	+212610000088	\N	t	\N	2026-11-23 16:10:08.037+00	2026-11-23 16:14:32.566+00
90	mehdi.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Kettani	joueur	+212610000089	\N	t	\N	2026-11-23 16:10:08.04+00	2026-11-23 16:14:32.566+00
91	abdelali.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Harit	joueur	+212610000090	\N	t	\N	2026-11-23 16:10:08.044+00	2026-11-23 16:14:32.566+00
92	soufiane.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Soufiane Ait Ali	joueur	+212610000091	\N	t	\N	2026-11-23 16:10:08.049+00	2026-11-23 16:14:32.566+00
93	salah.ounahi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Ounahi	joueur	+212610000092	\N	t	\N	2026-11-23 16:10:08.057+00	2026-11-23 16:14:32.566+00
94	jawad.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Amallah	joueur	+212610000093	\N	t	\N	2026-11-23 16:10:08.066+00	2026-11-23 16:14:32.566+00
95	nabil.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Zerouali	joueur	+212610000094	\N	t	\N	2026-11-23 16:10:08.077+00	2026-11-23 16:14:32.566+00
96	walid.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Tazi	joueur	+212610000095	\N	t	\N	2026-11-23 16:10:08.087+00	2026-11-23 16:14:32.566+00
97	coach.tas@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Mansouri	coach	+212610000096	6	t	\N	2026-11-23 16:10:08.103+00	2026-11-23 16:14:32.566+00
98	othmane.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane Boufal	joueur	+212610000097	\N	t	\N	2026-11-23 16:10:08.107+00	2026-11-23 16:14:32.566+00
99	ilyas.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Alaoui	joueur	+212610000098	\N	t	\N	2026-11-23 16:10:08.113+00	2026-11-23 16:14:32.566+00
100	abdelali.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali El Idrissi	joueur	+212610000099	\N	t	\N	2026-11-23 16:10:08.121+00	2026-11-23 16:14:32.566+00
101	khalid.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Kettani	joueur	+212610000100	\N	t	\N	2026-11-23 16:10:08.127+00	2026-11-23 16:14:32.566+00
102	omar.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Ziani	joueur	+212610000101	\N	t	\N	2026-11-23 16:10:08.133+00	2026-11-23 16:14:32.566+00
103	soufiane.tazi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Soufiane Tazi	joueur	+212610000102	\N	t	\N	2026-11-23 16:10:08.14+00	2026-11-23 16:14:32.566+00
104	mohamed.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed Bouzidi	joueur	+212610000103	\N	t	\N	2026-11-23 16:10:08.149+00	2026-11-23 16:14:32.566+00
105	zakaria.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Bouzidi	joueur	+212610000104	\N	t	\N	2026-11-23 16:10:08.159+00	2026-11-23 16:14:32.566+00
106	driss.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss Aguerd	joueur	+212610000105	\N	t	\N	2026-11-23 16:10:08.164+00	2026-11-23 16:14:32.566+00
107	abdelali.harit2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Harit	joueur	+212610000106	\N	t	\N	2026-11-23 16:10:08.174+00	2026-11-23 16:14:32.566+00
108	adil.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Berrada	joueur	+212610000107	\N	t	\N	2026-11-23 16:10:08.181+00	2026-11-23 16:14:32.566+00
109	adil.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Rahimi	joueur	+212610000108	\N	t	\N	2026-11-23 16:10:08.188+00	2026-11-23 16:14:32.566+00
110	taha.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha El Kaabi	joueur	+212610000109	\N	t	\N	2026-11-23 16:10:08.192+00	2026-11-23 16:14:32.566+00
111	fouad.ounahi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Ounahi	joueur	+212610000110	\N	t	\N	2026-11-23 16:10:08.198+00	2026-11-23 16:14:32.566+00
112	ismail.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail Tazi	joueur	+212610000111	\N	t	\N	2026-11-23 16:10:08.203+00	2026-11-23 16:14:32.566+00
113	walid.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Benoun	joueur	+212610000112	\N	t	\N	2026-11-23 16:10:08.208+00	2026-11-23 16:14:32.566+00
114	hamza.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Naciri	joueur	+212610000113	\N	t	\N	2026-11-23 16:10:08.213+00	2026-11-23 16:14:32.566+00
115	ayman.benali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayman Benali	joueur	+212610000114	\N	t	\N	2026-11-23 16:10:08.219+00	2026-11-23 16:14:32.566+00
116	coach.ndr@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Tazi	coach	+212610000115	7	t	\N	2026-11-23 16:10:08.228+00	2026-11-23 16:14:32.566+00
117	bilal.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Bilal Ait Ali	joueur	+212610000116	\N	t	\N	2026-11-23 16:10:08.232+00	2026-11-23 16:14:32.566+00
118	karim.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Rahimi	joueur	+212610000117	\N	t	\N	2026-11-23 16:10:08.237+00	2026-11-23 16:14:32.566+00
119	walid.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Zerouali	joueur	+212610000118	\N	t	\N	2026-11-23 16:10:08.242+00	2026-11-23 16:14:32.566+00
120	nabil.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Moutaouakil	joueur	+212610000119	\N	t	\N	2026-11-23 16:10:08.247+00	2026-11-23 16:14:32.566+00
121	zakaria.el.khattabi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria El Khattabi	joueur	+212610000120	\N	t	\N	2026-11-23 16:10:08.253+00	2026-11-23 16:14:32.566+00
122	ayman.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayman Mazraoui	joueur	+212610000121	\N	t	\N	2026-11-23 16:10:08.261+00	2026-11-23 16:14:32.566+00
123	mohamed.ouazzani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed Ouazzani	joueur	+212610000122	\N	t	\N	2026-11-23 16:10:08.27+00	2026-11-23 16:14:32.566+00
124	tarik.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Berrada	joueur	+212610000123	\N	t	\N	2026-11-23 16:10:08.277+00	2026-11-23 16:14:32.566+00
125	omar.sqalli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Sqalli	joueur	+212610000124	\N	t	\N	2026-11-23 16:10:08.294+00	2026-11-23 16:14:32.566+00
126	noureddine.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Fassi	joueur	+212610000125	\N	t	\N	2026-11-23 16:10:08.305+00	2026-11-23 16:14:32.566+00
127	jawad.haddad@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Haddad	joueur	+212610000126	\N	t	\N	2026-11-23 16:10:08.316+00	2026-11-23 16:14:32.566+00
128	taha.benali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Benali	joueur	+212610000127	\N	t	\N	2026-11-23 16:10:08.327+00	2026-11-23 16:14:32.566+00
129	ilyas.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Amallah	joueur	+212610000128	\N	t	\N	2026-11-23 16:10:08.332+00	2026-11-23 16:14:32.566+00
130	walid.belhaj@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Belhaj	joueur	+212610000129	\N	t	\N	2026-11-23 16:10:08.339+00	2026-11-23 16:14:32.566+00
131	nassim.lahlou@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Lahlou	joueur	+212610000130	\N	t	\N	2026-11-23 16:10:08.344+00	2026-11-23 16:14:32.566+00
132	karim.moutaouakil2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Moutaouakil	joueur	+212610000131	\N	t	\N	2026-11-23 16:10:08.349+00	2026-11-23 16:14:32.566+00
133	nabil.ounahi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Ounahi	joueur	+212610000132	\N	t	\N	2026-11-23 16:10:08.353+00	2026-11-23 16:14:32.566+00
134	ayoub.haddad@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub Haddad	joueur	+212610000133	\N	t	\N	2026-11-23 16:10:08.359+00	2026-11-23 16:14:32.566+00
135	coach.rb@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Berrada	coach	+212610000134	8	t	\N	2026-11-23 16:10:08.368+00	2026-11-23 16:14:32.566+00
136	said.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Alaoui	joueur	+212610000135	\N	t	\N	2026-11-23 16:10:08.372+00	2026-11-23 16:14:32.566+00
137	ilyas.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Seddiki	joueur	+212610000136	\N	t	\N	2026-11-23 16:10:08.377+00	2026-11-23 16:14:32.566+00
138	anas.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Rahimi	joueur	+212610000137	\N	t	\N	2026-11-23 16:10:08.384+00	2026-11-23 16:14:32.566+00
139	tarik.ezzalzouli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Ezzalzouli	joueur	+212610000138	\N	t	\N	2026-11-23 16:10:08.392+00	2026-11-23 16:14:32.566+00
140	khalid.saiss@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Saiss	joueur	+212610000139	\N	t	\N	2026-11-23 16:10:08.397+00	2026-11-23 16:14:32.566+00
141	karim.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Jabrane	joueur	+212610000140	\N	t	\N	2026-11-23 16:10:08.405+00	2026-11-23 16:14:32.566+00
142	adil.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Boufal	joueur	+212610000141	\N	t	\N	2026-11-23 16:10:08.411+00	2026-11-23 16:14:32.566+00
143	mehdi.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Harit	joueur	+212610000142	\N	t	\N	2026-11-23 16:10:08.417+00	2026-11-23 16:14:32.566+00
144	tarik.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Moutaouakil	joueur	+212610000143	\N	t	\N	2026-11-23 16:10:08.423+00	2026-11-23 16:14:32.566+00
145	fouad.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Bouzidi	joueur	+212610000144	\N	t	\N	2026-11-23 16:10:08.429+00	2026-11-23 16:14:32.566+00
146	zakaria.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Boufal	joueur	+212610000145	\N	t	\N	2026-11-23 16:10:08.434+00	2026-11-23 16:14:32.566+00
147	mehdi.ezzalzouli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Ezzalzouli	joueur	+212610000146	\N	t	\N	2026-11-23 16:10:08.441+00	2026-11-23 16:14:32.566+00
148	fouad.amrabat@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Amrabat	joueur	+212610000147	\N	t	\N	2026-11-23 16:10:08.445+00	2026-11-23 16:14:32.566+00
149	rachid.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Rahimi	joueur	+212610000148	\N	t	\N	2026-11-23 16:10:08.451+00	2026-11-23 16:14:32.566+00
150	jawad.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Ait Ali	joueur	+212610000149	\N	t	\N	2026-11-23 16:10:08.455+00	2026-11-23 16:14:32.566+00
151	ismail.ezzalzouli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail Ezzalzouli	joueur	+212610000150	\N	t	\N	2026-11-23 16:10:08.462+00	2026-11-23 16:14:32.566+00
152	jawad.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Aguerd	joueur	+212610000151	\N	t	\N	2026-11-23 16:10:08.469+00	2026-11-23 16:14:32.566+00
153	mehdi.ezzalzouli2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Ezzalzouli	joueur	+212610000152	\N	t	\N	2026-11-23 16:10:08.473+00	2026-11-23 16:14:32.566+00
154	coach.cayb@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Imad El Khattabi	coach	+212610000153	9	t	\N	2026-11-23 16:10:08.479+00	2026-11-23 16:14:32.566+00
155	yassine.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Yassine Amallah	joueur	+212610000154	\N	t	\N	2026-11-23 16:10:08.485+00	2026-11-23 16:14:32.566+00
156	bilal.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Bilal El Kaabi	joueur	+212610000155	\N	t	\N	2026-11-23 16:10:08.495+00	2026-11-23 16:14:32.566+00
157	khalid.aguerd2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Aguerd	joueur	+212610000156	\N	t	\N	2026-11-23 16:10:08.503+00	2026-11-23 16:14:32.566+00
158	tarik.seddiki2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Seddiki	joueur	+212610000157	\N	t	\N	2026-11-23 16:10:08.51+00	2026-11-23 16:14:32.566+00
159	hicham.mansouri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Mansouri	joueur	+212610000158	\N	t	\N	2026-11-23 16:10:08.523+00	2026-11-23 16:14:32.566+00
160	tarik.ezzalzouli2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Ezzalzouli	joueur	+212610000159	\N	t	\N	2026-11-23 16:10:08.532+00	2026-11-23 16:14:32.566+00
161	badr.amrabat@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Amrabat	joueur	+212610000160	\N	t	\N	2026-11-23 16:10:08.54+00	2026-11-23 16:14:32.566+00
162	karim.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Ouchen	joueur	+212610000161	\N	t	\N	2026-11-23 16:10:08.546+00	2026-11-23 16:14:32.566+00
163	amine.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Chraibi	joueur	+212610000162	\N	t	\N	2026-11-23 16:10:08.55+00	2026-11-23 16:14:32.566+00
164	rachid.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Bouzidi	joueur	+212610000163	\N	t	\N	2026-11-23 16:10:08.556+00	2026-11-23 16:14:32.566+00
165	anas.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Zerouali	joueur	+212610000164	\N	t	\N	2026-11-23 16:10:08.56+00	2026-11-23 16:14:32.566+00
166	anas.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Seddiki	joueur	+212610000165	\N	t	\N	2026-11-23 16:10:08.564+00	2026-11-23 16:14:32.566+00
167	adil.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Zerouali	joueur	+212610000166	\N	t	\N	2026-11-23 16:10:08.569+00	2026-11-23 16:14:32.566+00
168	youssef.el.khattabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef El Khattabi	joueur	+212610000167	\N	t	\N	2026-11-23 16:10:08.573+00	2026-11-23 16:14:32.566+00
169	imad.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Imad Alaoui	joueur	+212610000168	\N	t	\N	2026-11-23 16:10:08.577+00	2026-11-23 16:14:32.566+00
170	zakaria.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Fassi	joueur	+212610000169	\N	t	\N	2026-11-23 16:10:08.581+00	2026-11-23 16:14:32.566+00
171	taha.saiss2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Saiss	joueur	+212610000170	\N	t	\N	2026-11-23 16:10:08.586+00	2026-11-23 16:14:32.566+00
172	nabil.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Amallah	joueur	+212610000171	\N	t	\N	2026-11-23 16:10:08.591+00	2026-11-23 16:14:32.566+00
173	coach.ejsc@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Rami	coach	+212610000172	10	t	\N	2026-11-23 16:10:08.598+00	2026-11-23 16:14:32.566+00
174	walid.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Seddiki	joueur	+212610000173	\N	t	\N	2026-11-23 16:10:08.602+00	2026-11-23 16:14:32.566+00
175	omar.hakimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Hakimi	joueur	+212610000174	\N	t	\N	2026-11-23 16:10:08.606+00	2026-11-23 16:14:32.566+00
176	mounir.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Alaoui	joueur	+212610000175	\N	t	\N	2026-11-23 16:10:08.614+00	2026-11-23 16:14:32.566+00
177	adil.amrabat@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Amrabat	joueur	+212610000176	\N	t	\N	2026-11-23 16:10:08.621+00	2026-11-23 16:14:32.566+00
178	ayoub.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub El Amrani	joueur	+212610000177	\N	t	\N	2026-11-23 16:10:08.627+00	2026-11-23 16:14:32.566+00
179	noureddine.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Naciri	joueur	+212610000178	\N	t	\N	2026-11-23 16:10:08.633+00	2026-11-23 16:14:32.566+00
180	nabil.el.kaabi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil El Kaabi	joueur	+212610000179	\N	t	\N	2026-11-23 16:10:08.637+00	2026-11-23 16:14:32.566+00
181	ilyas.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Ouchen	joueur	+212610000180	\N	t	\N	2026-11-23 16:10:08.64+00	2026-11-23 16:14:32.566+00
182	othmane.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane Moutaouakil	joueur	+212610000181	\N	t	\N	2026-11-23 16:10:08.645+00	2026-11-23 16:14:32.566+00
183	khalid.bennani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Bennani	joueur	+212610000182	\N	t	\N	2026-11-23 16:10:08.649+00	2026-11-23 16:14:32.566+00
184	tarik.hakimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Hakimi	joueur	+212610000183	\N	t	\N	2026-11-23 16:10:08.653+00	2026-11-23 16:14:32.566+00
185	driss.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss Rahimi	joueur	+212610000184	\N	t	\N	2026-11-23 16:10:08.658+00	2026-11-23 16:14:32.566+00
186	nassim.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Fassi	joueur	+212610000185	\N	t	\N	2026-11-23 16:10:08.663+00	2026-11-23 16:14:32.566+00
187	badr.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Tazi	joueur	+212610000186	\N	t	\N	2026-11-23 16:10:08.669+00	2026-11-23 16:14:32.566+00
188	noureddine.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Harit	joueur	+212610000187	\N	t	\N	2026-11-23 16:10:08.674+00	2026-11-23 16:14:32.566+00
189	hakim.lahlou@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Lahlou	joueur	+212610000188	\N	t	\N	2026-11-23 16:10:08.678+00	2026-11-23 16:14:32.566+00
190	zakaria.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Berrada	joueur	+212610000189	\N	t	\N	2026-11-23 16:10:08.684+00	2026-11-23 16:14:32.566+00
191	adil.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Ait Ali	joueur	+212610000190	\N	t	\N	2026-11-23 16:10:08.689+00	2026-11-23 16:14:32.566+00
192	coach.rac@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef El Amrani	coach	+212610000191	11	t	\N	2026-11-23 16:10:08.695+00	2026-11-23 16:14:32.566+00
193	nabil.lahlou@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Lahlou	joueur	+212610000192	\N	t	\N	2026-11-23 16:10:08.698+00	2026-11-23 16:14:32.566+00
194	mounir.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir El Amrani	joueur	+212610000193	\N	t	\N	2026-11-23 16:10:08.704+00	2026-11-23 16:14:32.566+00
195	zakaria.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Zerouali	joueur	+212610000194	\N	t	\N	2026-11-23 16:10:08.712+00	2026-11-23 16:14:32.566+00
196	ayoub.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub Tazi	joueur	+212610000195	\N	t	\N	2026-11-23 16:10:08.723+00	2026-11-23 16:14:32.566+00
197	tarik.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Mazraoui	joueur	+212610000196	\N	t	\N	2026-11-23 16:10:08.733+00	2026-11-23 16:14:32.566+00
198	rachid.bouzidi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Bouzidi	joueur	+212610000197	\N	t	\N	2026-11-23 16:10:08.743+00	2026-11-23 16:14:32.566+00
199	ismail.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail El Kaabi	joueur	+212610000198	\N	t	\N	2026-11-23 16:10:08.75+00	2026-11-23 16:14:32.566+00
200	reda.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda Aguerd	joueur	+212610000199	\N	t	\N	2026-11-23 16:10:08.759+00	2026-11-23 16:14:32.566+00
201	abdelali.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Rahimi	joueur	+212610000200	\N	t	\N	2026-11-23 16:10:08.767+00	2026-11-23 16:14:32.566+00
202	badr.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Zerouali	joueur	+212610000201	\N	t	\N	2026-11-23 16:10:08.773+00	2026-11-23 16:14:32.566+00
203	nassim.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nassim Amallah	joueur	+212610000202	\N	t	\N	2026-11-23 16:10:08.776+00	2026-11-23 16:14:32.566+00
204	achraf.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Achraf Fassi	joueur	+212610000203	\N	t	\N	2026-11-23 16:10:08.784+00	2026-11-23 16:14:32.566+00
205	reda.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda El Amrani	joueur	+212610000204	\N	t	\N	2026-11-23 16:10:08.791+00	2026-11-23 16:14:32.566+00
206	mounir.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Ouchen	joueur	+212610000205	\N	t	\N	2026-11-23 16:10:08.795+00	2026-11-23 16:14:32.566+00
207	soufiane.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Soufiane Bouzidi	joueur	+212610000206	\N	t	\N	2026-11-23 16:10:08.802+00	2026-11-23 16:14:32.566+00
208	ismail.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail Kettani	joueur	+212610000207	\N	t	\N	2026-11-23 16:10:08.809+00	2026-11-23 16:14:32.566+00
209	reda.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda Boufal	joueur	+212610000208	\N	t	\N	2026-11-23 16:10:08.813+00	2026-11-23 16:14:32.566+00
210	achraf.hakimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Achraf Hakimi	joueur	+212610000209	\N	t	\N	2026-11-23 16:10:08.821+00	2026-11-23 16:14:32.566+00
211	coach.hac@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed Naciri	coach	+212610000210	12	t	\N	2026-11-23 16:10:08.831+00	2026-11-23 16:14:32.566+00
212	salah.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Boufal	joueur	+212610000211	\N	t	\N	2026-11-23 16:10:08.838+00	2026-11-23 16:14:32.566+00
213	hamza.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Jabrane	joueur	+212610000212	\N	t	\N	2026-11-23 16:10:08.845+00	2026-11-23 16:14:32.566+00
214	anas.ouchen@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Ouchen	joueur	+212610000213	\N	t	\N	2026-11-23 16:10:08.85+00	2026-11-23 16:14:32.566+00
215	youssef.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Benoun	joueur	+212610000214	\N	t	\N	2026-11-23 16:10:08.855+00	2026-11-23 16:14:32.566+00
216	karim.ouchen2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Ouchen	joueur	+212610000215	\N	t	\N	2026-11-23 16:10:08.861+00	2026-11-23 16:14:32.566+00
217	ayoub.haddad2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub Haddad	joueur	+212610000216	\N	t	\N	2026-11-23 16:10:08.867+00	2026-11-23 16:14:32.566+00
218	ismail.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail Alaoui	joueur	+212610000217	\N	t	\N	2026-11-23 16:10:08.871+00	2026-11-23 16:14:32.566+00
219	badr.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Badr Alaoui	joueur	+212610000218	\N	t	\N	2026-11-23 16:10:08.875+00	2026-11-23 16:14:32.566+00
220	yassine.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Yassine Tazi	joueur	+212610000219	\N	t	\N	2026-11-23 16:10:08.881+00	2026-11-23 16:14:32.566+00
221	taha.benali2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Benali	joueur	+212610000220	\N	t	\N	2026-11-23 16:10:08.886+00	2026-11-23 16:14:32.566+00
222	mohamed.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mohamed El Amrani	joueur	+212610000221	\N	t	\N	2026-11-23 16:10:08.889+00	2026-11-23 16:14:32.566+00
223	youssef.ouazzani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Ouazzani	joueur	+212610000222	\N	t	\N	2026-11-23 16:10:08.894+00	2026-11-23 16:14:32.566+00
224	mehdi.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Rahimi	joueur	+212610000223	\N	t	\N	2026-11-23 16:10:08.9+00	2026-11-23 16:14:32.566+00
225	bilal.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Bilal Fassi	joueur	+212610000224	\N	t	\N	2026-11-23 16:10:08.906+00	2026-11-23 16:14:32.566+00
226	said.ezzalzouli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Ezzalzouli	joueur	+212610000225	\N	t	\N	2026-11-23 16:10:08.911+00	2026-11-23 16:14:32.566+00
227	driss.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss Alaoui	joueur	+212610000226	\N	t	\N	2026-11-23 16:10:08.916+00	2026-11-23 16:14:32.566+00
228	taha.amrabat@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Amrabat	joueur	+212610000227	\N	t	\N	2026-11-23 16:10:08.921+00	2026-11-23 16:14:32.566+00
229	othmane.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane Ziani	joueur	+212610000228	\N	t	\N	2026-11-23 16:10:08.93+00	2026-11-23 16:14:32.566+00
230	coach.ccf@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Belhaj	coach	+212610000229	13	t	\N	2026-11-23 16:10:08.939+00	2026-11-23 16:14:32.566+00
231	marouane.haddad@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Marouane Haddad	joueur	+212610000230	\N	t	\N	2026-11-23 16:10:08.944+00	2026-11-23 16:14:32.566+00
232	hakim.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Kettani	joueur	+212610000231	\N	t	\N	2026-11-23 16:10:08.952+00	2026-11-23 16:14:32.566+00
233	imad.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Imad Tazi	joueur	+212610000232	\N	t	\N	2026-11-23 16:10:08.963+00	2026-11-23 16:14:32.566+00
234	mounir.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Harit	joueur	+212610000233	\N	t	\N	2026-11-23 16:10:08.972+00	2026-11-23 16:14:32.566+00
235	salah.aguerd@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Aguerd	joueur	+212610000234	\N	t	\N	2026-11-23 16:10:08.981+00	2026-11-23 16:14:32.566+00
236	abdelali.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Chraibi	joueur	+212610000235	\N	t	\N	2026-11-23 16:10:08.986+00	2026-11-23 16:14:32.566+00
237	hamza.berrada@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Berrada	joueur	+212610000236	\N	t	\N	2026-11-23 16:10:08.99+00	2026-11-23 16:14:32.566+00
238	walid.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Walid Jabrane	joueur	+212610000237	\N	t	\N	2026-11-23 16:10:08.995+00	2026-11-23 16:14:32.566+00
239	zakaria.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Chraibi	joueur	+212610000238	\N	t	\N	2026-11-23 16:10:09.002+00	2026-11-23 16:14:32.566+00
240	rachid.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid El Kaabi	joueur	+212610000239	\N	t	\N	2026-11-23 16:10:09.006+00	2026-11-23 16:14:32.566+00
241	karim.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Alaoui	joueur	+212610000240	\N	t	\N	2026-11-23 16:10:09.009+00	2026-11-23 16:14:32.566+00
242	youssef.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Moutaouakil	joueur	+212610000241	\N	t	\N	2026-11-23 16:10:09.012+00	2026-11-23 16:14:32.566+00
243	noureddine.benali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Benali	joueur	+212610000242	\N	t	\N	2026-11-23 16:10:09.017+00	2026-11-23 16:14:32.566+00
244	abdelali.belhaj@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Belhaj	joueur	+212610000243	\N	t	\N	2026-11-23 16:10:09.022+00	2026-11-23 16:14:32.566+00
245	khalid.rami@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Rami	joueur	+212610000244	\N	t	\N	2026-11-23 16:10:09.026+00	2026-11-23 16:14:32.566+00
246	rachid.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Tazi	joueur	+212610000245	\N	t	\N	2026-11-23 16:10:09.03+00	2026-11-23 16:14:32.566+00
247	rachid.ouchen2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Rachid Ouchen	joueur	+212610000246	\N	t	\N	2026-11-23 16:10:09.034+00	2026-11-23 16:14:32.566+00
248	hamza.mazraoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza Mazraoui	joueur	+212610000247	\N	t	\N	2026-11-23 16:10:09.038+00	2026-11-23 16:14:32.566+00
249	coach.erm@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda Tazi	coach	+212610000248	14	t	\N	2026-11-23 16:10:09.046+00	2026-11-23 16:14:32.566+00
250	hakim.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim El Kaabi	joueur	+212610000249	\N	t	\N	2026-11-23 16:10:09.051+00	2026-11-23 16:14:32.566+00
251	marouane.el.amrani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Marouane El Amrani	joueur	+212610000250	\N	t	\N	2026-11-23 16:10:09.058+00	2026-11-23 16:14:32.566+00
252	othmane.chraibi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane Chraibi	joueur	+212610000251	\N	t	\N	2026-11-23 16:10:09.062+00	2026-11-23 16:14:32.566+00
253	amine.boufal@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Boufal	joueur	+212610000252	\N	t	\N	2026-11-23 16:10:09.066+00	2026-11-23 16:14:32.566+00
254	mehdi.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi Moutaouakil	joueur	+212610000253	\N	t	\N	2026-11-23 16:10:09.07+00	2026-11-23 16:14:32.566+00
255	reda.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda El Kaabi	joueur	+212610000254	\N	t	\N	2026-11-23 16:10:09.072+00	2026-11-23 16:14:32.566+00
256	zakaria.el.khattabi3@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria El Khattabi	joueur	+212610000255	\N	t	\N	2026-11-23 16:10:09.075+00	2026-11-23 16:14:32.566+00
257	mounir.sqalli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Sqalli	joueur	+212610000256	\N	t	\N	2026-11-23 16:10:09.08+00	2026-11-23 16:14:32.566+00
258	omar.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Ait Ali	joueur	+212610000257	\N	t	\N	2026-11-23 16:10:09.084+00	2026-11-23 16:14:32.566+00
259	yassine.haddad@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Yassine Haddad	joueur	+212610000258	\N	t	\N	2026-11-23 16:10:09.089+00	2026-11-23 16:14:32.566+00
260	hakim.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Naciri	joueur	+212610000259	\N	t	\N	2026-11-23 16:10:09.093+00	2026-11-23 16:14:32.566+00
261	hicham.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Naciri	joueur	+212610000260	\N	t	\N	2026-11-23 16:10:09.098+00	2026-11-23 16:14:32.566+00
262	fouad.harit@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Harit	joueur	+212610000261	\N	t	\N	2026-11-23 16:10:09.102+00	2026-11-23 16:14:32.566+00
263	salah.jabrane2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Jabrane	joueur	+212610000262	\N	t	\N	2026-11-23 16:10:09.105+00	2026-11-23 16:14:32.566+00
264	abdelali.belhaj2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Belhaj	joueur	+212610000263	\N	t	\N	2026-11-23 16:10:09.108+00	2026-11-23 16:14:32.566+00
265	amine.rahimi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Amine Rahimi	joueur	+212610000264	\N	t	\N	2026-11-23 16:10:09.112+00	2026-11-23 16:14:32.566+00
266	driss.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Driss Tazi	joueur	+212610000265	\N	t	\N	2026-11-23 16:10:09.115+00	2026-11-23 16:14:32.566+00
267	anas.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Anas Moutaouakil	joueur	+212610000266	\N	t	\N	2026-11-23 16:10:09.119+00	2026-11-23 16:14:32.566+00
268	coach.ahram@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Abdelali Amallah	coach	+212610000267	15	t	\N	2026-11-23 16:10:09.123+00	2026-11-23 16:14:32.566+00
269	hakim.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Seddiki	joueur	+212610000268	\N	t	\N	2026-11-23 16:10:09.126+00	2026-11-23 16:14:32.566+00
270	hakim.benoun2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Benoun	joueur	+212610000269	\N	t	\N	2026-11-23 16:10:09.132+00	2026-11-23 16:14:32.566+00
271	adil.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Adil Naciri	joueur	+212610000270	\N	t	\N	2026-11-23 16:10:09.138+00	2026-11-23 16:14:32.566+00
272	ayoub.alaoui@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayoub Alaoui	joueur	+212610000271	\N	t	\N	2026-11-23 16:10:09.148+00	2026-11-23 16:14:32.566+00
273	khalid.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Khalid Seddiki	joueur	+212610000272	\N	t	\N	2026-11-23 16:10:09.16+00	2026-11-23 16:14:32.566+00
274	ismail.ouazzani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ismail Ouazzani	joueur	+212610000273	\N	t	\N	2026-11-23 16:10:09.172+00	2026-11-23 16:14:32.566+00
275	mounir.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mounir Rahimi	joueur	+212610000274	\N	t	\N	2026-11-23 16:10:09.184+00	2026-11-23 16:14:32.566+00
276	mehdi.el.idrissi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Mehdi El Idrissi	joueur	+212610000275	\N	t	\N	2026-11-23 16:10:09.195+00	2026-11-23 16:14:32.566+00
277	zakaria.tazi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria Tazi	joueur	+212610000276	\N	t	\N	2026-11-23 16:10:09.205+00	2026-11-23 16:14:32.566+00
278	nabil.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Seddiki	joueur	+212610000277	\N	t	\N	2026-11-23 16:10:09.212+00	2026-11-23 16:14:32.566+00
279	othmane.moutaouakil2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Othmane Moutaouakil	joueur	+212610000278	\N	t	\N	2026-11-23 16:10:09.218+00	2026-11-23 16:14:32.566+00
280	ayman.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ayman Zerouali	joueur	+212610000279	\N	t	\N	2026-11-23 16:10:09.224+00	2026-11-23 16:14:32.566+00
281	reda.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda Kettani	joueur	+212610000280	\N	t	\N	2026-11-23 16:10:09.232+00	2026-11-23 16:14:32.566+00
282	hicham.hakimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Hakimi	joueur	+212610000281	\N	t	\N	2026-11-23 16:10:09.237+00	2026-11-23 16:14:32.566+00
283	hamza.el.kaabi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hamza El Kaabi	joueur	+212610000282	\N	t	\N	2026-11-23 16:10:09.243+00	2026-11-23 16:14:32.566+00
284	hicham.benoun@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hicham Benoun	joueur	+212610000283	\N	t	\N	2026-11-23 16:10:09.249+00	2026-11-23 16:14:32.566+00
285	reda.lahlou@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Reda Lahlou	joueur	+212610000284	\N	t	\N	2026-11-23 16:10:09.257+00	2026-11-23 16:14:32.566+00
286	youssef.kettani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Youssef Kettani	joueur	+212610000285	\N	t	\N	2026-11-23 16:10:09.263+00	2026-11-23 16:14:32.566+00
287	coach.mcam@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Zakaria El Amrani	coach	+212610000286	16	t	\N	2026-11-23 16:10:09.28+00	2026-11-23 16:14:32.566+00
288	omar.moutaouakil@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Moutaouakil	joueur	+212610000287	\N	t	\N	2026-11-23 16:10:09.288+00	2026-11-23 16:14:32.566+00
289	ilyas.zerouali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Ilyas Zerouali	joueur	+212610000288	\N	t	\N	2026-11-23 16:10:09.295+00	2026-11-23 16:14:32.566+00
290	tarik.amrabat@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Amrabat	joueur	+212610000289	\N	t	\N	2026-11-23 16:10:09.301+00	2026-11-23 16:14:32.566+00
291	karim.rahimi2@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Karim Rahimi	joueur	+212610000290	\N	t	\N	2026-11-23 16:10:09.309+00	2026-11-23 16:14:32.566+00
292	noureddine.saiss@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Noureddine Saiss	joueur	+212610000291	\N	t	\N	2026-11-23 16:10:09.314+00	2026-11-23 16:14:32.566+00
293	tarik.ouazzani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Ouazzani	joueur	+212610000292	\N	t	\N	2026-11-23 16:10:09.32+00	2026-11-23 16:14:32.566+00
294	salah.seddiki@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Salah Seddiki	joueur	+212610000293	\N	t	\N	2026-11-23 16:10:09.326+00	2026-11-23 16:14:32.566+00
295	hakim.rahimi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Rahimi	joueur	+212610000294	\N	t	\N	2026-11-23 16:10:09.334+00	2026-11-23 16:14:32.566+00
296	jawad.ziani@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Jawad Ziani	joueur	+212610000295	\N	t	\N	2026-11-23 16:10:09.342+00	2026-11-23 16:14:32.566+00
297	imad.haddad@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Imad Haddad	joueur	+212610000296	\N	t	\N	2026-11-23 16:10:09.351+00	2026-11-23 16:14:32.566+00
298	omar.amallah@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Omar Amallah	joueur	+212610000297	\N	t	\N	2026-11-23 16:10:09.359+00	2026-11-23 16:14:32.566+00
299	said.boufal3@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Said Boufal	joueur	+212610000298	\N	t	\N	2026-11-23 16:10:09.366+00	2026-11-23 16:14:32.566+00
300	fouad.ait.ali@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Fouad Ait Ali	joueur	+212610000299	\N	t	\N	2026-11-23 16:10:09.375+00	2026-11-23 16:14:32.566+00
301	tarik.naciri@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Tarik Naciri	joueur	+212610000300	\N	t	\N	2026-11-23 16:10:09.38+00	2026-11-23 16:14:32.566+00
302	taha.bouzidi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Taha Bouzidi	joueur	+212610000301	\N	t	\N	2026-11-23 16:10:09.386+00	2026-11-23 16:14:32.566+00
303	nabil.jabrane@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Jabrane	joueur	+212610000302	\N	t	\N	2026-11-23 16:10:09.393+00	2026-11-23 16:14:32.566+00
304	hakim.sqalli@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Hakim Sqalli	joueur	+212610000303	\N	t	\N	2026-11-23 16:10:09.4+00	2026-11-23 16:14:32.566+00
305	nabil.fassi@footpro.ma	$2a$10$rd8tgBSRAxoyPUVMpgkiR.hXOtlI435xHcBu4sVroF1YVNiwnPlC.	Nabil Fassi	joueur	+212610000304	\N	t	\N	2026-11-23 16:10:09.407+00	2026-11-23 16:14:32.566+00
\.


--
-- Name: MatchEvents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."MatchEvents_id_seq"', 328, true);


--
-- Name: MatchLineups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."MatchLineups_id_seq"', 71, true);


--
-- Name: Matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Matches_id_seq"', 35, true);


--
-- Name: PlayerBadges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PlayerBadges_id_seq"', 138, true);


--
-- Name: PlayerClubHistories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PlayerClubHistories_id_seq"', 433, true);


--
-- Name: PlayerRewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PlayerRewards_id_seq"', 106, true);


--
-- Name: PlayerStats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PlayerStats_id_seq"', 288, true);


--
-- Name: Players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Players_id_seq"', 288, true);


--
-- Name: RefereeMissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."RefereeMissions_id_seq"', 140, true);


--
-- Name: ScoutEvaluations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ScoutEvaluations_id_seq"', 40, true);


--
-- Name: ScoutWatchlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ScoutWatchlists_id_seq"', 25, true);


--
-- Name: Teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Teams_id_seq"', 16, true);


--
-- Name: TournamentApplications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."TournamentApplications_id_seq"', 22, true);


--
-- Name: Tournaments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Tournaments_id_seq"', 3, true);


--
-- Name: TrainingAttendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."TrainingAttendances_id_seq"', 1818, true);


--
-- Name: TrainingSessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."TrainingSessions_id_seq"', 160, true);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Users_id_seq"', 311, true);


--
-- Name: Chats Chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_pkey" PRIMARY KEY (id);


--
-- Name: MatchEvents MatchEvents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchEvents"
    ADD CONSTRAINT "MatchEvents_pkey" PRIMARY KEY (id);


--
-- Name: MatchLineups MatchLineups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchLineups"
    ADD CONSTRAINT "MatchLineups_pkey" PRIMARY KEY (id);


--
-- Name: Matches Matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Matches"
    ADD CONSTRAINT "Matches_pkey" PRIMARY KEY (id);


--
-- Name: PlayerBadges PlayerBadges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerBadges"
    ADD CONSTRAINT "PlayerBadges_pkey" PRIMARY KEY (id);


--
-- Name: PlayerClubHistories PlayerClubHistories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerClubHistories"
    ADD CONSTRAINT "PlayerClubHistories_pkey" PRIMARY KEY (id);


--
-- Name: PlayerRewards PlayerRewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerRewards"
    ADD CONSTRAINT "PlayerRewards_pkey" PRIMARY KEY (id);


--
-- Name: PlayerStats PlayerStats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerStats"
    ADD CONSTRAINT "PlayerStats_pkey" PRIMARY KEY (id);


--
-- Name: Players Players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Players"
    ADD CONSTRAINT "Players_pkey" PRIMARY KEY (id);


--
-- Name: RefereeMissions RefereeMissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RefereeMissions"
    ADD CONSTRAINT "RefereeMissions_pkey" PRIMARY KEY (id);


--
-- Name: ScoutEvaluations ScoutEvaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutEvaluations"
    ADD CONSTRAINT "ScoutEvaluations_pkey" PRIMARY KEY (id);


--
-- Name: ScoutWatchlists ScoutWatchlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutWatchlists"
    ADD CONSTRAINT "ScoutWatchlists_pkey" PRIMARY KEY (id);


--
-- Name: Teams Teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Teams"
    ADD CONSTRAINT "Teams_pkey" PRIMARY KEY (id);


--
-- Name: TournamentApplications TournamentApplications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TournamentApplications"
    ADD CONSTRAINT "TournamentApplications_pkey" PRIMARY KEY (id);


--
-- Name: Tournaments Tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tournaments"
    ADD CONSTRAINT "Tournaments_pkey" PRIMARY KEY (id);


--
-- Name: TrainingAttendances TrainingAttendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingAttendances"
    ADD CONSTRAINT "TrainingAttendances_pkey" PRIMARY KEY (id);


--
-- Name: TrainingSessions TrainingSessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingSessions"
    ADD CONSTRAINT "TrainingSessions_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);


--
-- Name: Users Users_email_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key1" UNIQUE (email);


--
-- Name: Users Users_email_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key2" UNIQUE (email);


--
-- Name: Users Users_email_key3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key3" UNIQUE (email);


--
-- Name: Users Users_email_key4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key4" UNIQUE (email);


--
-- Name: Users Users_email_key5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key5" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: chats_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chats_created_at ON public."Chats" USING btree ("createdAt");


--
-- Name: chats_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chats_team_id ON public."Chats" USING btree ("teamId");


--
-- Name: match_lineups_match_id_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX match_lineups_match_id_team_id ON public."MatchLineups" USING btree ("matchId", "teamId");


--
-- Name: referee_missions_match_id_referee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX referee_missions_match_id_referee_id ON public."RefereeMissions" USING btree ("matchId", "refereeId");


--
-- Name: scout_evaluations_scout_id_player_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX scout_evaluations_scout_id_player_id ON public."ScoutEvaluations" USING btree ("scoutId", "playerId");


--
-- Name: scout_watchlists_scout_id_player_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX scout_watchlists_scout_id_player_id ON public."ScoutWatchlists" USING btree ("scoutId", "playerId");


--
-- Name: tournaments_is_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tournaments_is_public ON public."Tournaments" USING btree ("isPublic");


--
-- Name: tournaments_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tournaments_start_date ON public."Tournaments" USING btree ("startDate");


--
-- Name: tournaments_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tournaments_status ON public."Tournaments" USING btree (status);


--
-- Name: training_attendances_training_session_id_player_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX training_attendances_training_session_id_player_id ON public."TrainingAttendances" USING btree ("trainingSessionId", "playerId");


--
-- Name: Chats Chats_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."Users"(id) ON UPDATE CASCADE;


--
-- Name: Chats Chats_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE;


--
-- Name: MatchEvents MatchEvents_matchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchEvents"
    ADD CONSTRAINT "MatchEvents_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES public."Matches"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MatchLineups MatchLineups_matchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchLineups"
    ADD CONSTRAINT "MatchLineups_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES public."Matches"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MatchLineups MatchLineups_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MatchLineups"
    ADD CONSTRAINT "MatchLineups_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Matches Matches_awayTeamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Matches"
    ADD CONSTRAINT "Matches_awayTeamId_fkey" FOREIGN KEY ("awayTeamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Matches Matches_homeTeamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Matches"
    ADD CONSTRAINT "Matches_homeTeamId_fkey" FOREIGN KEY ("homeTeamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Matches Matches_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Matches"
    ADD CONSTRAINT "Matches_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournaments"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: PlayerBadges PlayerBadges_awardedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerBadges"
    ADD CONSTRAINT "PlayerBadges_awardedById_fkey" FOREIGN KEY ("awardedById") REFERENCES public."Players"(id) ON UPDATE CASCADE;


--
-- Name: PlayerBadges PlayerBadges_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerBadges"
    ADD CONSTRAINT "PlayerBadges_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlayerBadges PlayerBadges_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerBadges"
    ADD CONSTRAINT "PlayerBadges_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournaments"(id) ON UPDATE CASCADE;


--
-- Name: PlayerClubHistories PlayerClubHistories_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerClubHistories"
    ADD CONSTRAINT "PlayerClubHistories_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlayerClubHistories PlayerClubHistories_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerClubHistories"
    ADD CONSTRAINT "PlayerClubHistories_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: PlayerRewards PlayerRewards_awardedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerRewards"
    ADD CONSTRAINT "PlayerRewards_awardedById_fkey" FOREIGN KEY ("awardedById") REFERENCES public."Players"(id) ON UPDATE CASCADE;


--
-- Name: PlayerRewards PlayerRewards_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerRewards"
    ADD CONSTRAINT "PlayerRewards_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlayerRewards PlayerRewards_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerRewards"
    ADD CONSTRAINT "PlayerRewards_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournaments"(id) ON UPDATE CASCADE;


--
-- Name: PlayerStats PlayerStats_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlayerStats"
    ADD CONSTRAINT "PlayerStats_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Players Players_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Players"
    ADD CONSTRAINT "Players_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Players Players_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Players"
    ADD CONSTRAINT "Players_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: RefereeMissions RefereeMissions_matchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RefereeMissions"
    ADD CONSTRAINT "RefereeMissions_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES public."Matches"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RefereeMissions RefereeMissions_refereeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RefereeMissions"
    ADD CONSTRAINT "RefereeMissions_refereeId_fkey" FOREIGN KEY ("refereeId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ScoutEvaluations ScoutEvaluations_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutEvaluations"
    ADD CONSTRAINT "ScoutEvaluations_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE;


--
-- Name: ScoutEvaluations ScoutEvaluations_scoutId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutEvaluations"
    ADD CONSTRAINT "ScoutEvaluations_scoutId_fkey" FOREIGN KEY ("scoutId") REFERENCES public."Users"(id) ON UPDATE CASCADE;


--
-- Name: ScoutWatchlists ScoutWatchlists_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutWatchlists"
    ADD CONSTRAINT "ScoutWatchlists_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE;


--
-- Name: ScoutWatchlists ScoutWatchlists_scoutId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ScoutWatchlists"
    ADD CONSTRAINT "ScoutWatchlists_scoutId_fkey" FOREIGN KEY ("scoutId") REFERENCES public."Users"(id) ON UPDATE CASCADE;


--
-- Name: Teams Teams_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Teams"
    ADD CONSTRAINT "Teams_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournaments"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TournamentApplications TournamentApplications_reviewedBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TournamentApplications"
    ADD CONSTRAINT "TournamentApplications_reviewedBy_fkey" FOREIGN KEY ("reviewedBy") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TournamentApplications TournamentApplications_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TournamentApplications"
    ADD CONSTRAINT "TournamentApplications_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE;


--
-- Name: TournamentApplications TournamentApplications_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TournamentApplications"
    ADD CONSTRAINT "TournamentApplications_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournaments"(id) ON UPDATE CASCADE;


--
-- Name: TrainingAttendances TrainingAttendances_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingAttendances"
    ADD CONSTRAINT "TrainingAttendances_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Players"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TrainingAttendances TrainingAttendances_trainingSessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingAttendances"
    ADD CONSTRAINT "TrainingAttendances_trainingSessionId_fkey" FOREIGN KEY ("trainingSessionId") REFERENCES public."TrainingSessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TrainingSessions TrainingSessions_coachId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingSessions"
    ADD CONSTRAINT "TrainingSessions_coachId_fkey" FOREIGN KEY ("coachId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TrainingSessions TrainingSessions_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."TrainingSessions"
    ADD CONSTRAINT "TrainingSessions_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Users Users_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 7PZL7b4OfoDNMKbmLmOBQp87c4bGPY1TCIQsSwRiul3TWylBiXs5zIl7zDvJPfs

