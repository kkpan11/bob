-- Extensions
CREATE EXTENSION IF NOT EXISTS hstore;

-- Don't forget to maintain order here, foreign keys!
drop table if exists video_tags;
drop table if exists tags;
drop view if exists user_videos;
drop table if exists videos;
drop table if exists sponsors;
drop table if exists users;
drop materialized view if exists type_monsters_mv;
drop view if exists type_monsters_v;
drop table if exists type_monsters;
drop table if exists test_index_expressions;
drop table if exists foo_bar;
drop table if exists foo_baz;
drop table if exists foo_qux;
drop table if exists bar_baz;
drop table if exists bar_qux;

drop type if exists unicode_enum;
create type unicode_enum as enum ('hello', 'привет', 'こんにちは', '안녕하세요', 'hello_with_underscore');

drop domain if exists uint3;
create domain uint3 as numeric;

create table users (
	id serial primary key not null,
	email_validated  bool null default false,
	primary_email    varchar(100) unique null,
	parent_id int,
    party_id int UNIQUE,

	referrer int,

	foreign key (parent_id) references users (id),
	foreign key (party_id) references users (id),
	foreign key (referrer) references users (id)
);

comment on column users.email_validated is 'Has the email address been tested?';
comment on column users.primary_email is 'The user''s preferred email address.

Use this to send emails to the user.';


create table sponsors (
	id serial primary key not null
);

create table videos (
	id serial primary key not null,

	user_id int not null,
	sponsor_id int unique,

	foreign key (user_id) references users (id),
	foreign key (sponsor_id) references sponsors (id)
);

comment on column videos.id is 'The ID of the video';

create table tags (
	id serial primary key not null
);

create table video_tags (
	video_id int not null,
	tag_id int not null,

	primary key (video_id, tag_id),
	foreign key (video_id) references videos (id),
	foreign key (tag_id) references tags (id)
);

drop type if exists my_int_array;
create domain my_int_array as int[];

create table type_monsters (
	id serial primary key not null,

	enum_use        unicode_enum not null,
	enum_nullable   unicode_enum,

	bool_zero   bool,
	bool_one    bool null,
	bool_two    bool not null CONSTRAINT check_not_null CHECK(bool_two IS NOT NULL),
	bool_three  bool null default false,
	bool_four   bool null default true,
	bool_five   bool not null default false,
	bool_six    bool not null default true,

	string_zero   varchar(1),
	string_one    varchar(1) null,
	string_two    varchar(1) not null,
	string_three  varchar(1) null default 'a',
	string_four   varchar(1) not null default 'b',
	string_five   varchar(1000),
	string_six    varchar(1000) null,
	string_seven  varchar(1000) not null,
	string_eight  varchar(1000) null default 'abcdefgh',
	string_nine   varchar(1000) not null default 'abcdefgh',
	string_ten    varchar(1000) null default '',
	string_eleven varchar(1000) not null default '',

	nonbyte_zero   char(1),
	nonbyte_one    char(1) null,
	nonbyte_two    char(1) not null,
	nonbyte_three  char(1) null default 'a',
	nonbyte_four   char(1) not null default 'b',
	nonbyte_five   char(1000),
	nonbyte_six    char(1000) null,
	nonbyte_seven  char(1000) not null,
	nonbyte_eight  char(1000) null default 'a',
	nonbyte_nine   char(1000) not null default 'b',

	byte_zero   "char",
	byte_one    "char" null,
	byte_two    "char" null default 'a',
	byte_three  "char" not null,
	byte_four   "char" not null default 'b',

	big_int_zero  bigint,
	big_int_one   bigint null,
	big_int_two   bigint not null,
	big_int_three bigint null default 111111,
	big_int_four  bigint not null default 222222,
	big_int_five  bigint null default 0,
	big_int_six   bigint not null default 0,

	int_zero  int,
	int_one   int null,
	int_two   int not null,
	int_three int null default 333333,
	int_four  int not null default 444444,
	int_five  int null default 0,
	int_six   int not null default 0,

	real_zero  real,
	real_one   real,
	real_two   float(5),
	real_three float(5),
	real_four  float(5) null,
	real_five  float(5) not null,
	real_six   float(5) null default 1.1,
	real_seven float(5) not null default 1.1,
	real_eight float(5) null default 0.0,
	real_nine  float(5) null default 0.0,

	double_zero  double precision,
	double_one   double precision,
	double_two   float(35),
	double_three float(35),
	double_four  float(35) null,
	double_five  float(35) not null,
	double_six   float(35) null default 1.1,
	double_seven float(35) not null default 1.1,
	double_eight float(35) null default 0.0,
	double_nine  float(35) null default 0.0,

	decimal_zero  numeric,
	decimal_one   numeric,
	decimal_two   numeric(2,1),
	decimal_three numeric(2,1),
	decimal_four  numeric(2,1) null,
	decimal_five  numeric(2,1) not null,
	decimal_six   numeric(2,1) null default 1.1,
	decimal_seven numeric(2,1) not null default 1.1,
	decimal_eight numeric(2,1) null default 0.0,
	decimal_nine  numeric(2,1) null default 0.0,

	bytea_zero  bytea,
	bytea_one   bytea null,
	bytea_two   bytea not null,
	bytea_three bytea not null default 'a',
	bytea_four  bytea null default 'b',
	bytea_five  bytea not null default 'abcdefghabcdefghabcdefgh',
	bytea_six   bytea null default 'hgfedcbahgfedcbahgfedcba',
	bytea_seven bytea not null default '',
	bytea_eight bytea not null default '',

	time_zero      timestamp,
	time_one       date,
	time_two       timestamp null default null,
	time_three     timestamp null,
	time_four      timestamp not null,
	time_five      timestamp null default '1999-01-08 04:05:06.789',
	time_six       timestamp null default '1999-01-08 04:05:06.789 -8:00',
	time_seven     timestamp null default 'January 8 04:05:06 1999 PST',
	time_eight     timestamp not null default '1999-01-08 04:05:06.789',
	time_nine      timestamp not null default '1999-01-08 04:05:06.789 -8:00',
	time_ten       timestamp not null default 'January 8 04:05:06 1999 PST',
	time_eleven    date null,
	time_twelve    date not null,
	time_thirteen  date null default '1999-01-08',
	time_fourteen  date null default 'January 8, 1999',
	time_fifteen   date null default '19990108',
	time_sixteen   date not null default '1999-01-08',
	time_seventeen date not null default 'January 8, 1999',
	time_eighteen  date not null default '19990108',

	uuid_zero  uuid,
	uuid_one   uuid null,
	uuid_two   uuid null default null,
	uuid_three uuid not null,
	uuid_four  uuid null default '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
	uuid_five  uuid not null default '6ba7b810-9dad-11d1-80b4-00c04fd430c8',

	integer_default integer default '5'::integer,
	varchar_default varchar(1000) default 5::varchar,
	timestamp_notz  timestamp without time zone default (now() at time zone 'utc'),
	timestamp_tz    timestamp with time zone default (now() at time zone 'utc'),
	interval_nnull  interval not null default '21 days',
	interval_null   interval null default '23 hours',

	json_null   json null,
	json_nnull  json not null,
	jsonb_null  jsonb null,
	jsonb_nnull jsonb not null,

	box_null  box null,
	box_nnull box not null,

	cidr_null  cidr null,
	cidr_nnull cidr not null,

	circle_null  circle null,
	circle_nnull circle not null,

	inet_null  inet null,
	inet_nnull inet not null,

	line_null  line null,
	line_nnull line not null,

	lseg_null  lseg null,
	lseg_nnull lseg not null,

	macaddr_null  macaddr null,
	macaddr_nnull macaddr not null,

	money_null  money null,
	money_nnull money not null,

	path_null  path null,
	path_nnull path not null,

	pg_lsn_null  pg_lsn null,
	pg_lsn_nnull pg_lsn not null,

	point_null  point NULL,
	point_nnull point NOT NULL,

	polygon_null  polygon NULL,
	polygon_nnull polygon NOT NULL,

	tsvector_null  tsvector NULL,
	tsvector_nnull tsvector NOT NULL,

	txid_null  txid_snapshot NULL,
	txid_nnull txid_snapshot NOT NULL,

	pg_snapshot_null  pg_snapshot NULL,
	pg_snapshot_nnull pg_snapshot NOT NULL,

    hstore_null  hstore NULL,
    hstore_nnull hstore NOT NULL,

	xml_null  xml NULL,
	xml_nnull xml NOT NULL,

	intarr_null      integer[] null,
	intarr_nnull     integer[] not null,
	boolarr_null     boolean[] null,
	boolarr_nnull    boolean[] not null,

	varchararr_null          varchar[] null,
	varchararr_nnull         varchar[] not null,
	varchararr_limited_null  varchar(10)[] null,
	varchararr_limited_nnull varchar(10)[] not null,

	realarr_null          real[] null,
	realarr_nnull         real[] not null,
	realarr_limited_null  float(5)[] null,
	realarr_limited_nnull float(5)[] not null,

	doublearr_null          double precision[] null,
	doublearr_nnull         double precision[] not null,
	doublearr_limited_null  float(35)[] null,
	doublearr_limited_nnull float(35)[] not null,

	decimalarr_null          decimal[] null,
	decimalarr_nnull         decimal[] not null,
	decimalarr_limited_null  decimal(2,1)[] null,
	decimalarr_limited_nnull decimal(2,1)[] not null,

	byteaarr_null    bytea[] null,
	byteaarr_nnull   bytea[] not null,
	jsonbarr_null    jsonb[] null,
	jsonbarr_nnull   jsonb[] not null,
	jsonarr_null     json[] null,
	jsonarr_nnull    json[] not null,

    enumarr_null   unicode_enum[] null,
	enumarr_nnull  unicode_enum[] not null,

	customarr_null   my_int_array null,
	customarr_nnull  my_int_array not null,

    domainuint3_nnull uint3 not null,

    base text null,

    generated_nnull text NOT NULL GENERATED ALWAYS AS (UPPER(string_two)) STORED,
    generated_null text NULL GENERATED ALWAYS AS (UPPER(base)) STORED
);

create view user_videos as 
select u.id user_id, v.id video_id, v.sponsor_id sponsor_id
from users u
inner join videos v on v.user_id = u.id;

create view type_monsters_v as select * from type_monsters; 
create materialized view type_monsters_mv as select * from type_monsters_v;

CREATE TABLE test_index_expressions (
    col1 int,
    col2 int,
    col3 int
);

CREATE INDEX idx1 ON test_index_expressions ((col1 + col2));
CREATE INDEX idx2 ON test_index_expressions ((col1 + col2), col3);
CREATE INDEX idx3 ON test_index_expressions (col1, (col2 + col3));
CREATE INDEX idx4 ON test_index_expressions (col3);
CREATE INDEX idx5 ON test_index_expressions (col1 DESC, col2 DESC);
CREATE INDEX idx6 ON test_index_expressions (POW(col3, 2));

CREATE TABLE foo_bar (
    id SERIAL PRIMARY KEY,
    secret_col VARCHAR(255) NOT NULL
);

CREATE TABLE foo_baz (
    id SERIAL PRIMARY KEY,
    secret_col VARCHAR(255) NOT NULL
);

CREATE TABLE foo_qux (
    id SERIAL PRIMARY KEY,
    secret_col VARCHAR(255) NOT NULL
);

CREATE TABLE bar_baz (
    id SERIAL PRIMARY KEY,
    secret_col VARCHAR(255) NOT NULL
);

CREATE TABLE bar_qux (
    id SERIAL PRIMARY KEY,
    secret_col VARCHAR(255) NOT NULL
);

-- Add comments
COMMENT ON TABLE type_monsters IS 'This is a table';
COMMENT ON VIEW type_monsters_v IS 'This is a view';
COMMENT ON MATERIALIZED VIEW  type_monsters_mv IS 'This is a materialized view';
COMMENT ON INDEX idx1 IS 'This is an index';
COMMENT ON CONSTRAINT check_not_null ON type_monsters IS 'This is a constraint';
