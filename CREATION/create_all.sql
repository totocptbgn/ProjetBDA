DROP TABLE IF EXISTS Producer CASCADE;
DROP TABLE IF EXISTS Artist CASCADE;
DROP TABLE IF EXISTS Agent CASCADE;
DROP TABLE IF EXISTS Skill CASCADE;
DROP TABLE IF EXISTS People_skill CASCADE;
DROP TABLE IF EXISTS Casting CASCADE;
DROP TABLE IF EXISTS Skill_needed CASCADE;
DROP TABLE IF EXISTS Rejected CASCADE;
DROP TABLE IF EXISTS Agent_Contract CASCADE;
DROP TABLE IF EXISTS Producer_contract CASCADE;
DROP TABLE IF EXISTS Amendment CASCADE;
DROP TABLE IF EXISTS Claim CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TYPE IF EXISTS Skill_type;
DROP TYPE IF EXISTS Prod_contract_col;

CREATE TABLE Producer
(
    id_producer SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    firstname VARCHAR(40) NOT NULL,
    birthdate DATE NOT NULL
);

CREATE TABLE Artist
(
    id_artist SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    firstname VARCHAR(40) NOT NULL,
    birthdate DATE NOT NULL
);

CREATE TABLE Agent
(
    id_agent SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    firstname VARCHAR(40) NOT NULL,
    birthdate DATE NOT NULL
);

CREATE TYPE Skill_type AS ENUM ('language', 'instrument', 'job', 'formation');

CREATE TABLE Skill
(
    id_skill SERIAL PRIMARY KEY,
    type Skill_type NOT NULL,
    description VARCHAR(100) NOT NULL
);

CREATE TABLE People_skill
(
    id_artist INT REFERENCES Artist(id_artist),
    id_skill INT REFERENCES Skill(id_skill),
    PRIMARY KEY(id_artist,id_skill)
);

CREATE TABLE Casting
(
    id_casting SERIAL PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE Skill_needed
(
    id_casting INT REFERENCES Casting(id_casting),
    id_skill INT REFERENCES Skill(id_skill),
    PRIMARY KEY(id_casting,id_skill)
);

CREATE TABLE Rejected
(
    id_casting INT REFERENCES Casting(id_casting),
    id_artist INT REFERENCES Artist(id_artist),
    PRIMARY KEY(id_casting,id_artist)
);

CREATE TABLE Agent_Contract
(
    id_contract SERIAL PRIMARY KEY,
    id_artist INT REFERENCES Artist(id_artist),
    id_agent INT REFERENCES Agent(id_agent),
    agent_fee NUMERIC(4,2),
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE Producer_contract
(
    id_contract SERIAL PRIMARY KEY,
    id_artist  INT REFERENCES Artist(id_artist),
    id_producer INT REFERENCES Producer(id_producer),
    bonus_fee NUMERIC(4,2),
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TYPE Prod_contract_col AS ENUM ('bonus_fee', 'end_date');

CREATE TABLE Amendment
(
    id_amendment SERIAL PRIMARY KEY,
    id_contract INT REFERENCES Producer_contract(id_contract),
    attr Prod_contract_col NOT NULL,
    old_value  VARCHAR(20)NOT NULL,
    new_value VARCHAR(20) NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE Claim
(
    id_claim SERIAL PRIMARY KEY,
    id_contract_agent INT REFERENCES Agent_Contract(id_contract),
    id_contract_producer INT REFERENCES Producer_contract(id_contract),
    due_date DATE NOT NULL,
    value NUMERIC(10,2) NOT NULL
);

CREATE TABLE Payment
(
    id_payment SERIAL PRIMARY KEY,
    id_claim  INT REFERENCES Claim(id_claim),
    value NUMERIC(10,2) NOT NULL,
    date DATE NOT NULL
);
