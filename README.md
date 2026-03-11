# WebStencils Session Demos #

[![Delphi](https://img.shields.io/badge/RAD%20Studio-Delphi-red.svg)](https://www.embarcadero.com/products/rad-studio)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue.svg)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

WebStencils is a scripting technology, introduced with Delphi 12.2; with Delphi 13, Session Management has been added to the underlying technology making interactive web sites built with Delphi feasible without a lot of work or third-party components.

The previous iteration of this demo, [WebStencils Demo](https://github.com/corneliusdavid/webstencils-demo), compared the old WebBroker-style tag replacement with the newer WebStencils scripting and replacement syntax but it did not use any session management for user authentication; therefore, if you logged in on one browser, then opened a different browser to the same address and port, it was already logged in! In other words, user state was maintained at the server and shared with all connected sessions. Obviously, this was for demonstration purposes only and would never be implemented in a public website.

This repository expands the `CustListWebStencils` demo project and adds proper session management to isolate user authentication to a single browser on a single computer.

## Project Overview

The web application is run as Windows VCL program with the HTML files in a sub-folder; a data module accesses the [Chinook SQLite database](https://www.sqlitetutorial.net/sqlite-sample-database) (included).

There are five pages in the application:

1. Index
2. Login page
3. Login Error
4. Customer List (lists customers in a table)
5. Customer Edit (presents an edit page for the selected customer)

**WebStencils template HTML files:**

- `custlistframework1.html` - template used in all pages
- `session_include.html` - include file to show session information
- `request_include.html` - include file to show request information
- `index.html` - starting page
- `loginform.html` - form for requesting username and password
- `loginfailed.html` - error page for invalid login
- `custlist.html` - table of customers
- `custlist-style.html` - styles for the customer table
- `custedit.html` - the customer edit form

## Building the Project

WebStencils was introduced in Delphi 12.2 and Session Management (the focus of this repository) was introduced in Delphi 13 which is, therefore, required to build this project. It was built with Delphi Enterprise but should be able to be compiled with the Professional Edition without any problem. No third-party components are necessary.

The [Chinook SQLite database](https://github.com/lerocha/chinook-database) is a popular database used for tutorials and demos and can be found in many places on the internet; it is included here for convenience. The Delphi code configures the database path to point to the current project folder so you should be able to simply compile and run.

## Running the demos

All Delphi projects in this repository, `CustListFormsSessions`, `Authorizer/CustListFormsAuthroized`, and `basic/CustListBasicSession` are created as Web Server Windows GUI programs, meaning they will run as a small Windows VCL program that opens a port to listen for web requests with a button to launch your default web browser; the default ports are 8080, 8081, and 8082, respectively.

All three programs access the same sample SQLite database in the root folder of this repository. A valid login must be entered before it will take you to the customer list. A valid login is any user in the `Employees` table where:

- **Username** is the `FirstName`, case-insensitive;
- **Password** is a concatenation of the `EmployeeId` and the `LastName`, case-*sensitive*.

For example, the first entry in the sample database I downloaded had the following first employee:

- `ID`: 1
- `FirstName`: Andrew
- `LastName`: Adams

Therefore, to login with this employee:

- Username: `ANDREW` (upper or lower or mixed case)
- Password: `1Adams` (exactly)

Once logged in, the customer list is shown.

### Role-Based Access

To illustrate both conditional HTML scripting with WebStencils and WebBroker's new user authentication capabilities, the project implements three different roles that affect and control access to the generated web pages. These roles are defined by key words in the `Title` field of the `Employee` table:

- if the `Title` field contains the word "Manager", the user role is MANAGER;
- else if the `Title` field contains the word "IT", the user role is EDITOR;
- else the user role is VIEWER (no editing allowed).

The background changes color depending on the current user role. Both a MANAGER and an EDITOR will see a link under each customer's ID (left-most column) that takes them to an "edit" screen. A VIEWER will not be able to see customer details.

In the included sample database, the following user credentials are examples of each of these:
- `STEVE`/`5Johnson` - VIEWER
- `ROBERT`/`7King` - EDITOR
- `ANDREW`/`1Adams` - MANAGER

### Logging

The project contains a unit, `uLogging.pas`, for providing simple logging to provide visibility on when various events fire. The log files are created in the same folder as the running application.

## Important Limitations

The data module (`TdmCust`) is created as a global singleton shared across all requests. This works for a single-user demo but is **not thread-safe**: concurrent requests from different browsers can interfere with each other. A production application should create a separate data module instance per request or use proper synchronization.

### Three Variations

The original program in the root folder, `CustListFormsSessions`, was going to be the only one in this repository. However, as I learned more about the different ways to use the components and modified the HTML files slightly for different demonstration purposes, I added two more in the sub-folders; read the blog mentioned below to learn more.

## Blog

Read my [First Look at WebBroker's Session Management](https://corneliusconcepts.tech/first-look-webbrokers-session-management) blog to learn more about this new session management for the old WebBroker technology!
