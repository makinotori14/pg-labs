-- Задание 1.2. Операции изменения данных.

BEGIN;

-- 1. Добавление конференции, события и регистрации.
INSERT INTO meetings (
    title, description, capacity, start_at, end_at, creator_id, status_code
)
VALUES (
    'Дополнительный практикум по SQL',
    'Практика изменения данных.',
    20,
    '2026-11-28 10:00:00+03',
    '2026-11-28 13:00:00+03',
    (SELECT id FROM creators WHERE email = 'lab02.creator1@example.com'),
    'planned'
);

INSERT INTO events (
    title, description, start_at, end_at, meeting_id, online_room_id
)
VALUES (
    'Практика изменения данных',
    'INSERT, UPDATE, DELETE и транзакции.',
    '2026-11-28 10:30:00+03',
    '2026-11-28 12:00:00+03',
    (SELECT id FROM meetings WHERE title = 'Дополнительный практикум по SQL'),
    (SELECT id FROM online_rooms WHERE url = 'https://example.com/lab02/rooms/1')
);

INSERT INTO registrations (member_id, meeting_id)
VALUES (
    (SELECT id FROM members WHERE email = 'lab02.member20@example.com'),
    (SELECT id FROM meetings WHERE title = 'Дополнительный практикум по SQL')
);

-- 2. Изменение состояния конференции.
UPDATE meetings
SET status_code = 'cancelled'
WHERE title = 'Дополнительный практикум по SQL'
RETURNING id, title, status_code;

-- 3. Увеличение вместимости запланированных конференций ноября на 10 мест.
UPDATE meetings
SET capacity = capacity + 10
WHERE status_code = 'planned'
  AND start_at >= '2026-11-01 00:00:00+03'
  AND start_at < '2026-12-01 00:00:00+03'
RETURNING id, title, capacity;

-- 4. Удаление конференции; события и регистрации удаляются каскадно.
DELETE FROM meetings
WHERE title = 'Дополнительный практикум по SQL';

-- 5. Отмена изменений.
ROLLBACK;
