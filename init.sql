CREATE TABLE greetings (
    id SERIAL PRIMARY KEY,
    word VARCHAR(50)
);

INSERT INTO greetings (word) VALUES ('Docker');
