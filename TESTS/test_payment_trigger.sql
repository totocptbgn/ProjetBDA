\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test du trigger payment_trigger ] --------------------"
\! echo

\! echo "INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value) VALUES (173, 173, '23/10/2022', 1000.00);"

INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value)
VALUES (173, 173, '23/10/2022', 1000.00);

\! echo
\! echo "Fin de la table Claim : "
\! echo

SELECT *
FROM Claim
ORDER BY id_claim DESC
LIMIT 5;

\! echo
\! echo "Fin de la table Payment : "
\! echo

SELECT *
FROM Payment
ORDER BY id_payment DESC
LIMIT 5;

\! echo
\! echo "INSERT INTO Payment (id_claim, value) VALUES (101, 250.00);"
INSERT INTO Payment (id_claim, value) VALUES (101, 250.00);

\! echo
\! echo "INSERT INTO Payment (id_claim, value) VALUES (101, 500.00);"
INSERT INTO Payment (id_claim, value) VALUES (101, 500.00);

\! echo
\! echo "INSERT INTO Payment (id_claim, value) VALUES (101, 250.00);"
INSERT INTO Payment (id_claim, value) VALUES (101, 250.00);

\! echo
\! echo "Fin de la table Payment : "
\! echo

SELECT *
FROM Payment
ORDER BY id_payment DESC
LIMIT 5;