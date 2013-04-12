--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: abilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE abilities (
    id integer NOT NULL,
    action character varying(255),
    subject character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_id integer,
    available boolean DEFAULT false
);


--
-- Name: abilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE abilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: abilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE abilities_id_seq OWNED BY abilities.id;


--
-- Name: accesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accesses (
    id integer NOT NULL,
    credential_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cluster_user_id integer,
    task_needed boolean DEFAULT false
);


--
-- Name: accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accesses_id_seq OWNED BY accesses.id;


--
-- Name: account_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_codes (
    id integer NOT NULL,
    code character varying(255),
    project_id integer,
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    user_id integer
);


--
-- Name: account_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_codes_id_seq OWNED BY account_codes.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    user_id integer,
    project_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    username character varying(255),
    owner boolean DEFAULT false,
    access_state character varying(255),
    cluster_state character varying(255)
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: additional_emails; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE additional_emails (
    id integer NOT NULL,
    email character varying(255),
    user_id integer
);


--
-- Name: additional_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE additional_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE additional_emails_id_seq OWNED BY additional_emails.id;


--
-- Name: cluster_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cluster_fields (
    id integer NOT NULL,
    cluster_id integer,
    name character varying(255)
);


--
-- Name: cluster_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cluster_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cluster_fields_id_seq OWNED BY cluster_fields.id;


--
-- Name: cluster_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cluster_projects (
    id integer NOT NULL,
    state character varying(255),
    project_id integer,
    cluster_id integer,
    username character varying(255),
    task_needed boolean DEFAULT false
);


--
-- Name: cluster_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cluster_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cluster_projects_id_seq OWNED BY cluster_projects.id;


--
-- Name: cluster_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cluster_users (
    id integer NOT NULL,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id integer,
    cluster_project_id integer,
    username character varying(255),
    task_needed boolean DEFAULT false
);


--
-- Name: cluster_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cluster_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cluster_users_id_seq OWNED BY cluster_users.id;


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clusters (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    host character varying(255),
    description character varying(255),
    state character varying(255),
    statistic text,
    statistic_updated_at timestamp without time zone,
    cluster_user_type character varying(255) DEFAULT 'account'::character varying
);


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clusters_id_seq OWNED BY clusters.id;


--
-- Name: credentials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE credentials (
    id integer NOT NULL,
    public_key text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    state character varying(255)
);


--
-- Name: credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credentials_id_seq OWNED BY credentials.id;


--
-- Name: critical_technologies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE critical_technologies (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: critical_technologies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE critical_technologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: critical_technologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE critical_technologies_id_seq OWNED BY critical_technologies.id;


--
-- Name: critical_technologies_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE critical_technologies_projects (
    critical_technology_id integer,
    project_id integer
);


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: direction_of_sciences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE direction_of_sciences (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: direction_of_sciences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE direction_of_sciences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: direction_of_sciences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE direction_of_sciences_id_seq OWNED BY direction_of_sciences.id;


--
-- Name: direction_of_sciences_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE direction_of_sciences_projects (
    direction_of_science_id integer,
    project_id integer
);


--
-- Name: expands; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE expands (
    id integer NOT NULL,
    url character varying(255),
    script character varying(255)
);


--
-- Name: expands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE expands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE expands_id_seq OWNED BY expands.id;


--
-- Name: extends; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE extends (
    id integer NOT NULL,
    url character varying(255),
    script character varying(255),
    header character varying(255),
    footer character varying(255),
    weight integer DEFAULT 1
);


--
-- Name: extends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE extends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: extends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE extends_id_seq OWNED BY extends.id;


--
-- Name: fault_replies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fault_replies (
    id integer NOT NULL,
    fault_id integer,
    message text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fault_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fault_replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fault_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fault_replies_id_seq OWNED BY fault_replies.id;


--
-- Name: faults; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faults (
    id integer NOT NULL,
    user_id integer,
    description text,
    reference_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    kind character varying(255)
);


--
-- Name: faults_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faults_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faults_id_seq OWNED BY faults.id;


--
-- Name: fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fields (
    id integer NOT NULL,
    name character varying(255),
    code character varying(255),
    model_type character varying(255),
    "position" integer DEFAULT 1,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fields_id_seq OWNED BY fields.id;


--
-- Name: group_abilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_abilities (
    id integer NOT NULL,
    group_id integer,
    ability_id integer,
    available boolean
);


--
-- Name: group_abilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_abilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_abilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_abilities_id_seq OWNED BY group_abilities.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying(255),
    system boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: groups_ticket_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups_ticket_tags (
    group_id integer,
    ticket_tag_id integer
);


--
-- Name: history_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_items (
    id integer NOT NULL,
    user_id integer,
    data text,
    kind character varying(255),
    created_at timestamp without time zone,
    author_id integer
);


--
-- Name: history_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_items_id_seq OWNED BY history_items.id;


--
-- Name: import_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE import_items (
    id integer NOT NULL,
    first_name character varying(255),
    middle_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    organization_name character varying(255),
    project_name character varying(255),
    "group" character varying(255),
    login character varying(255),
    keys text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cluster_id integer,
    technologies text,
    directions text,
    phone character varying(255)
);


--
-- Name: import_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE import_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE import_items_id_seq OWNED BY import_items.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    subdivision_id integer
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: old_report_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_comments (
    id integer NOT NULL,
    message text,
    user_id integer,
    report_id integer
);


--
-- Name: old_report_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_comments_id_seq OWNED BY old_report_comments.id;


--
-- Name: old_report_organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_organizations (
    id integer NOT NULL,
    report_id integer,
    name character varying(255),
    subdivision character varying(255),
    "position" character varying(255),
    organization_type character varying(255),
    organization_id integer,
    other_position character varying(255)
);


--
-- Name: old_report_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_organizations_id_seq OWNED BY old_report_organizations.id;


--
-- Name: old_report_personal_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_personal_data (
    id integer NOT NULL,
    report_id integer,
    last_name character varying(255),
    first_name character varying(255),
    middle_name character varying(255),
    email character varying(255),
    phone character varying(255),
    confirm_data character varying(255),
    reason text
);


--
-- Name: old_report_personal_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_personal_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_personal_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_personal_data_id_seq OWNED BY old_report_personal_data.id;


--
-- Name: old_report_personal_surveys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_personal_surveys (
    id integer NOT NULL,
    report_id integer,
    software text,
    technologies text,
    compilators text,
    learning text,
    wanna_be_speaker text,
    request_technology text,
    other_technology text,
    other_compilator text,
    other_software text,
    other_learning text,
    computing text,
    comment text,
    "precision" text
);


--
-- Name: old_report_personal_surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_personal_surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_personal_surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_personal_surveys_id_seq OWNED BY old_report_personal_surveys.id;


--
-- Name: old_report_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_projects (
    id integer NOT NULL,
    report_id integer,
    ru_title text,
    ru_author text,
    emails text,
    ru_driver text,
    ru_strategy text,
    ru_objective text,
    ru_impact text,
    ru_usage text,
    en_title text,
    en_author text,
    en_driver text,
    en_strategy text,
    en_objective text,
    en_impact text,
    en_usage text,
    directions_of_science text,
    critical_technologies text,
    areas text,
    computing_systems text,
    lomonosov_logins text,
    chebyshev_logins text,
    materials_file_name character varying(255),
    materials_content_type character varying(255),
    materials_file_size integer,
    materials_updated_at timestamp without time zone,
    books_count integer DEFAULT 0,
    vacs_count integer DEFAULT 0,
    lectures_count integer DEFAULT 0,
    international_conferences_count integer DEFAULT 0,
    russian_conferences_count integer DEFAULT 0,
    doctors_dissertations_count integer DEFAULT 0,
    candidates_dissertations_count integer DEFAULT 0,
    students_count integer DEFAULT 0,
    graduates_count integer DEFAULT 0,
    your_students_count integer DEFAULT 0,
    rffi_grants_count integer DEFAULT 0,
    ministry_of_education_grants_count integer DEFAULT 0,
    rosnano_grants_count integer DEFAULT 0,
    ministry_of_communications_grants_count integer DEFAULT 0,
    ministry_of_defence_grants_count integer DEFAULT 0,
    ran_grants_count integer DEFAULT 0,
    other_russian_grants_count integer DEFAULT 0,
    other_intenational_grants_count integer DEFAULT 0,
    award_names text,
    lomonosov_intel_hours integer DEFAULT 0,
    lomonosov_nvidia_hours integer DEFAULT 0,
    chebyshev_hours integer DEFAULT 0,
    lomonosov_size integer DEFAULT 0,
    chebyshev_size integer DEFAULT 0,
    exclusive_usage text,
    strict_schedule text,
    wanna_speak boolean,
    request_comment text,
    international_conferences_in_russia_count integer DEFAULT 0,
    awards_count integer DEFAULT 0,
    illustrations_points integer DEFAULT 0,
    statement_points integer DEFAULT 0,
    summary_points integer DEFAULT 0,
    project_id integer
);


--
-- Name: old_report_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_projects_id_seq OWNED BY old_report_projects.id;


--
-- Name: old_report_replies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_report_replies (
    id integer NOT NULL,
    report_id integer,
    message text,
    user_id integer
);


--
-- Name: old_report_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_report_replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_report_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_report_replies_id_seq OWNED BY old_report_replies.id;


--
-- Name: old_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_reports (
    id integer NOT NULL,
    user_id integer,
    project_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    expert_id integer,
    illustrations_points integer,
    sent_on_time boolean DEFAULT false,
    submitted_at timestamp without time zone,
    allow_state character varying(255),
    superviser_comment text
);


--
-- Name: old_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_reports_id_seq OWNED BY old_reports.id;


--
-- Name: organization_kinds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organization_kinds (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255)
);


--
-- Name: organization_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organization_kinds_id_seq OWNED BY organization_kinds.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255),
    approved boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    abbreviation character varying(255),
    organization_kind_id integer,
    active_projects_count integer DEFAULT 0,
    subdivision_required boolean DEFAULT false
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: organizations_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations_projects (
    organization_id integer,
    project_id integer
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locator text,
    publicized boolean DEFAULT false
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: position_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE position_names (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    autocomplete text
);


--
-- Name: position_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE position_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: position_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE position_names_id_seq OWNED BY position_names.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE positions (
    id integer NOT NULL,
    membership_id integer,
    name character varying(255),
    value character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE positions_id_seq OWNED BY positions.id;


--
-- Name: project_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_cards (
    id integer NOT NULL,
    project_id integer,
    name text,
    en_name text,
    driver text,
    en_driver text,
    strategy text,
    en_strategy text,
    objective text,
    en_objective text,
    impact text,
    en_impact text,
    usage text,
    en_usage text
);


--
-- Name: project_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_cards_id_seq OWNED BY project_cards.id;


--
-- Name: project_prefixes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_prefixes (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_prefixes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_prefixes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_prefixes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_prefixes_id_seq OWNED BY project_prefixes.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    state character varying(255),
    description text,
    organization_id integer,
    cluster_user_type character varying(255) DEFAULT 'account'::character varying,
    username character varying(255),
    project_prefix_id integer,
    disabled boolean DEFAULT false
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_research_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_research_areas (
    project_id integer,
    research_area_id integer
);


--
-- Name: replies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE replies (
    id integer NOT NULL,
    user_id integer,
    ticket_id integer,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    notice text
);


--
-- Name: replies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE replies_id_seq OWNED BY replies.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    session_id integer,
    project_id integer,
    state character varying(255),
    materials_file_name character varying(255),
    materials_content_type character varying(255),
    materials_file_size integer,
    materials_updated_at timestamp without time zone,
    expert_id integer,
    illustration_points integer,
    summary_points integer,
    statement_points integer
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: request_properties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE request_properties (
    id integer NOT NULL,
    name character varying(255),
    value character varying(255),
    request_id integer
);


--
-- Name: request_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE request_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE request_properties_id_seq OWNED BY request_properties.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE requests (
    id integer NOT NULL,
    cpu_hours integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    state character varying(255),
    size integer DEFAULT 0,
    comment character varying(255),
    cluster_project_id integer,
    gpu_hours integer DEFAULT 0,
    project_id integer,
    cluster_id integer,
    maintain_requested_at timestamp without time zone
);


--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requests_id_seq OWNED BY requests.id;


--
-- Name: research_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE research_areas (
    id integer NOT NULL,
    "group" character varying(255),
    name character varying(255),
    weight integer DEFAULT 0
);


--
-- Name: research_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE research_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE research_areas_id_seq OWNED BY research_areas.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    personal_survey_id integer,
    projects_survey_id integer,
    counters_survey_id integer,
    state character varying(255),
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    description character varying(255),
    motivation character varying(255),
    receiving_to date
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stats (
    id integer NOT NULL,
    session_id integer,
    survey_field_id integer,
    group_by character varying(255),
    weight integer DEFAULT 0,
    organization_id integer,
    cache text
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stats_id_seq OWNED BY stats.id;


--
-- Name: subdivisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subdivisions (
    id integer NOT NULL,
    organization_id integer,
    name character varying(255),
    short character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subdivisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subdivisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subdivisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subdivisions_id_seq OWNED BY subdivisions.id;


--
-- Name: sureties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sureties (
    id integer NOT NULL,
    user_id integer,
    organization_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment character varying(255),
    project_id integer,
    boss_full_name character varying(255),
    boss_position character varying(255),
    cpu_hours integer DEFAULT 0,
    size integer DEFAULT 0,
    gpu_hours integer DEFAULT 0
);


--
-- Name: sureties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sureties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sureties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sureties_id_seq OWNED BY sureties.id;


--
-- Name: surety_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE surety_members (
    id integer NOT NULL,
    surety_id integer,
    user_id integer,
    email character varying(255),
    full_name character varying(255),
    account_code_id integer,
    first_name character varying(255),
    last_name character varying(255),
    middle_name character varying(255)
);


--
-- Name: surety_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE surety_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surety_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE surety_members_id_seq OWNED BY surety_members.id;


--
-- Name: survey_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE survey_fields (
    id integer NOT NULL,
    survey_id integer,
    kind character varying(255),
    collection text,
    max_values integer DEFAULT 1,
    weight integer DEFAULT 0,
    name character varying(255),
    required boolean DEFAULT false,
    entity character varying(255),
    strict_collection boolean DEFAULT false,
    hint character varying(255),
    reference_type character varying(255)
);


--
-- Name: survey_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE survey_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE survey_fields_id_seq OWNED BY survey_fields.id;


--
-- Name: survey_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE survey_values (
    id integer NOT NULL,
    value text,
    survey_field_id integer,
    user_id integer,
    reference_id integer,
    reference_type character varying(255)
);


--
-- Name: survey_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE survey_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE survey_values_id_seq OWNED BY survey_values.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE surveys (
    id integer NOT NULL
);


--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE surveys_id_seq OWNED BY surveys.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasks (
    id integer NOT NULL,
    resource_type character varying(255),
    resource_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    runned_at timestamp without time zone
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: ticket_field_relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_field_relations (
    id integer NOT NULL,
    ticket_question_id integer,
    ticket_field_id integer,
    required boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    use boolean DEFAULT false
);


--
-- Name: ticket_field_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_field_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_field_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_field_relations_id_seq OWNED BY ticket_field_relations.id;


--
-- Name: ticket_field_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_field_values (
    id integer NOT NULL,
    value character varying(255),
    ticket_field_relation_id integer,
    ticket_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ticket_field_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_field_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_field_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_field_values_id_seq OWNED BY ticket_field_values.id;


--
-- Name: ticket_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_fields (
    id integer NOT NULL,
    name character varying(255),
    hint character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255),
    url boolean DEFAULT false
);


--
-- Name: ticket_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_fields_id_seq OWNED BY ticket_fields.id;


--
-- Name: ticket_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_questions (
    id integer NOT NULL,
    ticket_question_id integer,
    question character varying(255),
    leaf boolean DEFAULT true,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ticket_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_questions_id_seq OWNED BY ticket_questions.id;


--
-- Name: ticket_questions_ticket_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_questions_ticket_tags (
    ticket_question_id integer,
    ticket_tag_id integer
);


--
-- Name: ticket_tag_relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_tag_relations (
    id integer NOT NULL,
    ticket_id integer,
    ticket_tag_id integer,
    active boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ticket_tag_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_tag_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_tag_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_tag_relations_id_seq OWNED BY ticket_tag_relations.id;


--
-- Name: ticket_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_tags (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255)
);


--
-- Name: ticket_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_tags_id_seq OWNED BY ticket_tags.id;


--
-- Name: ticket_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_templates (
    id integer NOT NULL,
    subject character varying(255),
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying(255)
);


--
-- Name: ticket_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_templates_id_seq OWNED BY ticket_templates.id;


--
-- Name: ticket_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_users (
    user_id integer,
    ticket_id integer
);


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tickets (
    id integer NOT NULL,
    subject character varying(255),
    message text,
    user_id integer,
    state character varying(255),
    url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    ticket_question_id integer,
    project_id integer,
    cluster_id integer,
    surety_id integer,
    report_id integer
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tickets_id_seq OWNED BY tickets.id;


--
-- Name: tickets_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tickets_users (
    user_id integer,
    ticket_id integer
);


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_groups (
    id integer NOT NULL,
    user_id integer,
    group_id integer
);


--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;


--
-- Name: user_surveys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_surveys (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    survey_id integer,
    project_id integer,
    state character varying(255)
);


--
-- Name: user_surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_surveys_id_seq OWNED BY user_surveys.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255),
    crypted_password character varying(255),
    salt character varying(255),
    remember_me_token character varying(255),
    remember_me_token_expires_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    activation_state character varying(255),
    activation_token character varying(255),
    activation_token_expires_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255),
    middle_name character varying(255),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean DEFAULT false,
    state character varying(255),
    token character varying(255),
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    phone character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "values" (
    id integer NOT NULL,
    field_id integer,
    model_id integer,
    model_type integer,
    value text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE values_id_seq OWNED BY "values".id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY abilities ALTER COLUMN id SET DEFAULT nextval('abilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accesses ALTER COLUMN id SET DEFAULT nextval('accesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_codes ALTER COLUMN id SET DEFAULT nextval('account_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY additional_emails ALTER COLUMN id SET DEFAULT nextval('additional_emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cluster_fields ALTER COLUMN id SET DEFAULT nextval('cluster_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cluster_projects ALTER COLUMN id SET DEFAULT nextval('cluster_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cluster_users ALTER COLUMN id SET DEFAULT nextval('cluster_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clusters ALTER COLUMN id SET DEFAULT nextval('clusters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credentials ALTER COLUMN id SET DEFAULT nextval('credentials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY critical_technologies ALTER COLUMN id SET DEFAULT nextval('critical_technologies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY direction_of_sciences ALTER COLUMN id SET DEFAULT nextval('direction_of_sciences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY expands ALTER COLUMN id SET DEFAULT nextval('expands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY extends ALTER COLUMN id SET DEFAULT nextval('extends_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fault_replies ALTER COLUMN id SET DEFAULT nextval('fault_replies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faults ALTER COLUMN id SET DEFAULT nextval('faults_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fields ALTER COLUMN id SET DEFAULT nextval('fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_abilities ALTER COLUMN id SET DEFAULT nextval('group_abilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_items ALTER COLUMN id SET DEFAULT nextval('history_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY import_items ALTER COLUMN id SET DEFAULT nextval('import_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_comments ALTER COLUMN id SET DEFAULT nextval('old_report_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_organizations ALTER COLUMN id SET DEFAULT nextval('old_report_organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_personal_data ALTER COLUMN id SET DEFAULT nextval('old_report_personal_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_personal_surveys ALTER COLUMN id SET DEFAULT nextval('old_report_personal_surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_projects ALTER COLUMN id SET DEFAULT nextval('old_report_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_report_replies ALTER COLUMN id SET DEFAULT nextval('old_report_replies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_reports ALTER COLUMN id SET DEFAULT nextval('old_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_kinds ALTER COLUMN id SET DEFAULT nextval('organization_kinds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY position_names ALTER COLUMN id SET DEFAULT nextval('position_names_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY positions ALTER COLUMN id SET DEFAULT nextval('positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_cards ALTER COLUMN id SET DEFAULT nextval('project_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_prefixes ALTER COLUMN id SET DEFAULT nextval('project_prefixes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY replies ALTER COLUMN id SET DEFAULT nextval('replies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_properties ALTER COLUMN id SET DEFAULT nextval('request_properties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY research_areas ALTER COLUMN id SET DEFAULT nextval('research_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats ALTER COLUMN id SET DEFAULT nextval('stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subdivisions ALTER COLUMN id SET DEFAULT nextval('subdivisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sureties ALTER COLUMN id SET DEFAULT nextval('sureties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY surety_members ALTER COLUMN id SET DEFAULT nextval('surety_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_fields ALTER COLUMN id SET DEFAULT nextval('survey_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_values ALTER COLUMN id SET DEFAULT nextval('survey_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY surveys ALTER COLUMN id SET DEFAULT nextval('surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_field_relations ALTER COLUMN id SET DEFAULT nextval('ticket_field_relations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_field_values ALTER COLUMN id SET DEFAULT nextval('ticket_field_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_fields ALTER COLUMN id SET DEFAULT nextval('ticket_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_questions ALTER COLUMN id SET DEFAULT nextval('ticket_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_tag_relations ALTER COLUMN id SET DEFAULT nextval('ticket_tag_relations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_tags ALTER COLUMN id SET DEFAULT nextval('ticket_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_templates ALTER COLUMN id SET DEFAULT nextval('ticket_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_surveys ALTER COLUMN id SET DEFAULT nextval('user_surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "values" ALTER COLUMN id SET DEFAULT nextval('values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: abilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY abilities
    ADD CONSTRAINT abilities_pkey PRIMARY KEY (id);


--
-- Name: accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accesses
    ADD CONSTRAINT accesses_pkey PRIMARY KEY (id);


--
-- Name: account_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_codes
    ADD CONSTRAINT account_codes_pkey PRIMARY KEY (id);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: additional_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY additional_emails
    ADD CONSTRAINT additional_emails_pkey PRIMARY KEY (id);


--
-- Name: cluster_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cluster_fields
    ADD CONSTRAINT cluster_fields_pkey PRIMARY KEY (id);


--
-- Name: cluster_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cluster_projects
    ADD CONSTRAINT cluster_projects_pkey PRIMARY KEY (id);


--
-- Name: cluster_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cluster_users
    ADD CONSTRAINT cluster_users_pkey PRIMARY KEY (id);


--
-- Name: clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- Name: critical_technologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY critical_technologies
    ADD CONSTRAINT critical_technologies_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: direction_of_sciences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY direction_of_sciences
    ADD CONSTRAINT direction_of_sciences_pkey PRIMARY KEY (id);


--
-- Name: expands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY expands
    ADD CONSTRAINT expands_pkey PRIMARY KEY (id);


--
-- Name: extends_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY extends
    ADD CONSTRAINT extends_pkey PRIMARY KEY (id);


--
-- Name: fault_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fault_replies
    ADD CONSTRAINT fault_replies_pkey PRIMARY KEY (id);


--
-- Name: faults_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faults
    ADD CONSTRAINT faults_pkey PRIMARY KEY (id);


--
-- Name: fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (id);


--
-- Name: group_abilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_abilities
    ADD CONSTRAINT group_abilities_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: history_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_items
    ADD CONSTRAINT history_items_pkey PRIMARY KEY (id);


--
-- Name: import_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY import_items
    ADD CONSTRAINT import_items_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: organization_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organization_kinds
    ADD CONSTRAINT organization_kinds_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: position_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY position_names
    ADD CONSTRAINT position_names_pkey PRIMARY KEY (id);


--
-- Name: positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: project_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_cards
    ADD CONSTRAINT project_cards_pkey PRIMARY KEY (id);


--
-- Name: project_prefixes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_prefixes
    ADD CONSTRAINT project_prefixes_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: replies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY replies
    ADD CONSTRAINT replies_pkey PRIMARY KEY (id);


--
-- Name: report_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_comments
    ADD CONSTRAINT report_comments_pkey PRIMARY KEY (id);


--
-- Name: report_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_organizations
    ADD CONSTRAINT report_organizations_pkey PRIMARY KEY (id);


--
-- Name: report_personal_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_personal_data
    ADD CONSTRAINT report_personal_data_pkey PRIMARY KEY (id);


--
-- Name: report_personal_surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_personal_surveys
    ADD CONSTRAINT report_personal_surveys_pkey PRIMARY KEY (id);


--
-- Name: report_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_projects
    ADD CONSTRAINT report_projects_pkey PRIMARY KEY (id);


--
-- Name: report_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_report_replies
    ADD CONSTRAINT report_replies_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey1 PRIMARY KEY (id);


--
-- Name: request_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY request_properties
    ADD CONSTRAINT request_properties_pkey PRIMARY KEY (id);


--
-- Name: requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: research_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY research_areas
    ADD CONSTRAINT research_areas_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: subdivisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subdivisions
    ADD CONSTRAINT subdivisions_pkey PRIMARY KEY (id);


--
-- Name: sureties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sureties
    ADD CONSTRAINT sureties_pkey PRIMARY KEY (id);


--
-- Name: surety_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY surety_members
    ADD CONSTRAINT surety_members_pkey PRIMARY KEY (id);


--
-- Name: survey_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY survey_fields
    ADD CONSTRAINT survey_fields_pkey PRIMARY KEY (id);


--
-- Name: survey_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY survey_values
    ADD CONSTRAINT survey_values_pkey PRIMARY KEY (id);


--
-- Name: surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: ticket_field_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_field_relations
    ADD CONSTRAINT ticket_field_relations_pkey PRIMARY KEY (id);


--
-- Name: ticket_field_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_field_values
    ADD CONSTRAINT ticket_field_values_pkey PRIMARY KEY (id);


--
-- Name: ticket_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_fields
    ADD CONSTRAINT ticket_fields_pkey PRIMARY KEY (id);


--
-- Name: ticket_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_questions
    ADD CONSTRAINT ticket_questions_pkey PRIMARY KEY (id);


--
-- Name: ticket_tag_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_tag_relations
    ADD CONSTRAINT ticket_tag_relations_pkey PRIMARY KEY (id);


--
-- Name: ticket_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_tags
    ADD CONSTRAINT ticket_tags_pkey PRIMARY KEY (id);


--
-- Name: ticket_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_templates
    ADD CONSTRAINT ticket_templates_pkey PRIMARY KEY (id);


--
-- Name: tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_surveys
    ADD CONSTRAINT user_surveys_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "values"
    ADD CONSTRAINT values_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_abilities_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_abilities_on_group_id ON abilities USING btree (group_id);


--
-- Name: index_abilities_on_group_id_and_subject_and_action; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_abilities_on_group_id_and_subject_and_action ON abilities USING btree (group_id, subject, action);


--
-- Name: index_accesses_on_credential_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accesses_on_credential_id ON accesses USING btree (credential_id);


--
-- Name: index_accesses_on_credential_id_and_cluster_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accesses_on_credential_id_and_cluster_user_id ON accesses USING btree (credential_id, cluster_user_id);


--
-- Name: index_accesses_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accesses_on_state ON accesses USING btree (state);


--
-- Name: index_account_codes_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_codes_on_project_id ON account_codes USING btree (project_id);


--
-- Name: index_account_codes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_codes_on_user_id ON account_codes USING btree (user_id);


--
-- Name: index_accounts_on_access_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_access_state ON accounts USING btree (access_state);


--
-- Name: index_accounts_on_cluster_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_cluster_state ON accounts USING btree (cluster_state);


--
-- Name: index_accounts_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_project_id ON accounts USING btree (project_id);


--
-- Name: index_accounts_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_state ON accounts USING btree (state);


--
-- Name: index_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_user_id ON accounts USING btree (user_id);


--
-- Name: index_accounts_on_user_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accounts_on_user_id_and_project_id ON accounts USING btree (user_id, project_id);


--
-- Name: index_additional_emails_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_additional_emails_on_user_id ON additional_emails USING btree (user_id);


--
-- Name: index_cluster_fields_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cluster_fields_on_cluster_id ON cluster_fields USING btree (cluster_id);


--
-- Name: index_cluster_projects_on_cluster_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_cluster_projects_on_cluster_id_and_project_id ON cluster_projects USING btree (cluster_id, project_id);


--
-- Name: index_cluster_users_on_cluster_project_id_and_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_cluster_users_on_cluster_project_id_and_account_id ON cluster_users USING btree (cluster_project_id, account_id);


--
-- Name: index_clusters_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clusters_on_state ON clusters USING btree (state);


--
-- Name: index_credentials_on_public_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credentials_on_public_key ON credentials USING btree (public_key);


--
-- Name: index_credentials_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credentials_on_user_id ON credentials USING btree (user_id);


--
-- Name: index_credentials_on_user_id_and_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credentials_on_user_id_and_state ON credentials USING btree (user_id, state);


--
-- Name: index_direction_of_sciences_projects_on_direction_of_science_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_direction_of_sciences_projects_on_direction_of_science_id ON direction_of_sciences_projects USING btree (direction_of_science_id);


--
-- Name: index_direction_of_sciences_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_direction_of_sciences_projects_on_project_id ON direction_of_sciences_projects USING btree (project_id);


--
-- Name: index_fault_replies_on_fault_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fault_replies_on_fault_id ON fault_replies USING btree (fault_id);


--
-- Name: index_fault_replies_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fault_replies_on_user_id ON fault_replies USING btree (user_id);


--
-- Name: index_group_abilities_on_ability_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_abilities_on_ability_id ON group_abilities USING btree (ability_id);


--
-- Name: index_group_abilities_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_abilities_on_group_id ON group_abilities USING btree (group_id);


--
-- Name: index_group_abilities_on_group_id_and_ability_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_group_abilities_on_group_id_and_ability_id ON group_abilities USING btree (group_id, ability_id);


--
-- Name: index_groups_ticket_tags_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_groups_ticket_tags_on_group_id ON groups_ticket_tags USING btree (group_id);


--
-- Name: index_groups_ticket_tags_on_ticket_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_groups_ticket_tags_on_ticket_tag_id ON groups_ticket_tags USING btree (ticket_tag_id);


--
-- Name: index_groups_ticket_tags_on_ticket_tag_id_and_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_groups_ticket_tags_on_ticket_tag_id_and_group_id ON groups_ticket_tags USING btree (ticket_tag_id, group_id);


--
-- Name: index_history_items_on_kind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_items_on_kind ON history_items USING btree (kind);


--
-- Name: index_history_items_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_items_on_user_id ON history_items USING btree (user_id);


--
-- Name: index_import_items_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_import_items_on_cluster_id ON import_items USING btree (cluster_id);


--
-- Name: index_memberships_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_organization_id ON memberships USING btree (organization_id);


--
-- Name: index_memberships_on_subdivision_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_subdivision_id ON memberships USING btree (subdivision_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_user_id ON memberships USING btree (user_id);


--
-- Name: index_organization_kinds_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organization_kinds_on_state ON organization_kinds USING btree (state);


--
-- Name: index_organizations_on_organization_kind_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_organization_kind_id ON organizations USING btree (organization_kind_id);


--
-- Name: index_organizations_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_state ON organizations USING btree (state);


--
-- Name: index_organizations_projects_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_organization_id ON organizations_projects USING btree (organization_id);


--
-- Name: index_organizations_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_project_id ON organizations_projects USING btree (project_id);


--
-- Name: index_organizations_projects_on_project_id_and_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organizations_projects_on_project_id_and_organization_id ON organizations_projects USING btree (project_id, organization_id);


--
-- Name: index_pages_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_pages_on_url ON pages USING btree (url);


--
-- Name: index_positions_on_membership_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_positions_on_membership_id ON positions USING btree (membership_id);


--
-- Name: index_project_cards_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_cards_on_project_id ON project_cards USING btree (project_id);


--
-- Name: index_projects_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_organization_id ON projects USING btree (organization_id);


--
-- Name: index_projects_on_project_prefix_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_project_prefix_id ON projects USING btree (project_prefix_id);


--
-- Name: index_projects_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_state ON projects USING btree (state);


--
-- Name: index_projects_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_user_id ON projects USING btree (user_id);


--
-- Name: index_projects_research_areas_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_research_areas_on_project_id ON projects_research_areas USING btree (project_id);


--
-- Name: index_projects_research_areas_on_research_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_research_areas_on_research_area_id ON projects_research_areas USING btree (research_area_id);


--
-- Name: index_replies_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_replies_on_ticket_id ON replies USING btree (ticket_id);


--
-- Name: index_replies_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_replies_on_user_id ON replies USING btree (user_id);


--
-- Name: index_report_comments_on_report_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_report_comments_on_report_id ON old_report_comments USING btree (report_id);


--
-- Name: index_report_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_report_comments_on_user_id ON old_report_comments USING btree (user_id);


--
-- Name: index_report_replies_on_report_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_report_replies_on_report_id ON old_report_replies USING btree (report_id);


--
-- Name: index_report_replies_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_report_replies_on_user_id ON old_report_replies USING btree (user_id);


--
-- Name: index_reports_on_expert_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_expert_id ON reports USING btree (expert_id);


--
-- Name: index_reports_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_session_id ON reports USING btree (session_id);


--
-- Name: index_reports_on_session_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_reports_on_session_id_and_project_id ON reports USING btree (session_id, project_id);


--
-- Name: index_reports_on_session_id_and_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_session_id_and_state ON reports USING btree (session_id, state);


--
-- Name: index_reports_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_user_id ON old_reports USING btree (user_id);


--
-- Name: index_request_properties_on_request_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_request_properties_on_request_id ON request_properties USING btree (request_id);


--
-- Name: index_requests_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_cluster_id ON requests USING btree (cluster_id);


--
-- Name: index_requests_on_cluster_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_cluster_project_id ON requests USING btree (cluster_project_id);


--
-- Name: index_requests_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_project_id ON requests USING btree (project_id);


--
-- Name: index_requests_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_state ON requests USING btree (state);


--
-- Name: index_requests_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_user_id ON requests USING btree (user_id);


--
-- Name: index_stats_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stats_on_session_id ON stats USING btree (session_id);


--
-- Name: index_sureties_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sureties_on_organization_id ON sureties USING btree (organization_id);


--
-- Name: index_sureties_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sureties_on_project_id ON sureties USING btree (project_id);


--
-- Name: index_sureties_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sureties_on_state ON sureties USING btree (state);


--
-- Name: index_sureties_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sureties_on_user_id ON sureties USING btree (user_id);


--
-- Name: index_surety_members_on_account_code_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_surety_members_on_account_code_id ON surety_members USING btree (account_code_id);


--
-- Name: index_surety_members_on_surety_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_surety_members_on_surety_id ON surety_members USING btree (surety_id);


--
-- Name: index_surety_members_on_surety_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_surety_members_on_surety_id_and_user_id ON surety_members USING btree (surety_id, user_id);


--
-- Name: index_surety_members_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_surety_members_on_user_id ON surety_members USING btree (user_id);


--
-- Name: index_survey_fields_on_survey_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_survey_fields_on_survey_id ON survey_fields USING btree (survey_id);


--
-- Name: index_survey_values_on_survey_field_id_and_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_survey_values_on_survey_field_id_and_reference_id ON survey_values USING btree (survey_field_id, reference_id);


--
-- Name: index_survey_values_on_survey_field_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_survey_values_on_survey_field_id_and_user_id ON survey_values USING btree (survey_field_id, user_id);


--
-- Name: index_tasks_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tasks_on_resource_id_and_resource_type ON tasks USING btree (resource_id, resource_type);


--
-- Name: index_ticket_field_relations_on_ticket_field_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_field_relations_on_ticket_field_id ON ticket_field_relations USING btree (ticket_field_id);


--
-- Name: index_ticket_field_relations_on_ticket_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_field_relations_on_ticket_question_id ON ticket_field_relations USING btree (ticket_question_id);


--
-- Name: index_ticket_field_values_on_ticket_field_relation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_field_values_on_ticket_field_relation_id ON ticket_field_values USING btree (ticket_field_relation_id);


--
-- Name: index_ticket_field_values_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_field_values_on_ticket_id ON ticket_field_values USING btree (ticket_id);


--
-- Name: index_ticket_fields_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_fields_on_state ON ticket_fields USING btree (state);


--
-- Name: index_ticket_questions_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_questions_on_state ON ticket_questions USING btree (state);


--
-- Name: index_ticket_questions_on_ticket_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_questions_on_ticket_question_id ON ticket_questions USING btree (ticket_question_id);


--
-- Name: index_ticket_questions_ticket_tags_on_ticket_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_questions_ticket_tags_on_ticket_question_id ON ticket_questions_ticket_tags USING btree (ticket_question_id);


--
-- Name: index_ticket_questions_ticket_tags_on_ticket_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_questions_ticket_tags_on_ticket_tag_id ON ticket_questions_ticket_tags USING btree (ticket_tag_id);


--
-- Name: index_ticket_tag_relations_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_tag_relations_on_ticket_id ON ticket_tag_relations USING btree (ticket_id);


--
-- Name: index_ticket_tag_relations_on_ticket_id_and_ticket_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ticket_tag_relations_on_ticket_id_and_ticket_tag_id ON ticket_tag_relations USING btree (ticket_id, ticket_tag_id);


--
-- Name: index_ticket_tag_relations_on_ticket_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_tag_relations_on_ticket_tag_id ON ticket_tag_relations USING btree (ticket_tag_id);


--
-- Name: index_ticket_tags_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_tags_on_state ON ticket_tags USING btree (state);


--
-- Name: index_ticket_templates_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_templates_on_state ON ticket_templates USING btree (state);


--
-- Name: index_ticket_users_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_users_on_ticket_id ON ticket_users USING btree (ticket_id);


--
-- Name: index_ticket_users_on_ticket_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ticket_users_on_ticket_id_and_user_id ON ticket_users USING btree (ticket_id, user_id);


--
-- Name: index_ticket_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ticket_users_on_user_id ON ticket_users USING btree (user_id);


--
-- Name: index_tickets_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_cluster_id ON tickets USING btree (cluster_id);


--
-- Name: index_tickets_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_project_id ON tickets USING btree (project_id);


--
-- Name: index_tickets_on_report_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_report_id ON tickets USING btree (report_id);


--
-- Name: index_tickets_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_state ON tickets USING btree (state);


--
-- Name: index_tickets_on_surety_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_surety_id ON tickets USING btree (surety_id);


--
-- Name: index_tickets_on_ticket_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_ticket_question_id ON tickets USING btree (ticket_question_id);


--
-- Name: index_tickets_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_user_id ON tickets USING btree (user_id);


--
-- Name: index_tickets_users_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_users_on_ticket_id ON tickets_users USING btree (ticket_id);


--
-- Name: index_tickets_users_on_ticket_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tickets_users_on_ticket_id_and_user_id ON tickets_users USING btree (ticket_id, user_id);


--
-- Name: index_tickets_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_users_on_user_id ON tickets_users USING btree (user_id);


--
-- Name: index_user_groups_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_groups_on_group_id ON user_groups USING btree (group_id);


--
-- Name: index_user_groups_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_groups_on_user_id ON user_groups USING btree (user_id);


--
-- Name: index_user_groups_on_user_id_and_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_groups_on_user_id_and_group_id ON user_groups USING btree (user_id, group_id);


--
-- Name: index_user_surveys_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_surveys_on_project_id ON user_surveys USING btree (project_id);


--
-- Name: index_user_surveys_on_survey_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_surveys_on_survey_id ON user_surveys USING btree (survey_id);


--
-- Name: index_user_surveys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_surveys_on_user_id ON user_surveys USING btree (user_id);


--
-- Name: index_user_surveys_on_user_id_and_survey_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_surveys_on_user_id_and_survey_id_and_project_id ON user_surveys USING btree (user_id, survey_id, project_id);


--
-- Name: index_users_on_activation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_activation_token ON users USING btree (activation_token);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_me_token ON users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_state ON users USING btree (state);


--
-- Name: index_users_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_token ON users USING btree (token);


--
-- Name: index_values_on_field_id_and_model_id_and_model_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_values_on_field_id_and_model_id_and_model_type ON "values" USING btree (field_id, model_id, model_type);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: uniq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uniq ON critical_technologies_projects USING btree (critical_technology_id, project_id);


--
-- Name: uniq_dir_proj; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uniq_dir_proj ON direction_of_sciences_projects USING btree (direction_of_science_id, project_id);


--
-- Name: unique_question_tag_relation; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_question_tag_relation ON ticket_questions_ticket_tags USING btree (ticket_question_id, ticket_tag_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: unique_users_with_same_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_users_with_same_email ON users USING btree (lower((email)::text));


--
-- Name: unqiue_projects_research_areas; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unqiue_projects_research_areas ON projects_research_areas USING btree (project_id, research_area_id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120625091607');

INSERT INTO schema_migrations (version) VALUES ('20120625091702');

INSERT INTO schema_migrations (version) VALUES ('20120625093054');

INSERT INTO schema_migrations (version) VALUES ('20120625102409');

INSERT INTO schema_migrations (version) VALUES ('20120702122615');

INSERT INTO schema_migrations (version) VALUES ('20120702122620');

INSERT INTO schema_migrations (version) VALUES ('20120702122743');

INSERT INTO schema_migrations (version) VALUES ('20120702123456');

INSERT INTO schema_migrations (version) VALUES ('20120702130155');

INSERT INTO schema_migrations (version) VALUES ('20120705082712');

INSERT INTO schema_migrations (version) VALUES ('20120705090302');

INSERT INTO schema_migrations (version) VALUES ('20120705131126');

INSERT INTO schema_migrations (version) VALUES ('20120705131902');

INSERT INTO schema_migrations (version) VALUES ('20120706124017');

INSERT INTO schema_migrations (version) VALUES ('20120706124026');

INSERT INTO schema_migrations (version) VALUES ('20120709094812');

INSERT INTO schema_migrations (version) VALUES ('20120709130827');

INSERT INTO schema_migrations (version) VALUES ('20120709131414');

INSERT INTO schema_migrations (version) VALUES ('20120710150558');

INSERT INTO schema_migrations (version) VALUES ('20120711091210');

INSERT INTO schema_migrations (version) VALUES ('20120711130431');

INSERT INTO schema_migrations (version) VALUES ('20120712142445');

INSERT INTO schema_migrations (version) VALUES ('20120712152419');

INSERT INTO schema_migrations (version) VALUES ('20120712153438');

INSERT INTO schema_migrations (version) VALUES ('20120714091500');

INSERT INTO schema_migrations (version) VALUES ('20120714091825');

INSERT INTO schema_migrations (version) VALUES ('20120716122113');

INSERT INTO schema_migrations (version) VALUES ('20120716150356');

INSERT INTO schema_migrations (version) VALUES ('20120716171340');

INSERT INTO schema_migrations (version) VALUES ('20120716173112');

INSERT INTO schema_migrations (version) VALUES ('20120716173428');

INSERT INTO schema_migrations (version) VALUES ('20120717133613');

INSERT INTO schema_migrations (version) VALUES ('20120717140217');

INSERT INTO schema_migrations (version) VALUES ('20120717161737');

INSERT INTO schema_migrations (version) VALUES ('20120717163714');

INSERT INTO schema_migrations (version) VALUES ('20120718053342');

INSERT INTO schema_migrations (version) VALUES ('20120718090150');

INSERT INTO schema_migrations (version) VALUES ('20120719154306');

INSERT INTO schema_migrations (version) VALUES ('20120720045505');

INSERT INTO schema_migrations (version) VALUES ('20120725130726');

INSERT INTO schema_migrations (version) VALUES ('20120725160758');

INSERT INTO schema_migrations (version) VALUES ('20120726071300');

INSERT INTO schema_migrations (version) VALUES ('20120726074929');

INSERT INTO schema_migrations (version) VALUES ('20120727084256');

INSERT INTO schema_migrations (version) VALUES ('20120730081216');

INSERT INTO schema_migrations (version) VALUES ('20120730092038');

INSERT INTO schema_migrations (version) VALUES ('20120731150244');

INSERT INTO schema_migrations (version) VALUES ('20120731150253');

INSERT INTO schema_migrations (version) VALUES ('20120731153033');

INSERT INTO schema_migrations (version) VALUES ('20120731153216');

INSERT INTO schema_migrations (version) VALUES ('20120731153241');

INSERT INTO schema_migrations (version) VALUES ('20120802100241');

INSERT INTO schema_migrations (version) VALUES ('20120803082355');

INSERT INTO schema_migrations (version) VALUES ('20120803122032');

INSERT INTO schema_migrations (version) VALUES ('20120807085105');

INSERT INTO schema_migrations (version) VALUES ('20120807113713');

INSERT INTO schema_migrations (version) VALUES ('20120807140657');

INSERT INTO schema_migrations (version) VALUES ('20120808100831');

INSERT INTO schema_migrations (version) VALUES ('20120808112712');

INSERT INTO schema_migrations (version) VALUES ('20120808134601');

INSERT INTO schema_migrations (version) VALUES ('20120808140622');

INSERT INTO schema_migrations (version) VALUES ('20120808142537');

INSERT INTO schema_migrations (version) VALUES ('20120808143448');

INSERT INTO schema_migrations (version) VALUES ('20120810135419');

INSERT INTO schema_migrations (version) VALUES ('20120813065136');

INSERT INTO schema_migrations (version) VALUES ('20120813070320');

INSERT INTO schema_migrations (version) VALUES ('20120813124920');

INSERT INTO schema_migrations (version) VALUES ('20120814065820');

INSERT INTO schema_migrations (version) VALUES ('20120814085711');

INSERT INTO schema_migrations (version) VALUES ('20120814120703');

INSERT INTO schema_migrations (version) VALUES ('20120814124240');

INSERT INTO schema_migrations (version) VALUES ('20120814131611');

INSERT INTO schema_migrations (version) VALUES ('20120815072909');

INSERT INTO schema_migrations (version) VALUES ('20120815072931');

INSERT INTO schema_migrations (version) VALUES ('20120815140147');

INSERT INTO schema_migrations (version) VALUES ('20120816135845');

INSERT INTO schema_migrations (version) VALUES ('20120817095402');

INSERT INTO schema_migrations (version) VALUES ('20120817110839');

INSERT INTO schema_migrations (version) VALUES ('20120821120903');

INSERT INTO schema_migrations (version) VALUES ('20120821140700');

INSERT INTO schema_migrations (version) VALUES ('20120822070948');

INSERT INTO schema_migrations (version) VALUES ('20120822100643');

INSERT INTO schema_migrations (version) VALUES ('20120822100727');

INSERT INTO schema_migrations (version) VALUES ('20120822113620');

INSERT INTO schema_migrations (version) VALUES ('20120824091450');

INSERT INTO schema_migrations (version) VALUES ('20120827092750');

INSERT INTO schema_migrations (version) VALUES ('20120827095938');

INSERT INTO schema_migrations (version) VALUES ('20120827100021');

INSERT INTO schema_migrations (version) VALUES ('20120827101312');

INSERT INTO schema_migrations (version) VALUES ('20120827134130');

INSERT INTO schema_migrations (version) VALUES ('20120828110623');

INSERT INTO schema_migrations (version) VALUES ('20120828135427');

INSERT INTO schema_migrations (version) VALUES ('20120828142248');

INSERT INTO schema_migrations (version) VALUES ('20120829062633');

INSERT INTO schema_migrations (version) VALUES ('20120829062910');

INSERT INTO schema_migrations (version) VALUES ('20120829094834');

INSERT INTO schema_migrations (version) VALUES ('20120830114816');

INSERT INTO schema_migrations (version) VALUES ('20120830115031');

INSERT INTO schema_migrations (version) VALUES ('20120830125833');

INSERT INTO schema_migrations (version) VALUES ('20120830134800');

INSERT INTO schema_migrations (version) VALUES ('20120903075645');

INSERT INTO schema_migrations (version) VALUES ('20120903085806');

INSERT INTO schema_migrations (version) VALUES ('20120903090926');

INSERT INTO schema_migrations (version) VALUES ('20120904113939');

INSERT INTO schema_migrations (version) VALUES ('20120904114318');

INSERT INTO schema_migrations (version) VALUES ('20120904114714');

INSERT INTO schema_migrations (version) VALUES ('20120905124723');

INSERT INTO schema_migrations (version) VALUES ('20120905131138');

INSERT INTO schema_migrations (version) VALUES ('20120910122728');

INSERT INTO schema_migrations (version) VALUES ('20120919113702');

INSERT INTO schema_migrations (version) VALUES ('20120919115602');

INSERT INTO schema_migrations (version) VALUES ('20120919150837');

INSERT INTO schema_migrations (version) VALUES ('20120921100234');

INSERT INTO schema_migrations (version) VALUES ('20120925084553');

INSERT INTO schema_migrations (version) VALUES ('20120925101115');

INSERT INTO schema_migrations (version) VALUES ('20120925110901');

INSERT INTO schema_migrations (version) VALUES ('20120925112233');

INSERT INTO schema_migrations (version) VALUES ('20120925114229');

INSERT INTO schema_migrations (version) VALUES ('20120927144809');

INSERT INTO schema_migrations (version) VALUES ('20120928123435');

INSERT INTO schema_migrations (version) VALUES ('20121001134401');

INSERT INTO schema_migrations (version) VALUES ('20121002105214');

INSERT INTO schema_migrations (version) VALUES ('20121004094155');

INSERT INTO schema_migrations (version) VALUES ('20121008114455');

INSERT INTO schema_migrations (version) VALUES ('20121008121553');

INSERT INTO schema_migrations (version) VALUES ('20121010131612');

INSERT INTO schema_migrations (version) VALUES ('20121015111604');

INSERT INTO schema_migrations (version) VALUES ('20121016082536');

INSERT INTO schema_migrations (version) VALUES ('20121017070528');

INSERT INTO schema_migrations (version) VALUES ('20121018091624');

INSERT INTO schema_migrations (version) VALUES ('20121018122953');

INSERT INTO schema_migrations (version) VALUES ('20121018142542');

INSERT INTO schema_migrations (version) VALUES ('20121019092627');

INSERT INTO schema_migrations (version) VALUES ('20121019125016');

INSERT INTO schema_migrations (version) VALUES ('20121101072002');

INSERT INTO schema_migrations (version) VALUES ('20121101072031');

INSERT INTO schema_migrations (version) VALUES ('20121101074026');

INSERT INTO schema_migrations (version) VALUES ('20121101074125');

INSERT INTO schema_migrations (version) VALUES ('20121101074732');

INSERT INTO schema_migrations (version) VALUES ('20121101075050');

INSERT INTO schema_migrations (version) VALUES ('20121101075109');

INSERT INTO schema_migrations (version) VALUES ('20121101122945');

INSERT INTO schema_migrations (version) VALUES ('20121101131653');

INSERT INTO schema_migrations (version) VALUES ('20121101132249');

INSERT INTO schema_migrations (version) VALUES ('20121101134037');

INSERT INTO schema_migrations (version) VALUES ('20121106081648');

INSERT INTO schema_migrations (version) VALUES ('20121106081931');

INSERT INTO schema_migrations (version) VALUES ('20121106095114');

INSERT INTO schema_migrations (version) VALUES ('20121113102938');

INSERT INTO schema_migrations (version) VALUES ('20121113102948');

INSERT INTO schema_migrations (version) VALUES ('20121113104211');

INSERT INTO schema_migrations (version) VALUES ('20121114095359');

INSERT INTO schema_migrations (version) VALUES ('20121114102617');

INSERT INTO schema_migrations (version) VALUES ('20121119084909');

INSERT INTO schema_migrations (version) VALUES ('20121119085225');

INSERT INTO schema_migrations (version) VALUES ('20121127081438');

INSERT INTO schema_migrations (version) VALUES ('20121127130548');

INSERT INTO schema_migrations (version) VALUES ('20121127131452');

INSERT INTO schema_migrations (version) VALUES ('20121127131815');

INSERT INTO schema_migrations (version) VALUES ('20121129075459');

INSERT INTO schema_migrations (version) VALUES ('20121129094044');

INSERT INTO schema_migrations (version) VALUES ('20121129094910');

INSERT INTO schema_migrations (version) VALUES ('20121129132721');

INSERT INTO schema_migrations (version) VALUES ('20121129134443');

INSERT INTO schema_migrations (version) VALUES ('20121130105811');

INSERT INTO schema_migrations (version) VALUES ('20121130120442');

INSERT INTO schema_migrations (version) VALUES ('20121218072956');

INSERT INTO schema_migrations (version) VALUES ('20121219114742');

INSERT INTO schema_migrations (version) VALUES ('20121219114803');

INSERT INTO schema_migrations (version) VALUES ('20121219114819');

INSERT INTO schema_migrations (version) VALUES ('20121219114844');

INSERT INTO schema_migrations (version) VALUES ('20121219114902');

INSERT INTO schema_migrations (version) VALUES ('20121220110321');

INSERT INTO schema_migrations (version) VALUES ('20121220111329');

INSERT INTO schema_migrations (version) VALUES ('20121220115927');

INSERT INTO schema_migrations (version) VALUES ('20121220134131');

INSERT INTO schema_migrations (version) VALUES ('20121220134222');

INSERT INTO schema_migrations (version) VALUES ('20121220134315');

INSERT INTO schema_migrations (version) VALUES ('20121224094106');

INSERT INTO schema_migrations (version) VALUES ('20121224101652');

INSERT INTO schema_migrations (version) VALUES ('20121224103647');

INSERT INTO schema_migrations (version) VALUES ('20121224110401');

INSERT INTO schema_migrations (version) VALUES ('20121224110433');

INSERT INTO schema_migrations (version) VALUES ('20121224121719');

INSERT INTO schema_migrations (version) VALUES ('20121224122059');

INSERT INTO schema_migrations (version) VALUES ('20121224122131');

INSERT INTO schema_migrations (version) VALUES ('20121224132007');

INSERT INTO schema_migrations (version) VALUES ('20121225101407');

INSERT INTO schema_migrations (version) VALUES ('20121225113103');

INSERT INTO schema_migrations (version) VALUES ('20121225113142');

INSERT INTO schema_migrations (version) VALUES ('20121225114820');

INSERT INTO schema_migrations (version) VALUES ('20121225114924');

INSERT INTO schema_migrations (version) VALUES ('20121225120435');

INSERT INTO schema_migrations (version) VALUES ('20121225120551');

INSERT INTO schema_migrations (version) VALUES ('20121225131405');

INSERT INTO schema_migrations (version) VALUES ('20121225133944');

INSERT INTO schema_migrations (version) VALUES ('20121225134636');

INSERT INTO schema_migrations (version) VALUES ('20130110064011');

INSERT INTO schema_migrations (version) VALUES ('20130110091724');

INSERT INTO schema_migrations (version) VALUES ('20130111073900');

INSERT INTO schema_migrations (version) VALUES ('20130111104355');

INSERT INTO schema_migrations (version) VALUES ('20130111114214');

INSERT INTO schema_migrations (version) VALUES ('20130114091122');

INSERT INTO schema_migrations (version) VALUES ('20130115122701');

INSERT INTO schema_migrations (version) VALUES ('20130117142241');

INSERT INTO schema_migrations (version) VALUES ('20130118103313');

INSERT INTO schema_migrations (version) VALUES ('20130121133202');

INSERT INTO schema_migrations (version) VALUES ('20130122072200');

INSERT INTO schema_migrations (version) VALUES ('20130122090615');

INSERT INTO schema_migrations (version) VALUES ('20130122092446');

INSERT INTO schema_migrations (version) VALUES ('20130122122853');

INSERT INTO schema_migrations (version) VALUES ('20130123080439');

INSERT INTO schema_migrations (version) VALUES ('20130128131409');

INSERT INTO schema_migrations (version) VALUES ('20130201072454');

INSERT INTO schema_migrations (version) VALUES ('20130201100531');

INSERT INTO schema_migrations (version) VALUES ('20130203104627');

INSERT INTO schema_migrations (version) VALUES ('20130203105454');

INSERT INTO schema_migrations (version) VALUES ('20130204064733');

INSERT INTO schema_migrations (version) VALUES ('20130204065259');

INSERT INTO schema_migrations (version) VALUES ('20130204161250');

INSERT INTO schema_migrations (version) VALUES ('20130204164054');

INSERT INTO schema_migrations (version) VALUES ('20130206064714');

INSERT INTO schema_migrations (version) VALUES ('20130206102858');

INSERT INTO schema_migrations (version) VALUES ('20130206105842');

INSERT INTO schema_migrations (version) VALUES ('20130311084434');

INSERT INTO schema_migrations (version) VALUES ('20130311200649');

INSERT INTO schema_migrations (version) VALUES ('20130311200850');

INSERT INTO schema_migrations (version) VALUES ('20130311201010');

INSERT INTO schema_migrations (version) VALUES ('20130311201758');

INSERT INTO schema_migrations (version) VALUES ('20130311201843');

INSERT INTO schema_migrations (version) VALUES ('20130311202019');

INSERT INTO schema_migrations (version) VALUES ('20130311205123');

INSERT INTO schema_migrations (version) VALUES ('20130313124706');

INSERT INTO schema_migrations (version) VALUES ('20130313130642');

INSERT INTO schema_migrations (version) VALUES ('20130313132025');

INSERT INTO schema_migrations (version) VALUES ('20130313150344');

INSERT INTO schema_migrations (version) VALUES ('20130314093949');

INSERT INTO schema_migrations (version) VALUES ('20130314095643');

INSERT INTO schema_migrations (version) VALUES ('20130314104603');

INSERT INTO schema_migrations (version) VALUES ('20130314110526');

INSERT INTO schema_migrations (version) VALUES ('20130314160909');

INSERT INTO schema_migrations (version) VALUES ('20130314164946');

INSERT INTO schema_migrations (version) VALUES ('20130315104808');

INSERT INTO schema_migrations (version) VALUES ('20130315123712');

INSERT INTO schema_migrations (version) VALUES ('20130317110328');

INSERT INTO schema_migrations (version) VALUES ('20130317123746');

INSERT INTO schema_migrations (version) VALUES ('20130318141818');

INSERT INTO schema_migrations (version) VALUES ('20130318144048');

INSERT INTO schema_migrations (version) VALUES ('20130318154555');

INSERT INTO schema_migrations (version) VALUES ('20130319103424');

INSERT INTO schema_migrations (version) VALUES ('20130319115555');

INSERT INTO schema_migrations (version) VALUES ('20130319122504');

INSERT INTO schema_migrations (version) VALUES ('20130320110257');

INSERT INTO schema_migrations (version) VALUES ('20130320110313');

INSERT INTO schema_migrations (version) VALUES ('20130320110333');

INSERT INTO schema_migrations (version) VALUES ('20130321211250');

INSERT INTO schema_migrations (version) VALUES ('20130322105101');

INSERT INTO schema_migrations (version) VALUES ('20130322110354');

INSERT INTO schema_migrations (version) VALUES ('20130322114230');

INSERT INTO schema_migrations (version) VALUES ('20130322175729');

INSERT INTO schema_migrations (version) VALUES ('20130322191037');

INSERT INTO schema_migrations (version) VALUES ('20130325084633');

INSERT INTO schema_migrations (version) VALUES ('20130325091221');

INSERT INTO schema_migrations (version) VALUES ('20130327110703');

INSERT INTO schema_migrations (version) VALUES ('20130327111631');

INSERT INTO schema_migrations (version) VALUES ('20130327111705');

INSERT INTO schema_migrations (version) VALUES ('20130327112053');

INSERT INTO schema_migrations (version) VALUES ('20130328103003');

INSERT INTO schema_migrations (version) VALUES ('20130329092947');

INSERT INTO schema_migrations (version) VALUES ('20130329121747');

INSERT INTO schema_migrations (version) VALUES ('20130330084831');

INSERT INTO schema_migrations (version) VALUES ('20130330114633');

INSERT INTO schema_migrations (version) VALUES ('20130401152216');

INSERT INTO schema_migrations (version) VALUES ('20130402085345');

INSERT INTO schema_migrations (version) VALUES ('20130402130115');

INSERT INTO schema_migrations (version) VALUES ('20130402131727');

INSERT INTO schema_migrations (version) VALUES ('20130402132017');

INSERT INTO schema_migrations (version) VALUES ('20130402132742');

INSERT INTO schema_migrations (version) VALUES ('20130402143606');

INSERT INTO schema_migrations (version) VALUES ('20130402144113');

INSERT INTO schema_migrations (version) VALUES ('20130403094201');

INSERT INTO schema_migrations (version) VALUES ('20130403104341');

INSERT INTO schema_migrations (version) VALUES ('20130404092852');

INSERT INTO schema_migrations (version) VALUES ('20130405095915');

INSERT INTO schema_migrations (version) VALUES ('20130405100052');

INSERT INTO schema_migrations (version) VALUES ('20130408162625');

INSERT INTO schema_migrations (version) VALUES ('20130408162636');

INSERT INTO schema_migrations (version) VALUES ('20130408162647');

INSERT INTO schema_migrations (version) VALUES ('20130411141030');

INSERT INTO schema_migrations (version) VALUES ('20130412065947');

INSERT INTO schema_migrations (version) VALUES ('20130412133953');