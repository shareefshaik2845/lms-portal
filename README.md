# LMS Portal - Learning Management System

A comprehensive Flutter-based Learning Management System (LMS) with separate admin and user workflows, course management, video playback, and interactive checkpoints.

## Features

### Admin Features
- **User Management**: Create, read, update, and delete users
- **Category Management**: Organize courses into categories (Data Science, Mechanical, Electrical, etc.)
- **Course Management**: Create and manage courses with titles, descriptions, instructors, levels, and pricing
- **Video Management**: Add videos to courses with YouTube URLs and metadata
- **Checkpoint Management**: Create interactive quiz checkpoints at specific timestamps in videos
- **Organization & Branch Management**: Manage organizational structure

### User Features
- **Category Browsing**: View available course categories
- **Course Selection**: Browse and select courses by category
- **Video Playback**: Watch course videos with YouTube integration
- **Interactive Checkpoints**: Answer quiz questions at designated timestamps
- **Progress Tracking**: Track enrollment and course completion

## Architecture

The app follows Clean Architecture principles with:
- **Presentation Layer**: ViewModels and UI screens
- **Data Layer**: Repositories and Data Sources (Remote API)
- **Core Layer**: Network clients, utilities, and constants

### Project Structure
```
lib/
├── core/
│   ├── constants/       # API endpoints and app constants
│   ├── network/         # API client and response handling
│   └── utils/           # Shared preferences and utilities
├── data/
│   ├── models/          # Data models (User, Course, Category, Video, etc.)
│   ├── data_sources/    # Remote data sources
│   └── repositories/    # Repository implementations
├── presentation/
│   ├── viewmodels/      # State management (Provider)
│   └── views/           # UI screens (Admin, User, Auth)
└── widgets/             # Reusable UI components
```

## API Integration

The app connects to a FastAPI backend at `http://16.170.31.99:8000`

### Endpoints Used:
- **Auth**: `/auth/register`, `/auth/login`
- **Users**: `/users/` (CRUD operations)
- **Categories**: `/categories/` (CRUD operations)
- **Courses**: `/courses/` (CRUD operations)
- **Videos**: `/videos/` (CRUD operations)
- **Checkpoints**: `/checkpoints/` (CRUD operations)
- **Organizations**: `/organizations/` (CRUD operations)
- **Branches**: `/branches/` (CRUD operations)
- **Enrollments**: `/enrollments/` (CRUD operations)

## Admin Workflow

1. **Sign In**: Admin logs in with credentials (role_id = 1)
2. **Master Options Dashboard**: Access to:
   - User Master → Manage all users
   - Course Categories → Create categories (Data Science, Mechanical, etc.)
   - Courses Master → Manage courses under categories
   - Video Management → Add videos to courses
3. **Course Creation**:
   - Select category
   - Add title, description, instructor, level, price
4. **Video Management**:
   - Add YouTube video URLs to courses
   - Set video metadata and duration
5. **Checkpoint Creation**:
   - Select video and timestamp
   - Add quiz question with multiple choices
   - Mark correct answer
   - Set as required or optional

## User Workflow

1. **Sign In**: User logs in with credentials (role_id = 2)
2. **Category Selection**: View and select from available course categories
3. **Course Browsing**: See courses within selected category with thumbnails
4. **Video Playback**:
   - Select a course to start watching
   - Video plays using YouTube player
5. **Checkpoint Interaction**:
   - At specific timestamps, video pauses
   - Quiz question appears with multiple choices
   - User must answer to continue
   - Feedback provided (correct/incorrect)
6. **Navigation**: Move forward/backward through course content

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code with Flutter extension
- iOS Simulator / Android Emulator or physical device

### Installation

1. Clone the repository:
```bash
cd lms_portal
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API endpoint (if needed):
   - Edit `lib/core/constants/api_constants.dart`
   - Update `baseUrl` to your backend server

4. Run the app:
```bash
flutter run
```

### Test Credentials

**Admin Account:**
- Email: `admin@gmail.com`
- Password: `admin1234`
- Role ID: 1

**User Account:**
- Email: `sirisha@gmail.com`
- Password: (contact admin)
- Role ID: 2

## Dependencies

Key packages used:
- `provider: ^6.1.1` - State management
- `http: ^1.1.0` - HTTP requests
- `dio: ^5.4.0` - Advanced HTTP client
- `shared_preferences: ^2.2.2` - Local storage
- `youtube_player_flutter: ^8.1.2` - YouTube video playback
- `fluttertoast: ^8.2.4` - Toast notifications
- `flutter_inappwebview: ^5.8.0` - In-app web views

## Key Features Implementation

### Authentication
- JWT token-based authentication
- Role-based access control (Admin vs User)
- Persistent login with SharedPreferences

### Video Player with Checkpoints
- YouTube integration for video playback
- Real-time checkpoint detection based on video position
- Pause video when checkpoint is reached
- Quiz modal with multiple choice questions
- Answer validation and feedback

### Admin CRUD Operations
- Complete create, read, update, delete for:
  - Users
  - Categories
  - Courses
  - Videos
  - Checkpoints

### Responsive UI
- Material Design 3
- Grid layouts for dashboards
- List views for data management
- Form dialogs for data entry
- Loading indicators and error handling

## State Management

Uses Provider pattern with ViewModels:
- `AuthViewModel` - Authentication state
- `UserViewModel` - User management
- `CategoryViewModel` - Category management
- `CourseViewModel` - Course management
- `VideoViewModel` - Video and checkpoint management

## Error Handling

- API response validation
- User-friendly error messages
- Loading states for async operations
- Network error recovery

## Future Enhancements

- Course progress tracking
- Certificate generation
- Push notifications
- Offline course download
- Advanced analytics dashboard
- Multi-language support
- Dark mode theme

## License

This project is private and proprietary.

## Support

For issues or questions, contact the development team.
