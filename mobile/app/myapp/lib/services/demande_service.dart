import '../models/demande_model.dart';
import 'api_service.dart';

class DemandeService {
  DemandeService._();

  static final DemandeService instance =
      DemandeService._();

  Future<DemandeModel> createDemande(
    Map<String, dynamic> data,
  ) {
    final Map<String, dynamic> payload =
        <String, dynamic>{
      'nom': (
        data['nom'] ??
        data['titre'] ??
        ''
      ).toString().trim(),
      'type': (
        data['type'] ??
        ''
      ).toString().trim(),
      'description': (
        data['description'] ??
        ''
      ).toString().trim(),
      if (
        (
          data['etudiant'] ??
          data['etudiantId']
        ) != null
      )
        'etudiant':
            data['etudiant'] ??
            data['etudiantId'],
    };

    return ApiService.instance.post(
      '/demande/create',
      payload,
      DemandeModel.fromJson,
    );
  }

  Future<List<DemandeModel>>
      getAllDemandes() {
    return ApiService.instance.getList(
      '/demande/getAll',
      DemandeModel.fromJson,
    );
  }

  Future<DemandeModel> getDemandeById(
    String id,
  ) {
    return ApiService.instance.get(
      '/demande/getById/$id',
      DemandeModel.fromJson,
    );
  }

  Future<List<DemandeModel>> getMyDemandes(
    String userId,
  ) {
    final String id = userId.trim();

    if (id.isEmpty) {
      throw Exception('Student ID is missing');
    }

    return ApiService.instance.getList(
      '/demande/user/$id',
      DemandeModel.fromJson,
    );
  }

  Future<DemandeModel> updateDemande(
    String id,
    Map<String, dynamic> data,
  ) {
    return ApiService.instance.put(
      '/demande/update/$id',
      data,
      DemandeModel.fromJson,
    );
  }

  Future<void> deleteDemande(
    String id,
  ) async {
    await ApiService.instance.delete(
      '/demande/delete/$id',
    );
  }
}
