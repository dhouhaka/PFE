// Thèmes OutlinedButton en clair et sombre.
import 'package:flutter/material.dart';
// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes d'OutlinedButton.
class TOutlinedButtonTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TOutlinedButtonTheme._();

  // Thème OutlinedButton pour le mode clair.
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    // Définit le style de base du bouton.
    style: OutlinedButton.styleFrom(
      // Couleur du texte et des icônes.
      foregroundColor: TColors.darkGrey,
      // Bordure du bouton.
      side: const BorderSide(color: TColors.darkGrey),
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
        color: TColors.textSecondary,
      ),
    ),
  );

  // Thème OutlinedButton pour le mode sombre.
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    // Définit le style de base du bouton.
    style: OutlinedButton.styleFrom(
      // Couleur du texte et des icônes.
      foregroundColor: TColors.white,
      // Bordure du bouton.
      side: const BorderSide(color: TColors.white),
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
