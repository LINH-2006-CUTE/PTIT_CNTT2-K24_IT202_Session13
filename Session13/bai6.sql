use session13_hw;
create table friendships (
    follower_id int, 
    followee_id int, 
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);
delimiter //
create trigger after_friendship_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users 
        set follower_count = follower_count + 1 
        where user_id = new.followee_id;
    end if;
end //
delimiter ;
delimiter //
create trigger after_friendship_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users 
        set follower_count = follower_count - 1 
        where user_id = old.followee_id;
    end if;
end //
delimiter ;
delimiter //
create procedure follow_user(p_follower_id int, p_followee_id int)
begin
    if p_follower_id = p_followee_id then
        signal sqlstate '45000' set message_text = 'khong the tu theo doi chinh minh!';
    else
        insert into friendships (follower_id, followee_id, status) 
        values (p_follower_id, p_followee_id, 'accepted');
    end if;
end //
delimiter ;

create view user_profile as
select 
    u.user_id, 
    u.username, 
    u.follower_count, 
    u.post_count,
    coalesce(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

select * from user_profile;
delete from friendships where follower_id = 1 and followee_id = 2;
select * from user_profile;