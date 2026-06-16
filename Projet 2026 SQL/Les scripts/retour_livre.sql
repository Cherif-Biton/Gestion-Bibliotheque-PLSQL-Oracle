SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT       RETOUR D_UN LIVRE
PROMPT ================================
ACCEPT p_id_liv    PROMPT 'ID du livre      svp : '
ACCEPT p_id_abonne PROMPT 'ID de l''abonne svp : '
BEGIN
    retour_livre('&p_id_liv', '&p_id_abonne');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql