create database session13_hw;
use session13_hw;
create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-10'),
('bob', 'bob@example.com', '2025-01-11'),
('charlie', 'charlie@example.com', '2025-01-12'),
('david', 'david.test@gmail.com', '2025-01-13'),
('emma', 'emma_sweet@yahoo.com', '2025-01-14'),
('frank', 'frank.tank@outlook.com', '2025-01-15'),
('grace', 'grace.hopper@pro.com', '2025-01-16'),
('hannah', 'hannah.dev@it.com', '2025-01-17'),
('ian', 'ian.m@company.org', '2025-01-18'),
('julia', 'julia.art@design.net', '2025-01-19');

delimiter //
create trigger after_post_insert
after insert on posts
for each row
begin
    update users 
    set post_count = post_count + 1
    where user_id = new.user_id;
end //
delimiter ;

delimiter //
create trigger after_post_insert_ss13
after insert on posts
for each row
begin
    update users 
    set post_count = post_count + 1
    where user_id = new.user_id;
end //
delimiter ;
insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

select * from users;
delete from posts where post_id = 2;
select * from users;

