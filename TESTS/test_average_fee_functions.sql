\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test des fonctions average_fee_functions ] --------------------"
\! echo


\! echo "SELECT average_agent_fee('23/10/2017');"
SELECT average_agent_fee('23/10/2017');

\! echo
\! echo "SELECT average_agent_fee('23/10/2020');"
SELECT average_agent_fee('23/10/2020');

\! echo
\! echo "SELECT average_bonus_fee('23/10/2017');"
SELECT average_bonus_fee('23/10/2017');

\! echo
\! echo "SELECT average_bonus_fee('23/10/2020');"
SELECT average_bonus_fee('23/10/2020');