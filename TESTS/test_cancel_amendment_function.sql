\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction cancel_amendment ] --------------------"
\! echo

\! echo "Contrat avec id = 1 mis à jour :"
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
\! echo "SELECT cancel_amendment(100);"
SELECT cancel_amendment(100);

\! echo
\! echo "Fin de la table Amendment sans l'amendment 100 qui a été annulé : "
\! echo

SELECT * 
FROM Amendment 
ORDER BY id_amendment DESC
LIMIT 5;

\! echo
\! echo "La séquence à été modifiée pour cacher le faite qu'un amendment a été créé puis supprimé."
\! echo "La prochaine insertion devrait donc être à 101 :"
\! echo "UPDATE Producer_contract SET bonus_fee = 3.14 WHERE id_contract = 1;"
UPDATE Producer_contract SET bonus_fee = 3.14 WHERE id_contract = 1;

\! echo
\! echo "La table Amendment : "
\! echo

SELECT * 
FROM Amendment 
ORDER BY id_amendment DESC
LIMIT 5;
