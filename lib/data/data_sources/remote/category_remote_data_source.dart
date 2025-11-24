import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    final response = await _apiClient.get(
      ApiConstants.categories,
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final categories = data.map((json) => CategoryModel.fromJson(json)).toList();
      return ApiResponse.success(categories);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch categories');
  }

  Future<ApiResponse<CategoryModel>> getCategoryById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.categories}$id',
      requiresAuth: true,  // ✅ Changed to true - requires token
    );

    if (response.success) {
      return ApiResponse.success(CategoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch category');
  }

  Future<ApiResponse<CategoryModel>> createCategory(CategoryModel category) async {
    final response = await _apiClient.post(
      ApiConstants.categories,
      body: category.toJson(),
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      return ApiResponse.success(CategoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create category');
  }

  Future<ApiResponse<CategoryModel>> updateCategory(int id, CategoryModel category) async {
    final response = await _apiClient.put(
      '${ApiConstants.categories}$id',
      body: category.toJson(),
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      return ApiResponse.success(CategoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update category');
  }

  Future<ApiResponse<bool>> deleteCategory(int id) async {
    return await _apiClient.delete(
      '${ApiConstants.categories}$id',
      requiresAuth: true,  // ✅ Already true
    );
  }
}