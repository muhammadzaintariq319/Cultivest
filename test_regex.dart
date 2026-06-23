void main() {
  String value = "Pass123!";
  bool hasUpper = value.contains(RegExp(r'[A-Z]'));
  bool hasNumber = value.contains(RegExp(r'[0-9]'));
  bool hasSpecial = value.contains(RegExp(r'[!@#\$&*~_+\-\=\^%]'));
  
  print("Upper: $hasUpper");
  print("Number: $hasNumber");
  print("Special: $hasSpecial");
}
