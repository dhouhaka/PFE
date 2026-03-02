// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes d'AppBar.
class TAppBarTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TAppBarTheme._();

  // Thème AppBar pour le mode clair.
  static const lightAppBarTheme = AppBarTheme(
    // Définit l'élévation par défaut.
    elevation: 1,
    // Centre le titre dans l'AppBar.
    centerTitle: true,
    // Définit l'élévation lors du scroll.
    scrolledUnderElevation: 1,
    // Rend le fond transparent.
    backgroundColor: Colors.transparent,
    // Désactive la teinte de surface.
    surfaceTintColor: Colors.transparent,
    // Définit le style des icônes.
    iconTheme: IconThemeData(color: TColors.darkGrey, size: 24),
    // Définit le style des icônes d'actions.
    actionsIconTheme: IconThemeData(color: TColors.darkGrey, size: 24),
    // Définit le style du titre.
    titleTextStyle: TextStyle(
      // Taille du texte du titre.
      fontSize: 18.0,
      // Poids du texte du titre.
      fontWeight: FontWeight.w600,
      // Couleur du texte du titre.
      color: TColors.secondary,
    ),
  );

  // Thème AppBar pour le mode sombre.
  static const darkAppBarTheme = AppBarTheme(
    // Définit l'élévation par défaut.
    elevation: 1,
    // Centre le titre dans l'AppBar.
    centerTitle: true,
    // Définit l'élévation lors du scroll.
    scrolledUnderElevation: 1,
    // Rend le fond transparent.
    backgroundColor: Colors.transparent,
    // Désactive la teinte de surface.
    surfaceTintColor: Colors.transparent,
    // Définit le style des icônes.
    iconTheme: IconThemeData(color: TColors.white, size: 24),
    // Définit le style des icônes d'actions.
    actionsIconTheme: IconThemeData(color: TColors.white, size: 24),
    // Définit le style du titre.
    titleTextStyle: TextStyle(
      // Taille du texte du titre.
      fontSize: 18.0,
      // Poids du texte du titre.
      fontWeight: FontWeight.w600,
      // Couleur du texte du titre.
      color: TColors.white,
    ),
  );
}
