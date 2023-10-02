DROP TABLE IF EXISTS circuit;
DROP TABLE IF EXISTS course;


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
                                                 ('France','Josette',2.5),
                                                    ('France','Herve',2.5);
INSERT INTO course (nom, date_course, circuit_id) VALUE ('test',CURDATE(),1);
