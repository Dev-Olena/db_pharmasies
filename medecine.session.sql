CREATE TABLE medecine (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK(name != ''),
    substanse varchar(300) NOT NULL CHECK(substanse != ''),
    dosage numeric(9,3) CHECK (dosage > 0),
    price numeric(12, 2) NOT NULL CHECK (price >0),
    quantity int NOT NULL CHECK(quantity > 0)
);

CREATE TABLE pharmasies (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK(name != ''),
    address text NOT NULL CHECK (address != ''),
    phone char(12) NOT NULL CHECK (phone != '')
);

CREATE TABLE medecine_to_pharmasies (
    medecine_id int REFERENCES medecine(id),
    pharmasy_id int REFERENCES pharmasies(id),
    quantity int NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (medecine_id, pharmasy_id)
);

CREATE TABLE customers (
    id serial PRIMARY KEY,
    first_name varchar(200) NOT NULL CHECK(first_name != ''),
    last_name varchar(200) NOT NULL CHECK(last_name != ''),
    email varchar(50) NOT NULL CHECK(email != ''),
    birthdate date CHECK (birthdate > '1900-01-01' AND birthdate < current_date),
    phone char(12) NOT NULL CHECK (phone != '')
);

CREATE TABLE orders (
    id serial,
    created_at timestamp DEFAULT current_timestamp CHECK (created_at <= current_timestamp),
    customer_id int REFERENCES customers(id),
    pharmasy_id int,
    medecine_id int,
    quantity int NOT NULL  CHECK(quantity > 0),
    FOREIGN KEY (pharmasy_id, medecine_id) REFERENCES medecine_to_pharmasies  (pharmasy_id, medecine_id),
    PRIMARY KEY (id, pharmasy_id)
);
