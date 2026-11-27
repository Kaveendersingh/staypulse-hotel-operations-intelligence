-- StayPulse schema v1.0: synthetic data only
-- Run in PostgreSQL on a new empty database.
CREATE SCHEMA IF NOT EXISTS staypulse;
SET search_path TO staypulse;

CREATE TABLE countries (
    country_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_code CHAR(2) UNIQUE NOT NULL,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE cities (
    city_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_id SMALLINT REFERENCES countries,
    city_name VARCHAR(100) NOT NULL
);

CREATE TABLE hubs (
    hub_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_code VARCHAR(30) UNIQUE NOT NULL,
    hub_name VARCHAR(100) NOT NULL,
    city_id INTEGER REFERENCES cities
);

CREATE TABLE employees (
    employee_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    designation VARCHAR(100),
    hub_id INTEGER REFERENCES hubs,
    manager_id BIGINT REFERENCES employees
);

CREATE TABLE physical_properties (
    physical_property_id VARCHAR(30) PRIMARY KEY,
    physical_property_name VARCHAR(200) NOT NULL,
    city_id INTEGER REFERENCES cities,
    hub_id INTEGER REFERENCES hubs,
    crn INTEGER NOT NULL CHECK (crn >= 0),
    number_of_floors INTEGER CHECK (number_of_floors >= 0),
    property_status VARCHAR(30) NOT NULL
);

CREATE TABLE properties (
    property_id VARCHAR(30) PRIMARY KEY,
    physical_property_id VARCHAR(30) REFERENCES physical_properties,
    property_name VARCHAR(200) NOT NULL,
    listing_type VARCHAR(20),
    listing_channel VARCHAR(100),
    property_manager_id BIGINT REFERENCES employees,
    CONSTRAINT ck_listing_type CHECK (listing_type IN ('Main Listing','Dual Listing'))
);

CREATE TABLE guests (
    guest_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    guest_country_id SMALLINT REFERENCES countries
);

CREATE TABLE booking_sources (
    booking_source_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(100) UNIQUE,
    source_category VARCHAR(30)
);

CREATE TABLE booking_statuses (
    booking_status_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status_name VARCHAR(30) UNIQUE
);

CREATE TABLE room_types (
    room_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    physical_property_id VARCHAR(30) REFERENCES physical_properties,
    room_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE bookings (
    booking_id BIGINT PRIMARY KEY,
    invoice_number VARCHAR(30) UNIQUE NOT NULL,
    property_id VARCHAR(30) REFERENCES properties,
    guest_id BIGINT REFERENCES guests,
    booking_source_id SMALLINT REFERENCES booking_sources,
    booking_status_id SMALLINT REFERENCES booking_statuses,
    room_type_id INTEGER REFERENCES room_types,
    booking_created_at TIMESTAMP NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE CHECK (check_out_date > check_in_date),
    actual_check_in TIMESTAMP,
    actual_check_out TIMESTAMP,
    number_of_rooms SMALLINT CHECK (number_of_rooms > 0),
    number_of_adults SMALLINT CHECK (number_of_adults >= 0),
    number_of_children SMALLINT CHECK (number_of_children >= 0),
    nightly_rate NUMERIC(12,2) CHECK (nightly_rate >= 0),
    gross_booking_value NUMERIC(12,2) CHECK (gross_booking_value >= 0),
    discount_amount NUMERIC(12,2) CHECK (discount_amount >= 0),
    refund_amount NUMERIC(12,2) CHECK (refund_amount >= 0),
    realized_revenue NUMERIC(12,2) CHECK (realized_revenue >= 0),
    currency CHAR(3) NOT NULL,
    cancellation_reason VARCHAR(250),
    CHECK (number_of_adults >= 0 AND number_of_children >= 0)
);

CREATE TABLE payment_types (
    payment_type_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_type_name VARCHAR(50) UNIQUE
);

CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    payment_type_id SMALLINT REFERENCES payment_types,
    transaction_type VARCHAR(20),
    transaction_amount NUMERIC(12,2) CHECK (transaction_amount >= 0),
    transaction_status VARCHAR(30) NOT NULL,
    currency CHAR(3) NOT NULL,
    transaction_timestamp TIMESTAMP NOT NULL
);

CREATE TABLE physical_property_inventory_daily (
    inventory_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    physical_property_id VARCHAR(30) REFERENCES physical_properties,
    inventory_date DATE NOT NULL,
    blocked_rooms INTEGER CHECK (blocked_rooms >= 0),
    srn INTEGER CHECK (srn >= 0),
    brn INTEGER CHECK (brn >= 0),
    urn INTEGER CHECK (urn >= 0),
    available_rooms INTEGER CHECK (available_rooms >= 0),
    UNIQUE (physical_property_id, inventory_date),
    CHECK (brn <= srn),
    CHECK (urn <= srn),
    CHECK (available_rooms = srn - brn)
);

CREATE TABLE booking_room_nights (
    room_night_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    stay_date DATE NOT NULL,
    rooms_booked SMALLINT CHECK (rooms_booked > 0),
    rooms_occupied SMALLINT CHECK (rooms_occupied >= 0),
    nightly_revenue NUMERIC(12,2) CHECK (nightly_revenue >= 0),
    UNIQUE (booking_id, stay_date),
    CHECK (rooms_occupied <= rooms_booked)
);

CREATE TABLE review_sources (
    review_source_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(100) UNIQUE
);

CREATE TABLE issue_categories (
    issue_category_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE,
    parent_category_id SMALLINT REFERENCES issue_categories
);

CREATE TABLE reviews (
    review_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    property_id VARCHAR(30) REFERENCES properties,
    review_source_id SMALLINT REFERENCES review_sources,
    review_date DATE NOT NULL,
    rating NUMERIC(3,1),
    review_text TEXT,
    issue_category_id SMALLINT REFERENCES issue_categories,
    sentiment_label VARCHAR(20),
    management_response_flag BOOLEAN
);

CREATE TABLE operations_cases (
    case_id BIGINT PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    property_id VARCHAR(30) REFERENCES properties,
    issue_category_id SMALLINT REFERENCES issue_categories,
    priority VARCHAR(20),
    case_status VARCHAR(30) NOT NULL,
    assigned_employee_id BIGINT REFERENCES employees,
    created_at TIMESTAMP NOT NULL,
    first_response_at TIMESTAMP,
    resolved_at TIMESTAMP,
    sla_target_minutes INTEGER CHECK (sla_target_minutes >= 0),
    sla_met BOOLEAN
);

CREATE TABLE checkin_events (
    checkin_event_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    checkin_method VARCHAR(30),
    digital_eligible BOOLEAN,
    precheckin_completed BOOLEAN,
    identity_verification_status VARCHAR(30),
    access_code_generated BOOLEAN,
    checkin_status VARCHAR(30),
    actual_checkin_timestamp TIMESTAMP
);

CREATE TABLE smart_lock_events (
    smart_lock_event_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    physical_property_id VARCHAR(30) REFERENCES physical_properties,
    lock_id VARCHAR(50),
    event_timestamp TIMESTAMP NOT NULL,
    event_type VARCHAR(50),
    event_status VARCHAR(30),
    failure_reason VARCHAR(250),
    bridge_status VARCHAR(30)
);

CREATE TABLE booking_history (
    booking_history_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT REFERENCES bookings,
    change_timestamp TIMESTAMP NOT NULL,
    change_type VARCHAR(50),
    field_name VARCHAR(100),
    old_value TEXT,
    new_value TEXT
);

-- Cross-table business checks (physical property consistency, room nights and CRN reconciliation)
-- are performed in the Python ETL validation layer before loading.
-- Room blocking and booking across listings must share the same physical inventory.