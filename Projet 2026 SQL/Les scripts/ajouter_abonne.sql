SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT       AJOUT D_UN ABONNE
PROMPT ================================
ACCEPT p_nom    PROMPT 'Nom de l''abonne    svp : '
ACCEPT p_prenom PROMPT 'Prenom de l''abonne svp : '
BEGIN
    ajout_abonne('&p_nom', '&p_prenom');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql