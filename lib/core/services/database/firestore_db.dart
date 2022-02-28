import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_x/core/exceptions/network_exceptions.dart';
import 'package:finance_x/core/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import '../../api/api_result.dart';

enum DBResultStatus { success, failure }

class DBService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DBResultStatus _status;

  Future<DBResultStatus> uploadUserCredentials(User user) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set(user.toJson());
      _status = DBResultStatus.success;
    } catch (e) {
      _status = DBResultStatus.failure;
    }
    return _status;
  }

  Future<DBResultStatus> updateUserCredentials(
      {required String fieldName, required dynamic fieldValue}) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({fieldName: fieldValue});
    } catch (e) {
      _status = DBResultStatus.failure;
    }
    return _status;
  }

  //ADD EXPENSES OR DEBTS
  Future<DBResultStatus> addTransaction({
    required String fieldName,
    required dynamic fieldValue,
  }) async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        fieldName: FieldValue.arrayUnion([fieldValue])
      });
      _status = DBResultStatus.success;
    } catch (e) {
      _status = DBResultStatus.failure;
    }
    return _status;
  }

  Future<DBResultStatus> deleteUserCredentials() async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).delete();
      _status = DBResultStatus.success;
    } catch (e) {
      _status = DBResultStatus.failure;
    }
    return _status;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserCredentialsStream() {
    final snapshots = FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .snapshots();
    return snapshots;
  }

  Future<ApiResult<User>> getUserCredentials() async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
     
      return ApiResult.success(
          data: User.fromJson(snapshot.data() as Map<String, dynamic>));
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Operation failed'));
    }
  }
}
