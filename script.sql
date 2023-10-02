DROP TABLE IF EXISTS circuit;
DROP TABLE IF EXISTS course;


# creation table course
CREATE TABLE circuit(
    circuit_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(255),
    nom VARCHAR(255),
    longueur FLOAT
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

CREATE VIEW toto AS (
SELECT *
FROM course
                    );

CREATE VIEW vue_course_circuit AS (
SELECT c.nom, c.date_course, ci.nom as 'nom circuit',ci.longueur
FROM course c
INNER JOIN circuit ci ON c.circuit_id = ci.circuit_id
                    );

SELECT * from toto;
SELECT * from vue_course_circuit;
INSERT INTO circuit (pays, nom, longueur) VALUE ('France','Jose',2.5);
INSERT INTO course (nom, date_course, circuit_id) VALUE ('test',CURDATE(),1);
