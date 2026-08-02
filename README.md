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


🚀 Getting Started
1. Clone the Repository
git clone https://github.com/not-vishnu/MediAlert.git
2. Open the Project
cd MediAlert
3. Install Dependencies
flutter pub get
4. Configure Firebase

Create a Firebase project and configure Firebase for your Flutter application.

You will need to configure Firebase Authentication and Cloud Firestore.

Do not upload private Firebase credentials or API secrets to GitHub.

5. Configure OpenRouter

The AI assistant uses an OpenRouter API key.

The project reads the API key using:

const String apiKey = String.fromEnvironment(
  'OPENROUTER_API_KEY',
);

Run the application with your API key supplied through --dart-define:

flutter run --dart-define=OPENROUTER_API_KEY=YOUR_API_KEY

Never hard-code your real API key inside the source code.

6. Run the Application
flutter run
🔒 Security

MediAlert AI uses external services such as Firebase and OpenRouter.

For security:

Never commit API keys to GitHub
Never hard-code secret keys in Dart files
Use --dart-define or another secure secret-management method
Do not expose private credentials in the repository
Configure Firebase security rules before deploying the application
⚠️ Medical Disclaimer

MediAlert AI is intended for general informational and medication-management purposes only.

The AI assistant does not provide professional medical diagnosis or treatment.

Users should consult a qualified doctor, pharmacist, or other healthcare professional before:

Starting a medication
Stopping a medication
Changing dosage
Making decisions about medical treatment

Do not rely on the AI assistant for emergency medical situations.

🔮 Future Improvements

Possible future improvements include:

💊 Medication interaction detection
📷 Medicine identification using the camera
🧠 Improved AI medicine assistant
📅 Advanced medication scheduling
👨‍⚕️ Doctor consultation integration
📈 More advanced health analytics
☁️ Improved cloud synchronization
🔔 Smarter notification management
📱 Play Store deployment
🌐 Multi-language support
🏥 Healthcare provider integration
🎯 Project Goals

The main goals of MediAlert AI are:

Make medication management easier.
Help users remember their medicines.
Provide a simple and modern user interface.
Keep medicine records organized.
Provide useful medicine-related AI assistance.
Combine cloud technology, notifications, analytics, and AI in one application.
👨‍💻 Developer

MediAlert AI

Developed as a Flutter application project using modern mobile application development technologies.

📄 License

This project is licensed under the MIT License.

See the LICENSE file for details.

⭐ Support

If you find this project useful, consider giving the repository a ⭐ on GitHub.
