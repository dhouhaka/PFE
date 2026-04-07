import '../models/demande_model.dart';
import 'api_service.dart';

// ─── DemandeService ─────────────────────────────────────────────────────────────
class DemandeService {
  DemandeService._();
  static final DemandeService instance = DemandeService._();

  // Create demande
  Future<DemandeModel> createDemande(Map<String, dynamic> data) async {
    return ApiService.instance.post(
      '/demandes/create',
      data,
      DemandeModel.fromJson,
    );
  }

  // Get all demandes (admin/teacher)
  Future<List<DemandeModel>> getAllDemandes() async {
    return ApiService.instance.getList(
      '/demandes/getAll',
      DemandeModel.fromJson,
    );
  }

  // Get by ID
  Future<DemandeModel> getDemandeById(String id) async {
    return ApiService.instance.get(
      '/demandes/getById/$id',
      DemandeModel.fromJson,
    );
  }

  // Get user demandes
  Future<List<DemandeModel>> getMyDemandes() async {
    return ApiService.instance.getList(
      '/demandes/user',
      DemandeModel.fromJson,
    );
  }

  // Update demande
  Future<DemandeModel> updateDemande(String id, Map<String, dynamic> data) async {
    return ApiService.instance.put(
      '/demandes/update/$id',
      data,
      DemandeModel.fromJson,
    );
  }

  // Delete demande
  Future<void> deleteDemande(String id) async {
    await ApiService.instance.delete('/demandes/delete/$id');
  }
}

