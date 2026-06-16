SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT ================================
PROMPT       LISTE DES ABONNES
PROMPT ================================
BEGIN
    affichage_abonne;
END;
/

PROMPT    Appuyer sur entrer pour continuer
Pause

@Menu.sql