class Cat {
  final String id;
  final String name;
  final String origin;

  final String nameUpperCase;

  const Cat({
    required this.id,
    required this.name,
    required this.origin,
    this.nameUpperCase = '',
  });

  String describe() => 'Cat: $name from $origin';
}
