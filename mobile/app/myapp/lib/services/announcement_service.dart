import '../models/announcement_model.dart';
import 'api_service.dart';

// ─── AnnouncementService ────────────────────────────────────────────────────────
class AnnouncementService {
  AnnouncementService._();
  static final AnnouncementService instance = AnnouncementService._();

  // Get all announcements
  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    return ApiService.instance.getList(
      '/announcements',
      AnnouncementModel.fromJson,
    );
  }

  // Get user announcements
  Future<List<AnnouncementModel>> getMyAnnouncements() async {
    return ApiService.instance.getList(
      '/announcements/my-announcements',
      AnnouncementModel.fromJson,
    );
  }

  // Get by ID
  Future<AnnouncementModel> getAnnouncementById(String id) async {
    return ApiService.instance.get(
      '/announcements/$id',
      AnnouncementModel.fromJson,
    );
  }

  // Create announcement (admin)
  Future<AnnouncementModel> createAnnouncement(Map<String, dynamic> data) async {
    return ApiService.instance.post(
      '/announcements',
      data,
      AnnouncementModel.fromJson,
    );
  }

  // Update
  Future<AnnouncementModel> updateAnnouncement(String id, Map<String, dynamic> data) async {
    return ApiService.instance.put(
      '/announcements/$id',
      data,
      AnnouncementModel.fromJson,
    );
  }

  // Delete
  Future<void> deleteAnnouncement(String id) async {
    await ApiService.instance.delete('/announcements/$id');
  }

  // Mark as viewed
  Future<void> markAsViewed(String id) async {
    await ApiService.instance.post('/announcements/$id/view', {}, (json) => json);
  }

  // Toggle pin
  Future<void> togglePin(String id) async {
    await ApiService.instance.delete('/announcements/$id/toggle-pin');
  }
}

