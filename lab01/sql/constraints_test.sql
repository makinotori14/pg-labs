INSERT INTO members (id, first_name, last_name, email)
VALUES (-101, 'Тест', 'Дубликат', 'makinotori14@gmail.com'); -- дубликат по почте

INSERT INTO registrations (member_id, meeting_id) VALUES (1, 1); -- дубликат по паре

UPDATE meetings SET capacity = -1 WHERE id = 1; -- отрицательный капасити нельзя задавать

UPDATE meetings SET end_at = '2026-10-19 08:00:00' WHERE id = 1;  -- начало стоит в это же число в 9 утра

UPDATE events SET end_at = start_at WHERE id = 1; -- строго больше начало и конец
