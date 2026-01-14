create database banking;
use banking;


create table account_banking (
	id int primary key auto_increment,
    full_name varchar(30) not null,
    balance decimal(10,2)
);

create table notification(
	id int primary key auto_increment,
    message varchar(255)
);

select * from account_banking;
select * from notification;
-- khi có 1 tài khoản được tạo thì thêm 1 bản ghi vào bảng thông báo đã tạo thành công 
DROP TRIGGER IF EXISTS trigger_after_insert_account;

delimiter //
create trigger trigger_after_insert_account
after insert on  account_banking
for each row
begin
	insert into notification (message) value('tao thanh cong tai khoan');
end //
delimiter ;

-- Nếu số dư <0 thfi không cho phép thêm mới
delimiter //
create trigger trigger_check_balance 
before insert on account_banking
for each row
begin
	if new.balance < 0 then
     signal sqlstate '45000' set message_text= 'So du khong the am!!!!';
--     set new.balance =0; 
    end if;
end //
delimiter ;