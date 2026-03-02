// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';
// Importe le support SVG.
import 'package:flutter_svg/svg.dart';

// Écran de test pour l'AppBar.
class TestAppbar extends StatelessWidget {
  // Constructeur const avec clé optionnelle.
  const TestAppbar({super.key});

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Exemple : déterminer le thème actuel (clair ou sombre).
    // Brightness brightness = Theme.of(context).brightness;

    // Exemple : choisir une image selon le thème.
    // String imagePath =
    //     brightness == Brightness.light
    //         ? 'assets/images/logo_appbar_white.png' // Image mode clair.
    //         : 'assets/images/logo_appbar_black.png'; // Image mode sombre.

    // Retourne une page avec AppBar et contenu.
    return Scaffold(
      // Déclare la barre d'application.
      appBar: AppBar(
        // Titre avec un logo SVG.
        title: SvgPicture.asset("assets/images/logo-spotify.svg", height: 30),
        // Actions à droite de l'AppBar.
        actions: [
          // Bouton icône Home.
          IconButton(icon: Icon(Icons.home), onPressed: () {}),
          // Bouton icône Profil.
          IconButton(icon: Icon(Icons.person), onPressed: () {}),
        ],
      ),
      // Corps centré avec un texte.
      body: Center(child: Text('Content here')),
    );
  }
}
