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
