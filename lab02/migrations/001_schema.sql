CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL
);

CREATE TABLE creators (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL,
    workplace VARCHAR(100) NOT NULL
);

CREATE TABLE meetings (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(3000),
    capacity INT NOT NULL,
    start_at TIMESTAMPTZ NOT NULL,
    end_at TIMESTAMPTZ NOT NULL,
    creator_id INT NOT NULL,

    FOREIGN KEY (creator_id) REFERENCES creators(id) ON DELETE RESTRICT,

    CONSTRAINT positive_capacity CHECK (capacity > 0),
    CONSTRAINT valid_period CHECK (end_at > start_at)
);

CREATE TABLE online_rooms (
    id SERIAL PRIMARY KEY,
    url VARCHAR(2000) UNIQUE NOT NULL,
    platform VARCHAR(100)
);

CREATE TABLE offline_rooms (
    id SERIAL PRIMARY KEY,
    address VARCHAR(1000) NOT NULL,
    place VARCHAR(500) NOT NULL,

    UNIQUE(address, place)
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(3000) NOT NULL,
    start_at TIMESTAMPTZ NOT NULL,
    end_at TIMESTAMPTZ NOT NULL,
    meeting_id INT NOT NULL,

    online_room_id INT,
    offline_room_id INT,

    FOREIGN KEY (online_room_id) REFERENCES online_rooms(id) ON DELETE RESTRICT,
    FOREIGN KEY (offline_room_id) REFERENCES offline_rooms(id) ON DELETE RESTRICT,

    FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE,

    CONSTRAINT valid_period CHECK (end_at > start_at),

    CONSTRAINT no_empty_rooms CHECK (offline_room_id IS NOT NULL OR online_room_id IS NOT NULL)
);

CREATE TABLE registrations (
    member_id INT NOT NULL,
    meeting_id INT NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE,

    PRIMARY KEY (member_id, meeting_id)
);
