import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_pm/src/core/utils/user_color_service.dart';

void main() {
  test('UserColorService provides deterministic colors', () {
    const userId1 = 1;
    const userId2 = 100;
    
    final color1a = UserColorService.getColorForUser(userId1);
    final color1b = UserColorService.getColorForUser(userId1);
    final color2 = UserColorService.getColorForUser(userId2);
    
    // Test consistency
    expect(color1a, color1b, reason: 'Color for same ID should be identical');
    
    // Test uniqueness (likely)
    expect(color1a, isNot(color2), reason: 'Colors for different IDs should be different');
    
    print('Color for ID 1: $color1a');
    print('Color for ID 100: $color2');
  });

  test('UserColorService handles null gracefully', () {
    final color = UserColorService.getColorForUser(null);
    expect(color, isA<Color>());
  });

  test('UserColorService provides consistent hex colors', () {
    const userId = 42;
    final hex1 = UserColorService.getHexColorForUser(userId);
    final hex2 = UserColorService.getHexColorForUser(userId);
    
    expect(hex1, hex2);
    expect(hex1.length, 6, reason: 'Hex color should be 6 characters long');
    expect(RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex1), isTrue);
    
    print('Hex color for ID 42: $hex1');
  });

  test('UserColorService generates correct initials', () {
    expect(UserColorService.getInitials('John Doe'), 'JD');
    expect(UserColorService.getInitials('alice'), 'A');
    expect(UserColorService.getInitials(' Bob '), 'B');
    expect(UserColorService.getInitials(''), '?');
    expect(UserColorService.getInitials(null), '?');
    expect(UserColorService.getInitials('Multiple Name Parts Test'), 'MN');
  });
}
