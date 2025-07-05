import 'dart:io';
void main() {
reverseAndParidromeCheck();
List<String> names = ['Uyisenga', 'Aristide', 'Bosco', 'Ganza', 'Manzi'];
List<String> uniqueNames = getUniqueValues(names);
print("Unique Names: $uniqueNames");

}

// 1. Reversing a word and Telling if it is parindrome
reverseAndParidromeCheck(){
  stdout.write("Please give a word: ");
  String input = stdin.readLineSync()!.toLowerCase();
  String revInput = input.split('').reversed.join('');

  input == revInput
      ? print("The word is palindrome")
      : print("The word is not a palindrome");
}

// 2.Filtering a List for Unique Values, function with Argument
List<T> getUniqueValues<T>(List<T> inputList) {
  return inputList.toSet().toList();
}
