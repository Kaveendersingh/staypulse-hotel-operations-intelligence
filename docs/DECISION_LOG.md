# StayPulse — Project Decision Log

## 1. Purpose

This document records significant business, technical, architectural and implementation decisions made throughout the StayPulse project lifecycle.

## 2. Decision Register

| ID | Decision | Rationale | Status |
|---|---|---|---|
| DEC-001 | Use synthetic hotel data exclusively | Protect guest privacy and confidential business information | Accepted |
| DEC-002 | Use PostgreSQL as the primary database | Support relational modelling, constraints and analytical SQL | Accepted |
| DEC-003 | Separate physical properties from property listings | Support multiple listings for the same physical hotel | Accepted |
| DEC-004 | Maintain inventory at physical property level | Prevent inventory duplication and double-selling across listings | Accepted |
| DEC-005 | Maintain fixed CRN at physical property level | Represent contracted room capacity consistently | Accepted |
| DEC-006 | Maintain daily SRN, BRN and URN | Enable daily inventory, demand and occupancy analysis | Accepted |
| DEC-007 | Use numeric booking IDs | Maintain consistent booking identification | Accepted |
| DEC-008 | Assign one unique alphanumeric invoice number per booking | Ensure invoice traceability and uniqueness | Accepted |
| DEC-009 | Separate payment and refund transactions from bookings | Support multiple financial transactions per booking | Accepted |
| DEC-010 | Use Python for synthetic data generation and ETL | Enable reproducible and automated data processing | Accepted |
| DEC-011 | Use a public GitHub repository with MIT License | Enable portfolio visibility and open-source collaboration | Accepted |
| DEC-012 | Maintain an isolated Python virtual environment | Prevent dependency conflicts between projects | Implemented |
| DEC-013 | Maintain pinned dependencies in requirements.txt | Improve environment reproducibility | Implemented |
| DEC-014 | Store credentials in local environment variables | Prevent exposure of sensitive configuration | Partially implemented |
| DEC-015 | Exclude generated datasets and reports from Git | Reduce repository size and unnecessary version tracking | Implemented |
| DEC-016 | Maintain separate documentation and executable test directories | Improve SDLC traceability and testing organization | Implemented |
| DEC-017 | Use .gitkeep files to preserve empty directories | Maintain consistent repository structure | Implemented |
| DEC-018 | Maintain Markdown-based change and decision logs alongside Word documents | Improve readability and version tracking on GitHub | Implemented |
| DEC-019 | Install dependencies incrementally by development phase | Avoid unnecessary dependencies and simplify troubleshooting | Accepted |
| DEC-020 | Use a fixed random seed for synthetic data generation | Support reproducible datasets and testing | Planned |

## 3. Business Rules

### BR-001 — Shared Physical Inventory

Multiple property listings may represent the same physical hotel. Room availability must be managed at the physical property level.

A room blocked or occupied through one listing must not be independently available through another listing.

### BR-002 — Daily Inventory Metrics

- CRN: Contracted Rooms.
- SRN: Sellable Rooms.
- BRN: Booked Rooms per Night.
- URN: Used Rooms per Night.

CRN remains fixed for each physical property, while SRN, BRN and URN are maintained daily.

### BR-003 — Booking Identification

Each booking must have a unique numeric booking ID and one unique alphanumeric invoice number.

## 4. Technical Environment

| Component | Configuration |
|---|---|
| Operating System | Windows |
| Development IDE | Visual Studio Code |
| Python Version | 3.13.9 |
| Version Control | Git |
| Remote Repository | GitHub |
| Virtual Environment | .venv |
| Dependency Management | pip and requirements.txt |
| Database | PostgreSQL — implementation pending |
| License | MIT |

## 5. Resolved Technical Issues

### ISS-001 — Git Not Detected in VS Code

Resolution: Installed Git for Windows and verified the installation using git --version.

### ISS-002 — Python Interpreter Detection

Resolution: Identified the existing Anaconda Python installation and created a project-specific virtual environment. Terminal interpreter verified; VS Code editor interpreter selection requires confirmation.

### ISS-003 — PowerShell Execution Policy

Resolution: Applied RemoteSigned execution policy at process scope and successfully activated the virtual environment.

### ISS-004 — Dependency Verification

Resolution: Verified dependency consistency using pip check and successfully imported all initial project libraries.

## 6. Pending Decisions and Validations

- PostgreSQL version and deployment configuration.
- Database schema execution and constraint validation.
- Synthetic dataset size and historical date range.
- Property and room distribution.
- Booking demand and seasonality patterns.
- Data quality thresholds.
- KPI calculation and aggregation validation.
- Cloud deployment configuration.
- CI/CD workflow design.

## 7. Revision History

| Version | Date | Description |
|---|---|---|
| 1.0 | 2026-11-26 | Initial decision register and implementation records |