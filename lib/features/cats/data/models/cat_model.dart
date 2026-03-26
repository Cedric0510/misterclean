import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  const CatModel({
    required String id,
    required String name,
    required String origin,
    String nameUpperCase = '',
  }) : super(
            id: id,
            name: name,
            origin: origin,
            nameUpperCase: nameUpperCase);

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      origin: json['origin'] as String,
    );
  }

  @override
  String describe() {
    throw UnsupportedError('CatModel should not be described directly');
  }
}
