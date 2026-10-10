\set ON_ERROR_STOP off

BEGIN;
SAVEPOINT test;

INSERT INTO members (id, first_name, last_name, email)
VALUES (-101, 'Тест', 'Дубликат', 'anna.ivanova@example.com');
ROLLBACK TO SAVEPOINT test;

INSERT INTO registrations (member_id, meeting_id) VALUES (1, 1);
ROLLBACK TO SAVEPOINT test;

UPDATE meetings SET capacity = -1 WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

UPDATE meetings SET end_at = start_at - INTERVAL '1 hour' WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

UPDATE events SET end_at = start_at WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

INSERT INTO registrations (member_id, meeting_id) VALUES (-999, 1);
ROLLBACK TO SAVEPOINT test;

UPDATE events SET online_room_id = NULL, offline_room_id = NULL WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

INSERT INTO events (
    id, title, description, start_at, end_at,
    meeting_id, online_room_id, offline_room_id
) VALUES (
    -102, 'Тест', 'Офлайн-пересечение',
    '2026-10-19 10:30:00', '2026-10-19 10:45:00', 1, NULL, 1
);
ROLLBACK TO SAVEPOINT test;

INSERT INTO events (
    id, title, description, start_at, end_at,
    meeting_id, online_room_id, offline_room_id
) VALUES (
    -103, 'Тест', 'Онлайн-пересечение',
    '2026-10-19 10:30:00', '2026-10-19 10:45:00', 1, 1, NULL
);
ROLLBACK TO SAVEPOINT test;

DELETE FROM creators WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

DELETE FROM online_rooms WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

DELETE FROM offline_rooms WHERE id = 1;
ROLLBACK TO SAVEPOINT test;

SELECT
    (SELECT COUNT(*) FROM members WHERE id = 1) AS member_count,
    (SELECT COUNT(*) FROM registrations WHERE member_id = 1) AS registration_count;

DELETE FROM members WHERE id = 1;

SELECT
    (SELECT COUNT(*) FROM members WHERE id = 1) AS member_count,
    (SELECT COUNT(*) FROM registrations WHERE member_id = 1) AS registration_count;
ROLLBACK TO SAVEPOINT test;

SELECT
    (SELECT COUNT(*) FROM meetings WHERE id = 1) AS meeting_count,
    (SELECT COUNT(*) FROM events WHERE meeting_id = 1) AS event_count,
    (SELECT COUNT(*) FROM registrations WHERE meeting_id = 1) AS registration_count;

DELETE FROM meetings WHERE id = 1;

SELECT
    (SELECT COUNT(*) FROM meetings WHERE id = 1) AS meeting_count,
    (SELECT COUNT(*) FROM events WHERE meeting_id = 1) AS event_count,
    (SELECT COUNT(*) FROM registrations WHERE meeting_id = 1) AS registration_count;

ROLLBACK;
\set ON_ERROR_STOP on
