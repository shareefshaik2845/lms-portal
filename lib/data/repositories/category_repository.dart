import '../../core/network/api_response.dart';
import '../data_sources/remote/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository(this._remoteDataSource);

  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    return await _remoteDataSource.getCategories();
  }

  Future<ApiResponse<CategoryModel>> getCategoryById(int id) async {
    return await _remoteDataSource.getCategoryById(id);
  }

  Future<ApiResponse<CategoryModel>> createCategory(CategoryModel category) async {
    return await _remoteDataSource.createCategory(category);
  }

  Future<ApiResponse<CategoryModel>> updateCategory(int id, CategoryModel category) async {
    return await _remoteDataSource.updateCategory(id, category);
  }

  Future<ApiResponse<bool>> deleteCategory(int id) async {
    return await _remoteDataSource.deleteCategory(id);
  }
}