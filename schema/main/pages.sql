CREATE TABLE `pages` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(63) NOT NULL,
 `href` varchar(511) NOT NULL,
 `description` varchar(127) DEFAULT NULL,
 `content` longtext DEFAULT NULL,
 `author_id` int(11) NOT NULL DEFAULT 0,
 PRIMARY KEY (id),
 UNIQUE (`href`),
 FOREIGN KEY (`author_id`) REFERENCES users(`id`)
)
