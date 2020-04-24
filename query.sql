/*Search all staffs with salary less than 4500*/
SELECT * FROM staff,salary WHERE staff.`staff_id`=salary.`staff_id` AND income>4500;

/*Rank salary from low to high*/
SELECT * FROM salary,staff WHERE staff.`staff_id`=salary.`staff_id` ORDER BY salary.income ASC;

/*Query the staffs name in department2 whose salary higher than 2200*/
SELECT staff_name,income FROM staff,salary WHERE staff.staff_id=salary.staff_id AND income>2200 AND staff.department= 1;

/*Query the average salary for department1*/
SELECT AVG(income) avg_income FROM salary,staff WHERE staff.staff_id=salary.staff_id AND staff.department= 1;

/*Query the highest and lowest salary for the staffs in department1*/
SELECT MAX(income) max_income,MIN(income) min_income FROM salary,staff WHERE staff.staff_id=salary.staff_id AND staff.department= 1;

/*Query the number of staffs in each department*/
SELECT department, COUNT(*) number FROM staff GROUP BY department;

/*Count the number of staffs whoes salary higher than 2000 in each deparment*/
SELECT department, COUNT(*) number FROM staff,salary WHERE staff.staff_id=salary.staff_id AND income>2000 GROUP BY department;

/*According to ID find certain customer's birthday,age and sex(simliar to staffs)*/   -- DATE_FORMAT(CAST(SUBSTRING(id_num,7,8) AS DATE), '%m-%d') AS Birthday  
SELECT id_num, CAST(SUBSTRING(id_num,7,8) AS DATE) AS 'Birthday', 
DATE_FORMAT(NOW(), '%Y') - SUBSTRING(id_num,7,4) AS age,
IF(LEFT(SUBSTRING(id_num,17),1)%2=1,'M','F') AS sex FROM customer WHERE cust_id=100001;

/*Caluculate the total salary of staffs*/
SELECT staff_id, income, bonus, SUM(income+bonus) AS TOTAL FROM salary GROUP BY staff_id;

/*Search VIP who spent higher than 8500*/
SELECT cust_id,spent FROM vip_info WHERE spent>8500;

/*Subquery*/

/*Search staff name in deparment1 whoes age oder than the age of staffs in deparment2*/
SELECT staff_name FROM staff WHERE department=1 AND birthday <=ALL (SELECT birthday FROM staff WHERE department=2) ;

/*Query all staffs whose salary higher than the salary of staffs in deparment1*/
SELECT staff.staff_name FROM staff WHERE staff_id IN (SELECT salary.staff_id FROM salary WHERE income>ALL (SELECT income FROM salary WHERE salary.staff_id IN (SELECT staff.staff_id FROM staff WHERE department=1)));

/*Create view*/

/*View to search customer information*/
CREATE VIEW cust_info AS SELECT * FROM customer;
# select * from cust_info;

/*View to search room information*/
CREATE VIEW room_info AS SELECT * FROM room;
# select * from room_info;

/*View register information*/
CREATE VIEW register_info AS SELECT * FROM register;
CREATE VIEW regis_info AS SELECT register.`room_id`,cust_name,register.`cust_id`,room.`type`,price FROM room,customer,register WHERE room.`room_id`=register.`room_id` AND register.`cust_id`=customer.`cust_id`;
# select * from register_info;
# select * from regis_info;

/*view VIP information*/
CREATE VIEW vip_info AS SELECT * FROM vip NATURAL JOIN customer;
# select * from vip_info;

/*Create index*/

/*Index to room table*/
CREATE UNIQUE INDEX ur ON room(room_id,price);

/*Index to customer table*/
CREATE UNIQUE INDEX uc ON customer(cust_id,cust_name);

/*Index to register table*/
CREATE UNIQUE INDEX ure	ON register(cust_id,room_id);

/*CREATE PROCEDURE*/

/*Room information procedure*/
	/*Insert room informtaion procedure*/
DELIMITER $$
CREATE PROCEDURE  insert_room_info (IN v_room_id VARCHAR(20),IN v_type VARCHAR(20),IN v_price DOUBLE,IN v_bed INT,IN v_state VARCHAR(20),IN v_staff_id VARCHAR(20),IN v_tel VARCHAR(20),IN v_description VARCHAR(255)) 
	BEGIN 
		INSERT INTO room VALUES (v_room_id,v_type,v_price,v_bed,v_state,v_staff_id,v_tel,v_description);
	END$$
DELIMITER ;
/*call insert_room_info(666666,'bigbig',23333,3,'available',535000,6666666,'full services');*/
	
	/*Update room information procedure*/
DELIMITER $$
CREATE PROCEDURE  alter_room_info (IN v_room_id VARCHAR(20),IN v_type VARCHAR(20),IN v_price DOUBLE,IN v_bed INT,IN v_state VARCHAR(20),IN v_staff_id VARCHAR(20),IN v_tel VARCHAR(20),IN v_description VARCHAR(255)) 
	BEGIN 
		UPDATE room SET TYPE=v_type,price=v_price,bed=v_bed,state=v_state,staff_id=v_staff_id,tel=v_tel,description=v_description WHERE room_id=v_room_id;
	END$$
DELIMITER ;
/*call alter_room_info(666666,'smallsmall',23333,3,'available',535000,6666666,'full services');*/

	/*Delete room information procedure*/
DELIMITER $$
CREATE PROCEDURE  delete_room_info (IN v_room_id VARCHAR(20)) 
	BEGIN 
		DELETE FROM room WHERE room_id=v_room_id; 
	END$$
DELIMITER ;
/*call delete_room_info(666666);*/

/*Procedure for customer information*/
	/*Insert customer information*/
DELIMITER $$
CREATE PROCEDURE insert_cust_info (IN v_cust_id VARCHAR(20), IN v_cust_name VARCHAR(30),IN v_id_num VARCHAR(20),IN v_address VARCHAR(255),IN v_phone VARCHAR(20),IN v_postcode VARCHAR(20),IN v_spent DOUBLE)
	BEGIN
		INSERT INTO customer VALUES (v_cust_id,v_cust_name,v_id_num,v_address,v_phone,v_postcode,v_spent);
	END$$
DELIMITER ;
/*call insert_cust_info (666666,'xxx xxxx',330821199610200048,'UnitedInternationalCollege, lalala-No.3933',13938573857,510000,0);*/

	/*Update customer information*/
DELIMITER $$
CREATE PROCEDURE alter_cust_info (IN v_cust_id VARCHAR(20), IN v_cust_name VARCHAR(30),IN v_id_num VARCHAR(20),IN v_address VARCHAR(255),IN v_phone VARCHAR(20),IN v_postcode VARCHAR(20),IN v_spent DOUBLE)
	BEGIN
		UPDATE customer SET cust_name=v_cust_name,id_num=v_id_num,address=v_address,phone=v_phone,postcode=v_postcode,spent=v_spent WHERE cust_id=v_cust_id;
	END$$
DELIMITER ;
/*call alter_cust_info (666666,'ooo oooo',330821199610200048,'UnitedInternationalCollege, lalala-No.3933',13938573857,510510,0);*/

	/*delete customer information*/
DELIMITER $$
CREATE PROCEDURE delete_cust_info (IN v_cust_id VARCHAR(20))
	BEGIN
		DELETE FROM customer WHERE cust_id=v_cust_id;
	END$$
DELIMITER ;
/*call delete_cust_info (666666);*/

/*Create check in information procedure*/
	/*Insert check in regester information*/
DELIMITER $$
CREATE PROCEDURE insert_regis_info (IN v_room_id VARCHAR(20), IN v_cust_id VARCHAR(20),IN v_book_time DATE)
	BEGIN
		INSERT INTO register VALUES(v_room_id,v_cust_id,v_book_time);
	END$$
DELIMITER ;
/*call insert_regis_info();*/

	/*Update check in information*/
DELIMITER $$
CREATE PROCEDURE alter_regis_info (IN v_room_id VARCHAR(20), IN v_cust_id VARCHAR(20),IN v_book_time DATE)
	BEGIN 
		UPDATE register SET room_id=v_kfb,cust_id=v_cust_id,book_time=v_book_time;
	END$$
DELIMITER ;
/*call alter_regis_info ();*/

	/*Check out and delete regist information*/
DELIMITER $$
CREATE PROCEDURE delete_regis_info (IN v_cust_id VARCHAR(20))
	BEGIN 
		DELETE FROM register WHERE cust_id=v_cust_id;
	END$$
DELIMITER ;
/*call delete_regis_info ()*/

/*Query procedure*/
	/*query room id*/
DELIMITER $$
CREATE PROCEDURE room_id_query (IN v_room_id VARCHAR(20),OUT v_type VARCHAR(20),OUT v_price DOUBLE,OUT v_bed INT,OUT v_state VARCHAR(20),OUT v_staff_id VARCHAR(20),OUT tel VARCHAR(20),OUT description VARCHAR(255))
	BEGIN 
		SELECT v_type=TYPE,v_price=price,v_bed=bed,v_state=state,v_staff_id=staff_id,v_tel=tel,v_description=description FROM room WHERE room_id=v_room_id;
	END$$
DELIMITER ;
/*call room_id_query ()*/

	/*query customer id*/
DELIMITER $$
CREATE PROCEDURE cust_id_query (IN v_cust_id VARCHAR(20),OUT v_cust_name VARCHAR(30),OUT v_id_num VARCHAR(20),OUT v_address VARCHAR(255),v_birthday DATE,v_phone VARCHAR(20),v_postcode VARCHAR(20),v_spent DOUBLE)
	BEGIN
		SELECT v_cust_name=cust_name,v_id_num=id_num,v_address=address,v_birthday=birthday,v_phone=phone,v_postcode=postcode,v_spent=spent FROM customer WHERE cust_id=v_cust_id;
	END$$
DELIMITER ;
/*call cust_id_query*/

	/*Procedure to query registed customer id*/
DELIMITER $$
CREATE PROCEDURE regis_cust_id_query (OUT v_room_id VARCHAR(20),IN v_cust_id VARCHAR(20),OUT v_book_time DATE)
	BEGIN
		SELECT v_cust_id=cust_id,v_book_time=book_time FROM register WHERE room_id=v_room_id;
	END$$
DELIMITER ;
/*call regis_cust_id_query ()*/

/*Create Trigger*/ 
	
	/*Update room status and customer spent*/
DELIMITER $$
CREATE TRIGGER check_in AFTER INSERT ON register FOR EACH ROW 
	BEGIN
		DECLARE s INT;
		DECLARE p INT;
		UPDATE room SET state='occupy' WHERE room_id=new.room_id;
		SET s=(SELECT spent FROM customer WHERE cust_id=new.cust_id);
		SET p=(SELECT price FROM room WHERE room.room_id=new.room_id);
		UPDATE customer SET spent=s+p WHERE cust_id=new.cust_id;
	END$$
DELIMITER ;

	/*Delete register information*/
DELIMITER $$
CREATE TRIGGER check_out AFTER DELETE ON register FOR EACH ROW 
	BEGIN
		UPDATE room SET state='available' WHERE room_id=old.room_id;
	END$$
DELIMITER ;

	/*Update VIP*/
DELIMITER $$
CREATE TRIGGER vip_tri AFTER UPDATE ON customer FOR EACH ROW
	BEGIN
		INSERT INTO vip SELECT cust_id FROM customer WHERE spent>=8000 AND cust_id NOT IN (SELECT cust_id FROM vip); 
		#UPDATE vip SET spent=new.spent WHERE cust_id=new.cust_id;
	END$$
DELIMITER ;

CALL insert_room_info(88888,'super',500,10,'available',535000,6688888,'full services');
INSERT INTO register VALUES (88888,100001,'2018-05-22');   -- 5700  +500          room/ customer/ register
DELETE FROM register WHERE room_id=88888;     -- room/ register
INSERT INTO register VALUES (88888,100009,'2018-05-20');   -- 7900  +500          room/ customer/ register/ vip
DELETE FROM register WHERE room_id=88888;     -- room/ register
INSERT INTO register VALUES (88888,100009,'2018-05-21');   -- 8400  +500          room/ customer/ register/
DELETE FROM register WHERE room_id=88888;     -- room/ register
CALL delete_room_info(88888);
CALL alter_cust_info(100001,'philly Lee',140401196210307092,'TangJiaDistrict, ZhuqueRoad-NO.9946',13391477627,510000,5700);
CALL alter_cust_info(100009,'rasheeda Rand',310223197904301962,'HuangpuDistrict, MakaoRoad-NO.45466',13540511893,510000,7900);
DELETE FROM vip WHERE cust_id=100009;