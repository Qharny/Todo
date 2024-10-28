# todo_app - Task Management App

todo_app is a feature-rich Flutter task management application that helps users organize their daily tasks efficiently. Built with Flutter and powered by Hive for local storage, it offers a smooth, responsive experience with both light and dark theme support.

## 🌟 Features

- **Task Management**
  - Create, edit, and delete tasks
  - Set due dates and priorities
  - Categorize tasks
  - Add tags for better organization
  - Track task completion status

- **Categories**
  - Create custom categories
  - Color coding
  - Icon customization
  - Category-based task filtering

- **User Interface**
  - Clean, modern design
  - Dark and light theme support
  - Responsive layout
  - Smooth animations
  - Intuitive navigation

- **Data Management**
  - Local storage using Hive
  - Fast data access
  - Data persistence
  - Easy data backup
  - Efficient filtering and sorting

## 📱 Screenshots

[ ]

## 🛠️ Technical Stack

- **Framework**: Flutter
- **Database**: Hive
- **State Management**: [Your choice - e.g., Provider, Bloc, Riverpod]
- **Local Storage**: SharedPreferences
- **Architecture**: Repository Pattern

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

## 🚀 Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/qharny/todo_app.git
   cd todo_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── task.dart
│   ├── category.dart
│   └── task_filter.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   └── task_screen.dart
├── theme/
│   ├── colors.dart
│   └── theme.dart
└── repositories/
    └── task_repository.dart
```

## 🔧 Configuration

1. **Theme Customization**
   - Edit `lib/theme/colors.dart` for color schemes
   - Modify `lib/theme/theme.dart` for theme settings

2. **Hive Models**
   - Task model in `lib/models/task.dart`
   - Category model in `lib/models/category.dart`
   - Filter model in `lib/models/task_filter.dart`

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Known Issues

- [List any known issues or limitations]

## 🗺️ Roadmap

- [ ] Cloud synchronization
- [ ] Task sharing
- [ ] Recurring tasks
- [ ] Statistics and analytics
- [ ] Custom notifications

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Manasseh Kabutey Kwame** - *Initial work* - [GitHub](https://github.com/qharny)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive developers for the efficient local database
- [Add other acknowledgments]

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/mr_kabuteyy) - kabuteymanasseh5@gmail.com.com

Project Link: [https://github.com/qharny/todo_app](https://github.com/qharny/todo_app)