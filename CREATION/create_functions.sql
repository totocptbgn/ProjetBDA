---- Affiche les skills d'un artist à partir de son id
CREATE OR REPLACE FUNCTION show_artist_skills (aid INT) RETURNS TABLE (description VARCHAR(100)) AS $$
BEGIN
    FOR description IN
        SELECT Skill.description
        FROM People_skill
        JOIN Skill ON People_skill.id_skill = Skill.id_skill
        WHERE People_skill.id_artist = aid
    LOOP
        RETURN NEXT;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;



---- Affiche les noms des artists ayant un contrat avec un agent à la date donnée

CREATE OR REPLACE FUNCTION show_contracted_artist(d DATE) RETURNS TABLE (firstname VARCHAR(40), name VARCHAR(40)) AS $$
BEGIN
    RETURN QUERY SELECT DISTINCT Artist.firstname, Artist.name
    FROM Agent_Contract
    JOIN Artist ON Agent_Contract.id_artist = Artist.id_artist
    WHERE Agent_Contract.start_date <= d
    AND (Agent_Contract.end_date >= d OR Agent_Contract.end_date IS NULL);
END;
$$ LANGUAGE plpgsql;



---- Affiche les noms des artists ayant un contrat avec un agent aujourd'hui

CREATE OR REPLACE FUNCTION show_contracted_artists_today() RETURNS TABLE (firstname VARCHAR(40), name VARCHAR(40)) AS $$
BEGIN
    RETURN QUERY SELECT * FROM show_contracted_artists(CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;



---- Calcule les revenus d'un artiste à partir de son id

CREATE OR REPLACE FUNCTION gain_artist(id INT) RETURNS NUMERIC(10,2) AS $$
DECLARE
    result NUMERIC(10,2) := 0;
    gain NUMERIC(10,2);
    contrats RECORD;
BEGIN
    FOR contrats IN
        SELECT *
        FROM Agent_Contract 
        WHERE id_artist = id
    LOOP
        SELECT value INTO gain FROM claim WHERE contrats.id_contract = claim.id_contract_agent;
        result := result + gain;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;



---- Affiche l'artiste le mieux payé en contrat actuel avec l'agence

CREATE OR REPLACE FUNCTION best_paid_artist() RETURNS VOID AS $$
DECLARE
    artists RECORD;
    max NUMERIC(10,2) := 0;
    gain NUMERIC(10,2) := 0;
    res_name VARCHAR(40);
    res_firstname VARCHAR(40);
BEGIN
    FOR artists IN
        SELECT Artist.id_artist, Artist.firstname, Artist.name 
        FROM Agent_Contract
        JOIN Artist ON Agent_Contract.id_artist = Artist.id_artist
        WHERE Agent_Contract.start_date <= CURRENT_DATE
        AND (Agent_Contract.end_date >= CURRENT_DATE OR Agent_Contract.end_date IS NULL)
    LOOP
        SELECT * INTO gain from gain_artist(artists.id_artist);
        IF gain > max THEN
            res_firstname := artists.firstname;
            res_name := artists.name;
            max := gain;
        END IF;
    END LOOP;
    RAISE NOTICE 'L`artiste le mieux payé est % % avec un total de % €.', res_firstname, res_name, max;
    RETURN;
END;
$$ LANGUAGE plpgsql;



---- Affiche les noms des agents ayant un contrat avec un artiste à la date donnée

CREATE OR REPLACE FUNCTION show_contracted_agents(d DATE) RETURNS TABLE (firstname VARCHAR(40), name VARCHAR(40)) AS $$
BEGIN
    RETURN QUERY SELECT DISTINCT Agent.firstname, Agent.name
    FROM Agent_Contract
    JOIN Agent ON Agent_Contract.id_agent = Agent.id_agent
    WHERE Agent_Contract.start_date <= d
    AND (Agent_Contract.end_date >= d OR Agent_Contract.end_date IS NULL);
END;
$$ LANGUAGE plpgsql;



---- Affiche les noms des agents ayant un contrat avec un artiste aujourd'hui

CREATE OR REPLACE FUNCTION show_contracted_agents_today() RETURNS TABLE (firstname VARCHAR(40), name VARCHAR(40)) AS $$
BEGIN
    RETURN QUERY SELECT * FROM show_contracted_agents(CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;



---- Annule un amendement en effectuant l'opération inverse. (Le supprime aussi de la table Amendment).

CREATE OR REPLACE FUNCTION cancel_amendment(id INT) RETURNS VOID AS $$
DECLARE
    a Amendment;
    lv INT;
BEGIN
    -- On récupère les valeurs de l'Amendment
    SELECT * INTO a FROM Amendment WHERE Amendment.id_amendment = id;

    -- On update la table Producer_contract
    IF a.attr = 'bonus_fee' THEN
        UPDATE Producer_contract SET bonus_fee = (a.old_value::NUMERIC(4,2)) WHERE Producer_contract.id_contract = a.id_contract;
    ELSEIF  a.attr = 'end_date' THEN
        UPDATE Producer_contract SET end_date = (a.old_value::DATE) WHERE Producer_contract.id_contract = a.id_contract;
    END IF;

    -- On supprime l'amendment
    DELETE FROM Amendment WHERE Amendment.id_amendment = a.id_amendment;

    -- On récupère la dernière valeur d'id
    SELECT last_value INTO lv FROM amendment_id_amendment_seq; 

    -- On supprime l'amendment généré par la modification de la table 
    DELETE FROM Amendment WHERE Amendment.id_amendment = lv;

    -- On modifie la valeur du compteur d'id pour la table Amendment pour conserver la continuité des IDs
    SELECT setval('amendment_id_amendment_seq', lv - 1) INTO lv;

    -- On affiche un message pour confirmer l'opération
    RAISE NOTICE 'L`amendment % a été annulé (%, %, %).', a.id_amendment, a.attr, a.old_value, a.new_value;

    RETURN;
END;
$$ LANGUAGE plpgsql;



----- Renvoie combien l'agence a gagné pour un paiment donné

CREATE OR REPLACE FUNCTION gain_agence(id int) RETURNS NUMERIC(10,2) AS $$
DECLARE
    c INT;
    a INT;
    f NUMERIC(4,2);
    result NUMERIC(10,2);
BEGIN
    -- On va déjà chercher l'id du contrat via la table claim
    SELECT id_claim INTO c FROM payment WHERE id_payment=id;
    SELECT id_contract_agent INTO a FROM claim WHERE id_claim=c;

    -- On récupère maintenant la commission de l'agent
    SELECT agent_fee INTO f FROM agent_contract WHERE id_contract=a;

    -- Et enfin, on calcul le gain de l'agent avec le paiment et la commission
    SELECT f*payment.value/100 INTO result
    FROM payment
    WHERE payment.id_payment=id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;



---- Fonction qui calcule le gain d'une agence pour une année donnée

CREATE OR REPLACE FUNCTION gain_year_agency(year INT) RETURNS NUMERIC(10,2) AS $$
DECLARE
    ligne RECORD;
    gain NUMERIC(10,2);
    result NUMERIC(10,2) := 0;
BEGIN
    FOR ligne IN 
        SELECT *
        FROM payment 
        WHERE date_part('year',date)=year
    LOOP
        SELECT * INTO gain FROM gain_agence(ligne.id_payment);
        result := result + gain;
    END LOOP;
    RAISE NOTICE 'L`agence a gagné % € l`année %.', result, year;
    RETURN result;
END;
$$ LANGUAGE plpgsql;



---- Renvoie la liste des candidats qui ont les skills necessaires pour le casting et qui ne sont pas déjà rejetés.

CREATE OR REPLACE FUNCTION get_potential_candidates(id INT) RETURNS SETOF Artist AS $$
DECLARE
    r RECORD;
    s RECORD;
    bool INT := 0;
BEGIN
    -- On créer une table temporaire pour stocker des artistes
    CREATE TEMPORARY TABLE temp_candidates (
        id_artist INT
    );

    -- On boucle sur tout les skills requis pour le casting
    FOR r IN 
        SELECT *
        FROM Skill_needed
        WHERE Skill_needed.id_casting = id
    LOOP
        -- Pour le premier skill, on rempli la table temporaire avec les artistes ayant le premier skill demandé
        IF bool = 0 THEN
            FOR s IN
                SELECT *
                FROM People_skill
                WHERE People_skill.id_skill = r.id_skill
            LOOP
                INSERT INTO temp_candidates(id_artist) VALUES (s.id_artist);
            END LOOP;
            bool := 1;

        -- Pour les autres skills, on retire de la table temporaire les artistes ayant
        ELSE
            FOR s IN
                SELECT DISTINCT People_skill.id_artist
                FROM People_skill
                WHERE People_skill.id_artist NOT IN 
                (SELECT DISTINCT People_skill.id_artist
                 FROM People_skill
                 WHERE People_skill.id_skill = r.id_skill)
                AND People_skill.id_artist IN (SELECT * FROM temp_candidates)
            LOOP
                DELETE FROM temp_candidates WHERE temp_candidates.id_artist = s.id_artist;
            END LOOP;
        END IF;
    END LOOP;

    -- On renvoie la liste des artises en enlevant ceux qui sont dans Rejected
    RETURN QUERY SELECT Artist.id_artist, Artist.name, Artist.firstname, Artist.birthdate
    FROM Artist
    JOIN temp_candidates 
    ON Artist.id_artist = temp_candidates.id_artist
    WHERE Artist.id_artist NOT IN (SELECT Rejected.id_artist FROM Rejected WHERE Rejected.id_casting = id);

    -- On drop la table temporaire
    DROP TABLE temp_candidates;
END;
$$ LANGUAGE plpgsql;



---- Fonction qui check si un Claim a bien été payé entièrement

CREATE OR REPLACE FUNCTION claim_paid(id INT) RETURNS VOID AS $$
DECLARE
    total NUMERIC(10,2) :=0;
    du NUMERIC(10,2);
    reste NUMERIC(10,2);
    paiment RECORD;
BEGIN
    SELECT value INTO du FROM claim WHERE id_claim = id;
    FOR paiment IN
        SELECT *
        FROM payment
        WHERE id_claim = id
    LOOP
        total := total + paiment.value;
    END LOOP;
    IF total > du THEN
        reste := total - du;
        RAISE NOTICE 'Erreur dans les comptes,trop-payé de % euros pour le claim : %',reste,id;
        RETURN;
    ELSEIF total = du THEN
        RETURN;
    ELSE
        reste := du - total;
        RAISE NOTICE 'Il reste % euros à payé pour le claim : %',reste,id;
        RETURN;
    END IF;
END;
$$ LANGUAGE plpgsql;



---- Fonction qui check si les paiements ont bien été effectués

CREATE OR REPLACE FUNCTION all_claim_paid() RETURNS VOID as $$
DECLARE
    c RECORD;
BEGIN
    FOR c IN
        SELECT * 
        FROM claim
    LOOP
        PERFORM claim_paid(c.id_claim);
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;



---- Fonction qui calcule les top K skills qui apparaissent le plus chez les artistes contractés à la date d

CREATE OR REPLACE FUNCTION top_skills(d DATE, k INT) RETURNS  TABLE (description VARCHAR(100), nombres bigint)  AS $$
BEGIN
    RETURN QUERY
    SELECT Skill.description, COUNT(People_skill.id_skill) AS cnt
    FROM People_skill
    JOIN Skill On People_skill.id_skill = Skill.id_skill
    WHERE People_skill.id_skill IN
    (SELECT DISTINCT Artist.id_artist
        FROM Agent_Contract
        JOIN Artist ON Agent_Contract.id_artist = Artist.id_artist
        WHERE Agent_Contract.start_date <= d
        AND (Agent_Contract.end_date >= d OR Agent_Contract.end_date IS NULL)) AND Skill.type <> 'language'
    GROUP BY Skill.description
    ORDER BY cnt DESC LIMIT k;
END;
$$ LANGUAGE plpgsql;



---- Fonction qui calcule les moyennes des agent_fee à une date donnée

CREATE OR REPLACE FUNCTION average_agent_fee(d DATE) RETURNS VOID AS $$
DECLARE
    res NUMERIC(6,3);
BEGIN
    SELECT AVG(Agent_Contract.agent_fee) INTO res
    FROM Agent_Contract
    WHERE Agent_Contract.start_date <= d
    AND (Agent_Contract.end_date >= d OR Agent_Contract.end_date IS NULL); 

    RAISE NOTICE 'La moyenne des agent_fee de l`agence le % est de % %.', d, res, '%';
END;
$$ LANGUAGE plpgsql;



---- Fonction qui calcule les moyennes des bonus_fee à une date donnée

CREATE OR REPLACE FUNCTION average_bonus_fee(d DATE) RETURNS VOID AS $$
DECLARE
    res NUMERIC(6,3);
BEGIN
    SELECT AVG(Producer_contract.bonus_fee) INTO res
    FROM Producer_contract
    WHERE Producer_contract.start_date <= d
    AND (Producer_contract.end_date >= d OR Producer_contract.end_date IS NULL); 

    RAISE NOTICE 'La moyenne des bonus_fee des artistes le % est de % %.', d, res, '%';
END;
$$ LANGUAGE plpgsql;
