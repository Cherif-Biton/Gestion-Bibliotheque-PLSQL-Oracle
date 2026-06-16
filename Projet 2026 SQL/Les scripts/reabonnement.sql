SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT         REABONNEMENT
PROMPT ================================
ACCEPT p_id PROMPT 'ID de l''abonne svp : '
BEGIN
    reabonnement('&p_id');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql