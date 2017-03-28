-- users - first_name, last_name, email_address NOT NULL, screen_name NOT NULL
-- posts - author, title, content, timestamp, >=0 comments, >=0 tags
-- comments - author, posts, text 
-- tags - text

-- write SQL statements to create some users, posts, and comments

--user => posts, comments
--post => comments, tags
--comments, tags => 😞

createdb dev -U blogapp

psql -U dev blogapp

CREATE TABLE users(
  id serial PRIMARY KEY,
  first_name text,
  last_name text,
  email_address text NOT NULL,
  screen_name text NOT NULL
); 

CREATE TABLE tags(
  id serial PRIMARY KEY,
  tag text
);

CREATE TABLE comments(
  id serial PRIMARY KEY,
  modified timestamp DEFAULT current_timestamp,
  post post_id, --foreign key constraints
  post_id integer REFERENCES posts,
  author user_id,
  user_id integer REFERENCES users, 
  text_field text
);

CREATE TABLE posts(
  id serial PRIMARY KEY,
  modified timestamp DEFAULT current_timestamp,
  author user_id,
  user_id integer REFERENCES users,
  title text NOT NULL,
  content text NOT NULL,
  comment comment_id,
  comment_id REFERENCES comments
); 

CREATE TABLE posts_tags(
  id serial PRIMARY KEY,
  post_id integer REFERENCES posts,
  tag_id integer REFERENCES tags
);

INSERT INTO posts_tags
  (post_id, tag_id)
  VALUES 
  (1, 1), (1, 2);

INSERT INTO users
  (first_name, last_name, email_address, screen_name)
    VALUES
    ('Ramon', 'Reyes', '123@gmail.com', 'reyesjunk'),
    ('Colin', 'Van Sickle', '456@gmail.com', 'colin')
     RETURNING id, first_name, last_name, screen_name, email_address;

INSERT INTO tags
  (tag)
    VALUES
    ('funny'), ('sad'), ('heartwarming'), ('horrible')
     RETURNING id, tag;

INSERT INTO posts
  (user_id, title, content)
    VALUES
    ( 1, 'What''s the Deal with Airline food?!', 'It''s no good!')
     RETURNING user_id, title, content;

SELECT posts.id, tags.tag FROM posts
  JOIN posts_tags ON posts_tags.post_id=posts.id
  JOIN tags ON posts_tags.tag_id=tags.id;

-- SELECT
--     users.id as "users_id",
--     comments.id as "comment_id",
--     posts.id as "post_id"

--     FROM users
--     INNER JOIN posts
--     ON posts.post_id = posts.id
--     LIMIT 5;