CREATE TABLE score_key (
    id                  SERIAL UNIQUE,
    key                 VARCHAR NOT NULL,
    tournament_id       VARCHAR REFERENCES tournament(name),
    max_val             INTEGER,
    min_val             INTEGER,
    PRIMARY KEY (key, tournament_id)
);
COMMENT ON TABLE score_key IS 'This table is all the score keys that might be entered for a tournament. An example might be round_1_battle, round_1_sports, best_painted_votes';

CREATE TABLE score (
    entry_id            INTEGER REFERENCES entry(id),
    score_key_id        INTEGER REFERENCES score_key(id),
    value               INTEGER DEFAULT 0,
    PRIMARY KEY (entry_id, score_key_id)
);
COMMENT ON TABLE score IS 'An entry will have lots of scores.';