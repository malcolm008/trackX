extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return "${word[0].toUpperCase()}${word.substring(1)}";
    }).join(' ');
  }

  String toCamelCase() {
    if (isEmpty) return this;
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}