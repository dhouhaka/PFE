// Thèmes ElevatedButton en clair et sombre.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes d'ElevatedButton.
class TElevatedButtonTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TElevatedButtonTheme._();
  // Thème ElevatedButton pour le mode clair.
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    // Définit le style de base du bouton.
    style: ElevatedButton.styleFrom(
      // Couleur du texte et des icônes.
      foregroundColor: TColors.white,
      // Couleur de fond du bouton.
      backgroundColor: TColors.buttonPrimary,
      // Couleur du texte en état désactivé.
      disabledForegroundColor: TColors.textwhite,
      // Couleur de fond en état désactivé.
      disabledBackgroundColor: TColors.buttonDisabled,
      // Forme et arrondi du bouton.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // Padding interne du bouton.
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      // Style du texte.
      textStyle: const TextStyle(
        // Taille du texte.
        fontSize: 20.0,
        // Poids du texte.
        fontWeight: FontWeight.w500,
        // Couleur du texte.
        color: TColors.textwhite,
      ),
    ),
  );

  // Thème ElevatedButton pour le mode sombre.
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    // Définit le style de base du bouton.
    style: ElevatedButton.styleFrom(
      // Couleur du texte et des icônes.
      foregroundColor: TColors.white,
      // Couleur de fond du bouton.
      backgroundColor: TColors.buttonPrimary,
      // Couleur du texte en état désactivé.
      disabledForegroundColor: TColors.textwhite,
      // Couleur de fond en état désactivé.
      disabledBackgroundColor: TColors.buttonDisabled,
      // Forme et arrondi du bouton.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // Padding interne du bouton.
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      // Style du texte.
      textStyle: const TextStyle(
        // Taille du texte.
        fontSize: 20.0,
        // Poids du texte.
        fontWeight: FontWeight.w500,
        // Couleur du texte.
        color: TColors.textwhite,
      ),
    ),
  );
}
