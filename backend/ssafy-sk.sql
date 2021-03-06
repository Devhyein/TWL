DROP TABLE IF EXISTS `user`;

create table `member` (
  `no` int auto_increment NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` int DEFAULT NULL,
  `create_date` datetime DEFAULT current_timestamp(),
  `nickname` char(20) NOT NULL,
  `info` varchar(200),
  PRIMARY KEY (`email`),
  UNIQUE KEY `member_idx_unique_no` (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- create table interest(
-- `no` int auto_increment,
-- `email`  varchar(128) DEFAULT NULL,
-- `skill` char(128) not null,
-- foreign key (`email`) references user(`email`) on delete cascade,
-- primary key (`email`,`skill`),
-- UNIQUE KEY `interst_unique_no` (`no`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 복합키
create table interest(
  `interest_id` int auto_increment not null,
`email`  varchar(128) DEFAULT NULL,
`skill` char(128) not null,
foreign key (`email`) references member(`email`) on delete cascade,
primary key (`email`,`skill`),
UNIQUE key `interest_id` (`interest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table `socialmember` (
  `no` int auto_increment NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `createDate` datetime DEFAULT current_timestamp(),
  `nickname` char(20) NOT NULL,
  `info` varchar(200),
  `type` varchar(8),
  `img` text,
  PRIMARY KEY (`email`),
  UNIQUE KEY `memberIdx_unique_no` (`no`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;