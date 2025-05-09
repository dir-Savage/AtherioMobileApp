import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : NameValidationError.invalid;
  }
}

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    return EmailValidator.validate(value ?? '')
        ? null
        : EmailValidationError.invalid;
  }
}

enum AgeValidationError { invalid }

class Age extends FormzInput<String, AgeValidationError> {
  const Age.pure() : super.pure('');
  const Age.dirty([String value = '']) : super.dirty(value);

  @override
  AgeValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return AgeValidationError.invalid;
    final age = int.tryParse(value);
    if (age == null || age <= 0 || age > 150) return AgeValidationError.invalid;
    return null;
  }
}

enum NationalNumberValidationError { invalid }

class NationalNumber extends FormzInput<String, NationalNumberValidationError> {
  const NationalNumber.pure() : super.pure('');
  const NationalNumber.dirty([String value = '']) : super.dirty(value);

  @override
  NationalNumberValidationError? validator(String? value) {
    return value?.isNotEmpty == true && value!.length >= 8
        ? null
        : NationalNumberValidationError.invalid;
  }
}

enum WeightValidationError { invalid }

class Weight extends FormzInput<String, WeightValidationError> {
  const Weight.pure() : super.pure('');
  const Weight.dirty([String value = '']) : super.dirty(value);

  @override
  WeightValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return WeightValidationError.invalid;
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0 || weight > 300) {
      return WeightValidationError.invalid;
    }
    return null;
  }
}

enum HeightValidationError { invalid }

class Height extends FormzInput<String, HeightValidationError> {
  const Height.pure() : super.pure('');
  const Height.dirty([String value = '']) : super.dirty(value);

  @override
  HeightValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return HeightValidationError.invalid;
    final height = double.tryParse(value);
    if (height == null || height <= 0 || height > 250) {
      return HeightValidationError.invalid;
    }
    return null;
  }
}