import 'package:locer/utils/models/child_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductsDatabase {
  static final ProductsDatabase instance = ProductsDatabase._init();

  static Database? _database;

  ProductsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "TEXT PRIMARY KEY";
    const priceType = "INTEGER";
    const textType = "TEXT";
    const boolType = "BOOLEAN";

    await db.execute('''
    CREATE TABLE $tableProducts (
      ${ProductFields.id} $idType,
      ${ProductFields.title} $textType,
      ${ProductFields.description} $textType,
      ${ProductFields.price} $priceType,
      ${ProductFields.imageUrl} $textType,
      ${ProductFields.isFavourite} $boolType
    )
    ''');
  }

  Future create(ChildModel item) async {
    final db = await instance.database;
    await db.insert(tableProducts, item.toJson());
  }

  Future<List<ChildModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    if (result.isNotEmpty) {
      return result.map((json) => ChildModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<ChildModel?> readProduct(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableProducts,
      columns: ProductFields.values,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ChildModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future delete(String id) async {
    final db = await instance.database;
    await db.delete(
      tableProducts,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
