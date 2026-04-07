import '../models/classe_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';

// ─── ClasseService ──────────────────────────────────────────────────────────────
// Matches backend classeRoutes.js

class ClasseService {
  ClasseService._();
  static final ClasseService instance = ClasseService._();

  // Get all classes
  Future<List<ClasseModel>> getAllClasses() async {
    return ApiService.instance.getList(
      '/classe/getAllClasses',
      ClasseModel.fromJson,
    );
  }

  // Get classe by ID
  Future<ClasseModel> getClasseById(String id) async {
    return ApiService.instance.get(
      '/classe/getClasseById/$id',
      ClasseModel.fromJson,
    );
  }

  // Create classe
  Future<ClasseModel> createClasse(Map<String, dynamic> data) async {
    return ApiService.instance.post(
      '/classe/createClasse',
      data,
      ClasseModel.fromJson,
    );
  }

  // Update classe
  Future<ClasseModel> updateClasse(String id, Map<String, dynamic> data) async {
    return ApiService.instance.put(
      '/classe/updateClasse/$id',
      data,
      ClasseModel.fromJson,
    );
  }

  // Delete classe
  Future<void> deleteClasse(String id) async {
    await ApiService.instance.delete('/classe/deleteClasse/$id');
  }

  // Get classe students (admin/teacher)
  Future<List<UserModel>> getClasseStudents(String classeId) async {
    return ApiService.instance.getList(
      '/classe/getClasseStudents/$classeId',
      UserModel.fromJson,
    );
  }

  // Get classe teachers
  Future<List<UserModel>> getClasseTeachers(String classeId) async {
    return ApiService.instance.getList(
      '/classe/getClasseTeachers/$classeId',
      UserModel.fromJson,
    );
  }

  // Get classe courses
  Future<List<dynamic>> getClasseCourses(String classeId) async {
    return ApiService.instance.getList(
      '/classe/getClasseCourses/$classeId',
      (json) => json, // Raw for now
    );
  }
}

