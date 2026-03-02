// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de BottomSheet.
class TBottomSheetTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TBottomSheetTheme._();

  // Thème BottomSheet pour le mode clair.
  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    // Affiche la poignée de glissement.
    showDragHandle: true,
    // Définit la couleur de fond.
    backgroundColor: TColors.lightContainer,
    // Définit les contraintes de largeur.
    constraints: const BoxConstraints(minWidth: double.infinity),
    // Définit la forme et l'arrondi.
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  // Thème BottomSheet pour le mode sombre.
  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    // Affiche la poignée de glissement.
    showDragHandle: true,
    // Définit la couleur de fond.
    backgroundColor: TColors.darkContainer,
    // Définit les contraintes de largeur.
    constraints: const BoxConstraints(minWidth: double.infinity),
    // Définit la forme et l'arrondi.
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
