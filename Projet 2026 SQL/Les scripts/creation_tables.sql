SET SERVEROUTPUT ON
SET VERIFY OFF

-- ============================================================
-- CREATION DES TABLES
-- ============================================================
create table livre (
    liv_id        varchar2(10)  constraint pk1 primary key,
    titre         varchar2(100),
    auteur        varchar2(200),
    disponibilite varchar2(5)   default null,
    statut        varchar2(10)  default 'Actif',
    motif         varchar2(200) default null
);

create table abonne (
    abon_id varchar2(20)  constraint pk2 primary key,
    nom     varchar2(50),
    prenom  varchar2(20),
    statut  varchar2(10)  default 'Actif',
    motif   varchar2(200) default null
);

create table emprunt (
    emprunt_id   number        constraint pk3 primary key,
    liv_id       varchar2(10)  references livre,
    abon_id      varchar2(20)  references abonne,
    date_emprunt date          default null,
    date_retour  date          default null
);
