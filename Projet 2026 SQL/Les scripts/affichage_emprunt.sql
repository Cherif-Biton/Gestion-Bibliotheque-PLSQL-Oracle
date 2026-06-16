SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT    EMPRUNTS EN COURS
PROMPT ================================
BEGIN
    affichage_emprunt;
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql