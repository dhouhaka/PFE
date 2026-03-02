// Importe les widgets Material de Flutter.
import 'package:flutter/material.dart';
// Importe les validateurs de champs.
import 'package:form_field_validator/form_field_validator.dart';

// Écran de test pour les TextFormField.
class TestFormField extends StatefulWidget {
  // Constructeur const avec clé optionnelle.
  const TestFormField({super.key});

  // Crée l'état associé.
  @override
  State<TestFormField> createState() => _TestFormFieldState();
}

// État interne du widget TestFormField.
class _TestFormFieldState extends State<TestFormField> {
  // Contrôleur du champ email.
  late TextEditingController _emailController;
  // Contrôleur du champ mot de passe.
  late TextEditingController _passwordController;
  // Clé de formulaire pour la validation.
  GlobalKey<FormState> formkeySignin = GlobalKey<FormState>();
  // Indique si le mot de passe est visible.
  bool _passwordVisible = false;

  // Initialise les contrôleurs.
  @override
  void initState() {
    // Crée le contrôleur email.
    _emailController = TextEditingController();
    // Crée le contrôleur mot de passe.
    _passwordController = TextEditingController();
    // Appelle l'initState parent.
    super.initState();
  }

  // Libère les ressources.
  @override
  void dispose() {
    // Libère le contrôleur email.
    _emailController.dispose();
    // Libère le contrôleur mot de passe.
    _passwordController.dispose();
    // Appelle le dispose parent.
    super.dispose();
  }

  // Construit l'interface de l'écran.
  @override
  Widget build(BuildContext context) {
    // Retourne une page avec un formulaire.
    return Scaffold(
      // AppBar de la page.
      appBar: AppBar(title: Text('Test FormField')),
      // Corps avec padding.
      body: Padding(
        // Padding interne.
        padding: const EdgeInsets.all(16.0),
        // Colonne des widgets.
        child: Column(
          // Liste des widgets enfants.
          children: [
            // Formulaire avec TextFormField.
            Form(
              // Clé du formulaire.
              key: formkeySignin,
              // Colonne interne du formulaire.
              child: Column(
                // Liste des champs.
                children: [
                  // Champ email.
                  TextFormField(
                    // Contrôleur associé.
                    controller: _emailController,
                    // Décoration du champ.
                    decoration: InputDecoration(
                      // Icône à gauche.
                      prefixIcon: Icon(Icons.home),
                      // Label du champ.
                      labelText: 'Enter your email',
                      // Placeholder.
                      hintText: 'johndoe@example.com',
                    ),
                    // Validateurs du champ.
                    validator:
                        MultiValidator([
                          // Champ requis.
                          RequiredValidator(errorText: "* Required"),
                          // Format email valide.
                          EmailValidator(
                            errorText: "Please enter a valid email address.",
                          ),
                        ]).call,
                  ),
                  // Espacement vertical.
                  SizedBox(height: 20),
                  // Champ mot de passe.
                  TextFormField(
                    // Contrôleur associé.
                    controller: _passwordController,
                    // Masque ou non le texte.
                    obscureText: !_passwordVisible,
                    // Décoration du champ.
                    decoration: InputDecoration(
                      // Label du champ.
                      labelText: 'Enter your password',
                      // Placeholder.
                      hintText: "**********",
                      // Icône à gauche.
                      prefixIcon: const Icon(Icons.lock),
                      // Icône à droite pour afficher/masquer.
                      suffixIcon: IconButton(
                        // Icône selon l'état.
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        // Action lors du clic.
                        onPressed: () {
                          // Met à jour l'état.
                          setState(() {
                            // Inverse la visibilité.
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    // Validateurs du champ.
                    validator:
                        MultiValidator([
                          // Champ requis.
                          RequiredValidator(errorText: "* Required"),
                          // Longueur minimale.
                          MinLengthValidator(
                            6,
                            errorText:
                                "Password must be at least 6 characters.",
                          ),
                          // Longueur maximale.
                          MaxLengthValidator(
                            15,
                            errorText:
                                "Password must not exceed 15 characters.",
                          ),
                        ]).call,
                  ),
                  // Espacement vertical.
                  SizedBox(height: 20),
                  // Bouton de soumission du formulaire.
                  ElevatedButton(
                    // Action lors du clic.
                    onPressed: () {
                      // Valide le formulaire.
                      if (formkeySignin.currentState!.validate()) {
                        // Succès (placeholder).
                        // print("success");
                      } else {
                        // Erreur (placeholder).
                        // print("error");
                      }
                    },
                    // Libellé du bouton.
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
