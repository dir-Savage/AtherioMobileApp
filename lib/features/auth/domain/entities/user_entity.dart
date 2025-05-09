class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final List<String> list1;
  final List<String> list2;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.list1,
    required this.list2,
    required this.createdAt,
  });
}