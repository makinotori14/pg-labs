CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_nmae TEXT,
    middle_name TEXT,
    phone_number TEXT,
    email TEXT
);

CREATE TABLE organizers (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    organization TEXT,
    job_title TEXT
);

CREATE TABLE speakers (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    biography TEXT,
    specialization TEXT,
    workplace TEXT
);

CREATE TABLE conferences (
    id SERIAL PRIMARY KEY,
    name TEXT,
    topic TEXT,
    description TEXT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    participant_limit INT,
    status TEXT,
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    conference_id INT NOT NULL REFERENCES conferences(id),
    online_room_id INT NOT NULL REFERENCES online_rooms(id),
    offline_room_id INT NOT NULL REFERENCES offline_rooms(id),
    name TEXT,
    description TEXT,
    event_type TEXT,
    starts_at TIMESTAMP,
    ends_at TIMESTAMP
);

CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    conference_id INT REFERENCES conferences(id),
    registered_at TIMESTAMP,
    status TEXT
);

CREATE TABLE online_rooms (
    id SERIAL PRIMARY KEY,
    name TEXT,
    connection_url TEXT
);

CREATE TABLE offline_rooms (
    id SERIAL PRIMARY KEY,
    name TEXT,
    address TEXT,
    premises TEXT,
    capacity INT
);

CREATE TABLE organization_participations (
    id SERIAL PRIMARY KEY,
    organizer_id INT NOT NULL REFERENCES organizers(id),
    conference_id INT NOT NULL REFERENCES conferences(id),
    team_role TEXT,
    responsibility TEXT
);

CREATE TABLE performances (
    id SERIAL PRIMARY KEY,
    event_id INT NOT NULL REFERENCES events(id),
    speaker_id INT NOT NULL REFERENCES speakers(id)
);
