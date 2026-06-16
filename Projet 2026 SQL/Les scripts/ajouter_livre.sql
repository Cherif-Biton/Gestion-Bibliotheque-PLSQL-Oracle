SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT       AJOUT D_UN LIVRE
PROMPT ================================
ACCEPT p_titre  PROMPT 'Titre du livre svp : '
ACCEPT p_auteur PROMPT 'Auteur         svp : '
BEGIN
    ajout_livre('&p_titre', '&p_auteur');
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql