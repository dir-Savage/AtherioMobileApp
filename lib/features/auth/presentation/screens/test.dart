// import 'package:atherio/features/auth/domain/entities/user_entity.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:flutter/material.dart';

// import '../../../prediction/presentation/screens/patient_details.dart';
// import 'login_page.dart';

// class HomePage extends StatelessWidget {
//   final User user;

//   const HomePage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Doctor Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await fb.FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome, Dr. ${user.firstName} ${user.lastName}',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 16),
//             Text('Email: ${user.email}'),
//             Text('Doctor ID: ${user.id}'),
//             Text('Created At: ${user.createdAt.toString()}'),
//             Text('Patient Cases: ${user.list1.isEmpty ? 'No cases' : user.list1.join(', ')}'),
//             Text('List 2: ${user.list2.isEmpty ? 'Empty' : user.list2.join(', ')}'),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PatientDetailsPage(doctorId: user.id),
//                 ),
//               ),
//               child: const Text('Add New Patient Case'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
