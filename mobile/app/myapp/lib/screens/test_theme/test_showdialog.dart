// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Écran de test pour showDialog.
class TestShowDialog extends StatelessWidget {
  // Constructeur const avec clé optionnelle.
  const TestShowDialog({super.key});

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page avec un bouton.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test ShowDialog')),
      // Corps centré.
      body: Center(
        // Bouton pour ouvrir le dialogue.
        child: ElevatedButton(
          // Action lors du clic.
          onPressed: () {
            // Affiche un dialogue.
            showDialog(
              // Contexte nécessaire au dialogue.
              context: context,
              // Construit le contenu du dialogue.
              builder: (BuildContext context) {
                // Retourne un AlertDialog.
                return AlertDialog(
                  // Titre du dialogue.
                  title: Text(
                    // Texte du titre.
                    'Dialog Title',
                    // Style du titre basé sur le thème.
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // Contenu du dialogue.
                  content: Text('This is a dialog to test the theme.'),
                  // Actions du dialogue.
                  actions: [
                    // Bouton pour fermer le dialogue.
                    TextButton(
                      // Action de fermeture.
                      onPressed: () {
                        // Ferme le dialogue.
                        Navigator.of(context).pop();
                      },
                      // Libellé du bouton.
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          // Libellé du bouton.
          child: Text('Show Dialog'),
        ),
      ),
    );
  }
}
