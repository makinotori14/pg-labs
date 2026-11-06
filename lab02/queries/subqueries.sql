-- Задание 3.1. Конференции с вместимостью выше средней у того же организатора.
SELECT m.id,
       m.title,
       m.creator_id,
       m.capacity
FROM meetings m
WHERE m.capacity > (
    SELECT AVG(m2.capacity)
    FROM meetings m2
    WHERE m2.creator_id = m.creator_id
)
ORDER BY m.creator_id, m.capacity DESC, m.id;

-- Задание 3.2. Участники с регистрацией хотя бы на одну запланированную конференцию.
SELECT u.id,
       u.first_name,
       u.last_name,
       u.email
FROM members u
WHERE EXISTS (
    SELECT 1
    FROM registrations r
    JOIN meetings m ON m.id = r.meeting_id
    WHERE r.member_id = u.id
      AND m.status_code = 'planned'
)
ORDER BY u.id;

-- Задание 3.3. Участники завершённых конференций, не оставившие ни одного отзыва о них.
SELECT u.id,
       u.first_name,
       u.last_name,
       u.email
FROM members u
WHERE EXISTS (
    SELECT 1
    FROM registrations r
    JOIN meetings m ON m.id = r.meeting_id
    WHERE r.member_id = u.id
      AND m.status_code = 'completed'
)
AND NOT EXISTS (
    SELECT 1
    FROM registrations r
    JOIN meetings m ON m.id = r.meeting_id
    WHERE r.member_id = u.id
      AND m.status_code = 'completed'
      AND r.comment_id IS NOT NULL
)
ORDER BY u.id;

-- Задание 3.4. Количество регистраций каждого участника.
SELECT u.id,
       u.first_name,
       u.last_name,
       (
           SELECT COUNT(*)
           FROM registrations r
           WHERE r.member_id = u.id
       ) AS registration_count
FROM members u
ORDER BY u.id;
