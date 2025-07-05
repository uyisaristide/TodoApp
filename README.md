ToDo App
A ToDo app built for the Vodari Flutter Developer test.

🚀 Getting Started
This is a simple yet structured Flutter ToDo app project. It helps manage tasks with start/end dates, descriptions, and completion toggling using Riverpod and SQLite.

🛠️ Features
Add, edit, delete tasks

Select start and end dates with a calendar

Toggle completion status

Persistent storage with SQLite

Structured and maintainable project architecture

🧪 How to Run the App
Clone the repo

bash
Copy
Edit
git clone https://github.com/your-username/todo.git
cd todo
Get Flutter packages

bash
Copy
Edit
flutter pub get
Run the app

bash
Copy
Edit
flutter run
📦 Dependencies Used
yaml
Copy
Edit
dependencies:
flutter:
sdk: flutter
cupertino_icons: ^1.0.6
flutter_riverpod: ^2.6.1
sqflite: ^2.3.3+1
path_provider: ^2.1.5
go_router: ^14.8.0
intl: ^0.18.1
flutter_svg: ^1.0.0
table_calendar: ^3.0.9

dev_dependencies:
flutter_test:
sdk: flutter
flutter_lints: ^3.0.0
🧱 Project Structure
bash
Copy
Edit
lib/
├── assets/                # SVGs and images
├── constants/             # Constant values (e.g., colors)
├── database/              # Local SQLite helper
├── models/                # Data models (e.g., TaskModel)
├── riverpod_state_mgt/    # Riverpod notifiers and providers
├── routers/               # GoRouter configuration
├── utils/                 # Reusable utils (e.g., callbacks, date formatting)
├── views/                 # Screens (e.g., Home, NewTask)
│   └── widgets/           # Reusable widgets within views
└── main.dart              # App entry point
🖋️ Fonts and Assets
yaml
Copy
Edit
flutter:
uses-material-design: true

assets:
- assets/images/
- assets/svgs/

fonts:
- family: Sora
fonts:
- asset: assets/fonts/Sora-Light.ttf
- asset: assets/fonts/Sora-Regular.ttf
- asset: assets/fonts/Sora-Medium.ttf
weight: 300
- asset: assets/fonts/Sora-Bold.ttf
- asset: assets/fonts/Sora-ExtraLight.ttf
- asset: assets/fonts/Sora-ExtraBold.ttf
weight: 700
