import '../models/cours_model.dart';
import 'api_service.dart';

// ─── CoursService ───────────────────────────────────────────────────────────────
class CoursService {
  CoursService._();
  static final CoursService instance = CoursService._();

  // Get all cours
  Future<List<CoursModel>> getAllCours() async {
    return ApiService.instance.getList(
      '/cours/getAllCours',
      CoursModel.fromJson,
    );
  }

  // Get cours by ID
  Future<CoursModel> getCoursById(String id) async {
    return ApiService.instance.get(
      '/cours/getCoursById/$id',
      CoursModel.fromJson,
    );
  }

  // Create cours
  Future<CoursModel> createCours(Map<String, dynamic> data) async {
    return ApiService.instance.post(
      '/cours/createCours',
      data,
      CoursModel.fromJson,
    );
  }

  // Update cours
  Future<CoursModel> updateCours(String id, Map<String, dynamic> data) async {
    return ApiService.instance.put(
      '/cours/updateCours/$id',
      data,
      CoursModel.fromJson,
    );
  }

  // Delete cours
  Future<void> deleteCours(String id) async {
    await ApiService.instance.delete('/cours/deleteCours/$id');
  }
}

