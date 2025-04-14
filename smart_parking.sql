CREATE TABLE ParkingLog (
    id INT PRIMARY KEY,
    vehicle_type VARCHAR(20),
    number_plate VARCHAR(20) UNIQUE,
    main_in DATETIME,
    main_out DATETIME,
    b1_in DATETIME NULL,
    b1_out DATETIME NULL,
    b2_in DATETIME NULL,
    b2_out DATETIME NULL,
    b3_in DATETIME NULL,
    b3_out DATETIME NULL
);

INSERT INTO ParkingLog (id, vehicle_type, number_plate, main_in, main_out, b1_in, b1_out, b2_in, b2_out, b3_in, b3_out) 
VALUES 
(13, 'Car', 'KA01AB1234', '2025-02-04 08:00:00', '2025-02-04 09:32:00', '2025-02-04 08:02:00', '2025-02-04 09:30:00', NULL, NULL, NULL, NULL),
(14, 'Bike', 'KA02CD5600', '2025-02-04 07:30:00', '2025-02-04 10:45:00', '2025-02-04 07:32:00', '2025-02-04 10:40:00', '2025-02-04 07:35:00', '2025-02-04 10:30:00', NULL, NULL),
(15, 'Car', 'KA02CD4321', '2025-02-04 07:15:00', '2025-02-04 09:45:00', '2025-02-04 07:18:00', '2025-02-04 09:43:00', '2025-02-04 07:20:00', '2025-02-04 09:40:00', '2025-02-04 07:22:00', '2025-02-04 09:38:00'),
(16, 'Car', 'KA02AD2341', '2025-02-04 07:00:00', '2025-02-04 11:45:00', '2025-02-04 07:10:00', '2025-02-04 11:30:00', '2025-02-04 08:00:00', '2025-02-04 11:15:00', '2025-02-04 09:40:00', '2025-02-04 11:00:00');

WITH TimeCalculations AS (
    SELECT 
        id,
        vehicle_type,
        number_plate,
        main_in,
        main_out,
        b1_in,
        b1_out,
        b2_in,
        b2_out,
        b3_in,
        b3_out,

        -- Total time at the main gate
        TIMESTAMPDIFF(MINUTE, main_in, main_out) AS total_time_main_gate_minutes,

        -- Calculate B1 time
        CASE 
            WHEN b1_in IS NOT NULL AND b2_in IS NULL 
            THEN TIMESTAMPDIFF(MINUTE, b1_in, b1_out)
            WHEN b1_in IS NOT NULL AND b2_in IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, b1_in, b2_in)
            ELSE 0 
        END AS total_time_b1_minutes_adjusted,

        -- Calculate B2 time
        CASE 
            WHEN b2_in IS NOT NULL AND b3_in IS NULL 
            THEN TIMESTAMPDIFF(MINUTE, b2_in, b2_out) 
            WHEN b2_in IS NOT NULL AND b3_in IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, b2_in, b3_in)
            ELSE 0 
        END AS total_time_b2_minutes_adjusted,

        -- Calculate B3 time
        CASE 
            WHEN b3_in IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, b3_in, b3_out)
            ELSE 0 
        END AS total_time_b3_minutes_adjusted,

        -- Determine current location
        CASE
            WHEN main_out IS NOT NULL THEN 'Exited'
            WHEN b3_in IS NOT NULL AND b3_out IS NULL THEN 'B3'
            WHEN b2_in IS NOT NULL AND b2_out IS NULL THEN 'B2'
            WHEN b1_in IS NOT NULL AND b1_out IS NULL THEN 'B1'
            ELSE 'Unknown'
        END AS current_location

    FROM ParkingLog
)

SELECT 
    id,
    vehicle_type,
    number_plate,
    main_in,
    main_out,
    b1_in,
    b1_out,
    b2_in,
    b2_out,
    b3_in,
    b3_out,

    -- Adjusted total time
    COALESCE(total_time_main_gate_minutes, 0) AS total_time_main_gate_minutes,
    COALESCE(total_time_b1_minutes_adjusted, 0) AS total_time_b1_minutes_adjusted,
    COALESCE(total_time_b2_minutes_adjusted, 0) AS total_time_b2_minutes_adjusted,
    COALESCE(total_time_b3_minutes_adjusted, 0) AS total_time_b3_minutes_adjusted,

    -- Current location of the vehicle
    current_location

FROM TimeCalculations;
