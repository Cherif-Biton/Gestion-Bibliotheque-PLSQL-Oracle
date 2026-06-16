SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT     DESABONNEMENT
PROMPT ================================
ACCEPT p_id    PROMPT 'ID de l''abonne svp  : '
ACCEPT p_motif PROMPT 'Motif du desabonnement : '
BEGIN
    desabonne('&p_id', '&p_motif');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql