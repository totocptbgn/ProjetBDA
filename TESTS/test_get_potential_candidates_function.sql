\i CREATION/create_all.sql
\i CREATION/insert_data.sql
\i CREATION/create_triggers.sql
\i CREATION/create_functions.sql

\! clear
\! echo "-------------------- [ Test de la fonction get_potential_candidates ] --------------------"
\! echo

\! echo
\! echo "Liste des candidats acceptables pour le casting 2 :"
\! echo "SELECT get_potential_candidates(2);"
\! echo
SELECT get_potential_candidates(2);

\! echo
\! echo "Liste des candidats acceptables pour le casting 4 :"
\! echo "SELECT get_potential_candidates(4);"
\! echo
SELECT get_potential_candidates(4);

\! echo
\! echo "Liste des skills necessaire pour le casting 4 :"
\! echo "SELECT * FROM Skill_needed WHERE id_casting = 4;"
\! echo
SELECT * FROM Skill_needed WHERE id_casting = 4;

\! echo 
\! echo "Quelques artistes ayant le skill 2 :"
\! echo "SELECT * FROM People_skill WHERE id_skill = 2 ORDER BY id_artist LIMIT 5;"
\! echo
SELECT * FROM People_skill WHERE id_skill = 2 ORDER BY id_artist LIMIT 5;

\! echo
\! echo "On ajoute le skill 40 au artistes 8 et 12 :"
\! echo "INSERT INTO People_skill (id_artist, id_skill) VALUES (8, 40), (12, 40);"
INSERT INTO People_skill (id_artist, id_skill) VALUES (8, 40), (12, 40);

\! echo
\! echo "Ils apparaissent désormais dans les candidats potentiels :"
\! echo "SELECT get_potential_candidates(4);"
\! echo
SELECT get_potential_candidates(4); 

\! echo
\! echo "On ne veut pas de l'artiste 8, on l'ajoute à la table Rejected :"
\! echo "INSERT INTO Rejected (id_casting, id_artist) VALUES (4, 8);"
INSERT INTO Rejected (id_casting, id_artist) VALUES (4, 8);

\! echo
\! echo "L'artiste 8 n'apparait donc plus dans les candidats potentiels :"
\! echo "SELECT get_potential_candidates(4);"
\! echo
SELECT get_potential_candidates(4);