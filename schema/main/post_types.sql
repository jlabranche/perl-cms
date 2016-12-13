CREATE TABLE `post_types` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `title` varchar(31) NOT NULL,
 `description` varchar(255) NOT NULL,
 PRIMARY KEY (`id`),
 UNIQUE KEY `title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1

