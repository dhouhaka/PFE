// Classe de configuration pour les thèmes de Checkbox en clair et sombre.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de Checkbox.
class TCheckboxTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TCheckboxTheme._();

  // Thème Checkbox pour le mode clair.
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    // Définit la forme et l'arrondi.
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    // Définit la couleur de remplissage selon l'état.
    fillColor: WidgetStateProperty.resolveWith((states) {
      // Si la case est cochée, utiliser la couleur primaire.
      if (states.contains(WidgetState.selected)) {
        return TColors.primary;
      }
      // Sinon, pas de remplissage.
      return Colors.transparent;
    }),
  );

  // Thème Checkbox pour le mode sombre.
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    // Définit la forme et l'arrondi.
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

    // Définit la couleur de remplissage selon l'état.
    fillColor: WidgetStateProperty.resolveWith((states) {
      // Si la case est cochée, utiliser la couleur primaire.
      if (states.contains(WidgetState.selected)) {
        return TColors.primary;
      }
      // Sinon, pas de remplissage.
      return Colors.transparent;
    }),
  );
}
