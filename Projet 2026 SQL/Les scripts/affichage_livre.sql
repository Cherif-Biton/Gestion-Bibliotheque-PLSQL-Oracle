SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT    AFFICHAGE DES LIVRES DISPONIBLES
PROMPT ================================
BEGIN
    affichage_livre;
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql