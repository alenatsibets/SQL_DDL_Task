CREATE DATABASE hospital_db;

CREATE SCHEMA hospital_data;

CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	full_name VARCHAR(100) GENERATED ALWAYS AS (first_name || ' ' || last_name) 
	STORED NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    birth_date DATE CHECK (birth_date > '2000-01-01'),
);
	
ALTER TABLE Patients ADD age INT CHECK (age >= 0);
UPDATE Patients p SET age = EXTRACT (YEAR FROM AGE(CURRENT_DATE, p.birth_date));

CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	full_name VARCHAR(100) GENERATED ALWAYS AS (first_name || ' ' || last_name) 
	STORED NOT NULL UNIQUE,
    gender CHAR(1) CHECK (gender IN ('M', 'F'))
);

CREATE TABLE Visits (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

INSERT INTO Patients (first_name, last_name, gender, birth_date) VALUES
('John', 'Doe', 'M', '2020-05-15'),
('Jane', 'Smith', 'F', '2007-11-20'),
('Karol', 'Scymborski', 'M', '2012-11-20'),
('Hanna', 'Dubina', 'F', '2003-10-10'),
('Alena', 'Tsibets', 'F', '2005-05-28'),
('Ivan', 'Kulchyckiy', 'M', '2000-07-23'),
('Vanda', 'Rej', 'F', '2008-11-24');

INSERT INTO Doctors (first_name, last_name, gender) VALUES
('Dr. Mark', 'Johnson', 'M'),
('Dr. Emily', 'Williams', 'F'),
('Dr. Kate', 'Marks', 'F'),
('Dr. William', 'Hulbert', 'M'),
('Dr. John', 'Williams', 'M'),
('Dr. Vinsent', 'Greg', 'F');

INSERT INTO Visits (patient_id, doctor_id) VALUES
(8, 4),
(9, 5),
(10, 6),
(11, 7),
(12, 8),
(13, 9),
(14, 7),
(10, 8),
(8, 9);

ALTER TABLE Patients
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
UPDATE Patients
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE Doctors
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
UPDATE Doctors
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE Visits
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
UPDATE Visits
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;