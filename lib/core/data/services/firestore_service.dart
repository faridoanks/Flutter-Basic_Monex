import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final result = await _firestore.collection(collection).add(data);

    return result.id;
  }

  Future<DocumentSnapshot> readOneData({
    required String collection,
    required String documentId,
  }) async {
    final result = await _firestore
        .collection(collection)
        .doc(documentId)
        .get();

    return result;
  }

  Future<QuerySnapshot> readAllData({required String collection}) async {
    final result = await _firestore.collection(collection).get();

    return result;
  }

  Future<void> updateData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<void> deleteData({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }
}
