SET VERIFY OFF
SET SERVEROUTPUT ON
SET ESCAPE ON
SET ESCAPE ON

cl screen

PROMPT
PROMPT    ***********************************************************
PROMPT    *                                                         *
PROMPT    *       BIENVENUE A LA BIBLIOTHEQUE UNIVERSITAIRE         *
PROMPT    *                                                         *
PROMPT    ***********************************************************
PROMPT    *                                                         *
PROMPT    *   1.  Ajouter un livre                                  *
PROMPT    *   2.  Ajouter un abonne                                 *
PROMPT    *   3.  Emprunter un livre                                *
PROMPT    *   4.  Retourner un livre                                *
PROMPT    *   5.  Afficher les livres disponibles                   *
PROMPT    *   6.  Afficher les emprunts en cours                    *
PROMPT    *   7.  Afficher les abonnes                              *
PROMPT    *   8.  Supprimer un livre                                *
PROMPT    *   9.  Desabonner un abonne                              *
PROMPT    *   10. Reabonner un abonne                               *
PROMPT    *   11. Quitter                                           *
PROMPT    *                                                         *
PROMPT    ***********************************************************
PROMPT

ACCEPT p_choix PROMPT 'Votre choix : '

COLUMN v_script NEW_VALUE v_script NOPRINT
SELECT
    CASE '&p_choix'
        WHEN '1' THEN 'ajouter_livre.sql'
        WHEN '2' THEN 'ajouter_abonne.sql'
        WHEN '3' THEN 'emprunter_livre.sql'
        WHEN '4' THEN 'retour_livre.sql'
        WHEN '5' THEN 'affichage_livre.sql'
        WHEN '6' THEN 'affichage_emprunt.sql'
        WHEN '7' THEN 'affichage_abonne.sql'
        WHEN '8'  THEN 'supprimer_livre.sql'
        WHEN '9'  THEN 'desabonne.sql'
        WHEN '10' THEN 'reabonnement.sql'
        WHEN '11' THEN 'quitter.sql'
        ELSE 'Menu.sql'
    END AS v_script
FROM dual;

@&v_script


