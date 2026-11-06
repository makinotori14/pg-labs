BEGIN;

CREATE TABLE meeting_statuses (
    code VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL
);

-- Исходным конференциям назначается начальный статус planned.
ALTER TABLE meetings
    ADD COLUMN status_code VARCHAR(20) NOT NULL DEFAULT 'planned';

-- Справочник заполняется в data/generate.sql; там же проверяются старые строки.
-- Новые INSERT/UPDATE проверяются внешним ключом сразу.
ALTER TABLE meetings
    ADD CONSTRAINT meetings_status_code_fkey
        FOREIGN KEY (status_code) REFERENCES meeting_statuses(code)
        ON DELETE RESTRICT NOT VALID;

COMMIT;
