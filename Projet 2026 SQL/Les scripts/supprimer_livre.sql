SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT     RETRAIT D_UN LIVRE
PROMPT ================================
ACCEPT p_id    PROMPT 'ID du livre svp : '
ACCEPT p_motif PROMPT 'Motif du retrait : '
BEGIN
    supprimer_livre('&p_id', '&p_motif');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql