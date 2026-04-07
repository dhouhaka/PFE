import '../models/presence_model.dart';
import 'api_service.dart';

// ─── PresenceService ────────────────────────────────────────────────────────────
class PresenceService {
  PresenceService._();
  static final PresenceService instance = PresenceService._();

  // Mark presence for student/seance
  Future<PresenceModel> markPresence(String seanceId, String etudiantId, bool presente) async {
    return ApiService.instance.post(
      '/presences',
      {'seance': seanceId, 'etudiant': etudiantId, 'presente': presente},
      PresenceModel.fromJson,
    );
  }

  // Get student presences
  Future<List<PresenceModel>> getStudentPresences(String studentId) async {
    return ApiService.instance.getList(
      '/presences/student/$studentId',
      PresenceModel.fromJson,
    );
  }

  // Get seance presences
  Future<List<PresenceModel>> getSeancePresences(String seanceId) async {
    return ApiService.instance.getList(
      '/presences/seance/$seanceId',
      PresenceModel.fromJson,
    );
  }
}

