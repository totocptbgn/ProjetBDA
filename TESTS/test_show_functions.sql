\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test des fonctions show ] --------------------"
\! echo

\! echo "SELECT show_artist_skills(212);"
SELECT show_artist_skills(212);

\! echo
\! echo "SELECT show_contracted_artist('23/10/2010') ORDER BY random() LIMIT 10;"
SELECT show_contracted_artist('23/05/2010') ORDER BY random() LIMIT 10;


\! echo
\! echo "SELECT show_contracted_artist_today() ORDER BY random() LIMIT 10;"
SELECT show_contracted_artist_today() ORDER BY random() LIMIT 10;


\! echo
\! echo "SELECT show_contracted_agents('23/10/2010') ORDER BY random() LIMIT 10;"
SELECT show_contracted_agents('23/05/2010') ORDER BY random() LIMIT 10;


\! echo
\! echo "SELECT show_contracted_agents_today() ORDER BY random() LIMIT 10;"
SELECT show_contracted_agents_today() ORDER BY random() LIMIT 10;