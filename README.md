# 📝 Multi-Role Notes App (Flutter)

A clean, scalable **Flutter Notes Application** with **role-based access**, **priority management**, **offline-first storage**, and **dark/light theme support**.  
Built using **Flutter + BLoC architecture** following clean coding practices.

---

## 📱 App Overview

This app demonstrates how to build a **production-style Flutter application** with:
- User & Admin roles
- Offline storage using Hive
- Priority-based notes
- Smart sorting & searching
- Dark / Light mode support
- Clean UI with proper UX patterns

---

## 🔐 Login Flow (Role Selection)

On app launch, the user is asked to **select a role**:

### 👤 User Login
- Can create notes
- Can edit notes
- Can delete notes
- Can set **priority** (Low / Moderate / High)
- Notes are saved locally (offline-first)
- Notes are **not visible to Admin** until synced

### 👨‍💼 Admin Login
- Can only **view synced notes**
- Cannot create, edit, or delete notes
- Can **refresh/sync** to fetch latest user-synced notes
- Purely read-only role

> 🔹 This role-based flow is handled using **BLoC state management**, not hardcoded UI logic.

---

## ✨ Features

### 🔑 Role-Based Access
- **User**
  - Create / Edit / Delete notes
  - Select note priority
- **Admin**
  - View synced notes
  - Read-only access

---

### 🚦 Note Priority System
- Low 🟢  
- Moderate 🟠  
- High 🔴  

**Features**
- Priority selectable while creating/editing notes
- Priority badge displayed on note card
- Search works with priority keywords:
  - `high`
  - `moderate`
  - `low`

---

### 💾 Offline-First Storage
- Uses **Hive** for local persistence
- Notes remain available without internet
- Sync operation updates visibility for Admin

---

### 🔄 Smart Sorting
- Latest notes always appear **on top**
- Sorting logic:
  - `updatedAt` (if note edited)
  - otherwise `createdAt`
- Order remains consistent after:
  - Add
  - Update
  - Delete
  - Sync
  - Search

---

### 🔍 Advanced Search
- Search by:
  - Title
  - Description
  - Priority
- Case-insensitive
- Real-time filtering

---

### 🌗 Dark & Light Mode
- Fully theme-aware UI
- Toggle using BLoC
- Proper contrast & borders in both themes
- No hardcoded colors

---

### 🎨 Clean UI / UX
- Card-based layout
- Expandable note cards
- Action icons placed on title row
- Priority badges with color indicators
- Confirmation bottom sheets for:
  - Delete
  - Logout

---

## 🧱 Architecture

This project follows **Clean Architecture**:

lib/
│
├── data/
│ ├── models/ # Hive models
│ └── repositories/ # Data layer implementations
│
├── domain/
│ ├── entities/ # Core business models
│ └── repositories/ # Abstract contracts
│
├── presentation/
│ ├── bloc/ # Auth, Notes, Theme BLoC
│ └── screens/ # UI screens
│
├── utils/
│ - widgets/
│ - constants/
│
└── main.dart


---

## 🛠 Tech Stack & Packages

### Flutter & Dart
- **Flutter Version:** `3.38.1`
- **Dart Version:** `3.10`

### Packages Used
- `flutter_bloc` → State management
- `hive` & `hive_flutter` → Local storage
- `uuid` → Unique ID generation
- `equatable` → State comparison (optional)
- `flutter_screenutil` (optional) → Responsive UI



