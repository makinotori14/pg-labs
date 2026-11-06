-- Задание 2.2. Агрегация и группировка.

-- 1. Количество зарегистрированных участников каждой конференции.
SELECT m.id,
       m.title,
       COUNT(r.member_id) AS member_count
FROM meetings m
LEFT JOIN registrations r ON r.meeting_id = m.id
GROUP BY m.id, m.title
ORDER BY member_count DESC, m.id;

-- 2. Конференции со средней оценкой выше 5.
SELECT m.id,
       m.title,
       AVG(c.mark) AS average_mark
FROM meetings m
JOIN registrations r ON r.meeting_id = m.id
JOIN commentaries c ON c.id = r.comment_id
GROUP BY m.id, m.title
HAVING AVG(c.mark) > 5
ORDER BY average_mark DESC, m.id;

-- 3. Количество конференций и общая вместимость по месяцам без отменённых.
SELECT DATE_TRUNC('month', start_at AT TIME ZONE 'Europe/Moscow')::date AS month,
       COUNT(*) AS meeting_count,
       SUM(capacity) AS total_capacity
FROM meetings
WHERE status_code <> 'cancelled'
GROUP BY month
ORDER BY month;
