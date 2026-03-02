// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Écran de test pour les Chips sélectionnables.
class TestChip extends StatefulWidget {
  // Constructeur const avec clé optionnelle.
  const TestChip({super.key});

  // Crée l'état associé.
  @override
  State<TestChip> createState() => _TestChipState();
}

// État interne du widget TestChip.
class _TestChipState extends State<TestChip> {
  // Index du chip sélectionné (nullable).
  int? _selectedChipIndex = 1;

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page avec des ChoiceChip.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text("Selectable Chips Example")),
      // Corps avec padding.
      body: Padding(
        // Padding interne.
        padding: const EdgeInsets.all(16.0),
        // Permet de disposer les chips avec retour à la ligne.
        child: Wrap(
          // Espacement horizontal entre les chips.
          spacing: 8.0,
          // Génère une liste de chips.
          children:
              List.generate(5, (index) {
                // Retourne un ChoiceChip pour chaque option.
                return ChoiceChip(
                  // Libellé du chip.
                  label: Text('Option ${index + 1}'),
                  // Détermine si ce chip est sélectionné.
                  selected: _selectedChipIndex == index,
                  // Callback lors de la sélection.
                  onSelected: (bool selected) {
                    // Met à jour l'état.
                    setState(() {
                      // Si sélectionné, on garde l'index.
                      if (selected) {
                        _selectedChipIndex = index;
                      } else {
                        // Sinon, on désélectionne.
                        _selectedChipIndex = null;
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
