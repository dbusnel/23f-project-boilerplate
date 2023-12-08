CREATE DATABASE Symphony;

GRANT ALL PRIVILEGES ON Symphony.* TO 'webapp'@'%';
flush privileges;

USE Symphony;

CREATE TABLE User (
    user_id     INTEGER AUTO_INCREMENT PRIMARY KEY,
    first_name  TINYTEXT NOT NULL,
    last_name   TINYTEXT NOT NULL,
    city        TEXT NOT NULL,
    email       TEXT,
    phone       VARCHAR(13)
);

INSERT INTO User(first_name, last_name, city, email, phone)
VALUES ('Thom', 'Yorke', 'Kingston', 'tyorke@nhsenate.gov', '603-583-1353');
INSERT INTO User(first_name, last_name, city, email, phone)
VALUES ('Alec', 'Churchill', 'Chicago', 'robloxfan110@hotmail.com', '278-522-8821');
INSERT INTO User(first_name, last_name, city, email, phone)
VALUES ('Lal', 'Celikbilek', 'Anime City', 'ilovefurries@bostoncorrectionalcenter.org', '666-415-3133');

CREATE TABLE User_Likes (
    user_id     INTEGER,
    liked_id    INTEGER,

    PRIMARY KEY (user_id, liked_id),
    CONSTRAINT fk_user_likes_1 FOREIGN KEY (user_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_user_likes_2 FOREIGN KEY (liked_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO User_Likes
VALUES (1, 2);
INSERT INTO User_Likes
VALUES (2, 3);
INSERT INTO User_Likes
VALUES (3, 2);

CREATE TABLE Flags (
    flag_id     INTEGER AUTO_INCREMENT PRIMARY KEY,
    description TEXT NOT NULL,
    user_id     INTEGER,

    CONSTRAINT fk_flags FOREIGN KEY (user_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Flags (description, user_id)
VALUES ('Inappropriate profile picture.', 3);
INSERT INTO Flags (description, user_id)
VALUES ('Physically apprehensive; ''a ticking-time bomb no one should have to witness'', dangerous presence-- consider shadow-ban.', 3);
INSERT INTO Flags (description, user_id)
VALUES ('lunatic sent me 13,522 messages in less than 8 hours', 3);

CREATE TABLE Artist (
    artist_id   INTEGER AUTO_INCREMENT PRIMARY KEY,
    first_name  TEXT NOT NULL,
    last_name   TEXT,
    email       TEXT,
    phone       VARCHAR(13),
    city        TEXT
);

INSERT INTO Artist(first_name, last_name, email, phone, city)
VALUES ('Jonathan', 'Davis', 'busneldavid55@gmail.com', '603-222-1231', 'Exeter');
INSERT INTO Artist(first_name, last_name, email, phone, city)
VALUES ('Alex', 'G', 'crackedrib@texasroadhouse.tr', '101-321-9901', 'Austin');
INSERT INTO Artist(first_name, last_name, email, phone, city)
VALUES ('Elliott', 'Smith', 'sadthings@montanna.now', '617-822-0991', 'Omaha');

CREATE TABLE User_Profile (
    user_id         INTEGER,
    display_name    VARCHAR(18),
    favorite_artist INTEGER,
    verified        BOOLEAN,
    bio             TEXT,
    photo           BLOB,

    PRIMARY KEY (user_id, display_name),
    CONSTRAINT fk_user_profile FOREIGN KEY (user_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_favorite_artist FOREIGN KEY (favorite_artist) REFERENCES Artist (artist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO User_Profile
VALUES(1, 'thomyorke', 1, 1, 'We''re here for a good time, not a long one. Live Laugh Love.', NULL);
INSERT INTO User_Profile
VALUES(2, 'puppiescatsdogs', 2, 0, 'y''all are so weird...', NULL);
INSERT INTO User_Profile
VALUES(3, 'PINAPPLES-RAINBOWS', 3, 0, '*does cool hand thing* Hi [kawaii] Friends! I''m Lal and i love music anime, drawing, and anime openings, and video games, and programming anime games and more! <all things anime ˶ᵔ ᵕ ᵔ˶>', NULL);

CREATE TABLE Artist_Profile (
    artist_id   INTEGER,
    artist_name VARCHAR(100),
    bio         MEDIUMTEXT,
    photo       BLOB,

    PRIMARY KEY (artist_id, artist_name),
    CONSTRAINT fk_artist_profile FOREIGN KEY (artist_id) REFERENCES Artist (artist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE Messages (
    sender_id    INTEGER,
    recipient_id INTEGER,
    content      VARCHAR(300),
    PRIMARY KEY (sender_id, recipient_id, content),
    CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_recipient FOREIGN KEY (recipient_id) REFERENCES User (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE  
);
INSERT INTO Artist_Profile
VALUES (1, 'Korn', 'If you listen to us you probably aren''t allowed near schools.', NULL);
INSERT INTO Artist_Profile
VALUES (2, 'Alex G', 'You''ve probably heard me on TikTok...', NULL);
INSERT INTO Artist_Profile
VALUES (3, 'Elliott Smith', 'To want something so much-- to hold it in your arms-- and know beyond a doubt you will never deserve it.', NULL);


CREATE TABLE Genre (
    genre_id    INTEGER AUTO_INCREMENT PRIMARY KEY,
    genre_name  TEXT
);

INSERT INTO Genre VALUES (1, 'Nu-Metal');
INSERT INTO Genre VALUES (2, 'Rock');
INSERT INTO Genre VALUES (3, 'Indie');

CREATE TABLE Genre_User (
    genre_id        INTEGER,
    user_id         INTEGER,
    display_name    VARCHAR(18),

    PRIMARY KEY (genre_id, user_id, display_name),
    CONSTRAINT fk_genre_user_1 FOREIGN KEY (genre_id) REFERENCES Genre (genre_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_genre_user_2 FOREIGN KEY (user_id, display_name) REFERENCES User_Profile (user_id, display_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Genre_User
VALUES (1, 3, 'PINAPPLES-RAINBOWS');
INSERT INTO Genre_User
VALUES (2, 1, 'thomyorke');
INSERT INTO Genre_User
VALUES (3, 2, 'puppiescatsdogs');


CREATE TABLE Genre_Artist (
    genre_id    INTEGER,
    artist_id   INTEGER,
    artist_name VARCHAR(100),

    PRIMARY KEY (genre_id, artist_id, artist_name),
    CONSTRAINT fk_genre_artist_1 FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_genre_artist_2 FOREIGN KEY (artist_id, artist_name) REFERENCES Artist_Profile(artist_id, artist_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Genre_Artist
VALUES (1, 1, 'Korn');
INSERT INTO Genre_Artist
VALUES (3, 2, 'Alex G');
INSERT INTO Genre_Artist
VALUES (3, 3, 'Elliott Smith');

CREATE TABLE Post (
    post_id      INTEGER AUTO_INCREMENT PRIMARY KEY,
    artist_id    INTEGER,
    artist_name  VARCHAR(100),
    title        TEXT,
    content      MEDIUMTEXT,
    likes        INTEGER,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_post FOREIGN KEY (artist_id, artist_name) REFERENCES Artist_Profile (artist_id, artist_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Post(ARTIST_ID, ARTIST_NAME, TITLE, CONTENT, LIKES)
VALUES (1, 'Korn', 'Y''all want a single?', 'Haiiii!! It''s me Jonathan! Do you guys want to see anything new?', 19389);
INSERT INTO Post(ARTIST_ID, ARTIST_NAME, TITLE, CONTENT, LIKES)
VALUES (2, 'Alex G', 'Grabbing coffee', 'Hey, it''s Alex. Anyone in LA and wanna grab a coffee?', 12);
INSERT INTO Post(ARTIST_ID, ARTIST_NAME, TITLE, CONTENT, LIKES)
VALUES (3, 'Elliott Smith', 'Don''t give up', 'Love you all. It''s going to be okay', 239122);

CREATE TABLE Post_Comments (
    comment_id   INTEGER AUTO_INCREMENT PRIMARY KEY,
    post_id      INTEGER,
    author_id    INTEGER,
    title        TEXT,
    content      MEDIUMTEXT,
    likes        INTEGER,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_post_comments_1 FOREIGN KEY (post_id) REFERENCES Post (post_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE,
    CONSTRAINT fk_post_comments_2 FOREIGN KEY (author_id) REFERENCES User (user_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE
);

INSERT INTO Post_Comments(post_id, author_id, title, content, likes)
VALUES (3, 2, 'Thank you', 'RIP Elliott. We''ll miss you. I used to listen to you every day on the Red Line going into class at Harvard. You made four year of misery and emptiness that much more bearable, and I cannot thank you enough.', 34999);
INSERT INTO Post_Comments(post_id, author_id, title, content, likes)
VALUES (3, 3, 'NAHH', 'DIS IS MUSIC IN OHIO', 1);
INSERT INTO Post_Comments(post_id, author_id, title, content, likes)
VALUES (1, 1, 'Yes', 'New K@#*%! single?!', 392);

CREATE TABLE Venue (
    venue_id    INTEGER AUTO_INCREMENT PRIMARY KEY,
    name        TEXT,
    photo       BLOB
);

INSERT INTO Venue (name, photo)
VALUES ('Roadrunner', NULL);
INSERT INTO Venue (name, photo)
VALUES ('Irving Plaza', NULL);
INSERT INTO Venue (name, photo)
VALUES ('Sphere', NULL);

CREATE TABLE Concert_Info (
    concert_id            INTEGER AUTO_INCREMENT PRIMARY KEY,
    generated_traffic     INTEGER
);

INSERT INTO Concert_Info
VALUES(1, 1384);
INSERT INTO Concert_Info
VALUES(2, 3192);
INSERT INTO Concert_Info
VALUES(3, 2883);

CREATE TABLE Concert_Profile (
      concert_id        INTEGER,
      concert_name      VARCHAR(100),
      venue_id          INTEGER,
      price             INTEGER,
      date              DATETIME,
      bio               TEXT,
      photo             BLOB,
      ticket_stock      INTEGER,

      PRIMARY KEY (concert_id, concert_name),
      CONSTRAINT fk_concert_profile FOREIGN KEY (concert_id) REFERENCES Concert_Info (concert_id)
          ON UPDATE CASCADE
          ON DELETE CASCADE,
      CONSTRAINT fk_concert_profile_2 FOREIGN KEY (venue_id) REFERENCES Venue (venue_id)
          ON UPDATE CASCADE
          ON DELETE CASCADE
);
INSERT INTO Concert_Profile
VALUES(1, 'KORN KILLS THE WORLD TOUR - BOSTON', 1, 35, '2023-12-31 20:00:00', 'KORN celebrates the release of their new Untitled album with their biggest tour yet!', NULL, 230);
INSERT INTO Concert_Profile
VALUES(2, 'BATH SALTS MANIA', 3, 12, '2024-4-12 14:00:00', 'See your favorite metal bands up close and personal at the 2024 annual Bath Salts tour!', NULL, 25);
INSERT INTO Concert_Profile
VALUES(3, 'like a sickly butterfly', 2, 45, '2024-7-22 20:00:00', 'Slowdive, Alex G, my bloody valentine, and other Indie/Shoegaze artists join to build a heart-wrenching experience. Don''t forget your tissues!', NULL, 0);


CREATE TABLE Staff (
    staff_id        INTEGER AUTO_INCREMENT PRIMARY KEY,
    venue_id        INTEGER,
    concert_id      INTEGER,
    first_name      TEXT,
    last_name       TEXT,
    email           VARCHAR(30),
    phone           VARCHAR(13),
    title           TEXT,

    CONSTRAINT fk_staff_1 FOREIGN KEY (venue_id) REFERENCES Venue (venue_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE,
    CONSTRAINT fk_staff_2 FOREIGN KEY (concert_id) REFERENCES Concert_Info (concert_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE
);

INSERT INTO Staff (venue_id, concert_id, first_name, last_name, email, phone, title)
VALUES (1, 1, 'Michael', 'Afton', 'mafton@roadrunner.org', '603-122-0919', 'Director of Security');
INSERT INTO Staff (venue_id, concert_id, first_name, last_name, email, phone, title)
VALUES (3, 2, 'John', 'Marston', 'jmart@irving.co', '617-442-0342', 'Lead Advertiser');
INSERT INTO Staff (venue_id, concert_id, first_name, last_name, email, phone, title)
VALUES (2, 3, 'Cain', 'Zarpenter', 'cdzarpenter@arasaka.org', '652-998-1738', 'Fixer');


CREATE TABLE Artist_Concert_Bridge (
    concert_name VARCHAR(100),
    artist_id INTEGER,
    concert_id INTEGER,
    venue_id INTEGER,

    PRIMARY KEY (artist_id,concert_id,concert_name,venue_id),
    CONSTRAINT fk_artist_concert_bridge_1 FOREIGN KEY (artist_id) REFERENCES Artist (artist_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE,
    CONSTRAINT fk_artist_concert_bridge_2 FOREIGN KEY (concert_id) REFERENCES Concert_Info (concert_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE,
    CONSTRAINT fk_artist_concert_bridge_3 FOREIGN KEY (venue_id) REFERENCES Venue (venue_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE
);

INSERT INTO Artist_Concert_Bridge
VALUES ('KORN KILLS THE WORLD TOUR - BOSTON', 1, 1, 1);
INSERT INTO Artist_Concert_Bridge
VALUES ('like a sickly butterfly', 2, 3, 2);
INSERT INTO Artist_Concert_Bridge
VALUES ('like a sickly butterfly', 3, 3, 2);


SELECT genre_name FROM Genre_User JOIN Genre
WHERE user_id = 1
LIMIT 10;

SELECT artist_name FROM Artist_Concert_Bridge JOIN Artist
where Artist.artist_id = 1
LIMIT 20;