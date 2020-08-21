CREATE TABLE `article` (
  `articleid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) DEFAULT NULL,
  `nickname` char(20) NOT NULL,
  `title` varchar(128) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `imgUrl` text DEFAULT NULL,
  `updatedAt` datetime DEFAULT current_timestamp(),
  `createdAt` datetime DEFAULT current_timestamp(),
  `preview` varchar(200) DEFAULT NULL,
  `ispublic` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`articleid`),
  KEY `email` (`email`),
  KEY `nickname` (`nickname`),
  CONSTRAINT `article_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `article_ibfk_2` FOREIGN KEY (`nickname`) REFERENCES `member` (`nickname`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `comment` (
  `commentid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) DEFAULT NULL,
  `articleid` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `updatedAt` datetime DEFAULT current_timestamp(),
  `createdAt` datetime DEFAULT current_timestamp(),
  `img` text DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `nickname` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`commentid`),
  KEY `email` (`email`),
  KEY `articleid` (`articleid`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`articleid`) REFERENCES `article` (`articleid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `follow` (
  `followid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `followEmail` varchar(128) NOT NULL,
  PRIMARY KEY (`email`,`followEmail`),
  UNIQUE KEY `followId` (`followid`),
  KEY `followEmail` (`followEmail`),
  CONSTRAINT `follow_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `follow_ibfk_2` FOREIGN KEY (`followEmail`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `interest` (
  `interestid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `sno` int(11) NOT NULL,
  PRIMARY KEY (`email`,`sno`),
  UNIQUE KEY `interestId` (`interestid`),
  KEY `sno` (`sno`),
  CONSTRAINT `interest_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE,
  CONSTRAINT `interest_ibfk_2` FOREIGN KEY (`sno`) REFERENCES `skills` (`sno`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `keyword` (
  `keywordid` int(11) NOT NULL AUTO_INCREMENT,
  `articleid` int(11) NOT NULL,
  `sno` int(11) NOT NULL,
  PRIMARY KEY (`keywordid`),
  KEY `articleid` (`articleid`),
  KEY `sno` (`sno`),
  CONSTRAINT `keyword_ibfk_1` FOREIGN KEY (`articleid`) REFERENCES `article` (`articleid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `keyword_ibfk_2` FOREIGN KEY (`sno`) REFERENCES `skills` (`sno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3349 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `likes` (
  `likesid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `articleid` int(11) NOT NULL,
  PRIMARY KEY (`email`,`articleid`),
  UNIQUE KEY `likesId` (`likesid`),
  KEY `articleid` (`articleid`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`articleid`) REFERENCES `article` (`articleid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=767 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `member` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `createDate` datetime DEFAULT current_timestamp(),
  `nickname` char(20) NOT NULL,
  `info` varchar(200) DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `github` varchar(300) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`email`),
  UNIQUE KEY `memberIdx_unique_no` (`no`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `member` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `createDate` datetime DEFAULT current_timestamp(),
  `nickname` char(20) NOT NULL,
  `info` varchar(200) DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `github` varchar(300) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`email`),
  UNIQUE KEY `memberIdx_unique_no` (`no`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `notification` (
  `notificationid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `other` varchar(128) NOT NULL,
  `content` varchar(256) NOT NULL,
  `type` varchar(128) NOT NULL,
  `readn` int(11) NOT NULL,
  `ready` tinyint(1) DEFAULT NULL,
  `articleid` int(11) NOT NULL,
  `createtime` datetime DEFAULT current_timestamp(),
  `nickname` varchar(20) DEFAULT NULL,
  `othernickname` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`email`,`other`,`type`,`content`(255),`articleid`,`readn`),
  UNIQUE KEY `notificationid` (`notificationid`),
  KEY `other` (`other`),
  KEY `notification_ibfk_3` (`articleid`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE,
  CONSTRAINT `notification_ibfk_2` FOREIGN KEY (`other`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_ibfk_3` FOREIGN KEY (`articleid`) REFERENCES `article` (`articleid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=584 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `pin` (
  `pinid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `articleid` int(11) NOT NULL,
  PRIMARY KEY (`email`,`articleid`),
  UNIQUE KEY `pinId` (`pinid`),
  KEY `articleid` (`articleid`),
  CONSTRAINT `pin_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pin_ibfk_2` FOREIGN KEY (`articleid`) REFERENCES `article` (`articleid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `skills` (
  `sno` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB AUTO_INCREMENT=496 DEFAULT CHARSET=utf8;