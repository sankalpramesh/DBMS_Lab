create table Painter(
	painter_id int,
	painter_name varchar(30) not null,
	date_of_birth date not null,
	date_of_death date,
	PRIMARY KEY(painter_id)	
);
create table Painting(
	painting_id int,
	painting_name varchar(30) not null,
	type_of_painting varchar(6) not null,
	start_date_of_painting date,
	PRIMARY KEY(painting_id)
);
create table Generation(
	painting_generation varchar(20),
	start_date date not null,
	end_date date not null,
	PRIMARY KEY(painting_generation)
);
create table Room(
	floor_no int,
	room_no int,
	PRIMARY KEY(floor_no, room_no)	
);
create table gen_painting(
	painting_id int,
	painting_generation varchar(30),
	PRIMARY KEY(painting_id),
	FOREIGN KEY fk1(painting_id) REFERENCES Painting(painting_id),
	FOREIGN KEY fk2(painting_generation) REFERENCES Generation(painting_generation)
);
create table painted_by(
	painting_id int,
	painter_id int,
	PRIMARY KEY(painting_id),
	FOREIGN KEY fk3(painting_id) REFERENCES Painting(painting_id),
	FOREIGN KEY fk4(painter_id) REFERENCES Painter(painter_id)
);
create table painting_location(
	painting_id int,
	floor_no int,
	room_no int,
	PRIMARY KEY(painting_id),
	FOREIGN KEY fk7(painting_id) REFERENCES Painting(painting_id),
	FOREIGN KEY fk5(floor_no) REFERENCES Room(floor_no),
	FOREIGN KEY fkb(room_no) REFERENCES Room(room_no)
);
create table painter_location(
	painter_id int,
	floor_no int,
	room_no int,
	PRIMARY KEY(painter_id, floor_no, room_no),
	FOREIGN KEY fk8(painter_id) REFERENCES Painter(painter_id),
	FOREIGN KEY fk9(floor_no) REFERENCES Room(floor_no),
	FOREIGN KEY fka(room_no) REFERENCES Room(room_no)
);
