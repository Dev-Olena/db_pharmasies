---------table medecine-------
CREATE TABLE medecine (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK(name != ''),
    substanse varchar(300) NOT NULL CHECK(substanse != ''),
    dosage numeric(9,3) CHECK (dosage > 0),
    price numeric(12, 2) NOT NULL CHECK (price >0),
    quantity int NOT NULL CHECK(quantity > 0)
);

ALTER TABLE medecine
RENAME COLUMN id TO medecine_id;


INSERT INTO medecine (name, substanse, price, quantity) VALUES
('med1', 'sub1', 120, 100),
('med2', 'sub2', 45, 100),
('med3', 'sub3', 80, 50);


---------table pharmasies-------
CREATE TABLE pharmasies (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK(name != ''),
    address text NOT NULL CHECK (address != ''),
    phone char(12) NOT NULL CHECK (phone != '')
);

ALTER TABLE pharmasies
RENAME COLUMN pharmasies_id TO pharmasy_id;

INSERT INTO pharmasies (name, address, phone) VALUES
('pharm1', 'adress1', '80501236654'),
('pharm2', 'adress2', '80961236654');

---------table customers------
CREATE TABLE customers (
    id serial PRIMARY KEY,
    first_name varchar(200) NOT NULL CHECK(first_name != ''),
    last_name varchar(200) NOT NULL CHECK(last_name != ''),
    email varchar(50) NOT NULL CHECK(email != ''),
    birthdate date CHECK (birthdate > '1900-01-01' AND birthdate < current_date),
    phone char(12) NOT NULL CHECK (phone != '')
);

ALTER TABLE customers
RENAME COLUMN id TO customer_id;

ALTER TABLE customers
ADD UNIQUE(phone);

 ALTER TABLE customers
 ADD CHECK(phone LIKE '380_________');
 
 INSERT INTO customers (first_name, last_name, email, phone) VALUES 
 ('Jane', 'Billy', 'fgsgsds@jjd.hd', '380507201488'),
 ('Jhone', 'Snow', 'snows@jjd.hd', '380507201123'),
 ('Kate', 'Park', 'parkds@jjd.hd', '380507207854');

---------

CREATE TABLE medecine_to_pharmasies (
    med_to_ph_id serial PRIMARY KEY,
    med_id int REFERENCES medecine(medecine_id) ON DELETE CASCADE ON UPDATE CASCADE,
    ph_id int REFERENCES pharmasies(pharmasy_id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity int NOT NULL CHECK(quantity > 0)
);

INSERT INTO medecine_to_pharmasies (med_id, ph_id, quantity) VALUES
(3, 3, 10),
(3, 4, 20),
(4, 3, 30),
(5, 3, 10),
(5, 4, 20);



-----------table orders-------

CREATE TABLE orders (
    order_id serial PRIMARY KEY,
    created_at timestamp DEFAULT current_timestamp CHECK (created_at <= current_timestamp),
    customer_id int REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    pharmasy_id int REFERENCES pharmasies(pharmasy_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO orders (customer_id, pharmasy_id) VALUES
(3,3),
(5,3),
(3,4);


---------table orders_items----
CREATE TABLE order_items (
    order_id int REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    medecine_id int REFERENCES medecine_to_pharmasies(med_to_ph_id),
    quantity int NOT NULL CHECK(quantity > 0)
);

ALTER TABLE order_items
ADD PRIMARY KEY (order_id, medecine_id);

INSERT INTO order_items (order_id, medecine_id, quantity) VALUES
(1, 1, 4),
(2, 3, 2),
(1, 3, 1);


DROP TABLE orders;

DROP TABLE medecine_to_pharmasies;



SELECT o.order_id, o.created_at, 
        concat(c.first_name, ' ', c.last_name) AS "full_name",
        c.phone,
        ph.name, ph.address,
        o_i.medecine_id, o_i.quantity,
        med_to_ph.med_id,
        m.name, m.substanse
        FROM orders  AS o 
LEFT JOIN customers AS c
ON o.customer_id = c.customer_id
LEFT JOIN pharmasies  AS ph 
ON o.pharmasy_id = ph.pharmasy_id
LEFT JOIN order_items AS o_i 
ON o.order_id = o_i.order_id
LEFT JOIN medecine_to_pharmasies AS med_to_ph 
ON o_i.medecine_id = med_to_ph.med_to_ph_id
LEFT JOIN medecine AS m 
ON med_to_ph.med_id = m.medecine_id
ORDER BY o.order_id;