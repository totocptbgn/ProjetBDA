-- SET DATESTYLE TO DMY

\COPY Artist (name,firstname,birthdate) FROM 'CREATION/CSV/artist.csv' DELIMITER ',' CSV HEADER;
-- 2000

\COPY Agent (name, firstname, birthdate) FROM 'CREATION/CSV/agent.csv' DELIMITER ',' CSV HEADER;
-- 1000

\COPY Producer (name, firstname, birthdate) FROM 'CREATION/CSV/producer.csv' DELIMITER ',' CSV HEADER;
-- 800

\COPY Agent_contract (id_artist, id_agent, agent_fee, start_date, end_date) FROM 'CREATION/CSV/agent_contract.csv' DELIMITER ',' CSV HEADER;
-- 800

\COPY Producer_contract (id_artist, id_producer, bonus_fee, start_date, end_date) FROM 'CREATION/CSV/producer_contract.csv' DELIMITER ',' CSV HEADER;
-- 400

\COPY Casting (description) FROM 'CREATION/CSV/casting.csv' DELIMITER '|' CSV HEADER;
-- 70

\COPY Amendment (id_contract, attr, old_value, new_value, date) FROM 'CREATION/CSV/amendment.csv' DELIMITER ',' CSV HEADER;
-- 100

\COPY Claim (id_contract_agent, id_contract_producer, due_date, value) FROM 'CREATION/CSV/claim.csv' DELIMITER ',' CSV HEADER;
-- 100

\COPY Payment (id_claim, value, date) FROM 'CREATION/CSV/payment.csv' DELIMITER ',' CSV HEADER;
-- 150

\COPY Skill (type, description) FROM 'CREATION/CSV/skill.csv' DELIMITER ',' CSV HEADER;
-- 70

\COPY People_skill (id_artist, id_skill) FROM 'CREATION/CSV/people_skill.csv' DELIMITER ',' CSV HEADER;
-- 3000

\COPY Skill_needed (id_casting, id_skill) FROM 'CREATION/CSV/skill_needed.csv' DELIMITER ',' CSV HEADER;
-- 100

\COPY Rejected (id_casting, id_artist) FROM 'CREATION/CSV/rejected.csv' DELIMITER ',' CSV HEADER;
-- 500
