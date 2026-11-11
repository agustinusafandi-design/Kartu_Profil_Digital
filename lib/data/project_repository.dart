import 'package:sqflite/sqflite.dart';
import '../models/project.dart';
import 'db_helper.dart';

class ProjectRepository {
  Future<int> insert(Project project) async {
    final db = await DbHelper.initDb();
    return await db.insert(DbHelper.tableProjects, project.toMap());
  }

  Future<List<Project>> getAll() async {
    final db = await DbHelper.initDb();
    final maps = await db.query(
      DbHelper.tableProjects,
      orderBy: 'is_favorite DESC, created_at DESC', // Urutkan favorit paling atas
    );
    return maps.map((m) => Project.fromMap(m)).toList();
  }

  Future<int> update(Project project) async {
    final db = await DbHelper.initDb();
    return await db.update(
      DbHelper.tableProjects,
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DbHelper.initDb();
    return await db.delete(
      DbHelper.tableProjects,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}