# WebStencils Session Demo #

WebStencils is a scripting technology, introduced with Delphi 12.2; with Delphi 13, Session Management has been added to the underlying technology making interactive web sites built with Delphi feasible without a lot of work or third-party components.

The previous iteration of this demo, [WebStencils Demo](https://github.com/corneliusdavid/webstencils-demo), compared the old WebBroker-style tag replacement with the newer WebStencils scripting and replacement syntax but it did not use any session management for user authentication; therefore, if you logged in on one browser, then opened a different browser to the same address and port, it was already logged in! In other words, user state was maintained at the server and shared with all connected sessions. Obviously, this was for demonstration purposes only and would implemented in a public website.

This repository expands the `CustListWebStencils` demo project and adds proper session management to isolate user authentication to a single browser on a single computer.

## Project Overview

The web application is run as Windows VCL program with the HTML files in a sub-folder; a data module accesses the [Chinook SQLite database](https://www.sqlitetutorial.net/sqlite-sample-database) (included).

There are five pages in the application:

1. Index (presents a login page)
2. Login Error
3. Customer List (lists customers in a table)
4. Customer Edit (presents an edit page for the selected customer)
5. An error page (for preventing unauthorized access)

**WebStencils template HTML files:**

- `index.html`
- `custlist.html`
- `custedit.html`
- `loginfailed.html`
- `custlistframework1.html`

## Building the Project

WebStencils was introduced in Delphi 12.2 and Session Management (the focus of this repository) was introduced in Delphi 13 which is, therefore, required to build this project.

The [Chinook SQLite database](https://github.com/lerocha/chinook-database) is a popular database used for tutorials and demos and can be found in many places on the internet; it is included here for convenience. The Delphi code configures the database path to point to the current project folder so you should be able to simply compile and run.

No third-party components are necessary.

## Running the demo

The demo Delphi project, `CustListSessionedWebStencils`, is created as a Web Server Windows GUI program, meaning it runs as a small Windows VCL program that opens a port to listen for web requests with a button to launch your default web browser; the default port is 8080.

The first page listed is a login page. A valid login must be entered before it will take you to the customer list. A valid login is any user in the `Employees` table where:

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

To illustrate WebBroker's new user authentication capabilities, the project implements three different roles that have affect the generated web pages. These roles are defined by key words in the `Employee`.`Title` field:

- if the `Title` field contains the word "Manager", the user role is MGR;
- else if the `Title` field contains the word "IT", the user role is EDITOR;
- else the user role is VIEWER (no editing allowed).

Once logged in, the background for a MGR will change to red. Both a MGR and an EDITOR will see a link under each customer's ID (left-most column) that takes them to an "edit" screen. A VIEWER will not be able to see customer details.

In the included sample database, the following user credentials are examples of each of these:
- `STEVE`/`5Johnson` - VIEWER
- `ROBERT`/`7King` - EDITOR
- `ANDREW`/`Adams` - MGR

### Logging

The project contains a unit, `uLogging.pas`, for providing simple logging when various events fire. The log files are created in the user's `ProgramData` folder.

## Blog

Read my ["Introducing WebStencils"](https://corneliusconcepts.tech/introducing-webstencils) blog to learn more about the technology behind these programs and why WebStencils is cool!

