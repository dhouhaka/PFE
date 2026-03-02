// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../constants/colors.dart';

// Contient la configuration des thèmes de TextFormField.
class TTextFormFieldTheme {
  // Constructeur privé pour empêcher l'instanciation.
  TTextFormFieldTheme._();

  // Thème InputDecoration pour le mode clair.
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    // Nombre max de lignes pour l'erreur.
    errorMaxLines: 3,
    // Couleur de l'icône de préfixe.
    prefixIconColor: TColors.darkGrey,
    // Couleur de l'icône de suffixe.
    suffixIconColor: TColors.darkGrey,
    // Style du label.
    labelStyle: const TextStyle(fontSize: 14, color: TColors.secondary),
    // Style du placeholder.
    hintStyle: const TextStyle().copyWith(
      // Taille du texte.
      fontSize: 14,
      // Couleur du texte.
      color: TColors.secondary,
    ),
    // Style du label flottant.
    floatingLabelStyle: const TextStyle().copyWith(color: TColors.secondary),
    // Bordure par défaut.
    border: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.grey),
    ),
    // Bordure activée.
    enabledBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.grey),
    ),
    // Bordure en focus.
    focusedBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.grey),
    ),
    // Bordure en erreur.
    errorBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.error),
    ),
    // Bordure en erreur avec focus.
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.warning),
    ),
  );

  // Thème InputDecoration pour le mode sombre.
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    // Nombre max de lignes pour l'erreur.
    errorMaxLines: 3,
    // Couleur de l'icône de préfixe.
    prefixIconColor: TColors.grey,
    // Couleur de l'icône de suffixe.
    suffixIconColor: TColors.grey,
    // Style du label.
    labelStyle: const TextStyle(fontSize: 14, color: TColors.white),
    // Style du placeholder.
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: TColors.white),
    // Style du label flottant.
    floatingLabelStyle: const TextStyle().copyWith(color: TColors.white),
    // Bordure par défaut.
    border: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.grey),
    ),
    // Bordure activée.
    enabledBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.grey),
    ),
    // Bordure en focus.
    focusedBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.white),
    ),
    // Bordure en erreur.
    errorBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.error),
    ),
    // Bordure en erreur avec focus.
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      // Arrondi de la bordure.
      borderRadius: BorderRadius.circular(14),
      // Couleur et largeur de la bordure.
      borderSide: const BorderSide(width: 1, color: TColors.warning),
    ),
  );
}
