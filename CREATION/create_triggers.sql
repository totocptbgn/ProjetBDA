---- Trigger qui créer un amendment lorsque l'on modifie un contrat Artist-Producer
CREATE OR REPLACE FUNCTION make_amendment() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.bonus_fee <> OLD.bonus_fee THEN
    	INSERT INTO Amendment (id_contract, attr, old_value, new_value, date) VALUES (NEW.id_contract, 'bonus_fee', OLD.bonus_fee, NEW.bonus_fee, CURRENT_TIMESTAMP);
    ELSEIF NEW.end_date <> OLD.end_date THEN
        INSERT INTO Amendment (id_contract, attr, old_value, new_value, date) VALUES (NEW.id_contract, 'end_date', OLD.end_date, NEW.end_date, CURRENT_TIMESTAMP);
    END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER amendment_trigger
AFTER UPDATE ON Producer_contract
FOR EACH ROW EXECUTE PROCEDURE make_amendment();



---- Trigger qui annonce combien d'argent il reste à payer quand on ajoute un payment
CREATE OR REPLACE FUNCTION pay() RETURNS TRIGGER AS $$
DECLARE
    total_claim INT;
    paid_total INT;
BEGIN
    SELECT Claim.value INTO total_claim
    FROM Claim
    WHERE Claim.id_claim = NEW.id_claim;

    SELECT SUM(Payment.value) INTO paid_total
    FROM Payment
    WHERE Payment.id_claim = NEW.id_claim;

    IF paid_total IS NULL THEN
        paid_total := 0;
    END IF;

    paid_total := paid_total + NEW.value;

    NEW.date = CURRENT_DATE;
    
    IF paid_total >= total_claim THEN
        RAISE NOTICE 'Vous avez payé l`entièreté du Claim.';
    ELSE
        RAISE NOTICE 'Il reste % € à verser pour payer le Claim entièrement.', (total_claim - paid_total);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER payment_trigger
BEFORE INSERT ON Payment
FOR EACH ROW EXECUTE PROCEDURE pay();