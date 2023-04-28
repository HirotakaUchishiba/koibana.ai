You can get api document at http://localhost:8000/docs after you load the server.


#####You have to create a database at postgresql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(50) NOT NULL,
    hashed_password VARCHAR(100) NOT NULL
);
