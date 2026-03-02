// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';
// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de texte.
class TTextTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TTextTheme._();

  // Thème de texte pour le mode clair.
  static TextTheme lightTextTheme = TextTheme(
    // Style du très grand titre.
    headlineLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 35.0,
      // Poids du texte.
      fontWeight: FontWeight.bold,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du titre moyen.
    headlineMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 27.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du petit titre.
    headlineSmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 21.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),

    // Style du grand titre.
    titleLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du titre moyen.
    titleMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du petit titre.
    titleSmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w400,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),

    // Style du grand texte de corps.
    bodyLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du texte de corps moyen.
    bodyMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textSecondary,
    ),
    // Style du petit texte de corps.
    bodySmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w400,
      // Couleur du texte.
      color: TColors.textDarkGrey,
    ),

    // Style du grand label.
    labelLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 15.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textgrey,
    ),
    // Style du label moyen.
    labelMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 13.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textgrey,
    ),
  );

  // Thème de texte pour le mode sombre.
  static TextTheme darkTextTheme = TextTheme(
    // Style du très grand titre.
    headlineLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 35.0,
      // Poids du texte.
      fontWeight: FontWeight.bold,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du titre moyen.
    headlineMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 27.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du petit titre.
    headlineSmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 21.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textwhite,
    ),

    // Style du grand titre.
    titleLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du titre moyen.
    titleMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du petit titre.
    titleSmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 20.0,
      // Poids du texte.
      fontWeight: FontWeight.w400,
      // Couleur du texte.
      color: TColors.textwhite,
    ),

    // Style du grand texte de corps.
    bodyLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w600,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du texte de corps moyen.
    bodyMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textwhite,
    ),
    // Style du petit texte de corps.
    bodySmall: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 19.0,
      // Poids du texte.
      fontWeight: FontWeight.w400,
      // Couleur du texte.
      color: TColors.textwhite,
    ),

    // Style du grand label.
    labelLarge: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 15.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textgrey,
    ),
    // Style du label moyen.
    labelMedium: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 13.0,
      // Poids du texte.
      fontWeight: FontWeight.w500,
      // Couleur du texte.
      color: TColors.textgrey,
    ),
  );
}
