// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de TextButton.
class TTextButtonTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TTextButtonTheme._();

  // Thème TextButton pour le mode clair.
  static TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    // Définit le style de base du bouton.
    style: ButtonStyle(
      // Couleur du texte.
      foregroundColor: WidgetStateProperty.all<Color>(
        TColors.primary,
      ),
      // Couleur de fond.
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.transparent,
      ),
      // Padding interne du bouton.
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      // Style du texte.
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(fontSize: 21.0, fontWeight: FontWeight.w600),
      ),
    ),
  );

  // Thème TextButton pour le mode sombre.
  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    // Définit le style de base du bouton.
    style: ButtonStyle(
      // Couleur du texte.
      foregroundColor: WidgetStateProperty.all<Color>(
        TColors.grey,
      ),
      // Couleur de fond.
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.transparent,
      ),
      // Padding interne du bouton.
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      // Style du texte.
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(fontSize: 21.0, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
