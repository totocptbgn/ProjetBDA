# Projet_BDA

>Projet de M1 en Bases de Données Avancées.

Mise en place d'une base de données pour une agence artistique. Fait sous Postgre SQL version 14.2.

### Mise en place de la BD :

```sql
-- Créer les tables :
\i CREATION/create_all.sql

-- Générer les CSV :
\! sh CREATION/SCRIPTS/generate_all_csv.sh

-- Remplir les tables avec les CSV :
\i CREATION/insert_data.sql

-- Ajouter les triggers :
\i CREATION/create_triggers.sql

-- Ajouter les fonctions :
\i CREATION/create_functions.sql
```

### Script de tests :

```sql
--- Test du trigger amendment_trigger :
\i TESTS/test_amendment_trigger.sql

--- Test du trigger payment_trigger :
\i TESTS/test_payment_trigger.sql

--- Test des fonctions show :
\i TESTS/test_show_functions.sql

--- Test de la fonction cancel_amendment :
\i TESTS/test_cancel_amendment_function.sql

--- Test de la fonction best_paid_artist :
\i TESTS/test_best_paid_artist_function.sql

--- Test de la fonction gain_year_agency :
\i TESTS/test_gain_year_function.sql

-- Test de la fonction all_claim_paid :
\i TESTS/test_all_claim_paid_function.sql

-- Test de la fonction test_get_potential_candidate :
\i TESTS/test_get_potential_candidates_function.sql

-- Test des fonctions average_fee :
\i TESTS/test_average_fee_functions.sql

-- Test de la fonction top_skills
\i TESTS/test_top_skills_function.sql
```

#### Problème de datestyle

```sql
SET DATESTYLE TO DMY;
```