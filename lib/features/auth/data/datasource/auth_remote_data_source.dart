import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register(String firstName, String lastName, String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String newPassword);
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> register(String firstName, String lastName, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = firestore.collection('users').doc(userCredential.user?.uid);
      final timestamp = DateTime.now();

      final userModel = UserModel(
        id: userDoc.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        list1: [],
        list2: [],
        createdAt: timestamp,
      );

      await userDoc.set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }
      throw ServerException();
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await firestore.collection('users').doc(userCredential.user?.uid).get();

      if (!userDoc.exists) {
        throw UserNotLoggedInException();
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw InvalidEmailAndPasswordCombinationException();
      }
      throw ServerException();
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    try {
      await firebaseAuth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw UserNotLoggedInException();
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw UserNotLoggedInException();
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw ServerException();
    }
  }
}