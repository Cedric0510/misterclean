import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/cat.dart';

final filterCatsUseCaseProvider = Provider<FilterCats>((ref) {
  return const FilterCats();
});

class FilterCats implements UseCase<List<Cat>, FilterCatsParams> {
  const FilterCats();

  @override
  Future<List<Cat>> call(FilterCatsParams params) async {
    if (params.query.isEmpty) return params.cats;
    final lowerQuery = params.query.toLowerCase();
    return params.cats
        .where((cat) => cat.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

class FilterCatsParams {
  final List<Cat> cats;
  final String query;
  const FilterCatsParams({required this.cats, required this.query});
}
