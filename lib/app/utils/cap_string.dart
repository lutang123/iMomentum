extension CapExtension on String {
  String get firstCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
}

//Usage:
//
//final helloWorld = 'hello world'.firstCaps; // 'Hello world'
//final helloWorld = 'hello world'.allInCaps; // 'HELLO WORLD'

//extension StringExtension on String {
//    String capitalize() {
//      return "${this[0].toUpperCase()}${this.substring(1)}";
//    }
//}

//return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
