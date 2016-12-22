CREATE TABLE `pages` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `title` varchar(63) NOT NULL,
  `href` varchar(511) NOT NULL,
  `description` varchar(127) DEFAULT NULL,
  `content` longtext,
  `author_id` int(11) NOT NULL DEFAULT '0',
  `page_status_id` int(6) DEFAULT '0',
  `date_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_published` datetime DEFAULT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `href` (`href`),
  KEY `author_id` (`author_id`),
  KEY `page_status_id` (`page_status_id`)
)
