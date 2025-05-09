class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role is required';
    }
    if (!['doctor', 'patient'].contains(value.toLowerCase())) {
      return 'Role must be either Doctor or Patient';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}