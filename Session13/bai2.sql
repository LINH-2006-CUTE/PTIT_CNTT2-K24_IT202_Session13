use session13_hw;
create table likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);
insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');
delimiter //
create trigger after_like_insert
after insert on likes
for each row
begin
    update posts 
    set like_count = like_count + 1
    where post_id = new.post_id;
end //
delimiter ;
delimiter //
create trigger after_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end //
delimiter ;
create view user_statistics as
select 
    u.user_id, 
    u.username, 
    u.post_count, 
    sum(p.like_count) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;
insert into likes (user_id, post_id, liked_at) values (2, 4, now());
select * from posts where post_id = 4;
select * from user_statistics;
delete from likes where user_id = 2 and post_id = 4;
select * from user_statistics;
-- ==============================
-- BAI 3:
delimiter //
create trigger before_like_insert
before insert on likes
for each row
begin
    declare owner_id int;
	select user_id into owner_id 
    from posts 
    where post_id = new.post_id;
    
    if new.user_id = owner_id then
        signal sqlstate '45000' 
        set message_text = 'không được tự like bài viết của chính mình!';
    end if;
end //
delimiter ;
delimiter //
create trigger after_like_update
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        update posts set like_count = like_count - 1 where post_id = old.post_id;
        update posts set like_count = like_count + 1 where post_id = new.post_id;
    end if;
end //
delimiter ;
select post_id, like_count from posts where post_id in (3, 4);
-- ==============================
-- BAI 4
create table post_history (
    history_id int primary key auto_increment,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);
delimiter //
create trigger before_post_update
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end //
delimiter ;

-- UPDATE 
update posts 
set content = 'nội dung đã thay đổi' 
where post_id = 1;

update posts 
set content = 'nội dung cập nhật lần hai' 
where post_id = 1;
select * from post_history;