import '../../core/network/api_response.dart';
import '../data_sources/remote/course_remote_data_source.dart';
import '../models/course_model.dart';

class CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  CourseRepository(this._remoteDataSource);

  Future<ApiResponse<List<CourseModel>>> getCourses() async {
    return await _remoteDataSource.getCourses();
  }

  Future<ApiResponse<CourseModel>> getCourseById(int id) async {
    return await _remoteDataSource.getCourseById(id);
  }

  Future<ApiResponse<CourseModel>> createCourse(CourseModel course) async {
    return await _remoteDataSource.createCourse(course);
  }

  Future<ApiResponse<CourseModel>> updateCourse(int id, CourseModel course) async {
    return await _remoteDataSource.updateCourse(id, course);
  }

  Future<ApiResponse<bool>> deleteCourse(int id) async {
    return await _remoteDataSource.deleteCourse(id);
  }
}