import 'package:flutter/material.dart';

/// Service to generate consistent, unique colors for users based on their IDs.
/// Uses HSL color space and the Golden Ratio for maximum hue distribution.
class UserColorService {
  
  /// Get a consistent color for a given userId (int or string).
  static Color getColorForUser(dynamic userId) {
    if (userId == null) return Colors.grey.shade400;
    
    // Normalize ID to string for hashing
    final String seed = userId.toString();
    
    // Golden ratio conjugate (approx 0.618)
    // Using this to spread hues as far as possible for sequential IDs
    const double phi = 0.618033988749895;
    
    // Robust string hashing (similar to Java's String.hashCode)
    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = seed.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Generate hue (0-360)
    // Multiplying hash by PHI gives a very good spread across the spectrum
    double hue = (hash.abs() * phi * 360) % 360;
    
    // Return a professional-looking color
    // Saturation 65% for vibrancy, Lightness 45% for visibility on light/dark backgrounds
    return HSLColor.fromAHSL(
      1.0, 
      hue, 
      0.65, 
      0.45,
    ).toColor();
  }

  /// Get a lighter version of the user color (good for backgrounds)
  static Color getLightColorForUser(dynamic userId, {double opacity = 0.1}) {
    return getColorForUser(userId).withOpacity(opacity);
  }

  /// Get the hex code (without #) for the user's color.
  static String getHexColorForUser(dynamic userId) {
    final color = getColorForUser(userId);
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }

  /// Extracts initials from a user's name (e.g., "John Doe" -> "JD").
  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
