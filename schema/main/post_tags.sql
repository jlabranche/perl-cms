CREATE TABLE `post_tags` (
`post_id` int(11) NOT NULL,
`tag_id` int(11) NOT NULL,
KEY `post_id` (`post_id`),
KEY `tag_id` (`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1

