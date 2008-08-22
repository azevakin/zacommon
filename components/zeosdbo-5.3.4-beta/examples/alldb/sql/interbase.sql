CREATE TABLE parts (
  PartNo integer default NULL,
  VendorNo integer default NULL,
  Description varchar(30) default NULL,
  OnHand integer default NULL,
  OnOrder integer default NULL,
  Cost integer default NULL,
  ListPrice integer default NULL,
);

CREATE INDEX IDX1 ON parts (PartNo);
ALTER TABLE parts ADD CONSTRAINT fk_parts FOREIGN KEY (VendorNo) REFERENCES Vendors (VendorNo) ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO parts VALUES (900,3820,'Dive kayak',24,16,1356.75,3999.95);
INSERT INTO parts VALUES (912,3820,'Underwater Diver Vehicle',5,3,504,1680);
INSERT INTO parts VALUES (1313,3511,'Regulator System',165,216,117.5,250);
INSERT INTO parts VALUES (1314,5641,'Second Stage Regulator',98,88,124.1,365);
INSERT INTO parts VALUES (1316,3511,'Regulator System',75,70,119.35,341);
INSERT INTO parts VALUES (1320,3511,'Second Stage Regulator',37,35,73.53,171);
INSERT INTO parts VALUES (1328,3511,'Regulator System',166,100,154.8,430);
INSERT INTO parts VALUES (1330,3511,'Alternate Inflation Regulator',47,43,85.8,260);
INSERT INTO parts VALUES (1364,3511,'Second Stage Regulator',128,135,99.9,270);
INSERT INTO parts VALUES (1390,3511,'First Stage Regulator',146,140,64.6,170);
INSERT INTO parts VALUES (1946,6588,'Second Stage Regulator',13,10,95.79,309);
INSERT INTO parts VALUES (1986,6588,'Depth/Pressure Gauge Console',25,24,73.32,188);
INSERT INTO parts VALUES (2314,3511,'Electronic Console',13,12,120.9,390);
INSERT INTO parts VALUES (2341,3511,'Depth/Pressure Gauge',226,225,48.3,105);
INSERT INTO parts VALUES (2343,3511,'Personal Dive Sonar',46,45,72.85,235);
INSERT INTO parts VALUES (2350,3511,'Compass Console Mount',211,300,10.15,29);
INSERT INTO parts VALUES (2367,3511,'Compass (meter only)',168,183,24.96,52);
INSERT INTO parts VALUES (2383,3511,'Depth/Pressure Gauge',128,120,76.22,206);
INSERT INTO parts VALUES (2390,3511,'Electronic Console w/ options',24,23,189,420);
INSERT INTO parts VALUES (2612,2014,'Direct Sighting Compass',15,12,12.582,34.95);
INSERT INTO parts VALUES (2613,2014,'Dive Computer',5,2,76.97,179);
INSERT INTO parts VALUES (2619,2014,'Navigation Compass',8,20,9.177,19.95);
INSERT INTO parts VALUES (2630,2014,'Wrist Band Thermometer (F)',6,3,7.92,18);
INSERT INTO parts VALUES (2632,2014,'Depth/Pressure Gauge (Digital)',12,10,53.64,149);
INSERT INTO parts VALUES (2648,2014,'Depth/Pressure Gauge (Analog)',16,15,39.27,119);
INSERT INTO parts VALUES (2657,2014,'Wrist Band Thermometer (C)',12,10,6.48,18);
INSERT INTO parts VALUES (2954,6588,'Dive Computer',45,43,253.5,650);
INSERT INTO parts VALUES (3316,3511,'Stabilizing Vest',56,67,146.2,430);
INSERT INTO parts VALUES (3326,3511,'Front Clip Stabilizing Vest',45,56,128.8,280);
INSERT INTO parts VALUES (3340,3511,'Trim Fit Stabilizing Vest',63,61,138.25,395);
INSERT INTO parts VALUES (3386,3511,'Welded Seam Stabilizing Vest',62,60,109.2,280);
INSERT INTO parts VALUES (5313,3511,'Safety Knife',16,30,13.12,41);
INSERT INTO parts VALUES (5318,5641,'Medium Titanium Knife',4,3,26.7665,56.95);
INSERT INTO parts VALUES (5324,3511,'Chisel Point Knife',14,35,14.35,41);
INSERT INTO parts VALUES (5349,3511,'Flashlight',28,27,29.25,65);
INSERT INTO parts VALUES (5356,3511,'Medium Stainless Steel Knife',30,23,34.3,70);
INSERT INTO parts VALUES (5378,3511,'Divers Knife and Sheath',24,23,27.3,70);
INSERT INTO parts VALUES (5386,3511,'Large Stainless Steel Knife',16,15,37.6,80);
INSERT INTO parts VALUES (7612,7382,'Krypton Flashlight',46,76,20.677,44.95);
INSERT INTO parts VALUES (7619,7382,'Flashlight (Rechargeable)',16,36,50.985,169.95);
INSERT INTO parts VALUES (7654,7382,'Halogen Flashlight',19,18,19.184,59.95);
INSERT INTO parts VALUES (9312,3511,'60.6 cu ft Tank',8,4,57.28,179);
INSERT INTO parts VALUES (9316,3511,'95.1 cu ft Tank',16,14,130,325);
INSERT INTO parts VALUES (9318,3511,'71.4 cu ft Tank',102,100,58.5,195);
INSERT INTO parts VALUES (9354,3511,'75.8 cu ft Tank',38,31,96.35,235);
INSERT INTO parts VALUES (11221,2674,'Remotely Operated Video System',13,12,710.7,2369);
INSERT INTO parts VALUES (11238,7382,'Marine Super VHS Video Package',3,1,1124.1,2498);
INSERT INTO parts VALUES (11518,4652,'Towable Video Camera (B&W)',12,21,859.57,1999);
INSERT INTO parts VALUES (11564,4652,'Towable Video Camera (Color)',16,39,1484.55,3299);
INSERT INTO parts VALUES (11635,7382,'Camera and Case',14,12,52.778,119.95);
INSERT INTO parts VALUES (11652,7382,'Video Light',5,1,147.5795,359.95);
INSERT INTO parts VALUES (12301,2674,'Boat Towable Metal Detector',13,12,203.66,599);
INSERT INTO parts VALUES (12303,2674,'Boat Towable Metal Detector',14,11,316.05,735);
INSERT INTO parts VALUES (12306,2674,'Underwater Altimeter',38,34,143.5,350);
INSERT INTO parts VALUES (12310,2674,'Sonar System',3,120,215.11,439);
INSERT INTO parts VALUES (12316,2674,'Marine Magnetometer',56,55,545.58,1299);
INSERT INTO parts VALUES (12317,2674,'Underwater Metal Detector',29,24,440.51,899);
INSERT INTO parts VALUES (12386,2674,'Underwater Metal Detector',45,41,338.3,995);
INSERT INTO parts VALUES (13545,4682,'Air Compressor',5,2,986.85,2295);

CREATE TABLE vendors (
  VendorNo integer NOT NULL,
  VendorName varchar(30) default NULL,
  Address1 varchar(30) default NULL,
  Address2 varchar(30) default NULL,
  City varchar(20) default NULL,
  State varchar(20) default NULL,
  Zip varchar(10) default NULL,
  Country varchar(15) default NULL,
  Phone varchar(15) default NULL,
  FAX varchar(15) default NULL,
  Preferred integer default NULL,
  PRIMARY KEY  (VendorNo),
);

INSERT INTO vendors VALUES (2014,'Cacor Corporation','161 Southfield Rd',NULL,'Southfield','OH','60093','U.S.A.','708-555-9555','708-555-7547',1);
INSERT INTO vendors VALUES (2641,'Underwater','50 N 3rd Street',NULL,'Indianapolis','IN','46208','U.S.A.','317-555-4523',NULL,1);
INSERT INTO vendors VALUES (2674,'J.W.  Luscher Mfg.','65 Addams Street',NULL,'Berkely','MA','02779','U.S.A.','800-555-4744','508-555-8949',0);
INSERT INTO vendors VALUES (3511,'Scuba Professionals','3105 East Brace',NULL,'Rancho Dominguez','CA','90221','U.S.A.','213-555-7850',NULL,1);
INSERT INTO vendors VALUES (3819,'Divers''  Supply Shop','5208 University Dr',NULL,'Macon','GA','20865','U.S.A.','912-555-6790','912-555-8474',0);
INSERT INTO vendors VALUES (3820,'Techniques','52 Dolphin Drive',NULL,'Redwood City','CA','94065-1086','U.S.A.','415-555-1410','415-555-1276',0);
INSERT INTO vendors VALUES (4521,'Perry Scuba','3443 James Ave',NULL,'Hapeville','GA','30354','U.S.A.','800-555-6220','404-555-8280',1);
INSERT INTO vendors VALUES (4642,'Beauchat, Inc.','45900 SW 2nd Ave',NULL,'Ft Lauderdale','FL','33315','U.S.A.','305-555-7242','305-555-6739',1);
INSERT INTO vendors VALUES (4651,'Amor Aqua','42 West 29th Street',NULL,'New York','NY','10011','U.S.A.','800-555-6880','212-555-7286',1);
INSERT INTO vendors VALUES (4652,'Aqua Research Corp.','P.O. Box 998',NULL,'Cornish','NH','03745','U.S.A.','603-555-2254',NULL,1);
INSERT INTO vendors VALUES (4655,'B&K Undersea Photo','116 W 7th Street',NULL,'New York','NY','10011','U.S.A.','800-555-5662','212-555-7474',0);
INSERT INTO vendors VALUES (4681,'Diving International Unlimited','1148 David Drive',NULL,'San Diego','DA','92102','U.S.A.','800-555-8439',NULL,1);
INSERT INTO vendors VALUES (4682,'Nautical Compressors','65 NW 167 Street',NULL,'Miami','FL','33015','U.S.A.','305-555-5554','305-555-0268',1);
INSERT INTO vendors VALUES (5385,'Glen Specialties, Inc.','17663 Campbell Lane',NULL,'Huntington Beach','CA','92647','U.S.A.','714-555-5100','714-555-6539',1);
INSERT INTO vendors VALUES (5641,'Dive Time','20 Miramar Ave',NULL,'Long Beach','CA','90815','U.S.A.','213-555-3708','213-555-1390',1);
INSERT INTO vendors VALUES (6415,'Undersea Systems, Inc.','18112 Gotham Street',NULL,'Huntington Beach','CA','92648','U.S.A.','800-555-3483',NULL,1);
INSERT INTO vendors VALUES (6451,'Felix Diving','310 S Michigan Ave',NULL,'Chicago','IL','60607','U.S.A.','800-555-3549','312-555-1586',0);
INSERT INTO vendors VALUES (6452,'Central Valley Skin Divers','160 Jameston Ave',NULL,'Jamaica','NY','11432','U.S.A.','718-555-5772',NULL,0);
INSERT INTO vendors VALUES (6481,'Parkway Dive Shop','241 Kelly Street',NULL,'South Amboy','NJ','08879','U.S.A.','908-555-5300',NULL,1);
INSERT INTO vendors VALUES (6482,'Marine Camera & Dive','117 South Valley Rd',NULL,'San Diego','CA','92121','U.S.A.','619-555-0604','619-555-6499',1);
INSERT INTO vendors VALUES (6588,'Dive Canada','275 W Ninth Ave',NULL,'Vancouver','British Columbia','V6K 1P9','Canada','604-555-2681','604-555-3749',1);
INSERT INTO vendors VALUES (7382,'Dive & Surf','P.O. Box 20210',NULL,'Indianapolis','IN','46208','U.S.A.','317-555-4523',NULL,0);
INSERT INTO vendors VALUES (7685,'Fish Research Labs','29 Wilkins Rd Dept. SD',NULL,'Los Banos','CA','93635','U.S.A.','209-555-3292','203-555-0416',1);

