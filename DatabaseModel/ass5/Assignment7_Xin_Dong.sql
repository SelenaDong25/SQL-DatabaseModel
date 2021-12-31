-- Database create script for museum database
-- Xin Dong

DROP DATABASE IF EXISTS museum;
CREATE DATABASE IF NOT EXISTS museum;
USE museum;
CREATE TABLE Grant_Source (
    grant_src CHAR(30) PRIMARY KEY
);

insert into Grant_Source values ('Carnegie Foundation');
insert into Grant_Source values ('NSF');

CREATE TABLE Employee (
    emp_numb CHAR(3) PRIMARY KEY,
    first_name CHAR(15),
    last_name CHAR(15),
    emp_phone CHAR(12)
);

INSERT INTO Employee VALUES ('001','Idaho','Smith','999-555-0001');
INSERT INTO Employee VALUES ('002','Leslie','Lewis','999-555-0002');
INSERT INTO Employee VALUES ('003','Indigo','Jones','999-555-0003');
INSERT INTO Employee VALUES ('004','Jackrabbit','Johnson','999-555-0004');
INSERT INTO Employee VALUES ('005','Big Cheese','Boss','999-555-0005');
INSERT INTO Employee VALUES ('006','Marian','Librarian','999-555-0006');
INSERT INTO Employee VALUES ('007','Stays In','Clerk','999-555-0007');
INSERT INTO Employee VALUES ('008','Loves To','Dig','999-555-0008');
INSERT INTO Employee VALUES ('009','Starving','GraduateStudent','999-555-0009');
INSERT INTO Employee VALUES ('010','Poor','GraduateStudent','999-555-0010');
INSERT INTO Employee VALUES ('011','He Knows','More','999-555-0011');
INSERT INTO Employee VALUES ('012','She Knows','More','999-555-0012');

CREATE TABLE Grant_Table (
    grant_numb CHAR(3) PRIMARY KEY,
    grant_src CHAR(30),
    total_amt NUMERIC(10 , 2 ),
    prinipal_researcher CHAR(3),
    CONSTRAINT Grant_SourceGrant_Table FOREIGN KEY (grant_src)
        REFERENCES Grant_Source (grant_src),
    CONSTRAINT EmployeeGrant_Table FOREIGN KEY (prinipal_researcher)
        REFERENCES Employee (emp_numb)
);

INSERT INTO Grant_Table VALUES ('005', 'Carnegie Foundation', 32750, '004');
INSERT INTO Grant_Table VALUES ('004', 'NSF', 75500, '003');
INSERT INTO Grant_Table VALUES ('003', 'NSF', 150000, '002');
INSERT INTO Grant_Table VALUES ('002', 'Carnegie Foundation', 30000, '001');
INSERT INTO Grant_Table VALUES ('001', 'NSF', 450000, '001');

CREATE TABLE Vendor (
    vendor_numb CHAR(3) PRIMARY KEY,
    vendor_name CHAR(40),
    vendor_street CHAR(50),
    vendor_city CHAR(20),
    vendor_state CHAR(2),
    vendor_zip CHAR(10),
    vendor_phone CHAR(12)
);
INSERT INTO Vendor VALUES ('001', 'Archaeology Supply Co.','85 Northland Highway','Newtown','MA','02111','999-555-0211');
INSERT INTO Vendor VALUES ('002', 'Westview Camping, Inc.','10876 Outer Ring Road','Westview','CA','96123','998-555-6123');
INSERT INTO Vendor VALUES ('003', 'Charter Airlines','25 Airport Way','Westview','GA','42601','997-555-2601');
INSERT INTO Vendor VALUES ('004', 'Digger’s Paradise','25 Airport Way','Eastview','TN','73109','996-555-3109');

CREATE TABLE Purchase (
    po_numb CHAR(6) PRIMARY KEY,
    po_date DATE,
    grant_numb CHAR(3),
    vendor_numb CHAR(3),
    CONSTRAINT Grant_TablePurchase FOREIGN KEY (grant_numb)
        REFERENCES Grant_Table (grant_numb),
    CONSTRAINT VendorPurchase FOREIGN KEY (vendor_numb)
        REFERENCES Vendor (vendor_numb)
);
INSERT INTO Purchase VALUES ('000001',str_to_date('3-15-2004','%m-%d-%Y'),'001','003');
INSERT INTO Purchase VALUES ('000002',str_to_date('3-21-2004','%m-%d-%Y'),'001','002');
INSERT INTO Purchase VALUES ('000003',str_to_date('3-21-2004','%m-%d-%Y'),'002','001');
INSERT INTO Purchase VALUES ('000004',str_to_date('3-25-2004','%m-%d-%Y'),'004','001');
INSERT INTO Purchase VALUES ('000005',str_to_date('3-25-2004','%m-%d-%Y'),'003','004');
INSERT INTO Purchase VALUES ('000006',str_to_date('4-02-2004','%m-%d-%Y'),'005','004');

CREATE TABLE Line_Item (
    po_numb CHAR(6),
    item_description CHAR(30),
    cost_each NUMERIC(8 , 2 ),
    quantity INTEGER,
    CONSTRAINT PRIMARY KEY (po_numb , item_description),
    CONSTRAINT PurchaseLine_Item FOREIGN KEY (po_numb)
        REFERENCES Purchase (po_numb)
);


CREATE TABLE Dig (
    dig_numb CHAR(3) PRIMARY KEY,
    grant_numb CHAR(3),
    dig_description CHAR(30),
    location CHAR(30),
    CONSTRAINT Grant_TableDig FOREIGN KEY (grant_numb)
        REFERENCES Grant_Table (grant_numb)
);
INSERT INTO Dig VALUES ('001','002','Excavating Eskimo ruins','Barrow, AK');
INSERT INTO Dig VALUES ('002','001','Excavating a new pyramid','Giza, Egypt');
INSERT INTO Dig VALUES ('003','003','Documenting cave paintings','Rural France');
INSERT INTO Dig VALUES ('004','005','Excavating mammoth skeleton','Hyde Park, NY');

CREATE TABLE Dig_Assignment (
    dig_numb CHAR(3),
    emp_numb CHAR(3),
    CONSTRAINT PRIMARY KEY (dig_numb , emp_numb),
    CONSTRAINT DigDig_Assignment FOREIGN KEY (dig_numb)
        REFERENCES Dig (dig_numb),
    CONSTRAINT EmployeeDig_Assignment FOREIGN KEY (emp_numb)
        REFERENCES Employee (emp_numb)
);
INSERT INTO Dig_Assignment VALUES ('001','001');
INSERT INTO Dig_Assignment VALUES ('001','008');
INSERT INTO Dig_Assignment VALUES ('001','009');
INSERT INTO Dig_Assignment VALUES ('001','010');
INSERT INTO Dig_Assignment VALUES ('002','001');
INSERT INTO Dig_Assignment VALUES ('002','011');
INSERT INTO Dig_Assignment VALUES ('002','012');
INSERT INTO Dig_Assignment VALUES ('003','002');
INSERT INTO Dig_Assignment VALUES ('004','004');
INSERT INTO Dig_Assignment VALUES ('004','003');
INSERT INTO Dig_Assignment VALUES ('004','011');
INSERT INTO Dig_Assignment VALUES ('004','012');

INSERT INTO Line_Item VALUES ('000001','First class tickets to Mexico','2500.10','6');
INSERT INTO Line_Item VALUES ('000002','6-man tent','109.00','4');
INSERT INTO Line_Item VALUES ('000002','Dining canopy','209.95','2');
INSERT INTO Line_Item VALUES ('000002','Mosquito netting','35.50','24');
INSERT INTO Line_Item VALUES ('000002','Camp stools','18.50','24');
INSERT INTO Line_Item VALUES ('000002','Fully-equipped camping kitchen','1500.95','2');
INSERT INTO Line_Item VALUES ('000003','Brush, size 0','4.95','15');
INSERT INTO Line_Item VALUES ('000003','Brush, size 2','5.95','15');
INSERT INTO Line_Item VALUES ('000003','G-pick','15.80','15');
INSERT INTO Line_Item VALUES ('000003','Shovel, size 0','21.95','15');
INSERT INTO Line_Item VALUES ('000003','Dry specimen case, size S','7.50','100');
INSERT INTO Line_Item VALUES ('000003','Dry specimen case, size M','12.50','75');
INSERT INTO Line_Item VALUES ('000003','Dry specimen case, size L','19.95','25');
INSERT INTO Line_Item VALUES ('000004','Sleeping bag','110.95','10');
INSERT INTO Line_Item VALUES ('000004','2-man tent','185.95','5');
INSERT INTO Line_Item VALUES ('000004','G-pick','15.80','20');
INSERT INTO Line_Item VALUES ('000004','Shovel, size 0','21.95','10');
INSERT INTO Line_Item VALUES ('000004','Brush, size 0','4.95','10');
INSERT INTO Line_Item VALUES ('000004','Brush, size 1','6.95','10');
INSERT INTO Line_Item VALUES ('000005','Twine, 1000 meters','17.50','5');
INSERT INTO Line_Item VALUES ('000005','Broom, corn','12.50','3');
INSERT INTO Line_Item VALUES ('000005','Canvas tent, one room, 20 x 15','609.00','2');
INSERT INTO Line_Item VALUES ('000005','Folding table','125.95','15');
INSERT INTO Line_Item VALUES ('000006','Chemical toilet','85.95','5');
INSERT INTO Line_Item VALUES ('000006','Latrine tent, 5-stall','329.95','1');
INSERT INTO Line_Item VALUES ('000006','Tissue for chemical toilets','1.25','100');

