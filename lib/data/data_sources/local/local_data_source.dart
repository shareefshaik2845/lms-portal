import 'package:shared_preferences/shared_preferences.dart';


class LocalDataSource {
  static const String _cachedUsersKey = 'cached_users';
  static const String _cachedCoursesKey = 'cached_courses';
  static const String _cachedCategoriesKey = 'cached_categories';

  Future<void> cacheUsers(String usersJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedUsersKey, usersJson);
  }

  Future<String?> getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedUsersKey);
  }

  Future<void> cacheCourses(String coursesJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedCoursesKey, coursesJson);
  }

  Future<String?> getCachedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedCoursesKey);
  }

  Future<void> cacheCategories(String categoriesJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedCategoriesKey, categoriesJson);
  }

  Future<String?> getCachedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedCategoriesKey);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}