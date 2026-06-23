import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  
  static String loggedInUser = 'Current User'; 
  static String loggedInEmail = ''; 
  static String loggedInProfilePicture = ''; 
  static String loggedInDob = ''; 
  static String loggedInCountry = '';
  static String loggedInRole = 'farmer'; // Track the role of the logged in user

  static Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInUser', loggedInUser);
    await prefs.setString('loggedInEmail', loggedInEmail);
    await prefs.setString('loggedInRole', loggedInRole);
    await prefs.setString('loggedInProfilePicture', loggedInProfilePicture);
    await prefs.setString('loggedInDob', loggedInDob);
    await prefs.setString('loggedInCountry', loggedInCountry);
  }

  static Future<bool> loadLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      loggedInUser = prefs.getString('loggedInUser') ?? 'Current User';
      loggedInEmail = prefs.getString('loggedInEmail') ?? '';
      loggedInRole = prefs.getString('loggedInRole') ?? 'farmer';
      loggedInProfilePicture = prefs.getString('loggedInProfilePicture') ?? '';
      loggedInDob = prefs.getString('loggedInDob') ?? '';
      loggedInCountry = prefs.getString('loggedInCountry') ?? '';
      return true;
    }
    return false;
  }

  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loggedInUser = 'Current User';
    loggedInEmail = '';
    loggedInRole = 'farmer';
    loggedInProfilePicture = '';
    loggedInDob = '';
    loggedInCountry = '';
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = 'cultivest_app.db';
    if (!kIsWeb) {
      path = join(await getDatabasesPath(), 'cultivest_app.db');
    }
    return await openDatabase(
      path,
      version: 12,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        password TEXT,
        role TEXT,
        profile_picture TEXT,
        dob TEXT,
        country TEXT,
        UNIQUE(email, role)
      )
    ''');
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        name TEXT,
        description TEXT,
        price REAL,
        quantity INTEGER,
        location TEXT,
        isDeliveryAvailable INTEGER,
        image_data TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communityName TEXT,
        userName TEXT,
        location TEXT,
        content TEXT,
        likes INTEGER DEFAULT 0,
        comments INTEGER DEFAULT 0,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE comments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        userName TEXT,
        content TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE joined_communities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communityName TEXT,
        role TEXT,
        UNIQUE(communityName, role)
      )
    ''');
    await db.execute('''
      CREATE TABLE learning_content(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        description TEXT,
        contentType TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        buyerName TEXT,
        productName TEXT,
        quantity TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 12) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS products');
      await db.execute('DROP TABLE IF EXISTS posts');
      await db.execute('DROP TABLE IF EXISTS comments');
      await db.execute('DROP TABLE IF EXISTS joined_communities');
      await db.execute('DROP TABLE IF EXISTS learning_content');
      await db.execute('DROP TABLE IF EXISTS orders');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      Database db = await database;
      return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertUser: $e");
      return -1;
    }
  }

  Future<int> updateUser(Map<String, dynamic> user, String email, String role) async {
    try {
      Database db = await database;
      return await db.update(
        'users',
        user,
        where: 'email = ? AND role = ?',
        whereArgs: [email, role],
      );
    } catch (e) {
      debugPrint("DatabaseHelper error updateUser: $e");
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getUser(String email, String password, String role) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? AND password = ? AND role = ?',
        whereArgs: [email, password, role],
      );
      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      debugPrint("DatabaseHelper error getUser: $e");
      return null;
    }
  }

  Future<bool> emailExistsForRole(String email, String role) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? AND role = ?',
        whereArgs: [email, role],
      );
      return results.isNotEmpty;
    } catch (e) {
      debugPrint("DatabaseHelper error emailExistsForRole: $e");
      return false;
    }
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    try {
      Database db = await database;
      return await db.insert('products', product, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertProduct: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      Database db = await database;
      return await db.query('products');
    } catch (e) {
      debugPrint("DatabaseHelper error getAllProducts: $e");
      return [];
    }
  }

  Future<int> deleteProduct(int id) async {
    try {
      Database db = await database;
      return await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("DatabaseHelper error deleteProduct: $e");
      return -1;
    }
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    try {
      Database db = await database;
      return await db.insert('orders', order, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertOrder: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      Database db = await database;
      return await db.query('orders', orderBy: 'timestamp DESC');
    } catch (e) {
      debugPrint("DatabaseHelper error getAllOrders: $e");
      return [];
    }
  }

  Future<int> insertPost(Map<String, dynamic> post) async {
    try {
      Database db = await database;
      return await db.insert('posts', post, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertPost: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    try {
      Database db = await database;
      return await db.query('posts', orderBy: 'timestamp DESC');
    } catch (e) {
      debugPrint("DatabaseHelper error getAllPosts: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPostsForCommunity(String communityName) async {
    try {
      Database db = await database;
      return await db.query('posts', where: 'communityName = ?', whereArgs: [communityName], orderBy: 'timestamp DESC');
    } catch (e) {
      debugPrint("DatabaseHelper error getPostsForCommunity: $e");
      return [];
    }
  }

  Future<int> insertComment(Map<String, dynamic> comment) async {
    try {
      Database db = await database;
      // Update the post's comment count
      await db.rawUpdate(
        'UPDATE posts SET comments = comments + 1 WHERE id = ?',
        [comment['postId']]
      );
      return await db.insert('comments', comment, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertComment: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsForPost(int postId) async {
    try {
      Database db = await database;
      return await db.query('comments', where: 'postId = ?', whereArgs: [postId], orderBy: 'timestamp ASC');
    } catch (e) {
      debugPrint("DatabaseHelper error getCommentsForPost: $e");
      return [];
    }
  }

  Future<int> joinCommunity(String communityName) async {
    try {
      Database db = await database;
      return await db.insert('joined_communities', {
        'communityName': communityName,
        'role': loggedInRole,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      debugPrint("DatabaseHelper error joinCommunity: $e");
      return -1;
    }
  }

  Future<int> leaveCommunity(String communityName) async {
    try {
      Database db = await database;
      return await db.delete('joined_communities', 
        where: 'communityName = ? AND role = ?', 
        whereArgs: [communityName, loggedInRole]);
    } catch (e) {
      debugPrint("DatabaseHelper error leaveCommunity: $e");
      return -1;
    }
  }

  Future<List<String>> getJoinedCommunities() async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('joined_communities', 
        where: 'role = ?', 
        whereArgs: [loggedInRole]);
      return List.generate(maps.length, (i) {
        return maps[i]['communityName'] as String;
      });
    } catch (e) {
      debugPrint("DatabaseHelper error getJoinedCommunities: $e");
      return [];
    }
  }

  Future<int> insertLearningContent(Map<String, dynamic> content) async {
    try {
      Database db = await database;
      return await db.insert('learning_content', content, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("DatabaseHelper error insertLearningContent: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllLearningContent() async {
    try {
      Database db = await database;
      return await db.query('learning_content', orderBy: 'timestamp DESC');
    } catch (e) {
      debugPrint("DatabaseHelper error getAllLearningContent: $e");
      return [];
    }
  }
}

