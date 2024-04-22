abstract class RepositoryInterface<T> {
  Future<dynamic> add(T value);

  Future<dynamic> update(Map<String, dynamic> body, int? id);

  Future<dynamic> delete(int? id);

  Future<dynamic> getList({int? offset});

  Future<dynamic> get(String? id);
}