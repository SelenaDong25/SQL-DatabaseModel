-- Database create script for User_Computer_Management_Xin_Dong database


DROP DATABASE IF EXISTS User_Computer_Management_Xin_Dong;
CREATE DATABASE IF NOT EXISTS User_Computer_Management_Xin_Dong;
USE User_Computer_Management_Xin_Dong;

CREATE TABLE os_type (
    type_id INT PRIMARY KEY,
    os_type CHAR(45)
);
CREATE TABLE os_version (
    version_id INT PRIMARY KEY,
    os_version CHAR(45),
    type_id INT, 
    CONSTRAINT os_type_os_version FOREIGN KEY (type_id)
		REFERENCES os_type (type_id)
);
CREATE TABLE computer (
    computer_name CHAR(30) PRIMARY KEY,
    version_id INT,
    CONSTRAINT os_version_computer FOREIGN KEY (version_id)
        REFERENCES os_version (version_id)
);
CREATE TABLE user (
    user_id INT PRIMARY KEY,
    user_name CHAR(45),
    user_information CHAR(45)
);

CREATE TABLE computer_has_user (
    computer_name CHAR(30),
    user_id INT,
    permission_type CHAR(45),
    CONSTRAINT computer_computer_has_user FOREIGN KEY (computer_name)
        REFERENCES computer (computer_name),
	CONSTRAINT user_computer_has_user FOREIGN KEY (user_id)
		REFERENCES user (user_id)
);

CREATE TABLE software (
    software_id INT PRIMARY KEY,
    software_title CHAR(45),
    software_source CHAR(100),
    software_version CHAR(30)
);

CREATE TABLE usergroup (
    user_group_name CHAR(20) PRIMARY KEY,
    user_group_description CHAR(45),
    software_id INT,
    CONSTRAINT software_usergroup FOREIGN KEY (software_id)
		REFERENCES software (software_id)
);


CREATE TABLE usergroup_has_user (
    user_group_name CHAR(20),
    user_id INT,
    CONSTRAINT usergroup_usergroup_has_user FOREIGN KEY (user_group_name)
        REFERENCES usergroup (user_group_name),
	CONSTRAINT user_usergroup_has_user FOREIGN KEY (user_id)
		REFERENCES user (user_id)
);

INSERT INTO os_type VALUES ( 1, 'Windows');
INSERT INTO os_type VALUES ( 2, 'Mac');

INSERT INTO os_version VALUES ( 1, 'Windows 10', 1);
INSERT INTO os_version VALUES ( 2, 'OS X 10.9', 2);
INSERT INTO os_version VALUES ( 3, 'OS X 10.10', 2);

INSERT INTO software VALUES ( 1, 'Software1', '//share1/Software1', 'v.12');
INSERT INTO software VALUES ( 2, 'Software2', 'https://www.company.com/software2', 'v.1242');

INSERT INTO usergroup VALUES ( 'Group1', 'User Group description 1', 1);
INSERT INTO usergroup VALUES ( 'Group2', 'User Group description 2', 2);

INSERT INTO user VALUES ( 1, 'Gran Pre', 'room12');
INSERT INTO user VALUES ( 2, 'John Doe', 'room13');
INSERT INTO user VALUES ( 3, 'Alex More', 'room14');
INSERT INTO user VALUES ( 4, 'Yixin Wan', 'room15');
INSERT INTO user VALUES ( 5, 'Jain Smith', 'room16');
INSERT INTO user VALUES ( 6, 'Maya Green', 'room17');
INSERT INTO user VALUES ( 7, 'Jayashree Bo', 'room18');
INSERT INTO user VALUES ( 8, 'Leya Princess', 'room19');

INSERT INTO computer VALUES ('Computer1', 1);
INSERT INTO computer VALUES ('Computer2', 2);
INSERT INTO computer VALUES ('Computer3', 3);

INSERT INTO computer_has_user VALUES ('Computer1',1,'Administrator');
INSERT INTO computer_has_user VALUES ('Computer1',2,'Administrator');
INSERT INTO computer_has_user VALUES ('Computer1',3,'Standard');
INSERT INTO computer_has_user VALUES ('Computer2',3,'Guest');
INSERT INTO computer_has_user VALUES ('Computer2',4,'Administrator');
INSERT INTO computer_has_user VALUES ('Computer3',5,'Managed');

INSERT INTO usergroup_has_user VALUES ('Group1', 1);
INSERT INTO usergroup_has_user VALUES ('Group1', 2);
INSERT INTO usergroup_has_user VALUES ('Group2', 2);
INSERT INTO usergroup_has_user VALUES ('Group2', 3);
INSERT INTO usergroup_has_user VALUES ('Group2', 4);
INSERT INTO usergroup_has_user VALUES ('Group1', 8);