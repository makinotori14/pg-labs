CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_nmae VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    phone_number VARCHAR(32) NOT NULL UNIQUE,
    email VARCHAR(254) NOT NULL UNIQUE,
    job_title VARCHAR(150),
    biography VARCHAR(4000),
    specialization VARCHAR(255),
    workplace VARCHAR(255),
    is_organizer BOOLEAN NOT NULL DEFAULT FALSE,
    is_speaker BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE conferences (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    topic VARCHAR(255),
    description VARCHAR(10000),
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    participant_limit INT,
    status VARCHAR(32)
);

CREATE TABLE online_rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    connection_url VARCHAR(2048)
);

CREATE TABLE offline_rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(500),
    premises VARCHAR(255),
    capacity INT
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    conference_id INT NOT NULL REFERENCES conferences(id),
    online_room_id INT NOT NULL REFERENCES online_rooms(id),
    offline_room_id INT NOT NULL REFERENCES offline_rooms(id),
    name VARCHAR(255),
    description VARCHAR(10000),
    event_type VARCHAR(64),
    starts_at TIMESTAMP,
    ends_at TIMESTAMP
);

CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    conference_id INT REFERENCES conferences(id),
    registered_at TIMESTAMP,
    status VARCHAR(32)
);

CREATE TABLE organization_participations (
    id SERIAL PRIMARY KEY,
    organizer_id INT NOT NULL REFERENCES users(id),
    conference_id INT NOT NULL REFERENCES conferences(id),
    team_role VARCHAR(100),
    responsibility VARCHAR(2000)
);

CREATE TABLE performances (
    id SERIAL PRIMARY KEY,
    event_id INT NOT NULL REFERENCES events(id),
    speaker_id INT NOT NULL REFERENCES users(id)
);
