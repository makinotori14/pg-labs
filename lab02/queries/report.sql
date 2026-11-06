-- Задание 4. Завершённые конференции, требующие внимания организатора.
-- Причины: нет регистраций, нет отзывов, отзывы оставили менее 50%
-- зарегистрированных или средняя оценка ниже 5 из 10.

WITH completed_meetings AS (
    -- Исходные данные: завершённые конференции и их организаторы.
    SELECT m.id,
           m.title,
           m.start_at,
           c.first_name || ' ' || c.last_name AS creator_name
    FROM meetings m
    JOIN creators c ON c.id = m.creator_id
    WHERE m.status_code = 'completed'
),
registration_details AS (
    -- Промежуточные данные: регистрации и оценки; отсутствие связей сохраняется.
    SELECT m.id,
           m.title,
           m.start_at,
           m.creator_name,
           r.member_id,
           c.id AS comment_id,
           c.mark
    FROM completed_meetings m
    LEFT JOIN registrations r ON r.meeting_id = m.id
    LEFT JOIN commentaries c ON c.id = r.comment_id
),
meeting_stats AS (
    -- Агрегация: одна строка с показателями каждой конференции.
    SELECT id,
           title,
           start_at,
           creator_name,
           COUNT(member_id) AS registration_count,
           COUNT(comment_id) AS review_count,
           AVG(mark) AS average_mark
    FROM registration_details
    GROUP BY id, title, start_at, creator_name
),
meeting_metrics AS (
    -- Доля отзывов среди зарегистрированных; без регистраций она не определена.
    SELECT *,
           100.0 * review_count / NULLIF(registration_count, 0) AS feedback_percent
    FROM meeting_stats
)
SELECT id,
       title,
       start_at,
       creator_name,
       registration_count,
       review_count,
       ROUND(feedback_percent, 2) AS feedback_percent,
       ROUND(average_mark, 2) AS average_mark,
       CONCAT_WS('; ',
           CASE
               WHEN registration_count = 0 THEN 'Нет регистраций'
               WHEN review_count = 0 THEN 'Нет обратной связи'
               WHEN feedback_percent < 50 THEN 'Мало обратной связи'
           END,
           CASE WHEN average_mark < 5 THEN 'Низкая оценка' END
       ) AS attention_reason
FROM meeting_metrics
WHERE review_count = 0
   OR feedback_percent < 50
   OR average_mark < 5
ORDER BY start_at, id;
