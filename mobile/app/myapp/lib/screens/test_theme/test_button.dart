// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Écran de test pour les boutons.
class TestButton extends StatelessWidget {
  // Constructeur const avec clé optionnelle.
  const TestButton({super.key});

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page listant différents boutons.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test des Boutons')),
      // Corps avec padding.
      body: Padding(
        // Padding interne.
        padding: const EdgeInsets.all(16.0),
        // Colonne de widgets pour les tests.
        child: Column(
          // Liste des widgets enfants.
          children: [
            // Test du ElevatedButton avec le style actuel du thème.
            ElevatedButton(onPressed: () {}, child: Text('Elevated Button')),
            // Espacement vertical.
            SizedBox(height: 20),

            // Test du ElevatedButton désactivé.
            ElevatedButton(
              // null désactive le bouton.
              onPressed: null,
              child: Text('Disabled Elevated Button'),
            ),
            // Espacement vertical.
            SizedBox(height: 20),

            // Test du ElevatedButton étendu.
            ElevatedButton(
              // Action lors du clic.
              onPressed: () {},
              // Style du bouton.
              style: ElevatedButton.styleFrom(
                // Largeur étendue.
                minimumSize: Size(double.infinity, 50),
              ),
              // Libellé du bouton.
              child: Text('Expanded Elevated Button'),
            ),
            // Espacement vertical.
            SizedBox(height: 20),
            // Séparateur visuel.
            Divider(),
            // Espacement vertical.
            SizedBox(height: 20),

            // Test du OutlinedButton avec le style actuel du thème.
            OutlinedButton(onPressed: () {}, child: Text('Outlined Button')),
            // Espacement vertical.
            SizedBox(height: 20),

            // Test du OutlinedButton désactivé.
            OutlinedButton(
              // null désactive le bouton.
              onPressed: null,
              child: Text('Disabled Outlined Button'),
            ),
            // Espacement vertical.
            SizedBox(height: 20),

            // Test du OutlinedButton étendu.
            OutlinedButton(
              // Action lors du clic.
              onPressed: () {},
              // Style du bouton.
              style: OutlinedButton.styleFrom(
                // Largeur étendue.
                minimumSize: Size(double.infinity, 50),
              ),
              // Libellé du bouton.
              child: Text('Expanded Outlined Button'),
            ),
          ],
        ),
      ),
    );
  }
}
