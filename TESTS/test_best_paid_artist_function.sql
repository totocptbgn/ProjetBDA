\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction best_paid_artist ] --------------------"
\! echo
\! echo "Quel est l'artiste le mieux payé actuellement par l'agence ?"
\! echo
SELECT * FROM best_paid_artist();