// import 'package:flutter/material.dart';

// // Color palette inspired by online modern UI templates
// class AppColors {
//   static const primaryGradient = LinearGradient(
//     colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Purple → Blue
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const background = Color(0xFFF8F9FD); // Light background
//   static const cardLight = Colors.white;
//   static const cardFake = Color(0xFFFFE5E5);
//   static const cardReal = Color(0xFFE8F5E9);
// }

// // Text styles for headings, labels, and content
// class AppTextStyles {
//   static const heading = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.bold,
//     color: Colors.black87,
//   );

//   static const label = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//     color: Colors.black54,
//   );

//   static const content = TextStyle(
//     fontSize: 15,
//     color: Colors.black87,
//     height: 1.4,
//   );

//   static const resultFake = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//     color: Colors.redAccent,
//   );

//   static const resultReal = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//     color: Colors.green,
//   );
// }

// // Custom button style
// class AppButtonStyles {
//   static ButtonStyle gradientButton = ElevatedButton.styleFrom(
//     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//   ).merge(
//     ButtonStyle(
//       backgroundColor: MaterialStateProperty.all(Colors.transparent),
//       elevation: MaterialStateProperty.all(0),
//     ),
//   );
// }

import 'package:flutter/material.dart';

/// 🎨 App color palette inspired by modern web templates
class AppColors {
  // Main gradient (purple → blue)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background colors
  static const Color background = Color(0xFFF8F9FD); // soft gray-white
  static const Color cardLight = Colors.white;

  // Result card colors
  static const Color cardFake = Color(0xFFFFE5E5); // soft red
  static const Color cardReal = Color(0xFFE8F5E9); // soft green

  // Accent colors
  static const Color accentYellow = Color(0xFFFFD54F); // ribbon yellow
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
}

/// 📝 Text styles for headings, labels, and content
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle content = TextStyle(
    fontSize: 15,
    color: AppColors.textDark,
    height: 1.5,
  );

  static const TextStyle resultFake = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.redAccent,
  );

  static const TextStyle resultReal = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );
}

/// 🔘 Custom button styles
class AppButtonStyles {
  // Gradient button for primary actions
  static final ButtonStyle gradientButton = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    backgroundColor: Colors.transparent,
    elevation: 0,
  ).merge(
    ButtonStyle(
      // Overlay gradient using MaterialStateProperty
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    ),
  );

  // White card-style button
  static final ButtonStyle whiteButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textDark,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  );
}

