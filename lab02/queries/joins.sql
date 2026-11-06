-- Задание 2.1. Многотабличные запросы.

-- 1. Регистрации: участник, конференция и организатор.
SELECT r.member_id,
       u.first_name || ' ' || u.last_name AS member_name,
       u.email,
       r.meeting_id,
       m.title AS meeting_title,
       m.start_at,
       m.status_code,
       c.first_name || ' ' || c.last_name AS creator_name
FROM registrations r
JOIN members u ON u.id = r.member_id
JOIN meetings m ON m.id = r.meeting_id
JOIN creators c ON c.id = m.creator_id
ORDER BY m.start_at, m.id, u.id;

-- 2. Конференции без регистраций и их организаторы.
SELECT m.id,
       m.title,
       m.start_at,
       c.first_name || ' ' || c.last_name AS creator_name,
       c.email AS creator_email
FROM meetings m
JOIN creators c ON c.id = m.creator_id
LEFT JOIN registrations r ON r.meeting_id = m.id
WHERE r.member_id IS NULL
ORDER BY m.start_at, m.id;

-- 3. События запланированных конференций ноября 2026 года на Zoom.
SELECT e.id,
       e.title AS event_title,
       m.title AS meeting_title,
       e.start_at,
       o.platform,
       o.url
FROM events e
JOIN meetings m ON m.id = e.meeting_id
JOIN online_rooms o ON o.id = e.online_room_id
WHERE m.status_code = 'planned'
  AND m.start_at >= '2026-11-01 00:00:00+03'
  AND m.start_at < '2026-12-01 00:00:00+03'
  AND o.platform = 'Zoom'
ORDER BY e.start_at, e.id;
