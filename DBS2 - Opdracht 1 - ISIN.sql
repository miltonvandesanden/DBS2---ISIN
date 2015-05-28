-- Drop alle tables, functies en procedures weer
DROP TABLE DBS2_University;
DROP TABLE DBS2_Country;
DROP FUNCTION DBS2_generateISIN;
DROP FUNCTION DBS2_checkForCorrectness;
DROP PROCEDURE DBS2_ASSERT_EQUALS;

-- Zet de server output aan
set serveroutput on

-- Maak de landen tabel
CREATE TABLE DBS2_Country
(
  ID NUMBER PRIMARY KEY,
  Code VARCHAR2(3) UNIQUE NOT NULL,
  Name VARCHAR2(50) UNIQUE NOT NULL
);

-- Maak de universiteiten tabel
CREATE TABLE DBS2_University
(
  ID NUMBER PRIMARY KEY,
  Code VARCHAR2(4) UNIQUE NOT NULL,
  CountryID NUMBER NOT NULL,
  Name VARCHAR2(100) NOT NULL,
  SNL NUMBER NOT NULL,
  
  FOREIGN KEY (CountryID) REFERENCES Country(ID)
);

-- Voeg wat landen toe
INSERT INTO DBS2_Country VALUES (1, 'NL', 'The Netherlands');
INSERT INTO DBS2_Country VALUES (2, 'FR', 'France');
INSERT INTO DBS2_Country VALUES (3, 'DE', 'Germany');
INSERT INTO DBS2_Country VALUES (4, 'GB', 'United Kingdom');
INSERT INTO DBS2_Country VALUES (5, 'BE', 'Belgium');
INSERT INTO DBS2_Country VALUES (6, 'US', 'United States of America');
INSERT INTO DBS2_Country VALUES (7, 'CA', 'Canada');

-- Universiteiten in Gelderland
INSERT INTO DBS2_University VALUES (0, 'TUA',   1, 'Theologische Universiteit Apeldoorn', 8);
INSERT INTO DBS2_University VALUES (1, 'RUN',   1, 'Radboud Universiteit Nijmegen', 10);
INSERT INTO DBS2_University VALUES (2, 'WUR',   1, 'Wageningen Universiteit', 10);

-- Universiteiten in Groningen
INSERT INTO DBS2_University VALUES (3, 'RUG',   1, 'Rijksuniversiteit Groningen', 7);

-- Universiteiten in Limburg
INSERT INTO DBS2_University VALUES (4, 'UM',    1, 'Universiteit Maastricht', 8);
INSERT INTO DBS2_University VALUES (5, 'OU',    1, 'Open Universiteit', 7);
INSERT INTO DBS2_University VALUES (6, 'MSM',   1, 'Maastricht School of Management', 10);

-- Universiteiten in Noord-Brabant
INSERT INTO DBS2_University VALUES (7, 'TUE',   1, 'Technische Universiteit Eindhoven', 9);
INSERT INTO DBS2_University VALUES (8, 'TIU',   1, 'Universiteit van Tilburg', 9);

-- Universiteiten in Noord-Holland
INSERT INTO DBS2_University VALUES (9, 'UVA',   1, 'Universiteit van Amsterdam', 10);
INSERT INTO DBS2_University VALUES (10, 'VU',   1, 'Vrije Universiteit', 9);

-- Universiteiten in Overijssel
INSERT INTO DBS2_University VALUES (11, 'PTHU', 1, 'Protestantse Theologische Universiteit vestiging Kampen', 7);
INSERT INTO DBS2_University VALUES (12, 'TUK',  1, 'Theologische Universiteit Kampen', 6);
INSERT INTO DBS2_University VALUES (13, 'UT',   1, 'Universiteit Twente', 7);

-- Universiteiten in Utrecht
INSERT INTO DBS2_University VALUES (14, 'UU',   1, 'Universiteit Utrecht', 8);
INSERT INTO DBS2_University VALUES (15, 'NBU',  1, 'Nyenrode Business Universiteit', 10);
INSERT INTO DBS2_University VALUES (16, 'UVH',  1, 'Universiteit voor Humanistiek', 6);
INSERT INTO DBS2_University VALUES (17, 'KTU',  1, 'Katholieke Theologische Universiteit', 6);
INSERT INTO DBS2_University VALUES (18, 'TIAS', 1, 'TiasNimbas Business School', 7);

-- Universiteiten in Zeeland
INSERT INTO DBS2_University VALUES (19, 'UCR',  1, 'University College Roosevelt', 7);

-- Universiteiten in Noord-Holland
INSERT INTO DBS2_University VALUES (20, 'TUD',  1, 'Technische Universiteit Delft', 9);
INSERT INTO DBS2_University VALUES (21, 'UL',   1, 'Universiteit Leiden', 10);
INSERT INTO DBS2_University VALUES (22, 'RUR',  1, 'Erasmus Universiteit Rotterdam', 10);

-- Een functie om een International Student Identification Number (ISIN) te genereren
CREATE OR REPLACE FUNCTION DBS2_generateISIN
(
  countryCode DBS2_Country.Code%TYPE,
  universityCode DBS2_University.Code%TYPE,
  studentNumber VARCHAR2
)
RETURN VARCHAR2
AS
  v_newStudentNumber VARCHAR2(50) := '';
  v_temp VARCHAR2(50) := '';
  v_count NUMBER(5) := 0;
  v_temp2 VARCHAR(50) := '';
  v_temp3 VARCHAR(50) := '';
  --v_tempNumber NUMBER(4);
  
  v_group1 VARCHAR2(4) := ''; 
  v_group2 VARCHAR2(4) := '';
  v_group3 VARCHAR2(4) := '';
  v_group4 VARCHAR2(4) := '';
BEGIN
  -- CREATE CHECKSUM
  LOOP
    v_temp := v_temp || ASCII(SUBSTR(universityCode, v_count+1, 1 )) - 49;
    v_count := v_count + 1;
    EXIT WHEN v_count = LENGTH(universityCode);
  END LOOP;
  
  v_temp := v_temp || studentNumber;
  
  v_group1 := SUBSTR(v_temp, 1, 4);
  v_group2 := SUBSTR(v_temp, 5, 4);
  v_group3 := SUBSTR(v_temp, 9, 4);
  v_group4 := SUBSTR(v_temp, 13, 4);
  
  v_temp := v_group4 || v_group3 || v_group2 || v_group1;  
  
  --v_tempNumber := TO_NUMBER(v_temp) % 62;
  v_temp := TO_CHAR(MOD( TO_NUMBER(v_temp), 62 ));
  
  IF LENGTH(v_temp) = 1 THEN
    v_temp := '0' || v_temp;
  END IF;  

  -- CREATE newStudentNumber
  v_temp2 := studentNumber || v_temp;
  
  v_count := 0;
  
  LOOP
    v_temp3 := v_temp3 || ' ' || SUBSTR(v_temp2, v_count + 1, 4);
    v_count := v_count + 4;
    EXIT WHEN v_count > LENGTH(v_temp2);
  END LOOP;  
  
  v_newStudentNumber := countryCode || v_temp3 || ' ' || universityCode;
  
  dbms_output.put_line(v_newStudentNumber);

  RETURN v_newStudentNumber;
END;
/

-- Een functie die controleert of een gegeven ISIN voldoet aan de eisen
CREATE OR REPLACE FUNCTION DBS2_checkForCorrectness (
  ISIN VARCHAR2
)
RETURN INTEGER
AS
  isCorrect INTEGER := 0;
BEGIN

  dbms_output.put_line('implementeer deze functie verder...');

  RETURN isCorrect;
END;
/

-- Een hulp functie die bij de test cases wordt gebruik
CREATE OR REPLACE PROCEDURE DBS2_ASSERT_EQUALS (
  actual VARCHAR2,
  expected VARCHAR2
)
AS
BEGIN
  IF (NVL(actual, -1) ^= NVL(expected, -2)) THEN
    RAISE_APPLICATION_ERROR(-20000, 'ASSERT FAILS. ' || actual || ' != ' || expected);
  END IF;
END;
/

-- Test cases
-- Zie meegeleverde testscripts
--DECLARE
--BEGIN
--END;
--/