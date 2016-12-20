CREATE TABLE `site_options` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(63) DEFAULT NULL,
 `value` varchar(511) DEFAULT NULL,
 PRIMARY KEY (`id`),
 UNIQUE (`name`)
)
