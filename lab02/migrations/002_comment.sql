CREATE TABLE commentaries (
    id SERIAL PRIMARY KEY,
    description VARCHAR(3000),
    mark INT NOT NULL,

    CONSTRAINT valid_mark CHECK (mark >= 1 AND mark <= 10)
);

ALTER TABLE registrations
    ADD COLUMN comment_id INT REFERENCES commentaries(id) DEFAULT NULL;
