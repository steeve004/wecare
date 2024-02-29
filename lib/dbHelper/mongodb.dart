import 'package: mongo_dart/mongo_dart.dart';
import 'package: yt_upload/dbHelper/constant.dart';
import 'package:wecare/screens/signup.dart';

class MongoDatabase {
static var db, userCollection;
static connect() async {
  db = await Db. create(MONGO_CONN_URL);
  await db.open();
  userCollection = db.collection (signUp(fullname, email, password))
  
  }
}