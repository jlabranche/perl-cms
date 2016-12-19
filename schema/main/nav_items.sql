CREATE TABLE `nav_items` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(63) DEFAULT NULL,
 `href` varchar(511) DEFAULT NULL,
 `position` int(6) NOT NULL,
 PRIMARY KEY (`id`)
)
