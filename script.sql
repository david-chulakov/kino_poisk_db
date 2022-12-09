DROP DATABASE IF EXISTS kino_poisk;
CREATE DATABASE kino_poisk;
USE kino_poisk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(200) NOT NULL,
	last_name VARCHAR(200) NOT NULL,
	email VARCHAR(200) NOT NULL,
	birthday DATE
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(200) NOT NULL
);

DROP TABLE IF EXISTS film_types;
CREATE TABLE film_types (
	type_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS films;
CREATE TABLE films (
	film_id SERIAL PRIMARY KEY,
	film_name VARCHAR(255) NOT NULL  COMMENT 'Название фильма',
	type_id TINYINT UNSIGNED NOT NULL COMMENT 'Фильм или Сериал',
	description TEXT,
	category_id BIGINT UNSIGNED NOT NULL COMMENT 'Жанр',
	country VARCHAR(100) NOT NULL COMMENT 'Страна',
	director VARCHAR(255) NOT NULL COMMENT 'ФИ Режиссера',
	budjet INT UNSIGNED NOT NULL COMMENT 'Бюджет фильма',
	premiere_year YEAR COMMENT 'Год премьеры',
	age_rating ENUM('0+', '6+', '12+', '16+', '18+') NOT NULL,
	imdb_rating FLOAT COMMENT 'Рейтинг IMDB',
	CONSTRAINT film_category_id_fk
		FOREIGN KEY (category_id)
		REFERENCES categories(category_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT type_id_fk
		FOREIGN KEY (type_id)
		REFERENCES film_types(type_id)
);



DROP TABLE IF EXISTS film_reviews;
CREATE TABLE film_reviews (
	review_id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	review_text TEXT NOT NULL,
	evaluation TINYINT NOT NULL,
	CONSTRAINT user_id_fk1
		FOREIGN KEY (user_id) REFERENCES users(user_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT film_id_fk
		FOREIGN KEY (film_id) REFERENCES films(film_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	actor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	birthday DATE
) COMMENT 'Актеры';

DROP TABLE IF EXISTS actors_films;
CREATE TABLE actors_films (
	id SERIAL PRIMARY KEY,
	actor_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (film_id) REFERENCES films(film_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
) COMMENT 'Актеры и в каких фильмах они снимались';

DROP TABLE IF EXISTS films_viewed;
CREATE TABLE films_viewed (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (film_id) REFERENCES films(film_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	media_type_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_name VARCHAR(200) NOT NULL
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	media_id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	media_type_id TINYINT UNSIGNED NOT NULL,
	filename VARCHAR(200),
	FOREIGN KEY (film_id) REFERENCES films(film_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES media_types(media_type_id)
);

