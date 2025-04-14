# 🚗 Smart Parking System - Database

This project contains the database schema for a **Smart Parking System**, designed to manage and automate the process of vehicle parking in smart cities or campuses.

## 📦 Project Structure

- `smart_parking.sql` – SQL script containing table definitions, constraints, and initial data for the system.

## 📚 Features

- Parking slot availability tracking
- Vehicle entry and exit logging
- User and admin role management
- Real-time booking and allocation

## 🗂️ Database Schema Overview

The schema includes the following key tables:

1. **Users** – Stores user details (e.g., customers and admins)
2. **Vehicles** – Maintains vehicle information linked to users
3. **ParkingSlots** – Tracks individual parking slot availability and type
4. **Bookings** – Records bookings, entry and exit times
5. **Payments** – Manages transaction data
6. **Admins** – System administrator records

> Note: Table names and relationships should be verified by reviewing `smart_parking.sql`.

## 🛠️ Getting Started

### Prerequisites

- MySQL or any compatible RDBMS
- MySQL Workbench (optional)

### Steps to Use

1. Clone or download this repository.
2. Open your SQL client (e.g., MySQL Workbench).
3. Execute the script:
   ```sql
   SOURCE path/to/smart_parking.sql;
