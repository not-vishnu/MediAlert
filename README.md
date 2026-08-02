# 💊 MediAlert AI

A smart medicine reminder application built with **Flutter** and **Firebase**, designed to help users manage their medications, schedule reminders, track medicine history, and get AI-powered health-related assistance.

---

## 📱 About the Project

**MediAlert AI** is a mobile medicine management application developed using Flutter.

The application helps users:

- Add and manage medicines
- Set daily medicine reminders
- Receive local notifications
- Track medicine history
- View medicine analytics
- Manage their profile
- Use an AI assistant for general medicine and health-related questions
- Store user and medicine information securely using Firebase

The project focuses on combining **medicine management, reminders, analytics, cloud storage, and AI assistance** into a single application.

---

## ✨ Features

### 🔐 Authentication
- User registration
- User login
- Firebase Authentication
- Logout functionality
- User profile management

### 💊 Medicine Management
- Add medicines
- Edit medicines
- Delete medicines
- Select medicine type
- Enter dosage information
- Add optional notes
- Enable or disable reminders

### ⏰ Medicine Reminders
- Select reminder time
- Daily medicine reminders
- Local notifications
- Enable/disable individual reminders
- Automatic reminder scheduling

### 📊 Analytics
- Medicine-related statistics
- Medicine tracking
- Visual representation of medicine data

### 📜 Medicine History
- View previous medicine records
- Track medicine status
- Monitor medication activity

### 🤖 MediAlert AI
The application includes an AI assistant designed for medicine and health-related questions.

The assistant is configured to:
- Answer general medicine-related questions
- Provide general health information
- Avoid diagnosing diseases
- Encourage users to consult qualified healthcare professionals

> ⚠️ The AI assistant is not a replacement for a doctor or qualified healthcare professional.

### 👤 Profile
- View user information
- Edit profile information
- Manage account details

### 🎨 Modern UI
- Material Design
- Glassmorphism-inspired interface
- Animated backgrounds
- Custom UI components
- Responsive layouts
- Light/Dark theme support

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Application development |
| Dart | Programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Firebase Storage | Cloud storage |
| Flutter Local Notifications | Medicine reminders |
| Provider | State management |
| Shared Preferences | Local preferences |
| OpenRouter API | AI assistant |
| HTTP | API communication |
| fl_chart | Analytics and charts |
| intl | Date and time formatting |

---

## 🏗️ Project Structure

```text
lib/
│
├── models/
│   ├── medicine_model.dart
│   └── user_model.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── medicine_provider.dart
│   └── theme_provider.dart
│
├── screens/
│   ├── add_medicine_screen.dart
│   ├── ai_chat_screen.dart
│   ├── analytics_screen.dart
│   ├── dashboard_page.dart
│   ├── edit_medicine_screen.dart
│   ├── edit_profile_screen.dart
│   ├── history_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   ├── settings_screen.dart
│   └── splash_screen.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── medicine_service.dart
│   ├── notification_service.dart
│   ├── openrouter_service.dart
│   └── reminder_service.dart
│
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
│
├── ui/
│   └── glass/
│
├── utils/
│
└── widgets/
    ├── medicine_card.dart
    ├── glass_button.dart
    ├── glass_container.dart
    ├── glass_textfield.dart
    └── ...
