// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Écran de test pour les BottomSheet.
class TestBottomSheet extends StatelessWidget {
  // Constructeur const avec clé optionnelle.
  const TestBottomSheet({super.key});

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page avec un bouton qui ouvre un BottomSheet.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test des BottomSheet')),
      // Corps avec padding.
      body: Padding(
        // Padding interne.
        padding: const EdgeInsets.all(16.0),
        // Centre le contenu.
        child: Center(
          // Bouton d'action principal.
          child: ElevatedButton(
            // Action lors du clic.
            onPressed: () {
              // Affiche le BottomSheet en fonction du thème actuel.
              showModalBottomSheet(
                // Contexte nécessaire pour afficher le BottomSheet.
                context: context,
                // Construit le contenu du BottomSheet.
                builder: (BuildContext context) {
                  // Conteneur principal du BottomSheet.
                  return Container(
                    // Padding interne du BottomSheet.
                    padding: EdgeInsets.all(16.0),
                    // Centre le contenu du BottomSheet.
                    child: Center(
                      // Texte affiché dans le BottomSheet.
                      child: Text(
                        // Message affiché.
                        'Ceci est un BottomSheet',
                        // Style de texte basé sur le thème.
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  );
                },
              );
            },
            // Libellé du bouton.
            child: Text('Afficher BottomSheet'),
          ),
        ),
      ),
    );
  }
}
