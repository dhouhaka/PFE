import '../models/seance_model.dart';
import 'api_service.dart';

// ─── SeanceService ──────────────────────────────────────────────────────────────
class SeanceService {
  SeanceService._();
  static final SeanceService instance = SeanceService._();

  // Create seance
  Future<void> createSeance(Map<String, dynamic> data) async {
    await ApiService.instance.post(
      '/seances',
      data,
      (json) => json,
    );
  }

  // Get seances for cours
  Future<List<SeanceModel>> getCoursSeances(String coursId) async {
    return ApiService.instance.getList(
      '/seances/cours/$coursId',
      SeanceModel.fromJson,
    );
  }

  // Get upcoming seances
  Future<List<SeanceModel>> getUpcomingSeances() async {
    return ApiService.instance.getList(
      '/seances/upcoming',
      SeanceModel.fromJson,
    );
  }

  // Update seance
  Future<void> updateSeance(String id, Map<String, dynamic> data) async {
    await ApiService.instance.put(
      '/seances/$id',
      data,
      (json) => json,
    );
  }
}

