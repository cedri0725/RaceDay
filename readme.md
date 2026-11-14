# RaceDay - Event Management System

## Overview
RaceDay is a full-stack web-based event management system designed specifically for the South African road running, walking, and cycling community. The platform allows Event Organisers to create and manage events, categories, and participant results, while Participants can browse upcoming events, enrol, and track their personal performance history.

This repository contains the complete project across all three parts of the PROG6212 Portfolio of Evidence.

## User Roles
1. **Organiser** - Creates and manages events, categories, and participant results. Can also upload event images.
2. **Participant** - Browses events, enrols in event categories, and tracks personal results.

---

## Project Structure

```text
RaceDay/
│
├── docs/                                   # PART 1 - PLANNING AND DATABASE
│   ├── ERD_PROG.jpg                        # Entity Relationship Diagram
│   ├── endpoint-plan.md                    # API Endpoint Specification
│   ├── RaceDay_Database.sql                # Complete SQL Database Script
│   └── Database_Results.png                # SQL Execution Screenshot
│
├── .github/workflows/                      # CI/CD PIPELINES
│   ├── validate-docs.yml                   # Part 1 - Validates planning files
│   └── api-build-test.yml                  # Part 2 - Builds API and runs tests
│
├── RaceDay.API/                            # PART 2 - RESTFUL API PROJECT
│   ├── Controllers/                        # API Endpoints (Auth, Events, Enrolments)
│   ├── Data/                               # EF Core DbContext
│   ├── DTOs/                               # Data Transfer Objects
│   ├── Migrations/                         # EF Core Database Migrations
│   ├── Models/                             # Database Entities
│   ├── Services/                           # JWT Token & Azure Blob Services
│   ├── appsettings.json                    # API Configuration
│   └── Program.cs                          # API Startup & Middleware
│
├── RaceDay.API.Tests/                      # PART 2 - UNIT TESTS (xUnit)
│
├── RaceDay.MVC/                            # PART 3 - MVC FRONTEND PROJECT
│   ├── Controllers/                        # Account & Events Controllers
│   ├── ViewModels/                         # View Models for UI
│   ├── Views/                              # Razor Views (Login, Register, Events)
│   ├── wwwroot/                            # CSS, JS, and Bootstrap
│   ├── appsettings.json                    # Frontend Configuration (API URL)
│   └── Program.cs                          # MVC Startup & HttpClient Config
│
├── .gitignore
├── readme.md
└── Screenshot_1.png ... Screenshot_5.png   # Part 1 Screenshots

How to Run the Project
Prerequisites
.NET 8.0 SDK

SQL Server (Express or Developer edition) or SQL Server Management Studio (SSMS)

Visual Studio 2022 (Community edition) or Visual Studio Code

Step 1: Database Setup (Part 1)
Open SQL Server Management Studio (SSMS).

Connect to your SQL Server instance.

Open docs/RaceDay_Database.sql.

Click Execute (F5) to create the database and seed sample data.

Step 2: Run the API (Part 2)
Open the RaceDay.API project in Visual Studio.

Set RaceDay.API as the Startup Project.

Press F5. The API will launch on http://localhost:5000 and Swagger UI will open in your browser.

Use the Swagger UI to test endpoints, register users, and generate JWT tokens.

Step 3: Run the MVC Frontend (Part 3)
Right-click the Solution in Solution Explorer and select Properties.

Set Multiple startup projects and ensure both RaceDay.API and RaceDay.MVC are set to Start.

Press F5. Both projects will launch.

Navigate to the MVC frontend (e.g., http://localhost:5129) to register, log in, and view events.

Technology Stack

Technology	Purpose
ASP.NET Core 8.0 Web API	RESTful API framework (Part 2)
ASP.NET Core 8.0 MVC	Web Frontend (Part 3)
Entity Framework Core 8.0	ORM with Code-First approach
SQL Server	Relational Database
JWT (JSON Web Tokens)	Secure Authentication
BCrypt.Net	Password Hashing
Azure Blob Storage (Azurite)	Image Upload Storage (Part 3)
Swagger (Swashbuckle)	API Documentation and Testing
xUnit & Moq	Unit Testing
GitHub Actions	CI/CD Automated Pipelines
Video Walkthroughs
Part 1 & 2 Walkthrough: Watch the walkthrough

Part 3 (MVC & Azure) Walkthrough: [Paste your Part 3 video link here]

CI/CD Build Status
Part 1 - Document Validation
https://./workflow.png

Part 2 & 3 - API Build & Test
https://./RaceDay.API/.github/workflows/ci-cd-success.png

