# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Delphi WebStencils demo application that showcases session management and user authentication for web applications built with Delphi 13. The project demonstrates how to build interactive web sites using Delphi's WebStencils technology with proper session management.

## Architecture

### Core Components

- **CustListSessionedWebStencils.dpr**: Main program file that initializes the web application
- **uwebCustListWebStencil.pas**: Web module containing WebStencils processors, session management, and action handlers
- **udmCust.pas**: Data module that handles database connections, user authentication, and customer data operations
- **ufrmCustListWebStencil.pas**: Windows VCL form that provides the GUI to start/stop the web server

### Key Technologies

- **WebStencils**: Delphi's server-side scripting technology for dynamic HTML generation
- **Session Management**: Uses TWebSessionManager for user session isolation
- **Authentication**: Role-based access control with three roles (ADMIN, EDITOR, VIEWER)
- **Database**: FireDAC with SQLite (Chinook sample database)

### Web Flow

1. Users access the application through a web browser (default port 8080)
2. Login is required using Employee table credentials (FirstName as username, EmployeeId+LastName as password)
3. Role-based access determines available features:
   - ADMIN: Red background, can edit customers
   - EDITOR: Can edit customers
   - VIEWER: Read-only access to customer list
4. Session management ensures proper user isolation between browsers

### File Structure

- **html/**: WebStencils HTML template files
  - `index-wStencils.html`: Login page
  - `custlist-wStencils.html`: Customer listing
  - `custedit-wStencils.html`: Customer edit form
  - `accessdenied-wStencils.html`: Access denied page
  - `loginfailed-wStencils.html`: Login failure page

## Development Commands

### Building
This is a standard Delphi project. Build using:
- Delphi IDE: Build > Build Project
- Command line: Use `dcc32` or `dcc64` compiler directly

### Running
- Compile and run the executable: `CustListSessionedWebStencils.exe`
- The application starts a VCL form with controls to start/stop the web server
- Default port is 8080, configurable in the GUI

### Database Setup
- Ensure `chinook.db` SQLite database file is in the project directory
- Modify the TFDConnection component in `udmCust` if database location differs
- The project expects singular table names (Customer, Employee, not Customers/Employees)

## Important Notes

- Requires Delphi 13 or newer (enforced by compiler directive in uwebCustListWebStencil.pas:3-5)
- The application uses no third-party components, only standard Delphi libraries
- WebStencils HTML templates are processed server-side and served as dynamic content
- Session management provides proper user isolation compared to traditional WebBroker applications