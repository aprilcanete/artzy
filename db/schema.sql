create database arts_app;

\c arts_app

create table users (
    id serial primary key,
    name varchar(64),
    email varchar(64),
    password_digest text
);


create table arts (
    id serial primary key,
    name varchar(200),
    image_url text,
    user_id int,
    comment_id int
);


create table comments (
    id serial primary key,
    comment text,
    user_id int,
    art_id int
);


insert into arts (name, image_url)
values ('art 1', 'http://via.placeholder.com/200x200');

insert into arts (name, image_url)
values ('art 2', 'http://via.placeholder.com/200x200');
