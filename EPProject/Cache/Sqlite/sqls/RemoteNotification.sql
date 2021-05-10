DROP TABLE IF EXISTS `RemoteNotification`;
CREATE TABLE `RemoteNotification` (
  `msgId` varchar(10),
  `userId` varchar(10),
  `type` integer(5) NOT NULL,
  `dateTime` integer(15) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` varchar(100) NOT NULL,
  `url` varchar(100),
  PRIMARY KEY (`msgId`,`userId`,`type`)
);
