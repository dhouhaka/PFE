// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';

// Importe les couleurs personnalisées de l'application.
import '../../utils/constants/colors.dart';

// Écran de test pour les styles de texte.
class TestText extends StatelessWidget {
  // Constructeur const avec clé optionnelle.
  const TestText({super.key});

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Récupère la luminosité actuelle.
    Brightness brightness = Theme.of(context).brightness;
    // Détermine si le thème est clair.
    bool isLight = brightness == Brightness.light;
    // Retourne une page avec une liste de textes.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test des Styles de Texte')),
      // Corps avec une liste scrollable.
      body: ListView(
        // Padding interne de la liste.
        padding: EdgeInsets.all(8.0),
        // Liste des widgets enfants.
        children: [
          // Utilise les styles de texte actuels.
          Text(
            // Texte d'exemple.
            "Headline Large (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            // Texte d'exemple.
            "Headline Medium (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            // Texte d'exemple.
            "Headline Small (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            // Texte d'exemple.
            "Title Large (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            // Texte d'exemple.
            "Title Medium (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            // Texte d'exemple.
            "Title Small (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            // Texte d'exemple.
            "Body Large (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            // Texte d'exemple.
            "Body Medium (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            // Texte d'exemple.
            "Body Small (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            // Texte d'exemple.
            "Label Large (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            // Texte d'exemple.
            "Label Medium (Actuel)",
            // Style du texte.
            style: Theme.of(context).textTheme.labelMedium,
          ),
          // Espacement vertical.
          SizedBox(height: 10),
          // Séparateur visuel.
          Divider(),
          // Espacement vertical.
          SizedBox(height: 10),
          // Conteneur pour afficher les textes sur fond personnalisé.
          Container(
            // Padding interne.
            padding: const EdgeInsets.all(5),
            // Décoration du conteneur.
            decoration: BoxDecoration(
              // Couleur selon le thème.
              color: isLight ? TColors.lightContainer : TColors.darkContainer,
              // Arrondi des coins.
              borderRadius: BorderRadius.circular(15),
              // Ombre portée.
              boxShadow: [
                // Définition de l'ombre.
                BoxShadow(
                  // Couleur de l'ombre.
                  color: TColors.darkContainer,
                  // Décalage de l'ombre.
                  offset: const Offset(1.0, 1.0),
                  // Flou de l'ombre.
                  blurRadius: 5,
                  // Étendue de l'ombre.
                  spreadRadius: 1,
                ),
              ],
            ),

            // Colonne de textes.
            child: Column(
              // Aligne à gauche.
              crossAxisAlignment: CrossAxisAlignment.start,
              // Liste des widgets enfants.
              children: [
                Text(
                  // Texte d'exemple.
                  "Headline Large (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  // Texte d'exemple.
                  "Headline Medium (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  // Texte d'exemple.
                  "Headline Small (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  // Texte d'exemple.
                  "Title Large (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  // Texte d'exemple.
                  "Title Medium (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  // Texte d'exemple.
                  "Title Small (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  // Texte d'exemple.
                  "Body Large (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  // Texte d'exemple.
                  "Body Medium (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  // Texte d'exemple.
                  "Body Small (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  // Texte d'exemple.
                  "Label Large (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  // Texte d'exemple.
                  "Label Medium (Actuel)",
                  // Style du texte.
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          // Espacement vertical.
          SizedBox(height: 10),
          // Séparateur visuel.
          Divider(),
          // Espacement vertical.
          SizedBox(height: 10),
          Text(
            // Texte d'exemple.
            'Headline Large (change Color)',
            // Style basé sur le thème avec couleur modifiée.
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: TColors.primary),
          ),
        ],
      ),
    );
  }
}
