-- script to create rental database
-- revised 3/02/2004 YZ
-- revised 2009-09-05 LR
-- revised 2013.2.14 AL
-- revised 2013.9.24 AL
-- revised 2014.9.17 AL
-- revised 2015.9.21 AL

BEGIN TRANSACTION

USE BMGT402_DB_Student_046

DROP TABLE Registration;
DROP TABLE Viewing;
DROP TABLE Client;
DROP TABLE PropertyForRent;
DROP TABLE PrivateOwner;
DROP TABLE Staff;
DROP TABLE Branch;

CREATE TABLE Branch (
  branchNo CHAR(4) NOT NULL,
  street VARCHAR(25),
  city VARCHAR(15),
  postcode VARCHAR(8),
  CONSTRAINT pk_Branch_branchNo PRIMARY KEY (branchNo) );

INSERT INTO Branch VALUES
  ('B005','22 Deer Rd','London','SW1 4EH'),
  ('B007','16 Argyll St','Aberdeen','AB2 3SU'),
  ('B003','163 Main St','Glasgow','G11 9QX'),
  ('B004','32 Manse Rd','Bristol','BS99 1NZ'),
  ('B002','56 Clover Dr','London','NW10 6EU');

CREATE TABLE Staff (
  staffNo CHAR(4) NOT NULL,
  fName VARCHAR(20),
  lName VARCHAR(20),
  position VARCHAR(20),
  sex CHAR,
  DOB DATE,
  salary DECIMAL(7,2),
  branchNo CHAR(4), 
  CONSTRAINT pk_Staff_staffNo PRIMARY KEY (staffNo),
  CONSTRAINT fk_Staff_branchNo FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE ON UPDATE NO ACTION );

INSERT INTO Staff VALUES
  ('SL21','John','White','Manager','M','1945-10-01',30000,'B005'),
  ('SG37','Ann','Beech','Assistant','F','1960-11-10',12000,'B003'),
  ('SG14','David','Ford','Supervisor','M','1958-03-24',18000,'B003'),
  ('SA9','Mary','Howe','Assistant','F','1970-02-19',9000,'B007'),
  ('SG5','Susan','Brand','Manager','F','1940-06-03',24000,'B003'),
  ('SL41','Julie','Lee','Assistant','F','1965-06-13', 9000,'B005');

CREATE TABLE PrivateOwner (
  ownerNo CHAR(4) NOT NULL,
  fName VARCHAR(20),
  lName VARCHAR(20),
  address VARCHAR(30),
  telNo VARCHAR(20),
  eMail VARCHAR(30),
  password CHAR(8),
  CONSTRAINT pk_PrivateOwner_ownerNo PRIMARY KEY (ownerNo) );

INSERT INTO PrivateOwner VALUES
  ('CO46','Joe','Keogh','2 Fergus Dr, Aberdeen AB2 7SX','01224-861212','jkeogh@lhh.com','********'),
  ('CO87','Carol','Farrel','6 Achray St, Glasgow G32 9DX','0141-357-7419','cfarrel@gmail.com','********'),
  ('CO40','Tina','Murphy','63 Well St, Glasgow G42','0141-943-1728','tinam@hotmail.com','********'),
  ('CO93','Tony','Shaw','12 Park Pl, Glasgow G4 0QR','0141-225-7025','tony.shaw@ark.com','********');

CREATE TABLE PropertyForRent (
  propertyNo CHAR(4) NOT NULL,
  street VARCHAR(25),
  city VARCHAR(15),
  postcode VARCHAR(8),
  type VARCHAR(5),
  rooms SMALLINT,
  rent DECIMAL(6,2),
  ownerNo CHAR(4),
  staffNo CHAR(4),
  branchNo CHAR(4),
  CONSTRAINT pk_PropertyForRent_propertyNo PRIMARY KEY (propertyNo),
  CONSTRAINT fk_PropertyForRent_ownerNo FOREIGN KEY (ownerNo) REFERENCES PrivateOwner(ownerNo) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT fk_PropertyForRent_staffNo FOREIGN KEY (staffNo) REFERENCES Staff(staffNo) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_PropertyForRent_branchNo FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE NO ACTION ON UPDATE NO ACTION );

INSERT INTO PropertyForRent VALUES
  ('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650,'CO46','SA9','B007'),
  ('PL94','6 Argyll St','London','NW2','Flat',4,400,'CO87','SL41','B005'),
  ('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350,'CO40',NULL,'B003'),
  ('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375,'CO93','SG37','B003'),
  ('PG21','18 Dale Rd','Glasgow','G12','House',5,600,'CO87','SG37','B003'),
  ('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450,'CO93','SG14','B003');

CREATE TABLE Client (
  clientNo CHAR(4) NOT NULL,
  fName VARCHAR(20),
  lName VARCHAR(20),
  telNo VARCHAR(20),
  prefType VARCHAR(5),
  maxRent DECIMAL(6,2),
  eMail VARCHAR(30),
  CONSTRAINT pk_Client_clientNo PRIMARY KEY (clientNo) );

INSERT INTO Client VALUES
  ('CR76','John','Kay','0207-774-5632','Flat',425,'john.kay@gmail.com'),
  ('CR56','Aline','Stewart','0141-848-1825','Flat',350,'astewart@hotmail.com'),
  ('CR74','Mike','Ritchie','01475-392178','House',750,'mrichie01@yahoo.co.uk'),
  ('CR62','Mary','Tregear','01224-196720','Flat',600,'maryt@hotmail.co.uk');

CREATE TABLE Viewing (
  clientNo CHAR(4) NOT NULL,
  propertyNo CHAR(4) NOT NULL,
  viewDate DATE,
  comment VARCHAR(20),
  CONSTRAINT pk_Viewing_clientNo_propertyNo PRIMARY KEY (clientNo,propertyNo),
  CONSTRAINT fk_Viewing_clientNo FOREIGN KEY (clientNo) REFERENCES Client(clientNo) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT fk_Viewing_propertyNo FOREIGN KEY (propertyNo) REFERENCES PropertyForRent(propertyNo) ON DELETE CASCADE ON UPDATE NO ACTION );

INSERT INTO Viewing VALUES
  ('CR56','PA14','2013-05-24','too small'),
  ('CR76','PG4','2013-04-20','too remote'),
  ('CR56','PG4','2013-05-26',NULL),
  ('CR62','PA14','2013-05-14','no dining room'),
  ('CR56','PG36','2013-04-28',NULL);

CREATE TABLE Registration (
  clientNo CHAR(4) NOT NULL,
  branchNo CHAR(4) NOT NULL,
  staffNo CHAR(4) NOT NULL,
  dateJoined DATE,
  CONSTRAINT pk_Registration_clientNo_branchNo PRIMARY KEY (clientNo,branchNo),
  CONSTRAINT fk_Registration_clientNo FOREIGN KEY (clientNo) REFERENCES Client(clientNo) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT fk_Registration_branchNo FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_Registration_staffNo FOREIGN KEY (staffNo) REFERENCES Staff(staffNo) ON DELETE NO ACTION ON UPDATE NO ACTION );

INSERT INTO Registration VALUES
  ('CR76','B005','SL41','2013-01-02'),
  ('CR56','B003','SG37','2012-04-11'),
  ('CR74','B003','SG37','2011-11-16'),
  ('CR62','B007','SA9','2012-03-07');

COMMIT;
