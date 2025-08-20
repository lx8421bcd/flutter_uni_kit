import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/common/datetime_functions.dart';

FormFieldValidator combineValidator({
  List<String? Function(dynamic value)> validators = const []
}) {
  return (value) {
    for (var validator in validators) {
      var result = validator.call(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  };
}

FormFieldValidator nonEmptyValidator() {
  return (dynamic value) {
    if (value == null) {
      return "Please enter";
    }
    if (value is String && value.isEmpty) {
      return "Please enter";
    }
    return null;
  };
}

FormFieldValidator ageValidator(int adultAge) {
  return (dynamic value) {
    if (value != null && !isAdult(birthDate: value, adultAge: adultAge)) {
      return "Input age does not meet the product requirements";
    }
    return null;
  };
}