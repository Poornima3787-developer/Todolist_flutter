# Frontend Documentation

## 📌 Overview
This is a Flutter-based Todo application with authentication and task management features. Users can register, log in, and securely manage their tasks and subtasks using token-based authentication.

---

## 🖥️ Screens

1. Login Screen
   - User enters email and password
   - Calls authentication API
   - On success:
     - Stores token securely
     - Navigates to Home Screen
   - Shows error message on invalid credentials

2. Signup Screen
   - New users can register
   - Sends user data to backend
   - Redirects to Login after success

3. Home Screen
   - Displays all tasks
   - Fetches data from backend using token
   - Supports:
     - Add Task
     - Edit Task
     - Delete Task
     - Search Tasks
     - Manage Subtasks

4. Add Task Bottom Sheet
   - Add task title
   - Add multiple subtasks

5. Edit Task Bottom Sheet
   - Edit existing task title
   - Updates task via API

---

## 🔐 Authentication Flow

1. User enters credentials in Login Screen
2. `AuthService.login()` is called
3. Backend returns a JWT token
4. Token is stored using `FlutterSecureStorage`
5. User is navigated to Home Screen
6. All future API calls include token

---

## 🔑 Token Handling

- Token is stored securely using:
  - `flutter_secure_storage`

Example:
```dart
final storage = FlutterSecureStorage();
await storage.write(key: "token", value: token);
await storage.read(key:'token');


## Base URL
http://192.168.0.197:3000

## API Integration

todo_service
auth_service

##🎯 Features

1.User Signup
2.User Login
3.Token-based Authentication
4.Add Task
5.Edit Task
6.Delete Task
7.Add Subtasks
8.Toggle Subtasks
9.Search Tasks
10.Progress Tracking

## 🎨 UI Components

-Scaffold
-AppBar
-TextField
-ElevatedButton
-ListView.builder
-ExpansionTile
-Card
-CheckboxListTile
-FloatingActionButton
-ModalBottomSheet
-SnackBar

## Run Frontend

flutter pub get
flutter run