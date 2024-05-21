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
  

## How to Run the Task Manager Flutter App

### Prerequisites
- Ensure you have Flutter (version 2.5.0 or above) and Dart installed.

### Steps to Run

1. **Clone the Repository**
    ```sh
    git clone https://github.com/Farwakhan971/Task_Manager_Flutter_App.git
    cd Task_Manager_Flutter_App
    ```

2. **Install Dependencies**
    ```sh
    flutter pub get
    ```

3. **Run the App**
    ```sh
    flutter run
    ```

## Directory Structure

lib/
|-- main.dart
|-- screens/
|   |-- login_screen.dart
|   |-- task_screen.dart
|-- models/
|   |-- task.dart
|   |-- user.dart
|-- services/
|   |-- api_service.dart
|   |-- database_helper.dart
|-- providers/
|   |-- auth_provider.dart
|   |-- task_provider.dart


## Design Decisions

### State Management
- **Provider**: Choose Provider for state management due to its simplicity and efficiency in managing state across the app.

### Local Storage
- **SQLite**: Used SQLite for persistent local storage to ensure tasks remain accessible between app sessions. 

### API Integration
- **DummyJSON API**: Integrated with DummyJSON API for authentication and task management, providing a realistic backend simulation.

### Pagination
- **Pagination**: Implemented pagination to handle large data sets efficiently, enhancing performance and user experience.

## Challenges Faced

### API Integration
- Handling edge cases and errors from the API responses to ensure a smooth user experience.

### State Management
- Managing state updates efficiently, especially with asynchronous operations such as API calls and database access.

### Local Storage
- Ensuring data consistency between the local database and the remote API, particularly with updates and deletions.

##  Screens
![Login_Screen](https://github.com/Farwakhan971/Task_Manager_Flutter_App/assets/130717631/89535a65-437d-46a3-92c0-352d8e1594e2)
![Home_Screen](https://github.com/Farwakhan971/Task_Manager_Flutter_App/assets/130717631/f3c23359-daf5-4228-93e4-d6314554a619)
![Add_task](https://github.com/Farwakhan971/Task_Manager_Flutter_App/assets/130717631/ba06eb97-b49d-4584-9387-8ba689e5edfc)
![delete_task](https://github.com/Farwakhan971/Task_Manager_Flutter_App/assets/130717631/ebe325bb-4660-47ec-bc6d-502057299a4e)

## Video 


https://github.com/Farwakhan971/Task_Manager_Flutter_App/assets/130717631/0547fcaa-e862-49b1-a78e-2287dc166fad




