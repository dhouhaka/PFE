import '../models/note_model.dart';
import 'api_service.dart';

// ─── NoteService ────────────────────────────────────────────────────────────────
class NoteService {
  NoteService._();
  static final NoteService instance = NoteService._();

  // Get student notes
  Future<List<NoteModel>> getStudentNotes(String studentId) async {
    return ApiService.instance.getList(
      '/notes/student/$studentId',
      NoteModel.fromJson,
    );
  }

  // Get all notes (teacher)
  Future<List<NoteModel>> getAllNotes() async {
    return ApiService.instance.getList(
      '/notes',
      NoteModel.fromJson,
    );
  }

  // Create/update note
  Future<NoteModel> saveNote(Map<String, dynamic> data) async {
    return ApiService.instance.post(
      '/notes',
      data,
      NoteModel.fromJson,
    );
  }

  // Delete note
  Future<void> deleteNote(String id) async {
    await ApiService.instance.delete('/notes/$id');
  }
}

