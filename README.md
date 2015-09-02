# README #

## Install
### Requirements
postgresql >=9.3
ruby 2.2.1

### Env variable
```
export HDR_DATABASE_HOST=localhost
```

### Postgresql
create database
```
CREATE USER hupi_data_retriever;
CREATE USER test WITH PASSWORD 'test';
CREATE DATABASE hdr_development WITH OWNER hupi_data_retriever;
CREATE DATABASE hdr_test WITH OWNER test;

CREATE DATABASE hdr_test_data WITH OWNER test;
```

fill test database
```
$ psql -d hdr_test_data
```

```
CREATE TABLE IF NOT EXISTS hdr_test_data_entitystatstable (
  entity_name VARCHAR(20),
  memberof_valid BOOLEAN,
  memberof_share_quantity INT,
  memberof_name VARCHAR(20),
  entity_gender VARCHAR(20),
  memberof_memberfromint INT,
  entity_createat_int INT,
  entity_latitude DOUBLE PRECISION,
  entity_longitude DOUBLE PRECISION,
  entity_type VARCHAR(20)
);

INSERT INTO hdr_test_data_entitystatstable (entity_name, memberof_valid, memberof_share_quantity, memberof_name, entity_gender, memberof_memberfromint, entity_createat_int, entity_latitude, entity_longitude, entity_type)
VALUES
('manufacturer1', true, 1, 'college1', '', 20140101, 20140101, 1.0, 2.0, 'supplier'),
('manufacturer2', true, 14, 'college1', '', 20140202, 20140101, 1.0, 2.0, 'supplier'),
('manufacturer3', false, 0, 'college1', '', NULL, 20140101, 1.0, 2.0, 'supplier'),
('client1', false, 10, 'college2', 'homme', NULL, 20140101, 1.0, 2.0, 'customer'),
('client2', true, 5, 'college2', 'homme', 20140101, 20140101, 1.0, 2.0, 'customer'),
('client3', true, 1, 'college2', 'homme', 20140202, 20140101, 1.0, 2.0, 'customer'),
('client4', true, 5, 'college2', 'homme', 20140303, 20140202, 1.0, 2.0, 'customer'),
('client5', true, 2, 'college2', 'femme', 20140404, 20140202, 1.0, 2.0, 'customer'),
('client6', false, 10, 'college2', 'femme', NULL, 20140303, 1.0, 2.0, 'customer'),
('client7', true, 1, 'college2', 'femme', 20140505, 20140303, 1.0, 2.0, 'customer'),
('client8', true, 1, 'college2', 'femme', 20140606, 20140404, 1.0, 2.0, 'customer')
;

```

###
```
git clone https://github.com/hupi-analytics/data-retriever.git
cd data-retriever
bundle install
bundle exec rake db:reset
bundle exec rspec spec
```

## USE
### ruby console
```
bundle console
require_relative 'config/environment'
```
