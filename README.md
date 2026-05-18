# HotWheels Nepal

An e-commerce web application for buying and selling Hot Wheels die-cast car models in Nepal.

## Tech Stack
- **Backend:** Java Servlets (Jakarta EE), JDBC
- **Frontend:** JSP, HTML, CSS, JavaScript
- **Database:** MySQL
- **Build:** Apache Maven
- **Server:** Apache Tomcat

## Features
- User registration and login with session management
- Product listing with search and sort
- Shopping cart with session-based storage
- Checkout and order confirmation
- Admin dashboard: product and user management
- User dashboard: profile editing with avatar upload
- Team portfolio pages
- Custom error handling

## Setup
1. Import the project into Eclipse as a Maven project
2. Create the database using `hotwheelsnepal.sql`
3. Update DB credentials in `src/main/java/com/hotwheelsnepal/util/DbConfig.java`
4. Deploy on Apache Tomcat 10+

## Team
- Sanjeev Ghimire
- Pratik Karki
- Aryan

## Project Structure
```
src/main/java/com/hotwheelsnepal/
├── controller/   Servlet controllers
├── dao/          Data Access Objects
├── filter/       Security filters
├── model/        Entity models
├── service/      Business logic
└── util/         Helper utilities
```
