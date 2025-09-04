# WebStencils Sessions Demo #

WebStencils is a scripting technology, introduced with Delphi 12.2; with Delphi 13, Session Management has been added to the underlying technology making interactive web sites built with Delphi feasible without a lot of work or third-party components.

The previous iteration of this demo, [WebStencils Demo](https://github.com/corneliusdavid/webstencils-demo), compared the old WebBroker-style tag replacement with the newer WebStencils scripting and replacement syntax but it did not use any session management for user authentication; therefore, if you logged in on one browser, then opened one of the sites in a different browser or on a different computer, it was already logged in!

This repository expands the `CustListWebStencils` demo project and adds proper session management to isolate user authentication to a single browser on a single computer.

## Project Overview

The web application is run as Windows VCL program and all the project and HTML files are in one folder; a data module accesses the [Chinook SQLite database](https://www.sqlitetutorial.net/sqlite-sample-database) (not included).

There are five pages in the application:

1. Index (presents a login page)
2. Login Error
3. Customer List (lists customers in a table)
4. Customer Edit (presents an edit page for the selected customer)
5. An error page (for preventing unauthorized access)

**WebStencils template HTML files:**

- `index-wStencils.html`
- `login-failed-wStencils.html`
- `custlist-wStencils.html`
- `custedit-wStencils.html`
- `accessdenied-wStencils.html`
- `custlistframework1.html`

## Building the Projects

Before you try to compile or run, you should download the [Chinook sample database](https://github.com/lerocha/chinook-database). This is a popular database used for tutorials and demos and can be found in many different places. I use [DBeaver](https://dbeaver.io/), a free database tool, and found it ships with that.

Once you have the `chinook.db` in the same folder as the project, you need to open the data module, **`udmCust`**, and modify the `TFDConnection` component to specify the location of the database file. I would also suggest using a database tool or Delphi's [Data Explorer](https://docwiki.embarcadero.com/RADStudio/Athens/en/Data_Explorer) to view the tables in the database.

Delphi 13 was used to create and test the program (which uses no third-party components).

## Running the demo

The demo is created as Web Server Windows GUI program, meaning it runs as a small Windows VCL program that opens a port to listen for web requests with a button to launch your default web browser; the default port is 8080.

The first page listed is a login page. A valid login must be entered before it will take you to the customer list. A valid login is any user in the Employees table where:

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

To illustrate WebBroker's new user authentication capabilities, the project implements three different roles that have small affects on the generated web pages. These roles are defined by key words in the `Employee`.`Title` field:

- if the `Title` field contains the word "Management", the user role is ADMIN;
- else if the `Title` field contains the word "IT", the user role is EDITOR;
- else the user role is VIEWER.

Once logged in, the background for an ADMIN will change to red. Both an ADMIN and an EDITOR will see a link under each customer's ID (left-most column) that takes them to an "edit" screen (NOTE: the `Submit` button does not save changes or do anything other than take you back to the list of customers). A VIEWER will not be able to see customer details.

### Table Names

I've used two different "Chinook" sample databases, one had singular table names (e.g. "Customer" and "Employee") while the other had plural (e.g. "Customer**s**" and "Employee**s**"); if the one you get is different than the one in this repository, just change the table names and queries to match.

### Why HTML Tables?

The customer list is built using the old HTML table tags (`<table>`, `<tr>`, `<td>`, etc.) because that's the simple and default way that the old WebBroker server apps built using the `TDataSetTableProducer` components were done. The new WebStencils version builds the same HTML result so you can compare how it's done and the resulting web pages will be nearly identical. Modern websites typically construct CSS-style tables, a benefit that can be realized by switching from DataSetTableProducers to WebStencils.

## Blog

Read my ["Introducing WebStencils"](https://corneliusconcepts.tech/introducing-webstencils) blog to learn more about the technology behind these programs and why WebStencils is cool!

