CREATE TABLE meeting_statuses (
    code VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL
);

INSERT INTO meeting_statuses (code, title, description) VALUES
    ('planned', 'Запланирована', 'Конференция запланирована и ещё не завершена.'),
    ('completed', 'Завершена', 'Конференция состоялась и завершена.'),
    ('cancelled', 'Отменена', 'Конференция отменена и не будет проводиться.');

ALTER TABLE meetings
    ADD COLUMN status_code VARCHAR(20) NOT NULL DEFAULT 'planned'
        REFERENCES meeting_statuses(code) ON DELETE RESTRICT;
