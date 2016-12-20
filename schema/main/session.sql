CREATE TABLE `session` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `session` VARCHAR(126) DEFAULT NULL,
 `expired` TINYINT(1) DEFAULT NULL,
 `expiration` DATE NOT NULL,
 `user_id` VARCHAR(11) NOT NULL,
 PRIMARY KEY (`id`),
 FOREIGN KEY (user_id) REFERENCES users(id)
);
