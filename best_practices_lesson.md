# Best Practices Lesson

## Principes de programmation

### Principes SOLID

**SOLID** est un acronyme pour cinq principes de conception orientée objet, introduits par Robert C. Martin (Uncle Bob). Ces principes visent à rendre le code plus compréhensible, flexible et maintenable.

#### S — Single Responsibility Principle (SRP) / Curly's Law

> Une classe ne devrait avoir qu'**une seule raison de changer**.

Chaque classe ou module doit avoir une responsabilité unique, entièrement encapsulée par cette classe. On parle aussi de **Curly's Law** : "Do One Thing".

**But :**

- Simplifier la maintenance : un changement ne nécessite la modification que d'un seul module
- Rendre le code plus lisible et plus facile à tester

**Exemple** :

```dart
// ❌ Bad
class UserManager {
  void authenticateUser(String email, String password) { /* ... */ }
  void sendEmail(String to, String subject) { /* ... */ }
  void generateReport() { /* ... */ }
}

// ✅ Good : une responsabilité par classe
class AuthService {
  void authenticate(String email, String password) { /* ... */ }
}

class EmailService {
  void send(String to, String subject) { /* ... */ }
}

class ReportService {
  void generate() { /* ... */ }
}
```

#### O — Open/Closed Principle (OCP)

> Les entités logicielles doivent être **ouvertes à l'extension** mais **fermées à la modification**.

On doit pouvoir ajouter de nouveaux comportements sans modifier le code existant.

**But :**

- Améliorer la maintenabilité et la stabilité en minimisant les changements au code existant
- Réduire le risque de régression

**Exemple** :

```dart
// ❌ Bad
class AreaCalculator {
  double calculate(Object shape) {
    if (shape is Circle) {
      return 3.14 * shape.radius * shape.radius;
    } else if (shape is Rectangle) {
      return shape.width * shape.height;
    }
    // Il faut modifier cette méthode pour chaque nouvelle forme...
    return 0;
  }
}

// ✅ Good : ouvert à l'extension via une interface
abstract class Shape {
  double area();
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

class Rectangle implements Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

// On peut ajouter Triangle sans toucher au code existant
class Triangle implements Shape {
  final double base, height;
  Triangle(this.base, this.height);

  @override
  double area() => 0.5 * base * height;
}
```

#### L — Liskov Substitution Principle (LSP)

> Les objets d'un programme doivent pouvoir être **remplacés par des instances de leurs sous-types** sans altérer le bon fonctionnement du programme.

Si `B` est un sous-type de `A`, alors on doit pouvoir utiliser `B` partout où `A` est attendu, sans effet de bord.

**But :**

- Garantir que l'héritage est utilisé correctement
- Éviter les bugs subtils liés à des sous-classes qui ne respectent pas le contrat de leur parent

**Exemple** :

```dart
// ❌ Bad
class Bird {
  void fly() => print('Je vole !');
}

class Penguin extends Bird {
  @override
  void fly() => throw Exception('Les pingouins ne volent pas !');
  // Violation du LSP : on ne peut pas substituer Bird par Penguin
}

// ✅ Good : séparer les comportements
abstract class Bird {
  void eat();
}

abstract class FlyingBird extends Bird {
  void fly();
}

class Parrot extends FlyingBird {
  @override
  void eat() => print('Je mange des graines');
  @override
  void fly() => print('Je vole !');
}

class Penguin extends Bird {
  @override
  void eat() => print('Je mange du poisson');
  // Pas de méthode fly() : pas de violation
}
```

#### I — Interface Segregation Principle (ISP)

> Il vaut mieux avoir **plusieurs interfaces spécifiques** qu'une seule interface trop large.

Un client ne devrait pas être forcé d'implémenter des méthodes dont il n'a pas besoin.

**But :**

- Garder le système découplé et plus facile à refactorer
- Éviter les implémentations vides ou absurdes

**Exemple** :

```dart
// ❌ Bad
abstract class Worker {
  void work();
  void eat();
  void sleep();
}

class Robot implements Worker {
  @override
  void work() => print('Je travaille');
  @override
  void eat() => print('???'); // Un robot ne mange pas !
  @override
  void sleep() => print('???'); // Un robot ne dort pas !
}

// ✅ Good : interfaces séparées
abstract class Workable {
  void work();
}

// We can also create abstract classes Feedable and Sleepable, just like Workable

class Human implements Workable, Feedable, Sleepable {
  @override
  void work() => print('Je travaille');
  @override
  void eat() => print('Je mange');
  @override
  void sleep() => print('Je dors');
}

class Robot implements Workable {
  @override
  void work() => print('Je travaille');
  // Pas besoin d'implémenter eat() ou sleep()
}
```

#### D — Dependency Inversion Principle (DIP)

> Dépendre des **abstractions**, pas des **implémentations concrètes**.

Les modules de haut niveau ne doivent pas dépendre directement des modules de bas niveau. Les deux doivent dépendre d'abstractions.

**But :**

- Rendre les modules de haut niveau plus réutilisables et maintenables
- Faciliter les tests unitaires grâce aux mocks
- Dépendre d'abstractions stables plutôt que de classes concrètes qui changent fréquemment

**Exemple** :

```dart
// ❌ Bad
class MySqlDatabase {
  void save(String data) => print('Sauvé dans MySQL: $data');
}

class UserRepository {
  final MySqlDatabase database = MySqlDatabase(); // Couplage fort !

  void saveUser(String user) => database.save(user);
}

// ✅ Good : dépendre d'une abstraction
abstract class IDatabase {
  void save(String data);
}

class MySqlDatabase implements IDatabase {
  @override
  void save(String data) => print('Sauvé dans MySQL: $data');
}

class PostgresDatabase implements IDatabase {
  @override
  void save(String data) => print('Sauvé dans Postgres: $data');
}

class UserRepository {
  final IDatabase database; // Dépend de l'abstraction
  UserRepository({required this.database});

  void saveUser(String user) => database.save(user);
}
```

### 15 principes à connaître

#### KISS (Keep It Simple, Stupid)

> La plupart des systèmes fonctionnent mieux quand ils restent **simples** plutôt que complexes.

**But :**

- Réduire le code pour réduire les bugs et faciliter les modifications
- Viser la simplicité comme sophistication ultime
- Retirer le superflu : *"Less is more"*

#### YAGNI (You Aren't Gonna Need It)

> N'implémentez pas une fonctionnalité tant qu'elle n'est pas **réellement nécessaire**.

**But :**

- Concentrer l'effort sur les besoins de l'itération courante
- Éviter le code bloat : un logiciel plus volumineux et plus complexe pour rien

**Comment ?**

- Implémentez les choses quand vous en avez vraiment besoin, jamais quand vous prévoyez en avoir besoin

#### Separation of Concerns

> Diviser un programme en **sections distinctes**, chacune traitant une préoccupation séparée.

Par exemple, la logique métier et l'interface utilisateur sont des préoccupations séparées : modifier l'une ne devrait pas nécessiter de modifier l'autre.

> *"It is what I sometimes have called 'the separation of concerns', which is the only available technique for effective ordering of one's thoughts."* — Edsger W. Dijkstra (1974)

**But :**

- Simplifier le développement et la maintenance
- Permettre de réutiliser et développer indépendamment les sections individuelles

#### Code For The Maintainer

> Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live. Code for readability. - John F Woods (1991)

**But :**

- Réduire le coût de la maintenance, la phase la plus coûteuse de tout projet.

**Comment ?**

- Mettez-vous à la place de celui qui lira votre code (un développeur Junior par exemple).
- Appliquez le principe **Don't make me think**.
- Appliquez le **Principle of Least Astonishment**.

#### DRY (Don't Repeat Yourself)

> Each significant piece of functionality in a program should be implemented in just one place in the source code.

**Ne vous répétez pas.** Évitez au maximum de dupliquer vos manières de faire.

**Pourquoi ?**

- Quand du code est dupliqué, une correction à un endroit peut être oubliée ailleurs.
- Un changement dans une logique dupliquée force à modifier plusieurs fichiers qui n'ont rien à voir entre eux.

**Comment ?**

- Une règle métier = un seul endroit dans le code
- **Rule of Three :** Si vous copiez-collez pour la troisième fois, c'est le moment de factoriser votre code.

#### Boy Scout Rule

> *"Laissez le campement plus propre que vous ne l'avez trouvé."*

**But :**

- Éviter que la qualité du code se dégrade et accumule de la **dette technique** au fil des modifications.
- Maintenir la qualité à chaque commit grâce à un refactoring continu et incrémental.

**Comment ?**

- Chaque commit ne doit pas dégrader la qualité de la codebase.
- Quand le code n'est pas aussi clair qu'il devrait l'être, corrigez-le immédiatement.

#### Minimise Coupling

> **Réduire les interdépendances** entre modules pour faciliter la modification et la maintenance.

Le couplage est le degré d'interdépendance entre modules. Plus le couplage est faible, mieux c'est.

**But :**

- Éviter l'effet domino lors d'un changement dans un module
- Faciliter la réutilisation et les tests des modules
- Encourager les développeurs à modifier le code sans crainte de casser quelque chose

**Comment ?**

- Éliminer, minimiser et réduire la complexité des relations entre les classes.
- Cacher les détails d'implémentation pour réduire le couplage.
- Appliquer la loi **'Law of Demeter'**.

#### Law of Demeter

> *"Ne parlez qu'à vos amis proches."*

Une méthode d'un objet ne devrait appeler que les méthodes :

1. De l'objet lui-même
2. Des paramètres de la méthode
3. Des objets créés à l'intérieur de la méthode
4. Des propriétés directes de l'objet

#### Robustness Principle / Postel's Law / Tolerant Reader

> *"Soyez conservateur pour ce que vous **envoyez**. Soyez flexible pour que vous **recevez**."*

**But :**

- Assurer que les services peuvent évoluer tout en causant un minimum de casse chez les clients existants.

**Comment ?**

- Le code qui envoie des données doit se conformer strictement aux spécifications.
- Le code qui reçoit des données doit accepter des entrées non conformes tant que le sens est clair.

#### Inversion of Control / Hollywood Principle

> *"Don't call us, we'll call you."*

Le code personnalisé reçoit le flux de contrôle d'un framework générique, au lieu de le contrôler lui-même.

**But :**

- Augmenter la modularité et l'extensibilité
- Découpler l'exécution des tâches de leur implémentation
- Empêcher les effets de bord lors du remplacement d'un module

**Comment ?**

- Factory pattern
- Service Locator
- Dependency Injection
- Strategy pattern

#### Hide Implementation Details / Information Hiding / Encapsulation / Abstraction

> Un module doit **cacher ses détails d'implémentation** en fournissant une interface propre, sans fuiter d'information inutile.

☕ **Analogie de la machine à café** :

- **Côté client (Abstraction)** : on appuie sur le bouton "Faire café"
- **Côté machine (Encapsulation)** : la pompe, la gestion de la température, le broyeur... tout est caché

**But :**

- Permettre de changer l'implémentation sans impacter l'interface utilisée par les clients

**Comment ?**

- Minimiser l'accessibilité des classes et de leurs membres
- Ne pas exposer les données internes publiquement
- Réduire le couplage pour cacher davantage les détails d'implémentation

#### CQS (Command Query Separation)

> Les méthodes doivent soit **effectuer une action** (commande), soit **retourner des données** (requête), mais **jamais les deux**.
>
> *"Poser une question ne devrait pas changer la réponse."*

**But :**

- Permettre aux développeurs de coder avec plus de confiance sans connaître les détails d'implémentation
- Permettre d'utiliser les méthodes de requête n'importe où et dans n'importe quel ordre car elles ne mutent pas l'état

#### FIRST (Fast, Independent, Repeatable, Self-checking, Timely)

Les tests unitaires doivent être :

- **Fast** : rapides à exécuter, pour encourager leur exécution fréquente
- **Independent** : indépendants les uns des autres, sans dépendance d'ordre
- **Repeatable** : reproductibles dans n'importe quel environnement
- **Self-checking** : auto-vérifiants, avec un résultat booléen (pass/fail)
- **Timely** : écrits au bon moment, idéalement avant le code (TDD)

#### AAA (Arrange, Act, Assert)

Pattern de structure de test en trois étapes :

1. **Arrange** : préparer les conditions et les données de test
2. **Act** : exécuter le code à tester
3. **Assert** : vérifier que le résultat est conforme aux attentes

## Refactoring

### When to refactor -> Code Smells

Les **code smells** sont des signes dans le code qui indiquent un problème de conception plus profond. Ils ne sont pas des bugs, mais ils rendent le code plus difficile à maintenir et à faire évoluer.

#### Bloaters

Les bloaters sont des éléments du code qui ont grossi au point de devenir difficiles à manipuler. Cela inclut les méthodes trop longues, les classes avec trop de responsabilités, les listes de paramètres excessives ou les groupes de données qui voyagent toujours ensemble sans être encapsulés dans un objet dédié. Ils apparaissent progressivement et s'accumulent avec le temps si on ne les traite pas.

#### Change Preventers

Les change preventers sont des structures de code qui rendent toute modification difficile. Quand un changement dans une partie du code oblige à modifier de nombreux autres endroits, c'est le signe d'un couplage trop fort ou d'une mauvaise répartition des responsabilités. On retrouve typiquement le *Divergent Change* (une classe modifiée pour des raisons différentes) et le *Shotgun Surgery* (un changement qui impacte de nombreuses classes).

#### Comments

Les commentaires excessifs sont souvent le signe d'un code qui n'est pas assez clair par lui-même. Un bon code devrait être suffisamment lisible pour ne pas nécessiter d'explications supplémentaires. Si vous ressentez le besoin d'ajouter un commentaire, demandez-vous d'abord si vous ne pouvez pas renommer une variable, extraire une méthode ou simplifier la logique pour rendre le code auto-documenté.

#### Duplicated code

Le code dupliqué est l'un des smells les plus courants. Quand la même logique apparaît à plusieurs endroits, toute correction ou évolution doit être répétée partout, ce qui augmente le risque d'oubli et d'incohérence. La solution est d'extraire la logique commune dans une méthode, une classe ou un module partagé (principe DRY).

#### Dead code

Le code mort est du code qui n'est plus jamais exécuté : variables inutilisées, méthodes jamais appelées, branches de conditions impossibles, imports inutiles. Il encombre le projet, crée de la confusion pour les développeurs et ralentit la compréhension du code. Il doit être supprimé sans hésitation — le contrôle de version (git) permet toujours de le retrouver si nécessaire.

### How to refactor

Quand vous identifiez un code smell, utilisez les bonnes pratiques pour le corriger, voire un design pattern si c'est nécessaire.

#### Changement de code

Le **refactoring**, qui implique un besoin de **changement** dans votre code, pourra s'exprimer de la manière suivante :

- **Composition de méthodes** : extraire une méthode ou une variable, supprimer les méthodes et variables inutiles.
- **Déplacement de fonctionnalités** : déplacer une méthode, extraire une classe, masquer un délégué.
- **Organisation des données** : utiliser des constantes, encapsuler un champ, remplacer un code type par des sous-classes.
- **Simplification des conditions** : remplacer les conditions imbriquées par des clauses de garde, décomposer une condition, remplacer une condition par du polymorphisme.
- **Simplification des appels de méthodes** : introduire un objet paramètre, séparer requête et modification.

#### Renommage

Utilisez votre IDE pour renommer un fichier, une méthode, une classe ou une variable. Il est recommandé d'assigner un raccourci clavier pour cette action, car c'est quelque chose que l'on fait quotidiennement.

En utilisant systématiquement cette fonctionnalité, vous gagnerez du temps et éviterez les erreurs qu'un renommage manuel peut provoquer (oubli d'une occurrence, incohérence entre fichiers).

#### Tests

Exécutez toujours les tests après un refactoring. Le refactoring ne doit jamais changer le comportement observable du code — les tests sont votre filet de sécurité pour le vérifier. Si vous n'avez pas de tests, c'est le moment d'en écrire avant de refactorer.

## Clean code

### Best practices

On appelle "best practices" les conventions et habitudes de développement qui améliorent la lisibilité, la maintenabilité et la fiabilité du code. Ce ne sont pas des règles absolues, mais des recommandations issues de l’expérience collective des développeurs.

#### Évitez les données "hard-codées"

Il est fortement déconseillé de placer des chaînes de caractères directement dans le code (URLs, messages, clés de configuration...). Regroupez-les dans des constantes ou des fichiers de configuration dédiés. Cela facilite la maintenance, la traduction et évite les erreurs de frappe difficiles à débugger.

```dart
// ❌ Bad
if (user.role == ‘admin’) { /* ... */ }
print(‘Erreur: utilisateur non trouvé’);

// ✅ Good
class Roles {
  static const admin = ‘admin’;
  static const user = ‘user’;
}

class ErrorMessages {
  static const userNotFound = ‘Erreur: utilisateur non trouvé’;
}

if (user.role == Roles.admin) { /* ... */ }
print(ErrorMessages.userNotFound);
```

#### Enum switch case

Utilisez des `enum` combinés avec `switch` pour garantir que tous les cas sont traités. Le compilateur vous avertira si un cas est manquant, ce qui évite les oublis.

```dart
// ❌ Bad
String getMessage(String status) {
  if (status == 'loading') {
    // Do something
  } else {
    // Do something
  }
}

// ✅ Good : le compilateur vérifie que tous les cas sont couverts
enum Status { loading, success, error }

String getMessage(Status status) {
  switch (status) {
    case Status.loading:
      return ‘Chargement...’;
    case Status.success:
      return ‘Succès !’;
    case Status.error:
      return ‘Une erreur est survenue’;
  }
}
```

#### Avoid redundancy

Évitez de stocker ou de passer plusieurs informations qui expriment la même chose. Si une donnée peut être déduite d’une autre, ne la dupliquez pas. Cela réduit les risques d’incohérence.

```dart
// ❌ Bad
class LogEntry {
  final String level;   // ‘error’
  final String color;   // ‘red’ -> déduit du level !
  final String message;

  LogEntry({required this.level, required this.color, required this.message});
}

// ✅ Good : la couleur est déduite du level
class LogEntry {
  final String level;
  final String message;

  LogEntry({required this.level, required this.message});

  String get color {
    switch (level) {
      case ‘error’: return ‘red’;
      case ‘warning’: return ‘orange’;
      default: return ‘white’;
    }
  }
}
```

#### Naming conventions

Le nommage est l’un des aspects les plus importants du clean code. Un bon nom doit être **descriptif**, **cohérent** et **sans ambiguïté**.

- **Classes** : nom, au singulier, en PascalCase (`UserRepository`, `PaymentService`)
- **Méthodes** : verbe d’action, en camelCase (`fetchUsers()`, `calculateTotal()`)
- **Booléens** : préfixés par `is`, `has`, `can` (`isLoading`, `hasPermission`)
- **Variables** : nom descriptif, en camelCase, évitez les abréviations (`userCount` plutôt que `uc`)
- **Constantes** : en camelCase en Dart (`defaultTimeout`), en SCREAMING_SNAKE_CASE dans d’autres langages comme Java

### Linter

Un **linter** est un outil d'analyse statique qui vérifie automatiquement le code source pour détecter des erreurs, des mauvaises pratiques et des incohérences de style, sans exécuter le programme.

**Le `Linter` permet de :**

- Détecter les erreurs avant l'exécution (variables inutilisées, imports manquants, types incorrects...)
- Imposer un style de code cohérent dans toute l'équipe
- Faciliter les code reviews en automatisant les vérifications de forme
- Réduire la dette technique en signalant les mauvaises pratiques au fur et à mesure

**Règle d'or** : votre code doit toujours avoir **0 warning et 0 error** avant de créer une Pull Request. Les warnings ignorés s'accumulent et finissent par masquer les vrais problèmes.

**Exemples de linters par langage** :

- **Dart/Flutter** : `dart analyze` avec le fichier `analysis_options.yaml`
- **JavaScript/TypeScript** : ESLint
- **Python** : Pylint, Ruff, Flake8
- **Kotlin** : Detekt, ktlint

**En pratique** :

- Configurez votre `Linter` dès le début du projet
- Intégrez-le dans votre IDE pour avoir un retour en temps réel. Dans VS Code, les erreurs et warnings du linter apparaissent directement dans l'onglet **"Problems"** (dans le panel en bas), avec un petit badge sur l'icône qui indique le nombre total de  détectés (warnings+errors)
- Ajoutez-le dans votre pipeline CI/CD pour bloquer les merges non conformes

### Cas d'usage : Flutter

#### Toujours utiliser final

En Dart, utilisez `final` pour toute variable dont la valeur ne change pas après l'initialisation. Cela rend le code plus lisible, plus sûr et aide le compilateur à optimiser.

```dart
// ❌ Bad
var name = 'Alice';
var items = [1, 2, 3];

// ✅ Good
final name = 'Alice';
final items = [1, 2, 3];
```

#### Paramètres nommés dans les constructeurs

Dans les constructeurs, il est préférable d'utiliser des **paramètres nommés** plutôt que des paramètres positionnels. Cela rend le code plus lisible, surtout quand il y a plusieurs paramètres.

```dart
// ❌ Bad
class User {
  final String name;
  final int age;
  final String email;

  User(this.name, this.age, this.email);
}

final user = User('Alice', 25, 'alice@mail.com'); // Quel paramètre est quoi ?

// ✅ Good : paramètres nommés
class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});
}

final user = User(name: 'Alice', age: 25, email: 'alice@mail.com');
```

#### State Management

Évitez d'appeler `setState()` dans de nombreuses méthodes d'un même widget. C'est le signe que la logique d'état est trop dispersée et difficile à suivre.

```dart
// ❌ Bad
class _MyWidgetState extends State<MyWidget> {
  void _someMethod() {
    setState(() { /* ... */ });
  }

  void _anotherMethod() {
    setState(() { /* ... */ });
  }
  // setState dans 20 méthodes différentes
}
```

```
// ✅ Good : Utiliser un state management approprié (Provider, Riverpod, BLoC)
```

#### Composition de widgets

Évitez les widgets géants avec des centaines de lignes imbriquées. Découpez en widgets plus petits et réutilisables.

```dart
// ❌ Bad : Un seul widget géant
Widget build(BuildContext context) {
  return Column(
    children: [
      // 500 lignes de widgets imbriqués
    ],
  );
}

// ✅ Good : Découper en widgets réutilisables
Widget build(BuildContext context) {
  return Column(
    children: [HeaderSection(), ContentSection(), FooterSection()]
  );
}
```

#### Abus de Singleton

Évitez de transformer tous vos services en Singleton. Cela crée un état global difficile à tester et à maintenir.

```dart
// ❌ Bad : Tout devient global et difficile à tester
class DatabaseService { /* Singleton */ }
class ApiService { /* Singleton */ }
class CacheService { /* Singleton */ }
class UserService { /* Singleton */ }

// ✅ Good : Utiliser l'injection de dépendances (exemple avec Riverpod)
final userServiceProvider = Provider<UserService>((ref) {
  return UserService(
    api: ref.read(apiServiceProvider),
    cache: ref.read(cacheServiceProvider),
  );
});
```

## Resources

**Programming principles Wiki :**
<https://wiki.c2.com/?PrinciplesOfObjectOrientedDesign>

**Refactoring :**
<https://refactoring.guru/refactoring>

**Optimize code for deletion :**
<https://programmingisterrible.com/post/139222674273/write-code-that-is-easy-to-delete-not-easy-to>

**Martin Fowler's principles :**
<https://www.martinfowler.com/>
<https://www.martinfowler.com/articles/injection.html>
<https://martinfowler.com/bliki/TolerantReader.html>
<https://martinfowler.com/bliki/CommandQuerySeparation.html>
