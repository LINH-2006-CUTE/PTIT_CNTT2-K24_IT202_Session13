CREATE TABLE SanPham (
    id INT PRIMARY KEY,
    ten VARCHAR(50),
    ton_kho INT
);

CREATE TABLE DonHang (
    id INT PRIMARY KEY,
    id_sanpham INT,
    so_luong_mua INT
);

INSERT INTO SanPham VALUES (1, 'Laptop Dell', 10);

elimiter //
create trigger demo_1
{before | after}{insert | update | delete}
on demo_1 for each row 
begin
-- NOI DUNG  
end //
delimiter ;