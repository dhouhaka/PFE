// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de Chip.
class TChipTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TChipTheme._();

  // Thème Chip pour le mode clair.
  static ChipThemeData lightChipTheme = ChipThemeData(
    // Couleur d'un chip désactivé.
    disabledColor: TColors.grey,
    // Style du texte du chip.
    labelStyle: const TextStyle(color: Colors.black),
    // Couleur d'un chip sélectionné.
    selectedColor: TColors.primary,
    // Espacement interne du chip.
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    // Couleur de la coche.
    checkmarkColor: TColors.white,
  );

  // Thème Chip pour le mode sombre.
  static ChipThemeData darkChipTheme = const ChipThemeData(
    // Couleur d'un chip désactivé.
    disabledColor: TColors.grey,
    // Style du texte du chip.
    labelStyle: TextStyle(color: Colors.white),
    // Couleur d'un chip sélectionné.
    selectedColor: TColors.primary,
    // Espacement interne du chip.
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    // Couleur de la coche.
    checkmarkColor: TColors.white,
  );
}
