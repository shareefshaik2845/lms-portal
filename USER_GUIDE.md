# LMS Portal User Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Admin Workflow](#admin-workflow)
3. [User Workflow](#user-workflow)
4. [Features](#features)
5. [Troubleshooting](#troubleshooting)

## Getting Started

### Installation
1. Ensure you have Flutter installed on your system
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

### First Login

The app opens with a login screen. Use one of the test accounts:

**Admin Account:**
- Email: `admin@gmail.com`
- Password: `admin1234`

**User Account:**
- Email: `sirisha@gmail.com`  
- Password: (provided by admin)

---

## Admin Workflow

### 1. Sign In
- Enter admin credentials
- Click "Login"
- You'll be redirected to the Admin Dashboard

### 2. Admin Dashboard

The dashboard shows 4 main options:

#### A. User Management
**Purpose:** Manage all users in the system

**Actions:**
- **View Users:** See list of all users with their details
- **Add User:** 
  1. Click the "+" button
  2. Fill in user details (name, email, role, organization, branch)
  3. Set password
  4. Click "Add"
- **Edit User:**
  1. Tap on a user card
  2. Click "Edit" button
  3. Modify details
  4. Click "Update"
- **Delete User:**
  1. Tap on a user card
  2. Click "Delete" button
  3. Confirm deletion

#### B. Category Management
**Purpose:** Create and organize course categories (Data Science, Mechanical, Electrical, etc.)

**Actions:**
- **View Categories:** See all course categories
- **Add Category:**
  1. Click the "+" button
  2. Enter category name (e.g., "Data Science")
  3. Enter description
  4. Click "Add"
- **Edit Category:**
  1. Tap on a category
  2. Click "Edit"
  3. Update name/description
  4. Click "Update"
- **Delete Category:**
  1. Tap on a category
  2. Click "Delete"
  3. Confirm deletion

#### C. Course Management
**Purpose:** Create and manage courses

**Actions:**
- **View Courses:** See all available courses
- **Add Course:**
  1. Click the "+" button
  2. Enter course title
  3. Enter instructor name
  4. Set price
  5. Select level (Beginner/Intermediate/Advanced)
  6. Click "Add"
- **Edit Course:**
  1. Tap on a course
  2. Click "Edit"
  3. Modify details
  4. Click "Update"
- **Delete Course:**
  1. Tap on a course
  2. Click "Delete"
  3. Confirm deletion

#### D. Video Management
**Purpose:** Add videos to courses and create checkpoints

**Actions:**
- **View Videos:** See all course videos
- **Add Video:**
  1. Click the "+" button
  2. Select the course
  3. Enter video title
  4. Paste YouTube URL
  5. Enter duration (in seconds)
  6. Click "Add"
- **Add Checkpoint to Video:**
  1. Tap on a video
  2. Click "Add Checkpoint"
  3. Enter timestamp (when checkpoint should appear, in seconds)
  4. Enter quiz question
  5. Enter answer choices (comma-separated)
  6. Enter correct answer
  7. Mark as required/optional
  8. Click "Add"
- **View Checkpoints:**
  - Expand video card to see all checkpoints
  - Each checkpoint shows timestamp, question, and answer

### 3. Creating a Complete Course

**Step-by-Step Example:**

1. **Create Category:**
   - Go to Categories
   - Add "Data Science"

2. **Create Course:**
   - Go to Courses
   - Add "Introduction to Python"
   - Instructor: "John Doe"
   - Level: Beginner
   - Price: 99.99

3. **Add Videos:**
   - Go to Videos
   - Add Video 1: "Python Basics"
   - YouTube URL: `https://youtube.com/watch?v=xxxxx`
   - Duration: 600 (10 minutes)

4. **Add Checkpoints:**
   - Select the video
   - Add checkpoint at 300 seconds (5 minutes)
   - Question: "What is a variable in Python?"
   - Choices: "A container for data, A function, A loop, A class"
   - Correct Answer: "A container for data"

### 4. Admin Profile
- Click profile icon (top right)
- View your details
- Click logout to sign out

---

## User Workflow

### 1. Sign In
- Enter user credentials
- Click "Login"
- You'll be redirected to Course Categories

### 2. Browse Categories

The home screen displays all available course categories:
- Each category is shown as a card with icon and name
- Tap on any category to see its courses

**Example Categories:**
- Data Science
- Mechanical Engineering
- Electrical Engineering
- Web Development

### 3. View Courses

After selecting a category:
- See all courses in that category
- Each course shows:
  - Title
  - Instructor name (if added)
  - Level
  - "Open Course" button

### 4. Watch Course Videos

**Starting a Course:**
1. Tap "Open Course" on any course
2. Video player opens with the first video
3. Video plays automatically

**Video Player Controls:**
- Play/Pause button
- Progress bar
- Full screen option (via YouTube player)
- Video list below player

**Navigating Videos:**
- Swipe through video list
- Tap any video to switch to it
- Use forward/backward buttons

### 5. Interactive Checkpoints

**How Checkpoints Work:**
1. Video plays normally
2. At specific timestamps, video automatically pauses
3. A quiz question appears as an overlay
4. You must answer before continuing

**Answering Questions:**
1. Read the question
2. Select one of the multiple choice options
3. Click "Submit Answer"
4. Get instant feedback:
   - ✅ **Correct:** "Great job! Continue watching."
   - ❌ **Incorrect:** Shows the correct answer
5. Click "Continue" to resume video

**Example:**
- Video: "Python Variables"
- At 5:00 minutes: Question appears
- Question: "What keyword is used to create a variable in Python?"
- Options: "var", "let", "Nothing special", "define"
- Correct: "Nothing special"

### 6. Course Progress

- Navigate between videos using the video list
- Videos you've watched are marked
- Checkpoints ensure you're learning (can't skip without answering)

### 7. User Profile
- Click profile icon (top right)
- View your details:
  - Name
  - Email
  - Role
- Click logout to sign out

---

## Features

### For Admins

#### User Management
- ✅ Create users with roles (Admin/User)
- ✅ Assign users to organizations and branches
- ✅ Set user details (designation, DOB, joining date)
- ✅ Mark users as active/inactive

#### Content Management
- ✅ Organize courses into categories
- ✅ Create courses with detailed information
- ✅ Add YouTube videos to courses
- ✅ Create timed checkpoints in videos
- ✅ Design quiz questions with multiple choices

#### Dashboard
- ✅ Quick access to all management functions
- ✅ View statistics (coming soon)

### For Users

#### Learning Experience
- ✅ Browse courses by category
- ✅ Watch high-quality YouTube videos
- ✅ Interactive learning with checkpoints
- ✅ Immediate feedback on answers
- ✅ Forced engagement (must answer to continue)

#### Navigation
- ✅ Easy course discovery
- ✅ Smooth video playback
- ✅ Progress tracking within courses

---

## Troubleshooting

### Login Issues

**Problem:** "Login failed" error
**Solution:**
1. Check your internet connection
2. Verify email and password are correct
3. Ensure the backend server is running
4. Contact admin if password forgotten

**Problem:** "Session expired" message
**Solution:**
1. You've been logged out for security
2. Simply login again with your credentials

### Video Playback Issues

**Problem:** Video won't play
**Solution:**
1. Check YouTube URL is valid
2. Ensure you have internet connection
3. Try a different video
4. Refresh the page

**Problem:** Checkpoint doesn't appear
**Solution:**
1. Make sure checkpoint timestamp is set correctly
2. Video must reach that exact timestamp
3. Check if checkpoint exists for that video

### Admin Issues

**Problem:** Can't create category/course
**Solution:**
1. Check all required fields are filled
2. Ensure you're logged in as admin
3. Check internet connection
4. Verify API server is running

**Problem:** Changes don't save
**Solution:**
1. Wait for loading indicator to finish
2. Check for error messages
3. Try again after a few seconds
4. Check network connection

### General Issues

**Problem:** App crashes or freezes
**Solution:**
1. Close and restart the app
2. Clear app data (if available)
3. Check Flutter version compatibility
4. Report to development team

**Problem:** UI elements not displaying correctly
**Solution:**
1. Restart the app
2. Check screen orientation
3. Try on different device
4. Report bug to development team

---

## Best Practices

### For Admins

1. **Organize Content Logically**
   - Group related courses in same category
   - Use clear, descriptive names
   - Keep course titles consistent

2. **Create Effective Checkpoints**
   - Place checkpoints at key learning moments
   - Ask clear, concise questions
   - Provide distinct answer choices
   - Space checkpoints evenly (every 5-10 minutes)

3. **Video Selection**
   - Use high-quality educational videos
   - Ensure videos are publicly accessible
   - Check video duration matches actual length
   - Test videos before publishing

4. **User Management**
   - Use descriptive user names
   - Set appropriate roles
   - Keep user information up to date
   - Remove inactive users regularly

### For Users

1. **Effective Learning**
   - Watch videos without distractions
   - Pay attention to checkpoint questions
   - Review incorrect answers
   - Take notes during videos

2. **Navigation**
   - Complete videos in order
   - Don't rush through checkpoints
   - Use the video list to track progress
   - Revisit difficult topics

---

## Keyboard Shortcuts

Currently not implemented, but planned for future versions:
- Space: Play/Pause video
- → : Skip forward 10 seconds
- ← : Skip backward 10 seconds
- F: Full screen
- Esc: Exit full screen

---

## FAQ

**Q: Can I skip checkpoints?**
A: No, checkpoints are designed to ensure learning. You must answer to continue.

**Q: What happens if I answer incorrectly?**
A: You'll see the correct answer, but can still continue. It's a learning tool, not a test.

**Q: Can I watch videos offline?**
A: Not currently. Videos are streamed from YouTube, requiring internet connection.

**Q: How do I change my password?**
A: Contact your admin to reset your password.

**Q: Can I enroll in multiple courses?**
A: Yes! Browse categories and select any course you're interested in.

**Q: Are certificates provided?**
A: Not in the current version, but this feature is planned.

---

## Support

For technical issues or questions:
- Contact your system administrator
- Report bugs to the development team
- Check for app updates regularly

---

## Version History

**Version 1.0.0**
- Initial release
- Admin dashboard with full CRUD operations
- User course browsing and video playback
- Interactive checkpoints
- Role-based access control
- JWT authentication

---

*Last Updated: November 6, 2025*
