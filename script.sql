DROP TABLE IF EXISTS course_pilote;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS circuit;
DROP TABLE IF EXISTS pilote;
DROP TABLE if EXISTS equipe;
DROP VIEW IF EXISTS score_pilote;


# creation table course
CREATE TABLE circuit(
    circuit_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(255),
    nom VARCHAR(255),
    longueur FLOAT #en km
);



# creation table course
CREATE TABLE course(
  course_id INTEGER AUTO_INCREMENT,
  CONSTRAINT course_PK PRIMARY KEY (course_id),
  nom VARCHAR(255),
  date_course DATE,
  circuit_id INTEGER,
  CONSTRAINT course_fk FOREIGN KEY (circuit_id) REFERENCES circuit(circuit_id)
);

#create table equipe
CREATE TABLE equipe(
    equipe_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(255),
    nom VARCHAR(255) NOT NULL,
    directeur_technique VARCHAR(255)
);

CREATE TABLE pilote(
  pilote_id INTEGER AUTO_INCREMENT PRIMARY KEY ,
  nom VARCHAR(255),
  prenom VARCHAR(255),
  nationalite VARCHAR(255),
  date_naissance DATE,
  equipe_id INTEGER,
  FOREIGN KEY (equipe_id) REFERENCES equipe(equipe_id)
);

CREATE TABLE course_pilote(
    pilote_id INTEGER,
    course_id INTEGER,
    position_pilote INTEGER NOT NULL,
    CONSTRAINT pilote_fk FOREIGN KEY (pilote_id) REFERENCES pilote(pilote_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    CONSTRAINT course_pilote_pk PRIMARY KEY (pilote_id,course_id)
);

#creation d'un index : augmentation des performance
# attention, cela prend de la place sur le disque
CREATE INDEX index_pays ON circuit(pays);

#je sais à l'avance que je vais avoir besoin de lancer x fois la requete

CREATE VIEW score_pilote AS
(SELECT p.nom as 'nom_pilote', p.prenom, c.nom as 'nom_course', c.date_course, cp.position_pilote
FROM pilote as p
JOIN course_pilote as cp ON p.pilote_id = cp.pilote_id
JOIN course as c ON c.course_id = cp.course_id);

INSERT INTO circuit (pays, nom, longueur) VALUES ('France','Jose',2.5),
                                                 ('Espagne','Josette',4),
                                                    ('Belgique','Herve',5);

#creation des courses
INSERT INTO course (nom, date_course, circuit_id) VALUE ('test',CURDATE(),1);
INSERT INTO course (nom, date_course, circuit_id) VALUE ('course ecolo','2024-10-09',2);


INSERT INTO equipe (pays, nom, directeur_technique) VALUE ('FRANCE','Studi','Jose');
INSERT INTO pilote (nom, prenom, nationalite, date_naissance, equipe_id) VALUE ('Michel','Augustin',
                                                                               'Francaise',
                                                                               '2023-10-09',
                                                                               1);
#creation du champ compteur_course
ALTER TABLE pilote ADD COLUMN compteur_course INTEGER NOT NULL DEFAULT 0;

INSERT INTO pilote (nom, prenom, nationalite, date_naissance, equipe_id) VALUE ('Josette','jesaispas',
                                                                               'Francaise',
                                                                               '2023-10-09',
                                                                               1);



#automatisation du compteur suite à une nouvelle insertion dans course_pilote
CREATE OR REPLACE TRIGGER update_compteur_pilote
    AFTER INSERT ON course_pilote
    FOR EACH ROW
    BEGIN
       # on a le traitement d'incrémentation
        UPDATE pilote
        SET compteur_course = compteur_course + 1
        WHERE pilote_id = NEW.pilote_id;
    END;

INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (1,1,5);
INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (1,2,3);


#appel de la vue : 1
SELECT * FROM score_pilote;

INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (2,2,2);

#appel de la vue : 2
SELECT * FROM score_pilote;

#affichage de toutes les données pilote
SELECT * FROM pilote;



