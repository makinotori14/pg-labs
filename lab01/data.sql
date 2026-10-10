BEGIN;

INSERT INTO members (id, first_name, last_name, email) VALUES
    (1, 'Анна', 'Иванова', 'anna.ivanova@example.com'),
    (2, 'Иван', 'Петров', 'ivan.petrov@example.com'),
    (3, 'Мария', 'Соколова', 'maria.sokolova@example.com'),
    (4, 'Алексей', 'Смирнов', 'alexey.smirnov@example.com'),
    (5, 'Ольга', 'Кузнецова', 'olga.kuznetsova@example.com'),
    (6, 'Дмитрий', 'Волков', 'dmitry.volkov@example.com');

INSERT INTO creators (id, first_name, last_name, email, workplace) VALUES
    (1, 'Елена', 'Морозова', 'elena.morozova@example.com', 'Университет'),
    (2, 'Сергей', 'Орлов', 'sergey.orlov@example.com', 'Центр анализа данных'),
    (3, 'Наталья', 'Лебедева', 'natalia.lebedeva@example.com', 'ИТ-компания');

INSERT INTO meetings (
    id, title, description, capacity, start_at, end_at, creator_id
) VALUES
    (1, 'PostgreSQL и базы данных',
     'Проектирование реляционных моделей и работа с PostgreSQL.',
     100, '2026-10-19 09:00:00', '2026-10-19 18:00:00', 1),
    (2, 'Анализ данных',
     'Практические подходы к обработке и визуализации данных.',
     80, '2026-10-20 09:00:00', '2026-10-20 18:00:00', 2),
    (3, 'Разработка серверных приложений',
     NULL,
     60, '2026-10-19 09:00:00', '2026-10-19 18:00:00', 1);

INSERT INTO online_rooms (id, url, platform) VALUES
    (1, 'https://example.com/rooms/database', 'Zoom'),
    (2, 'https://example.com/rooms/backend', 'Microsoft Teams'),
    (3, 'https://example.com/rooms/reserve', NULL);

INSERT INTO offline_rooms (id, address, place) VALUES
    (1, 'Москва, ул. Университетская, 1', 'Аудитория 101'),
    (2, 'Москва, ул. Университетская, 1', 'Аудитория 102'),
    (3, 'Москва, ул. Научная, 5', 'Конференц-зал');

INSERT INTO events (
    id, title, description, start_at, end_at,
    meeting_id, online_room_id, offline_room_id
) VALUES
    (1, 'Введение в PostgreSQL', 'Обзор возможностей PostgreSQL.',
     '2026-10-19 10:00:00', '2026-10-19 11:00:00', 1, 1, 1),
    (2, 'Нормализация данных', 'Разбор примеров приведения схемы к 3НФ.',
     '2026-10-19 11:00:00', '2026-10-19 12:00:00', 1, 1, 1),
    (3, 'Индексы PostgreSQL', 'Онлайн-доклад о выборе индексов.',
     '2026-10-19 12:00:00', '2026-10-19 13:00:00', 1, 1, NULL),
    (4, 'Практикум по SQL', 'Очное решение задач на запросы.',
     '2026-10-19 14:00:00', '2026-10-19 15:00:00', 1, NULL, 1),
    (5, 'Проектирование API', 'Гибридный доклад о серверных интерфейсах.',
     '2026-10-19 10:00:00', '2026-10-19 11:00:00', 3, 2, 2),
    (6, 'Тестирование приложений', 'Очный практикум по автоматизации тестов.',
     '2026-10-19 11:00:00', '2026-10-19 12:00:00', 3, NULL, 2),
    (7, 'Подготовка данных', 'Гибридный доклад об очистке данных.',
     '2026-10-20 10:00:00', '2026-10-20 11:00:00', 2, 1, 1),
    (8, 'Визуализация данных', 'Онлайн-демонстрация графиков.',
     '2026-10-20 11:00:00', '2026-10-20 12:00:00', 2, 1, NULL),
    (9, 'Обсуждение проектов', 'Очное обсуждение проектов участников.',
     '2026-10-20 10:00:00', '2026-10-20 11:00:00', 2, NULL, 2);

INSERT INTO registrations (member_id, meeting_id) VALUES
    (1, 1), (1, 2), (1, 3),
    (2, 1), (2, 3),
    (3, 1), (3, 2),
    (4, 2), (4, 3),
    (5, 1), (5, 2), (5, 3);

SELECT setval(pg_get_serial_sequence('members', 'id'), (SELECT MAX(id) FROM members));
SELECT setval(pg_get_serial_sequence('creators', 'id'), (SELECT MAX(id) FROM creators));
SELECT setval(pg_get_serial_sequence('meetings', 'id'), (SELECT MAX(id) FROM meetings));
SELECT setval(pg_get_serial_sequence('online_rooms', 'id'), (SELECT MAX(id) FROM online_rooms));
SELECT setval(pg_get_serial_sequence('offline_rooms', 'id'), (SELECT MAX(id) FROM offline_rooms));
SELECT setval(pg_get_serial_sequence('events', 'id'), (SELECT MAX(id) FROM events));

COMMIT;
