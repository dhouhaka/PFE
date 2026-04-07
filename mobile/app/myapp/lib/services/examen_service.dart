import '../models/examen_model.dart';
import 'api_service.dart';

// ─── ExamenService ──────────────────────────────────────────────────────────────
class ExamenService {
  ExamenService._();
  static final ExamenService instance = ExamenService._();

  // Create examen
  Future<void> createExamen(Map<String, dynamic> data) async {
    await ApiService.instance.post(
      '/examens/create',
      data,
      (json) => json,
    );
  }

  // Get all examens
  Future<List<dynamic>> getAllExamens() async {
    return ApiService.instance.getList(
      '/examens/getAll',
      (json) => json,
    );
  }

  // Get by ID
  Future<dynamic> getExamenById(String id) async {
    return ApiService.instance.get(
      '/examens/getById/$id',
      (json) => json,
    );
  }

  // Update examen
  Future<void> updateExamen(String id, Map<String, dynamic> data) async {
    await ApiService.instance.put(
      '/examens/update/$id',
      data,
      (json) => json,
    );
  }

  // Delete examen
  Future<void> deleteExamen(String id) async {
    await ApiService.instance.delete('/examens/delete/$id');
  }

  // Submit assignment
  Future<void> submitAssignment(String examenId, Map<String, dynamic> data) async {
    await ApiService.instance.post(
      '/examens/submitAssignment/$examenId',
      data,
      (json) => json,
    );
  }
}

