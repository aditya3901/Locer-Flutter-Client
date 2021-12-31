import 'package:locer/utils/models/cart_item_model.dart';
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
    CREATE TABLE $tableWishlist (
      ${ProductFields.id} $idType,
      ${ProductFields.title} $textType,
      ${ProductFields.description} $textType,
      ${ProductFields.price} $priceType,
      ${ProductFields.imageUrl} $textType,
      ${ProductFields.isFavourite} $boolType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableCart (
      ${CartFields.id} $idType,
      ${CartFields.title} $textType,
      ${CartFields.price} $priceType,
      ${CartFields.imageUrl} $textType,
      ${CartFields.count} $priceType
    )
    ''');
  }

  Future create(ChildModel item) async {
    final db = await instance.database;
    await db.insert(tableWishlist, item.toJson());
  }

  Future createCart(CartItem item) async {
    final db = await instance.database;
    await db.insert(tableCart, item.toJson());
  }

  Future<List<ChildModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(tableWishlist);

    if (result.isNotEmpty) {
      return result.map((json) => ChildModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<CartItem>> readAllCartItems() async {
    final db = await instance.database;
    final result = await db.query(tableCart);

    if (result.isNotEmpty) {
      return result.map((json) => CartItem.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<ChildModel?> readProduct(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWishlist,
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

  Future<CartItem?> readCart(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCart,
      columns: CartFields.values,
      where: '${CartFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CartItem.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future delete(String id) async {
    final db = await instance.database;
    await db.delete(
      tableWishlist,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future deleteCartItem(String id) async {
    final db = await instance.database;
    await db.delete(
      tableCart,
      where: '${CartFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future clearWishlistTable() async {
    final db = await instance.database;
    await db.execute("DELETE FROM $tableWishlist");
  }

  Future clearCartTable() async {
    final db = await instance.database;
    await db.execute("DELETE FROM $tableCart");
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
