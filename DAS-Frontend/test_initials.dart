void main() {
  String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    
    // First letter of first name + first letter of LAST word (last name)
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  print(getInitials('Durga Prasad A G'));
}
