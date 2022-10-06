-- DELIMITER $$

-- CREATE TRIGGER trigger_name
--      trigger_time trigger_event ON table_name FOR EACH ROW
--      BEGIN
--      END;
-- $$

-- DELIMITER ;

-- create database trigger_demo;
use trigger_demo;

-- create table users
-- (
-- username varchar(100),
-- age int
-- );

-- insert into users 
-- (username, age) values ("Bobby", 23);

DELIMITER $$
-- $$(or any symbol can be used instead) treats it as a single code, else every ; will be considered as the end of the code. 
CREATE TRIGGER must_be_adult
     BEFORE INSERT ON users FOR EACH ROW
     BEGIN
          IF NEW.age < 18
          THEN
              SIGNAL SQLSTATE '45000'
--               45000 is a generic state representing "unhandled user-defined exception"
                    SET MESSAGE_TEXT = 'Must be an adult!';
          END IF;
     END;
$$
DELIMITER ;

insert into users 
(username, age) values ("Kim", 12); 
-- Error Code: 1644. Must be an adult!

select * from users;

-- TRIGGERS USING INSTAGRAM DATA
-- =============================
-- Preventing instagram self-follows with triggers

-- DELIMITER $$

-- CREATE TRIGGER trigger_name
--      trigger_time trigger_event ON table_name FOR EACH ROW
--      BEGIN
--      END;
-- $$

-- DELIMITER ;

insert into follows(follower_id, followee_id) values(4,4);
select * from follows;
USE ig_clone; 

DELIMITER $$
CREATE TRIGGER cant_follow_yourself
     before insert on follows for each row
     BEGIN
     IF NEW.follower_id = NEW.followee_id
		then
        signal sqlstate '45000'
        set message_text = 'cannot follow yourself';
     END if;
     END;
$$
DELIMITER ;

insert into follows(follower_id, followee_id) values(7,2);

insert into follows(follower_id, followee_id) values(5,5);
-- Error Code: 1644. cannot follow yourself

-- Logging Unfollows
-- ====================
-- create a table unfollows 

select * from unfollows;

-- DELIMITER $$
-- CREATE TRIGGER trigger_name
--      trigger_time trigger_event ON table_name FOR EACH ROW
--      BEGIN
--      END;
-- $$
-- DELIMITER ;

DELIMITER $$
CREATE TRIGGER capture_unfollows
     After delete ON follows FOR EACH ROW
     BEGIN
     -- insert into unfollows(follower_id, followee_id)
--      values(old.follower_id, old.followee_id);
     insert into unfollows
     set follower_id = old.follower_id,
     followee_id = old.followee_id;
     END;
$$
DELIMITER ;

select * from unfollows;
select * from follows limit 5;

delete from follows
where follower_id = 2 and followee_id = 1;

select * from unfollows;

-- Managing Triggers
show triggers;





