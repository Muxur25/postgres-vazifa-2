CREATE OR REPLACE FUNCTION update_updateAt_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updateAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create table courses (
	id bigserial primary key not null,
	name_course varchar(90) not null,
	instruktor varchar(90) not null,
	jadval text,
	max_students numeric(13) not null,
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);


CREATE TRIGGER set_updateAt
BEFORE UPDATE ON courses
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


create table students (
	id bigserial primary key not null,
	full_name varchar(90) not null,
	student_age numeric(10) not null,
	talabani_sohasi text,
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);

CREATE TRIGGER set_updateAt
BEFORE UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


create table enrollments (
	id bigserial primary key not null,
	student_id bigint references students(id),
	course_id bigint references courses(id),
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);

CREATE TRIGGER set_updateAt
BEFORE UPDATE ON enrollments
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


-- Kurs yaratamiz
INSERT INTO courses (name_course, instruktor, jadval, max_students)
VALUES 
('Python Dasturlash Asoslari', 'Dr. Otabek Usmonov', 'Dushanba va Chorshanba, 14:00-16:00', 30),
('Veb Dasturlash (HTML/CSS/JS)', 'Prof. Diyorbek Yuldashev', 'Seshanba va Payshanba, 10:00-12:00', 25),
('Ma''lumotlar Bazasi Dasturlash', 'Dr. Shohruh Karimov', 'Dushanba va Juma, 16:00-18:00', 20),
('Kiberxavfsizlik Asoslari', 'Dr. Dilmurod Rahmonov', 'Chorshanba va Juma, 09:00-11:00', 15),
('Sun''iy Intellektga Kirish', 'Prof. Gulsanam Yusupova', 'Payshanba va Shanba, 13:00-15:00', 18),
('Mobil Ilovalar Dasturlash', 'Dr. Aziza Akbarova', 'Seshanba va Juma, 15:00-17:00', 22);



--Talaba yaratamiz
INSERT INTO students (full_name, student_age, talabani_sohasi)
VALUES 
('Abdulloh Azizov', 22, 'Dasturlash'),
('Gulbahor Tursunova', 24, 'Kiberxavfsizlik'),
('Javohir Rahmonov', 20, 'Sun''iy intellekt'),
('Maftuna Karimova', 23, 'Veb Dasturlash'),
('Shahzod O''ktamov', 21, 'Mobil Ilovalar'),
('Nilufar Yusupova', 25, 'Ma''lumotlar bazalari'),
('Diyorbek Usmonov', 19, 'Dasturlash'),
('Feruza Murodova', 22, 'Sun''iy intellekt'),
('Akmal Nurmatov', 26, 'Kiberxavfsizlik'),
('Shoxrux Akbarov', 23, 'Veb Dasturlash');


-- Kursga talabalarni yozamiz
INSERT INTO enrollments (student_id, course_id) VALUES 
(1, 2), 
(3, 1), 
(4, 3), 
(5, 2);


--Mavjud kursni yangilaymiz;
update courses set name_course = 'Matematika va Algoritm' where id = 4;

-- Kursni olib tashlaymiz
delete from courses where id = 4;

--Muayyan o'qtuvchuni barcha kurslarini olish
select * from courses where instruktor = 'Prof. Gulsanam Yusupova';

--Malum bir vaqt oralig'ida kursga yozilgan talabalarni olish

select e.id as royxatga_olish_id, s.full_name as student_name, s.student_age as student_age, s.talabani_sohasi, c.name_course, c.instruktor, c.jadval from enrollments e join students s on e.student_id = s.id join courses c on e.course_id = c.id where e.createAt between '2024-11-07' and '2024-12-09';

--Ma'lum miqdordagi kurslarga ro'yxatdan o'tgan barcha talabalarni olish
	SELECT 
			s.id AS student_id,
			s.full_name AS student_name,
			COUNT(e.course_id) AS number_of_courses
	FROM 
			enrollments e
	JOIN 
			students s ON e.student_id = s.id
	GROUP BY 
			s.id
	HAVING 
			COUNT(e.course_id) >= 2;
