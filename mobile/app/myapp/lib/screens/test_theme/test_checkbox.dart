// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Écran de test pour les Checkbox.
class TestCheckbox extends StatefulWidget {
  // Constructeur const avec clé optionnelle.
  const TestCheckbox({super.key});

  // Crée l'état associé.
  @override
  State<TestCheckbox> createState() => _TestCheckboxState();
}

// État interne du widget TestCheckbox.
class _TestCheckboxState extends State<TestCheckbox> {
  // Valeur actuelle de la case à cocher.
  bool _isChecked = true;

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page avec une CheckboxListTile.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test Checkbox')),
      // Corps avec padding.
      body: Padding(
        // Padding interne.
        padding: const EdgeInsets.all(16.0),
        // Colonne centrée verticalement.
        child: Column(
          // Centre les éléments dans la colonne.
          mainAxisAlignment: MainAxisAlignment.center,
          // Liste des widgets enfants.
          children: [
            // Affiche une CheckboxListTile.
            CheckboxListTile(
              // Valeur de la checkbox.
              value: _isChecked,
              // Callback lors du changement.
              onChanged: (bool? value) {
                // Met à jour l'état.
                setState(() {
                  // Force la nouvelle valeur non nulle.
                  _isChecked = value!;
                });
              },
              // Texte à droite de la checkbox.
              title: Text('Custom Checkbox'),
            ),
            // Espacement vertical.
            SizedBox(height: 20),
            // Affiche l'état sous forme de texte.
            Text(_isChecked ? 'Checked' : 'Unchecked'),
          ],
        ),
      ),
    );
  }
}
