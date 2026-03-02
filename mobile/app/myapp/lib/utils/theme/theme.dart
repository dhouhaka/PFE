// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';
// Importe les couleurs personnalisées de l'application.
import '../constants/colors.dart';
// Importe le thème AppBar personnalisé.
import 'custom_themes/appbar_theme.dart';
// Importe le thème BottomSheet personnalisé.
import 'custom_themes/bottom_sheet_theme.dart';
// Importe le thème Checkbox personnalisé.
import 'custom_themes/checkbox_theme.dart';
// Importe le thème Chip personnalisé.
import 'custom_themes/chip_theme.dart';
// Importe le thème Dialog personnalisé.
import 'custom_themes/dialog_theme.dart';
// Importe le thème ElevatedButton personnalisé.
import 'custom_themes/elevated_button_theme.dart';
// Importe le thème OutlinedButton personnalisé.
import 'custom_themes/outlined_button_theme.dart';
// Importe le thème TextButton personnalisé.
import 'custom_themes/text_button_theme.dart';
// Importe le thème TextTheme personnalisé.
import 'custom_themes/text_theme.dart';
// Importe le thème des TextFormField personnalisés.
import 'custom_themes/textformfield_theme.dart';

// Contient la configuration globale des thèmes clair et sombre.
class AppTheme {
  // Constructeur privé pour empêcher l'instanciation.
  AppTheme._();

  // Thème clair.
  static ThemeData lightTheme = ThemeData(
    // Active Material 3.
    useMaterial3: true,
    // Définit la police globale.
    fontFamily: 'Poppins',
    // Définit la luminosité en clair.
    brightness: Brightness.light,
    // Définit la couleur primaire.
    primaryColor: TColors.primary,
    // Définit la couleur d'arrière-plan des écrans.
    scaffoldBackgroundColor: TColors.light,
    // Définit le thème de texte.
    textTheme: TTextTheme.lightTextTheme,
    // Définit le thème des ElevatedButton.
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    // Définit le thème des OutlinedButton.
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    // Définit le thème des AppBar.
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    // Définit le thème des BottomSheet.
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    // Définit le thème des Checkbox.
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    // Définit le thème des Chip.
    chipTheme: TChipTheme.lightChipTheme,
    // Définit le thème des Dialog.
    dialogTheme: TDialogTheme.lightDialogTheme,
    // Définit le thème des TextButton.
    textButtonTheme: TTextButtonTheme.lightTextButtonTheme,
    // Définit le thème des champs de formulaire.
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  // Thème sombre.
  static ThemeData darkTheme = ThemeData(
    // Active Material 3.
    useMaterial3: true,
    // Définit la police globale.
    fontFamily: 'Poppins',
    // Définit la luminosité en sombre.
    brightness: Brightness.dark,
    // Définit la couleur primaire.
    primaryColor: TColors.primary,
    // Définit la couleur d'arrière-plan des écrans.
    scaffoldBackgroundColor: TColors.dark,
    // Définit le thème de texte.
    textTheme: TTextTheme.darkTextTheme,
    // Définit le thème des ElevatedButton.
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    // Définit le thème des OutlinedButton.
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    // Définit le thème des AppBar.
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    // Définit le thème des BottomSheet.
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    // Définit le thème des Checkbox.
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    // Définit le thème des Chip.
    chipTheme: TChipTheme.darkChipTheme,
    // Définit le thème des Dialog.
    dialogTheme: TDialogTheme.darkDialogTheme,
    // Définit le thème des TextButton.
    textButtonTheme: TTextButtonTheme.darkTextButtonTheme,
    // Définit le thème des champs de formulaire.
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
