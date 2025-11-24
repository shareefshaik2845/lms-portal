import '../data_sources/remote/enrollment_remote_data_source.dart';
import '../models/enrollment_model.dart';
import '../../core/network/api_response.dart';

class EnrollmentRepository {
  final EnrollmentRemoteDataSource _remoteDataSource;

  EnrollmentRepository(this._remoteDataSource);

  Future<ApiResponse<List<EnrollmentModel>>> getAllEnrollments() {
    return _remoteDataSource.getAllEnrollments();
  }

  Future<ApiResponse<EnrollmentModel>> createEnrollment({
    required int userId,
    required int courseId,
  }) {
    return _remoteDataSource.createEnrollment(
      userId: userId,
      courseId: courseId,
    );
  }

  Future<ApiResponse<List<EnrollmentModel>>> getUserEnrollments(int userId) {
    return _remoteDataSource.getUserEnrollments(userId);
  }

  Future<ApiResponse<List<EnrollmentModel>>> getCourseEnrollments(int courseId) {
    return _remoteDataSource.getCourseEnrollments(courseId);
  }

  Future<ApiResponse<bool>> deleteEnrollment(int id) {
    return _remoteDataSource.deleteEnrollment(id);
  }
}
