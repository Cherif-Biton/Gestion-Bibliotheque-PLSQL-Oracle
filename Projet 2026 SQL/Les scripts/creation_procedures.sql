SET SERVEROUTPUT ON
SET VERIFY OFF
-- ============================================================
-- PROCEDURES
-- ============================================================

create or replace procedure ajout_livre(
    title      in livre.titre%type,
    auteur_liv in livre.auteur%type)
is
    v_id livre.liv_id%type;
begin
    select 'LIV' || seq_livre.nextval into v_id from dual;
    insert into livre values(v_id, title, auteur_liv, 'Oui', 'Actif', null);
    commit;
    dbms_output.put_line('Le livre ' || v_id || ' ' || title || ' a ete ajoute avec succes');
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end ajout_livre;
/

--==============================================================================================
create or replace procedure ajout_abonne(
    
    nom_a    in abonne.nom%type,
    prenom_a in abonne.prenom%type)
is
    id abonne.abon_id%type;
    v_count number;
begin
    select 'ABN' || seq_abonne.nextval into id from dual;
    select count(*) into v_count from abonne where abon_id = id;
    if v_count > 0 then
        dbms_output.put_line('Erreur!! L''identifiant ' || id || ' existe deja dans la base de donnees.');
        dbms_output.put_line('Impossible d''enregistrer deux etudiants avec le meme identifiant.');
        return;
    end if;
    insert into abonne values(id, nom_a, prenom_a, 'Actif', null);
    commit;
    dbms_output.put_line('L''abonne ' || id || ' ' || nom_a || ' ' || prenom_a || ' a ete ajoute avec succes');
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end ajout_abonne;
/

--========================================================================================
create or replace procedure emprunt_livre(
    id_liv    in livre.liv_id%type,
    id_abonne in abonne.abon_id%type)
is
    v_dispo         livre.disponibilite%type;
    v_statut_liv    livre.statut%type;
    v_statut_abon   abonne.statut%type;
    v_count_liv     number;
    v_count_abon    number;
    v_count_emprunt number;
begin
    select count(*) into v_count_liv
    from livre where liv_id = id_liv;

    select count(*) into v_count_abon
    from abonne where abon_id = id_abonne;

    if v_count_liv = 0 then
        dbms_output.put_line('Erreur!! Ce livre n''existe pas dans la base de donnees.');
        return;
    end if;

    if v_count_abon = 0 then
        dbms_output.put_line('Erreur!! Cet abonne n''existe pas dans la base de donnees.');
        return;
    end if;

    select statut into v_statut_liv
    from livre where liv_id = id_liv;

    if v_statut_liv = 'Inactif' then
        dbms_output.put_line('Erreur!! Ce livre a ete retire de la bibliotheque.');
        return;
    end if;

    select statut into v_statut_abon
    from abonne where abon_id = id_abonne;

    if v_statut_abon = 'Inactif' then
        dbms_output.put_line('Erreur!! Cet abonne est desabonne de la bibliotheque.');
        return;
    end if;

    select count(*) into v_count_emprunt
    from emprunt
    where abon_id = id_abonne and date_retour is null;

    if v_count_emprunt > 0 then
        dbms_output.put_line('Erreur!! Cet abonne a deja un livre en cours d''emprunt.');
        dbms_output.put_line('Il doit rendre le livre avant d''en emprunter un autre.');
        return;
    end if;

    select disponibilite into v_dispo
    from livre where liv_id = id_liv;

    if v_dispo = 'Oui' then
        insert into emprunt(emprunt_id, liv_id, abon_id, date_emprunt)
        values(seq_emprunt.nextval, id_liv, id_abonne, sysdate);
        update livre set disponibilite = 'Non'
        where liv_id = id_liv;
        commit;
        dbms_output.put_line('L''emprunt a ete effectue avec succes');
    else
        dbms_output.put_line('Ce livre n''est plus disponible dans la bibliotheque');
    end if;
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end emprunt_livre;
/

--===============================================================================================================

create or replace procedure retour_livre(
    id_liv    in livre.liv_id%type,
    id_abonne in abonne.abon_id%type)
is
    v_count_liv  number;
    v_count_abon number;
begin
    select count(*) into v_count_liv
    from livre where liv_id = id_liv;

    select count(*) into v_count_abon
    from abonne where abon_id = id_abonne;

    if v_count_liv = 0 then
        dbms_output.put_line('Erreur!! Ce livre n''existe pas dans la base de donnees.');
        return;
    end if;

    if v_count_abon = 0 then
        dbms_output.put_line('Erreur!! Cet abonne n''existe pas dans la base de donnees.');
        return;
    end if;

    update emprunt
    set date_retour = sysdate
    where liv_id = id_liv and abon_id = id_abonne and date_retour is null;

    if SQL%NOTFOUND then
        dbms_output.put_line('Aucun emprunt en cours trouve pour ce livre et cet abonne.');
        return;
    end if;

    update livre set disponibilite = 'Oui'
    where liv_id = id_liv;
    commit;
    dbms_output.put_line('Le retour du livre a ete effectue avec succes');
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end retour_livre;
/

--=======================================================================================
create or replace procedure affichage_livre
is
    cursor info is
        select titre, auteur, count(*) as nb_exemplaires
        from livre
        where disponibilite = 'Oui' and statut = 'Actif'
        group by titre, auteur;
    v_count number := 0;
begin
    dbms_output.put_line('================================================================');
    dbms_output.put_line('  TITRE                | AUTEUR              | DISPONIBILITE    ');
    dbms_output.put_line('================================================================');
    for i in info loop
        v_count := v_count + 1;
        dbms_output.put_line(
            '  ' || rpad(i.titre, 25) || ' | '
                 || rpad(i.auteur, 22) || ' | '
                 || i.nb_exemplaires || ' exemplaire(s)');
    end loop;
    dbms_output.put_line('================================================================');
    if v_count = 0 then
        dbms_output.put_line('  Aucun livre disponible.');
        dbms_output.put_line('================================================================');
    end if;
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
end affichage_livre;
/

--===================================================================================================

create or replace procedure affichage_emprunt
is
    cursor info is
        select a.abon_id, a.nom, a.prenom,
               l.liv_id, l.titre, l.auteur,
               e.date_emprunt, e.date_retour
        from emprunt e
        join abonne a on e.abon_id = a.abon_id
        join livre  l on e.liv_id  = l.liv_id
        order by e.date_emprunt;
    v_count number := 0;
begin
    dbms_output.put_line('========================================================================================');
    dbms_output.put_line('                          LISTE DES EMPRUNTS                                          ');
    dbms_output.put_line('========================================================================================');
    dbms_output.put_line('  ABONNE         | TITRE                | DATE EMPRUNT | DATE RETOUR  ');
    dbms_output.put_line('========================================================================================');
    for i in info loop
        v_count := v_count + 1;
        dbms_output.put_line(
            '  ' || rpad(i.nom || ' ' || i.prenom, 20) || ' | '
                 || rpad(i.titre, 25) || ' | '
                 || to_char(i.date_emprunt, 'DD/MM/YYYY') || '   | '
                 || case
                        when i.date_retour is null then 'En cours'
                        else to_char(i.date_retour, 'DD/MM/YYYY')
                    end);
    end loop;
    dbms_output.put_line('========================================================================================');
    if v_count = 0 then
        dbms_output.put_line('  Aucun emprunt enregistre.');
        dbms_output.put_line('========================================================================================');
    end if;
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
end affichage_emprunt;
/

--===========================================================================
create or replace procedure affichage_abonne
is
    cursor info is
        select abon_id, nom, prenom, statut
        from abonne
        order by nom;
    v_count number := 0;
begin
    dbms_output.put_line('================================================================');
    dbms_output.put_line('                    LISTE DES ABONNES                          ');
    dbms_output.put_line('================================================================');
    dbms_output.put_line('  INE                  | NOM               | PRENOM  | STATUT  ');
    dbms_output.put_line('================================================================');
    for i in info loop
        v_count := v_count + 1;
        dbms_output.put_line(
            '  ' || rpad(i.abon_id, 20) || ' | '
                 || rpad(i.nom, 20)     || ' | '
                 || rpad(i.prenom, 20)   || ' | '
                 || i.statut);
    end loop;
    dbms_output.put_line('================================================================');
    if v_count = 0 then
        dbms_output.put_line('  Aucun abonne enregistre.');
        dbms_output.put_line('================================================================');
    end if;
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
end affichage_abonne;
/

--====================================================================================================================

create or replace procedure desabonne(
    id      in abonne.abon_id%type,
    p_motif in abonne.motif%type)
is
    v_count_abon    number;
    v_count_emprunt number;
    v_statut        abonne.statut%type;
begin
    select count(*) into v_count_abon
    from abonne where abon_id = id;

    if v_count_abon = 0 then
        dbms_output.put_line('Erreur!! Cet abonne n''existe pas dans la base de donnees.');
        return;
    end if;

    select statut into v_statut
    from abonne where abon_id = id;

    if v_statut = 'Inactif' then
        dbms_output.put_line('Erreur!! Cet abonne est deja desabonne.');
        return;
    end if;

    select count(*) into v_count_emprunt
    from emprunt
    where abon_id = id and date_retour is null;

    if v_count_emprunt > 0 then
        dbms_output.put_line('Erreur!! Cet abonne a un emprunt en cours.');
        dbms_output.put_line('Il doit rendre le livre avant de se desabonner.');
        return;
    end if;

    update abonne
    set statut = 'Inactif',
        motif  = p_motif
    where abon_id = id;
    commit;
    dbms_output.put_line('L''abonne ' || id || ' a ete desabonne avec succes.');
    dbms_output.put_line('Motif : ' || p_motif);
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end desabonne;
/

create or replace procedure supprimer_livre(
    id      in livre.liv_id%type,
    p_motif in livre.motif%type)
is
    v_count_liv number;
    v_dispo     livre.disponibilite%type;
    v_statut    livre.statut%type;
begin
    select count(*) into v_count_liv
    from livre where liv_id = id;

    if v_count_liv = 0 then
        dbms_output.put_line('Erreur!! Ce livre n''existe pas dans la base de donnees.');
        return;
    end if;

    select statut into v_statut
    from livre where liv_id = id;

    if v_statut = 'Inactif' then
        dbms_output.put_line('Erreur!! Ce livre est deja retire de la bibliotheque.');
        return;
    end if;

    select disponibilite into v_dispo
    from livre where liv_id = id;

    if v_dispo = 'Non' then
        dbms_output.put_line('Erreur!! Ce livre est actuellement emprunte.');
        dbms_output.put_line('Impossible de le retirer tant qu''il n''est pas rendu.');
        return;
    end if;

    update livre
    set statut = 'Inactif',
        motif  = p_motif
    where liv_id = id;
    commit;
    dbms_output.put_line('Le livre ' || id || ' a ete retire de la bibliotheque.');
    dbms_output.put_line('Motif : ' || p_motif);
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end supprimer_livre;
/

create or replace procedure reabonnement(id in abonne.abon_id%type)
is
    v_count  number;
    v_statut abonne.statut%type;
begin
    select count(*) into v_count from abonne where abon_id = id;
    if v_count = 0 then
        dbms_output.put_line('Erreur!! Cet abonne n''existe pas dans la base de donnees.');
        return;
    end if;

    select statut into v_statut from abonne where abon_id = id;
    if v_statut = 'Actif' then
        dbms_output.put_line('Erreur!! Cet abonne est deja actif dans la bibliotheque.');
        return;
    end if;

    update abonne
    set statut = 'Actif',
        motif  = null
    where abon_id = id;
    commit;
    dbms_output.put_line('L''abonne ' || id || ' a ete reabonne avec succes.');
exception
    when others then
        dbms_output.put_line('Erreur!! ' || SQLERRM);
        rollback;
end reabonnement;
/

