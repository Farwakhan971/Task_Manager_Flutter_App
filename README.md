# Task Manager App

Task Manager App is a Flutter application designed to help users manage their tasks efficiently. It features user authentication, task management, pagination, state management, and local storage for persistent data. The app offers a clean and intuitive user interface, robust state management using Provider, and seamless performance.

## Features

### User Authentication
- Secure login using username and password with the DummyJSON API.

### Task Management
- **View Tasks:** Retrieve and display existing tasks from the DummyJSON Todos API.
- **Add Task:** Users can add new tasks through the app interface. Note that adding a new todo will not add it to the server as DummyJSON does not support this. Instead, the app simulates a POST request to create the task and returns the newly created todo with a new ID.
- **Edit Task:** Users can edit existing tasks.
- **Delete Task:** Deleting a todo will not delete it from the server. It will simulate a DELETE request.
- **Pagination:** Efficiently fetch and display a large number of tasks with pagination.

### State Management
- Efficient state management using the Provider package.

### Local Storage
- Persist tasks locally using an SQLite database to ensure data remains accessible even when the app is closed and reopened.
- Retain user login information by saving the username and password locally using shared preferences.

### Comprehensive Unit Tests
- **auth_provider_test.dart:** Ensures that the authentication provider correctly handles user authentication processes, including login, logout, and session management.
- **database_helper_test.dart:** Verifies the functionality of database operations, ensuring data is correctly inserted, updated, retrieved, and deleted within the app's database.
- **task_provider_test.dart:** Validates the task provider's ability to manage task-related data, including creating, updating, and deleting tasks, and ensuring accurate state management.
  

## Getting Started

### Prerequisites

- Flutter (version 2.5.0 or above)
- Dart

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com//task_manager_app.git
    cd task_manager
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

## Directory Structure

