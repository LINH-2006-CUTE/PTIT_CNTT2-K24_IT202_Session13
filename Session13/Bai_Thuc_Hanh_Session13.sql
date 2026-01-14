DROP DATABASE IF EXISTS SocialNetworkDB;
create database SocialNetworkDB;
use SocialNetworkDB;

CREATE TABLE users_ss13 (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100),
    total_posts INT DEFAULT 0
);
 
 
CREATE TABLE posts_ss13 (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,                                                                                                                       
    content TEXT,
    created_at DATETIME,
    FOREIGN KEY (user_id)
        REFERENCES users_ss13 (user_id)
);
 
CREATE TABLE post_audits (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME
);


-- Thêm dữ liệu
INSERT INTO users_ss13 (username, total_posts) VALUES 
('anh_tuan_99', 0),
('bao_ngoc_ptit', 0),
('cuong_do_la', 0),
('duy_le_94', 0),
('em_be_ha_noi', 0),
('phuong_thao_vnu', 0),
('gia_huy_dev', 0),
('hoang_yen_nhi', 0),
('it_boy_2003', 0),
('khanh_huyen_95', 0);

INSERT INTO posts_ss13 (user_id, content, created_at) VALUES 
(1, 'Hôm nay học MySQL mệt nhưng mà vui!', '2026-01-10 08:30:00'),
(2, 'Có ai ở PTIT đang làm bài tập SS13 không?', '2026-01-10 09:15:00'),
(3, 'Trigger trong SQL thật sự rất mạnh mẽ.', '2026-01-11 10:00:00'),
(4, 'Làm sao để tối ưu hóa câu lệnh Join nhỉ?', '2026-01-11 14:20:00'),
(5, 'Review quán cafe học bài cực chill tại Hà Nội.', '2026-01-12 16:45:00'),
(6, 'Database Audit giúp mình kiểm soát dữ liệu tốt hơn.', '2026-01-12 19:30:00'),
(1, 'Post thứ 2 trong ngày, quyết tâm xong project!', '2026-01-13 07:00:00'),
(7, 'Chào thế giới! Mình là dev mới.', '2026-01-13 11:10:00'),
(8, 'Thời tiết hôm nay thật thích hợp để đi dạo.', '2026-01-14 15:00:00'),
(10, 'Học, học nữa, học mãi...', '2026-01-14 17:00:00');


-- Task 1 (BEFORE INSERT): Viết trigger tg_CheckPostContent trên bảng posts.
-- Nhiệm vụ: Kiểm tra nội dung bài viết (content). Nếu nội dung trống hoặc chỉ toàn khoảng trắng, hãy ngăn chặn hành động chèn và thông báo lỗi: "Nội dung bài viết không được để trống!".
DELIMITER //
CREATE TRIGGER tg_CheckPostContent
BEFORE INSERT ON posts_ss13
FOR EACH ROW
BEGIN
    IF NEW.content IS NULL OR TRIM(NEW.content) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Nội dung bài viết không được để trống!';
    END IF;
END //
DELIMITER ;

-- Task 2 (AFTER INSERT): Viết trigger tg_UpdatePostCountAfterInsert trên bảng posts.
-- Nhiệm vụ: Mỗi khi một bài viết được thêm mới thành công, hãy tự động tăng giá trị cột total_posts của người dùng đó trong bảng users lên 1 đơn vị.
DELIMITER //
CREATE TRIGGER tg_UpdatePostCountAfterInsert
AFTER INSERT ON posts_ss13
FOR EACH ROW
BEGIN
    UPDATE users_ss13 
    SET total_posts = total_posts + 1
    WHERE user_id = NEW.user_id;
END //
DELIMITER ;

-- Task 3 (AFTER UPDATE): Viết trigger tg_LogPostChanges trên bảng posts.
-- Nhiệm vụ: Khi nội dung (content) của một bài viết bị thay đổi, hãy tự động chèn một dòng vào bảng post_audits để lưu lại nội dung cũ, nội dung mới và thời điểm chỉnh sửa.
DELIMITER //
CREATE TRIGGER tg_LogPostChanges
AFTER UPDATE ON posts_ss13
FOR EACH ROW
BEGIN
        INSERT INTO post_audits (post_id, old_content, new_content, changed_at)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW());
END //
DELIMITER ;

-- Task 4 (AFTER DELETE): Viết trigger tg_UpdatePostCountAfterDelete trên bảng posts.
-- Nhiệm vụ: Khi một bài viết bị xóa, hãy tự động giảm giá trị cột total_posts của người dùng đó trong bảng users xuống 1 đơn vị.
DELIMITER //
CREATE TRIGGER tg_UpdatePostCountAfterDelete
AFTER DELETE ON posts_ss13
FOR EACH ROW
BEGIN
    UPDATE users_ss13 
    SET total_posts = total_posts - 1
    WHERE user_id = OLD.user_id; 
END //
DELIMITER ;