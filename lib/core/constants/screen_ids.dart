class ScreenIds {
  // Private constructor to prevent instantiation
  ScreenIds._();

  // Admin Screens
  static const int adminDashboard = 1;
  static const int categoryManagement = 2;
  static const int courseManagement = 3;
  static const int videoManagement = 4;
  static const int userManagement = 5;
  static const int checkpointManagement = 6;

  // User Screens
  static const int userDashboard = 100;
  static const int courseList = 101;
  static const int videoPlayer = 102;

  // Helper method to get screen name for logging
  static String getScreenName(int screenId) {
    switch (screenId) {
      case adminDashboard:
        return 'Admin Dashboard';
      case categoryManagement:
        return 'Category Management';
      case courseManagement:
        return 'Course Management';
      case videoManagement:
        return 'Video Management';
      case userManagement:
        return 'User Management';
      case checkpointManagement:
        return 'Checkpoint Management';
      case userDashboard:
        return 'User Dashboard';
      case courseList:
        return 'Course List';
      case videoPlayer:
        return 'Video Player';
      default:
        return 'Unknown Screen';
    }
  }
}