# RaceDay Database Data Dictionary

## Users Table
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| User_ID | INT | Unique user identifier | PRIMARY KEY, IDENTITY |
| Role_ID | INT | User's role | FOREIGN KEY to Roles |
| Email | VARCHAR(100) | User's email address | UNIQUE, NOT NULL |
...