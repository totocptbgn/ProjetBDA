\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction gain_year_agency(year INT) ] --------------------"
\! echo
\! echo "Combien l'agence a-t-elle gagné en 2020?"
\! echo "SELECT * FROM gain_year_agency(2020);"
\! echo

SELECT * FROM gain_year_agency(2020);


\! echo
\! echo "Combien l'agence a-t-elle gagné en 2016?"
\! echo "SELECT * FROM gain_year_agency(2016);"
\! echo

SELECT * FROM gain_year_agency(2016);