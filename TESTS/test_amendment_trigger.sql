\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test du trigger amendment_trigger ] --------------------"
\! echo
\! echo "Contrat avec id = 1 :"
\! echo

SELECT * 
FROM Producer_contract
WHERE id_contract = 1;

\! echo
\! echo "Fin de la table Amendment : "
\! echo

SELECT * 
FROM Amendment 
ORDER BY id_amendment DESC
LIMIT 5;

\! echo
\! echo Execution de : UPDATE Producer_contract SET bonus_fee = 3.14 WHERE id_contract = 1;

UPDATE Producer_contract SET bonus_fee = 3.14 WHERE id_contract = 1;

\! echo
\! echo "La table Producer_contract a été mise à jour : "
\! echo

SELECT * 
FROM Producer_contract
WHERE id_contract = 1;

\! echo
\! echo "La table Amendment a été mise à jour : "
\! echo

SELECT * 
FROM Amendment 
ORDER BY id_amendment DESC
LIMIT 5;