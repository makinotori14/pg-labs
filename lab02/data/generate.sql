-- Генерация данных для задания 1.1 на схеме после миграций 001, 002 и 003.
-- Запуск из корня проекта:
-- psql -v ON_ERROR_STOP=1 -d <имя_базы> -f lab02/data/generate.sql
--
-- Добавляется 133 записи:
-- members: 20, creators: 5, meetings: 9, online_rooms: 4,
-- offline_rooms: 4, events: 24, registrations: 48, commentaries: 16,
-- meeting_statuses: 3.
-- Даты конференций: сентябрь, октябрь и ноябрь 2026 года.
-- Существующие записи сохраняются; ID новых записей получаются через RETURNING.
-- Скрипт рассчитан на однократный запуск: повторный запуск отклоняется
-- ограничением уникальности, изменения транзакции отменяются.
-- Состояния конференций: 6 completed, 2 planned, 1 cancelled.

BEGIN;

SET LOCAL TIME ZONE 'Europe/Moscow';

INSERT INTO meeting_statuses (code, title, description) VALUES
    ('planned', 'Запланирована', 'Конференция запланирована и ещё не завершена.'),
    ('completed', 'Завершена', 'Конференция состоялась и завершена.'),
    ('cancelled', 'Отменена', 'Конференция отменена и не будет проводиться.');

ALTER TABLE meetings VALIDATE CONSTRAINT meetings_status_code_fkey;

DO $$
DECLARE
    member_ids INTEGER[] := ARRAY[]::INTEGER[];
    creator_ids INTEGER[] := ARRAY[]::INTEGER[];
    meeting_ids INTEGER[] := ARRAY[]::INTEGER[];
    online_room_ids INTEGER[] := ARRAY[]::INTEGER[];
    offline_room_ids INTEGER[] := ARRAY[]::INTEGER[];
    comment_ids INTEGER[] := ARRAY[]::INTEGER[];

    member_first_names TEXT[] := ARRAY[
        'Александр', 'Мария', 'Дмитрий', 'Анна', 'Максим',
        'Екатерина', 'Алексей', 'Дарья', 'Илья', 'Полина',
        'Никита', 'София', 'Андрей', 'Алиса', 'Роман',
        'Виктория', 'Олег', 'Ксения', 'Павел', 'Вера'
    ];
    member_last_names TEXT[] := ARRAY[
        'Соколов', 'Волкова', 'Кузнецов', 'Попова', 'Смирнов',
        'Новикова', 'Морозов', 'Петрова', 'Васильев', 'Орлова',
        'Павлов', 'Семёнова', 'Лебедев', 'Козлова', 'Егоров',
        'Зайцева', 'Фёдоров', 'Соловьёва', 'Белов', 'Тихонова'
    ];
    creator_first_names TEXT[] := ARRAY['Ирина', 'Денис', 'Ольга', 'Виктор', 'Светлана'];
    creator_last_names TEXT[] := ARRAY['Крылова', 'Захаров', 'Мельникова', 'Серов', 'Белова'];
    workplaces TEXT[] := ARRAY['НИУ ВШЭ', 'МГУ', 'ИТМО', 'DataLab', 'TechForum'];
    meeting_titles TEXT[] := ARRAY[
        'PostgreSQL: проектирование баз данных',
        'Разработка и тестирование API',
        'Введение в анализ данных',
        'PostgreSQL: индексы и оптимизация',
        'Архитектура серверных приложений',
        'Визуализация данных',
        'PostgreSQL: транзакции и блокировки',
        'Наблюдаемость приложений',
        'Индивидуальная консультация по SQL'
    ];
    event_titles TEXT[] := ARRAY['Вводный доклад', 'Практикум', 'Обсуждение'];
    event_descriptions TEXT[] := ARRAY[
        'Обзор темы конференции и разбор основных понятий.',
        'Решение практических задач с участниками.',
        'Ответы на вопросы и обсуждение результатов.'
    ];
    review_texts TEXT[] := ARRAY[
        'Материал оказался слишком поверхностным.',
        'Не хватило объяснений и примеров.',
        'Практикум был сложным для начинающих.',
        'Полезная тема, но осталось много вопросов.',
        'Хороший обзор, хотелось бы больше практики.',
        'Получил ответы на основные вопросы.',
        'Понравились примеры из реальных проектов.',
        'Полезный материал и понятные объяснения.',
        'Отличный доклад и содержательное обсуждение.',
        'Превосходная организация и сильная программа.'
    ];

    i INTEGER;
    j INTEGER;
    new_id INTEGER;
    member_index INTEGER;
    room_index INTEGER;
    review_index INTEGER;
    review_mark INTEGER;
    meeting_start TIMESTAMPTZ;
    event_start TIMESTAMPTZ;
BEGIN
    -- 1. Участники. Последние четыре останутся без регистраций.
    FOR i IN 1..20 LOOP
        INSERT INTO members (first_name, last_name, email)
        VALUES (
            member_first_names[i],
            member_last_names[i],
            format('lab02.member%s@example.com', i)
        )
        RETURNING id INTO new_id;

        member_ids[i] := new_id;
    END LOOP;

    -- 2. Организаторы. Пятый организатор не создаёт конференций.
    FOR i IN 1..5 LOOP
        INSERT INTO creators (first_name, last_name, email, workplace)
        VALUES (
            creator_first_names[i],
            creator_last_names[i],
            format('lab02.creator%s@example.com', i),
            workplaces[i]
        )
        RETURNING id INTO new_id;

        creator_ids[i] := new_id;
    END LOOP;

    -- 3. Комнаты. Четвёртая комната каждого типа остаётся неиспользуемой.
    FOR i IN 1..4 LOOP
        INSERT INTO online_rooms (url, platform)
        VALUES (
            format('https://example.com/lab02/rooms/%s', i),
            CASE i
                WHEN 1 THEN 'Zoom'
                WHEN 2 THEN 'Microsoft Teams'
                WHEN 3 THEN 'Jitsi Meet'
                ELSE NULL
            END
        )
        RETURNING id INTO new_id;

        online_room_ids[i] := new_id;

        INSERT INTO offline_rooms (address, place)
        VALUES (
            'Москва, ул. Конференционная, 20',
            format('Зал %s', i)
        )
        RETURNING id INTO new_id;

        offline_room_ids[i] := new_id;
    END LOOP;

    -- 4. По три конференции в каждом месяце: 10, 17 и 24 числа.
    -- Первая будет заполнена полностью: 6 регистраций при capacity = 6.
    -- Девятая отменена, имеет минимальную вместимость 1 и останется без событий
    -- и регистраций: её показатели количества событий и участников равны 0.
    FOR i IN 1..9 LOOP
        meeting_start := TIMESTAMPTZ '2026-09-10 09:00:00+03'
            + make_interval(months => (i - 1) / 3, days => ((i - 1) % 3) * 7);

        INSERT INTO meetings (
            title, description, capacity, start_at, end_at, creator_id, status_code
        )
        VALUES (
            meeting_titles[i],
            CASE WHEN i % 3 = 0 THEN NULL
                 ELSE format('Конференция по теме «%s».', meeting_titles[i]) END,
            CASE WHEN i = 1 THEN 6 WHEN i = 9 THEN 1 ELSE 20 + i * 10 END,
            meeting_start,
            meeting_start + INTERVAL '9 hours',
            creator_ids[((i - 1) % 4) + 1],
            CASE WHEN i <= 6 THEN 'completed'
                 WHEN i = 9 THEN 'cancelled' ELSE 'planned' END
        )
        RETURNING id INTO new_id;

        meeting_ids[i] := new_id;

        -- У первых восьми конференций по три события:
        -- гибридное, только онлайн и только офлайн.
        IF i <= 8 THEN
            room_index := ((i - 1) % 3) + 1;

            FOR j IN 1..3 LOOP
                event_start := meeting_start + make_interval(hours => 1 + (j - 1) * 2);

                INSERT INTO events (
                    title, description, start_at, end_at,
                    meeting_id, online_room_id, offline_room_id
                )
                VALUES (
                    format('%s: %s', event_titles[j], meeting_titles[i]),
                    event_descriptions[j],
                    event_start,
                    event_start + INTERVAL '90 minutes',
                    meeting_ids[i],
                    CASE WHEN j <> 3 THEN online_room_ids[room_index] ELSE NULL END,
                    CASE WHEN j <> 2 THEN offline_room_ids[room_index] ELSE NULL END
                );
            END LOOP;
        END IF;
    END LOOP;

    -- 5. Шестнадцать отзывов: оценки от 1 до 10, в том числе границы.
    -- У части отзывов текст отсутствует, но оценка обязательна.
    FOR i IN 1..16 LOOP
        review_mark := ((i - 1) % 10) + 1;

        INSERT INTO commentaries (description, mark)
        VALUES (
            CASE WHEN i % 5 = 0 THEN NULL ELSE review_texts[review_mark] END,
            review_mark
        )
        RETURNING id INTO new_id;

        comment_ids[i] := new_id;
    END LOOP;

    -- 6. По шесть разных участников у первых восьми конференций.
    -- Используются первые 16 участников; один участник посещает несколько
    -- конференций. У первых четырёх конференций по четыре отзыва,
    -- остальные регистрации без отзывов (comment_id = NULL).
    -- В частности, на ноябрьские конференции отзывы ещё не оставлены.
    FOR i IN 1..8 LOOP
        FOR j IN 1..6 LOOP
            member_index := (((i - 1) * 3 + j - 1) % 16) + 1;
            review_index := (i - 1) * 4 + j;

            INSERT INTO registrations (member_id, meeting_id, comment_id)
            VALUES (
                member_ids[member_index],
                meeting_ids[i],
                CASE WHEN i <= 4 AND j <= 4
                     THEN comment_ids[review_index] ELSE NULL END
            );
        END LOOP;
    END LOOP;
END;
$$;

COMMIT;
