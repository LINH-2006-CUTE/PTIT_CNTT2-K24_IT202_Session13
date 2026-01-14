use session13_hw;
create table users_ss13 (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,   
    email varchar(100) unique not null,   
    created_at date,                      
    follower_count int default 0,          
    post_count int default 0               
);

delimiter //
create procedure add_user(
    in p_username varchar(50), 
    in p_email varchar(100), 
    in p_created_at date
)
begin
    insert into users_ss13 (username, email, created_at) 
    values (p_username, p_email, p_created_at);
end //
delimiter ;


delimiter //
create trigger before_user_insert
before insert on users_ss13
for each row
begin
    -- kiểm tra email
    if new.email not like '%@%.%' then
        signal sqlstate '45000' 
        set message_text = 'định dạng email không hợp lệ';
    end if;

	if new.username regexp '[^a-z0-9_]' then
        signal sqlstate '45000' 
        set message_text = 'username chỉ được chứa chữ cái, số và dấu gạch dưới';
    end if;
end //
delimiter ;
-- ktr
call add_user('lin', 'lin@example.com', curdate());
call add_user('abc', 'abc_email_sai.com', curdate());
call add_user('lin@#$%^&&*()', 'lin@example.com', curdate());
