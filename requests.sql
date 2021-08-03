use kino_poisk;

# пользователи
SELECT * FROM users;

# фильмы
SELECT * FROM films;

# актеры
SELECT * FROM actors;

# Актеры фильма 
delimiter /
DROP PROCEDURE IF EXISTS actors_in_film/
CREATE PROCEDURE actors_in_film(film_name VARCHAR(200))
BEGIN
	SELECT tbl2.name as film_name, tbl3.type_name as `type`, tbl4.category_name as category, 
		tbl5.first_name as actor_fn, tbl5.last_name as actor_ln
	FROM actors_films tbl1
	JOIN films tbl2 ON tbl1.film_id = tbl2.id
	JOIN film_types tbl3 ON tbl2.type_id = tbl3.id 
	JOIN categories tbl4 ON tbl2.category_id = tbl4.id 
	JOIN actors tbl5 ON tbl1.actor_id = tbl5.id 
	WHERE tbl2.name = film_name;
END;
/
delimiter ;

CALL actors_in_film('Начало');

# сколько фильмов посмотрел пользователь
delimiter /
DROP FUNCTION IF EXISTS films_watched_by_uesr_id /
CREATE FUNCTION films_watched_by_user_id(user_id BIGINT UNSIGNED)
	RETURNS INT DETERMINISTIC
BEGIN
	
	DECLARE `result` INT;
	SET `result` = (SELECT COUNT(*)
	FROM users tbl1
	JOIN films_viewed tbl2 ON tbl1.id = tbl2.user_id
	JOIN films tbl3 ON tbl2.film_id = tbl3.id 
	WHERE tbl1.id = user_id);

	RETURN `result`;
END;
/

delimiter ;

SELECT films_watched_by_user_id(1);



# Отзывы фильма
CREATE OR REPLACE VIEW reviews
AS
	SELECT tbl2.name as film_name, tbl3.first_name as user_name, tbl1.review 
	FROM film_reviews tbl1
	JOIN films tbl2 ON tbl1.film_id = tbl2.id 
	JOIN users tbl3 ON tbl1.user_id = tbl3.id;

SELECT * FROM reviews r ;


# Файлы фильма
delimiter /
DROP PROCEDURE IF EXISTS film_files/
CREATE PROCEDURE film_files(film_name VARCHAR(200))
BEGIN
	SELECT tbl2.name as film_name, tbl3.type_name, tbl1.filename
	FROM media tbl1
	JOIN films tbl2 ON tbl1.film_id = tbl2.id 
	JOIN media_types tbl3 ON tbl1.media_type_id = tbl3.id 
	WHERE tbl2.name = film_name;
END;
/
delimiter ;
CALL film_files('Начало')


# какие фильмы посмотерл пользователь
delimiter /
DROP PROCEDURE IF EXISTS what_films_by_user_id/
CREATE PROCEDURE what_films_by_user_id(
	user_id BIGINT UNSIGNED)
BEGIN
	SELECT tbl1.first_name as user_name, tbl3.name as film_name
	FROM users tbl1
	JOIN films_viewed tbl2 ON tbl1.id = tbl2.user_id
	JOIN films tbl3 ON tbl2.film_id = tbl3.id 
	WHERE tbl1.id = user_id;
END;
/
delimiter ;

CALL what_films_by_user_id(1);


# триггер для проверки возраста пользователя перед обновлением
delimiter //
DROP TRIGGER IF EXISTS check_uesr_age_before_update//
CREATE TRIGGER check_user_age_before_update BEFORE UPDATE ON users
FOR EACH ROW 
BEGIN 
	IF NEW.birthday >= CURRENT_DATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Обновление не прошло. День рождения должен быть в прошлом';
	END IF;
END //

delimiter ;

# триггер для корректировки возраста пользователя

DROP TRIGGER IF EXISTS check_user_age_before_insert;
delimiter //

CREATE TRIGGER check_user_age_before_insert BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	IF NEW.birthday > CURRENT_DATE() THEN
		SET NEW.birthday = CURRENT_DATE();
	END IF;
END//

delimiter ;



