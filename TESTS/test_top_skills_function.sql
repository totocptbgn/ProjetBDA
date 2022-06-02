\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction top_skills ] --------------------"
\! echo
\! echo "Quel est le top 5 des skills le 16 mars 2019 ?"
\! echo
SELECT * FROM top_skills('2019-03-16', 5);
\! echo
\! echo "Quel est le top 3 des skills le 9 juin 2010 ?"
\! echo
SELECT * FROM top_skills('2010-06-09', 3);
