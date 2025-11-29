-- Create Database
CREATE DATABASE IF NOT EXISTS crop_yield_db;
USE crop_yield_db;

-- Districts Table
CREATE TABLE districts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crops Table
CREATE TABLE crops (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seasons Table
CREATE TABLE seasons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main Crop Data Table
CREATE TABLE crop_data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    district_id INT NOT NULL,
    crop_id INT NOT NULL,
    season_id INT NOT NULL,
    rainfall_mm DECIMAL(10, 2) NOT NULL,
    avg_temp_c DECIMAL(5, 2) NOT NULL,
    area_ha DECIMAL(12, 2) NOT NULL,
    yield_t_ha DECIMAL(10, 4) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE CASCADE,
    FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_record (year, district_id, crop_id, season_id)
);

-- Predictions Log Table
CREATE TABLE predictions_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    district VARCHAR(100) NOT NULL,
    crop VARCHAR(100) NOT NULL,
    season VARCHAR(50) NOT NULL,
    rainfall_mm DECIMAL(10, 2) NOT NULL,
    avg_temp_c DECIMAL(5, 2) NOT NULL,
    area_ha DECIMAL(12, 2) NOT NULL,
    predicted_yield DECIMAL(10, 4) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Model Training Log
CREATE TABLE model_training_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    training_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    records_used INT NOT NULL,
    mse DECIMAL(15, 6),
    rmse DECIMAL(15, 6),
    mae DECIMAL(15, 6),
    r2_score DECIMAL(10, 6),
    status ENUM('success', 'failed') DEFAULT 'success',
    error_message TEXT
);

-- Insert Initial Data
INSERT INTO districts (name) VALUES 
('District_A'), ('District_B'), ('District_C'), ('District_D'), ('District_E');

INSERT INTO crops (name) VALUES 
('Wheat'), ('Rice'), ('Maize');

INSERT INTO seasons (name) VALUES 
('Kharif'), ('Rabi'), ('Zaid');

-- Create View for Easy Data Access
CREATE VIEW crop_data_view AS
SELECT 
    cd.id,
    cd.year,
    d.name AS district,
    c.name AS crop,
    s.name AS season,
    cd.rainfall_mm,
    cd.avg_temp_c,
    cd.area_ha,
    cd.yield_t_ha,
    cd.created_at,
    cd.updated_at
FROM crop_data cd
JOIN districts d ON cd.district_id = d.id
JOIN crops c ON cd.crop_id = c.id
JOIN seasons s ON cd.season_id = s.id;