import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('\n=== Dart Practice Console App ===');
    print('1️⃣  Simple Calculator');
    print('2️⃣  Personal Profile');
    print('3️⃣  Bank Cash Calculator');
    print('4️⃣  Exit');
    stdout.write('Choose an option (1-4): ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        calculator();
        break;
      case '2':
        profile();
        break;
      case '3':
        bankCashCalculator();
        break;
      case '4':
        print('Exiting... Bye 👋');
        return;
      default:
        print('Invalid choice! Please enter 1-4.');
    }
  }
}

/// 🧮 Simple Calculator
void calculator() {
  print('\n=== Simple Calculator ===');

  stdout.write('Enter first number: ');
  double num1 = double.parse(stdin.readLineSync()!);

  stdout.write('Enter second number: ');
  double num2 = double.parse(stdin.readLineSync()!);

  stdout.write('Enter operator (+, -, *, /): ');
  String op = stdin.readLineSync()!;

  double result;

  switch (op) {
    case '+':
      result = num1 + num2;
      break;
    case '-':
      result = num1 - num2;
      break;
    case '*':
      result = num1 * num2;
      break;
    case '/':
      if (num2 == 0) {
        print('Error: Cannot divide by zero!');
        return;
      }
      result = num1 / num2;
      break;
    default:
      print('Invalid operator!');
      return;
  }

  print('Result: $num1 $op $num2 = $result');
}

/// 👤 Personal Profile
void profile() {
  print('\n=== Personal Profile ===');

  stdout.write('Enter your name: ');
  String name = stdin.readLineSync()!;

  stdout.write('Enter your age: ');
  int age = int.parse(stdin.readLineSync()!);

  stdout.write('Enter your city: ');
  String city = stdin.readLineSync()!;

  print('\n--- Profile Info ---');
  print('Name: $name');
  print('Age: $age');
  print('City: $city');
  print('Welcome, $name from $city!');
}

/// 🏦 Bank Cash Calculator (Compound Interest)
void bankCashCalculator() {
  print('\n=== Bank Cash Calculator ===');

  stdout.write('Enter principal amount: ');
  double principal = double.parse(stdin.readLineSync()!);

  stdout.write('Enter annual interest rate (%): ');
  double rate = double.parse(stdin.readLineSync()!);

  stdout.write('Enter number of years: ');
  int years = int.parse(stdin.readLineSync()!);

  double amount = principal * pow((1 + rate / 100), years);
  double profit = amount - principal;

  print('\n--- Result ---');
  print('Principal: \$${principal.toStringAsFixed(2)}');
  print('Rate: $rate%');
  print('Years: $years');
  print('Total Amount: \$${amount.toStringAsFixed(2)}');
  print('Profit: \$${profit.toStringAsFixed(2)}');
}
