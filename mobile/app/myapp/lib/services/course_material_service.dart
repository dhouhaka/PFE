import '../models/course_material_model.dart';
import 'api_service.dart';

// ─── CourseMaterialService ─────────────────────────────────────────────────────
class CourseMaterialService {
  CourseMaterialService._();
  static final CourseMaterialService instance = CourseMaterialService._();

  // Upload material for cours
  Future<void> uploadMaterial(String coursId, Map<String, dynamic> data) async {
    await ApiService.instance.post(
      '/course-materials/upload/$coursId',
      data,
      (json) => json,
    );
  }

  // Get materials for cours
  Future<List<CourseMaterialModel>> getCoursMaterials(String coursId) async {
    return ApiService.instance.getList(
      '/course-materials/course/$coursId',
      CourseMaterialModel.fromJson,
    );
  }

  // Get material by ID
  Future<CourseMaterialModel> getMaterialById(String id) async {
    return ApiService.instance.get(
      '/course-materials/getMaterial/$id',
      CourseMaterialModel.fromJson,
    );
  }

  // Delete material
  Future<void> deleteMaterial(String id) async {
    await ApiService.instance.delete('/course-materials/deleteMaterial/$id');
  }
}

