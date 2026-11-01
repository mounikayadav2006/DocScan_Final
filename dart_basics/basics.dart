// EXPERIMENT 1b - Dart Language Basics
// Run with:  dart run dart_basics/basics.dart
void main() {
  String topic = "Dart Basics";
  int year = 2026;
  print("Welcome to $topic ($year)");
  if (year >= 2026) {
    print("Modern Dart with Null Safety.");
  }
  List<String> fruits = ["Apple", "Banana", "Orange"];
  for (var fruit in fruits) {
    print("Fruit: $fruit");
  }
  print("Sum: ${addNumbers(10, 20)}");
}

int addNumbers(int a, int b) {
  return a + b;
}
