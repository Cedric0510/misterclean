import 'package:app/features/cats/data/repositories/cat_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

final getCatsUseCaseProvider = Provider<GetCats>((ref) {
  return GetCats(ref.watch(catRepositoryProvider));
});

class GetCats implements UseCase<List<Cat>, GetCatsParams> {
  final CatRepository repository;

  const GetCats(this.repository);

  @override
  Future<List<Cat>> call(GetCatsParams params) {
    return repository.getCats(page: params.page);
  }
}

class GetCatsParams {
  final int page;
  const GetCatsParams({required this.page});
}
