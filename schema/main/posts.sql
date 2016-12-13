CREATE TABLE `posts` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `author` int(11) DEFAULT NULL,
 `publish_date` date NOT NULL,
 `title` varchar(255) NOT NULL,
 `subtitle` varchar(255) DEFAULT NULL,
 `content` longtext,
 `feature_image_url` varchar(511) DEFAULT NULL,
 `post_type` int(11) DEFAULT NULL,
 PRIMARY KEY (`id`),
 KEY `author` (`author`),
 KEY `post_type` (`post_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1

