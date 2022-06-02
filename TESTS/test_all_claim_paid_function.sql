\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction all_claim_paid ] --------------------"
\! echo
\! echo "Est-ce qu'il reste des paiements à effectuer? Si non, rien, si oui, afficher les paiements"
\! echo


\! echo "SELECT * FROM all_claim_paid();"
SELECT * FROM all_claim_paid();

\! echo
\! echo "INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value) VALUES (173, 173, '23/10/2022', 1000.00);"
\! echo "INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value) VALUES (173, 173, '23/10/2022', 750.00);"
INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value) VALUES (173, 173, '23/10/2022', 1000.00);
INSERT INTO Claim (id_contract_agent, id_contract_producer, due_date, value) VALUES (173, 173, '23/10/2022', 750.00);


\! echo
\! echo "SELECT * FROM all_claim_paid();"
SELECT * FROM all_claim_paid();
