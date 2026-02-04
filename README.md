# 📝 Multi-Role Notes App (Flutter)

A clean, scalable **Flutter Notes Application** with **role-based login**, **priority management**, **offline-first storage**, and **dark/light theme support**.  
Built using **Flutter + BLoC architecture** following clean architecture principles.

---

## 🚀 Overview

This app allows users to create and manage notes with priority levels, while admins can monitor synced notes.  
The application is designed with **real-world app patterns** such as offline storage, syncing, sorting, and role-based access control.

---

## 🔐 Login Flow (Role-Based)

When the app starts, the user is prompted to **select a role**:

### 👤 User Login
- Can create notes
- Can edit existing notes
- Can delete notes
- Can set note priority (Low / Moderate / High)
- Notes are stored locally (offline-first)
- Notes can be synced to make them visible to Admin

### 🛡️ Admin Login
- Can view only **synced user notes**
- Cannot create, edit, or delete notes
- Sync button is **disabled for admin**
- Acts as a read-only dashboard

> 🔑 Login is simulated for demo purposes using role selection (Admin/User).

---

## ✨ Features

### 👥 Role-Based Access
**User**
- Create notes
- Edit notes
- Delete notes
- Assign priority
- Sync notes

**Admin**
- View synced notes
- Read-only access
- No modification permissions

---

### ⚡ Note Priority System
- Priority levels:
  - 🟢 Low
  - 🟠 Moderate
  - 🔴 High
- Priority selected while creating/editing notes
- Priority badge shown on each note card
- Search supports priority keywords (`low`, `moderate`, `high`)

---

### 💾 Offline-First Storage
- Uses **Hive** for local persistence
- Notes remain available without internet
- Sync mechanism updates visibility for Admin

---

### 🔄 Smart Sorting
- Latest notes always appear on top
- Sorting based on:
  - `updatedAt` (if note is edited)
  - Otherwise `createdAt`
- Sorting remains consistent after:
  - Add
  - Update
  - Delete
  - Sync
  - Search

---

### 🔍 Advanced Search
- Real-time search
- Search by:
  - Title
  - Description
  - Priority
- Case-insensitive filtering

---

### 🌗 Dark & Light Mode
- Fully theme-aware UI
- Toggle between dark and light mode
- Managed using **Theme BLoC**
- Proper contrast and borders in both themes

---

### 🎨 Clean UI/UX
- Card-based layout
- Expandable notes using `ExpansionTile`
- Edit & Delete icons placed on title row
- Priority badges with color indicators
- Confirmation bottom sheets for:
  - Delete
  - Logout

---

## 🧱 Architecture

This project follows **Clean Architecture**:

