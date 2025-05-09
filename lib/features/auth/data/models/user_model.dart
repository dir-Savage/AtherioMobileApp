import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required List<String> list1,
    required List<String> list2,
    required DateTime createdAt,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    list1: list1,
    list2: list2,
    createdAt: createdAt,
  );

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      list1: List<String>.from(data['list1'] ?? []),
      list2: List<String>.from(data['list2'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'list1': list1,
      'list2': list2,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}