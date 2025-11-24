# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Prerequisites
Ensure you have:
- ✅ Flutter SDK (>=3.9.0) installed
- ✅ Android Studio or VS Code with Flutter extension
- ✅ An Android emulator, iOS simulator, or physical device

Check Flutter installation:
```bash
flutter doctor
```

### 2. Install Dependencies
```bash
cd lms_portal
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

Or select your device in VS Code/Android Studio and press F5.

---

## 🔐 Test Accounts

### Admin Login
```
Email: admin@gmail.com
Password: admin1234
```

### User Login
```
Email: sirisha@gmail.com
Password: (ask admin)
```

---

## 📱 First Steps After Launch

### As Admin:
1. Login with admin credentials
2. You'll see the Admin Dashboard with 4 options
3. Try creating a category:
   - Tap "Categories"
   - Click the "+" button
   - Name: "Data Science"
   - Description: "Data science and ML courses"
   - Click "Add"
4. Create a course:
   - Tap "Courses"  
   - Click the "+"
   - Title: "Python Basics"
   - Instructor: "John Doe"
   - Level: Beginner
   - Price: 0
   - Click "Add"
5. Add a video:
   - Tap "Videos"
   - Click the "+"
   - Select your course
   - Title: "Introduction"
   - YouTube URL: `https://www.youtube.com/watch?v=kqtD5dpn9C8`
   - Duration: 600
   - Click "Add"
6. Add a checkpoint:
   - Find your video in the list
   - Tap the video card
   - Click "Add Checkpoint"
   - Timestamp: 300 (5 minutes)
   - Question: "What is Python?"
   - Choices: "Programming Language, Database, OS, Browser"
   - Correct Answer: "Programming Language"
   - Required: Yes
   - Click "Add"

### As User:
1. Login with user credentials
2. Browse categories on the home screen
3. Tap any category to see courses
4. Tap "Open Course" on any course
5. Video will play automatically
6. At checkpoint timestamp, answer the question
7. Continue watching after answering

---

## 🔧 Configuration

### Change API URL (if needed)
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://YOUR_API_URL:8000';
```

### Backend Server
The app connects to: `http://16.170.31.99:8000`

Ensure the backend server is running and accessible.

---

## 🎯 Key Features to Try

### Admin:
- ✅ Create multiple categories
- ✅ Add courses to categories
- ✅ Upload YouTube videos
- ✅ Create quiz checkpoints
- ✅ Manage users
- ✅ Edit and delete content

### User:
- ✅ Browse by category
- ✅ Watch course videos
- ✅ Answer checkpoints
- ✅ Navigate between videos
- ✅ Complete courses

---

## 📚 Documentation

- **README.md** - Overview and setup
- **USER_GUIDE.md** - Complete usage instructions
- **API_GUIDE.md** - API documentation
- **IMPLEMENTATION_SUMMARY.md** - Technical details

---

## ⚡ Quick Commands

```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Clean build
flutter clean

# Update dependencies
flutter pub upgrade

# Run tests (when added)
flutter test

# Check for issues
flutter analyze
```

---

## 🐛 Troubleshooting

### "No device found"
- Start an emulator
- Or connect a physical device with USB debugging

### "Build failed"
- Run `flutter clean`
- Run `flutter pub get`
- Try again

### "Network error"
- Check internet connection
- Verify API server is running
- Check API URL in constants

### Video won't play
- Ensure YouTube URL is valid
- Check internet connection
- Try a different video

---

## 📞 Need Help?

- Check the **USER_GUIDE.md** for detailed instructions
- Review **API_GUIDE.md** for API documentation
- Read **IMPLEMENTATION_SUMMARY.md** for technical details

---

## 🎉 You're Ready!

The app is fully functional with:
- ✅ Complete admin management
- ✅ User course browsing
- ✅ Video playback with checkpoints
- ✅ Role-based access
- ✅ All CRUD operations

**Enjoy your LMS Portal!** 🚀

---

*LMS Portal v1.0.0 - November 2025*
