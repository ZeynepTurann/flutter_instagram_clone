/// {@template api_repository}
/// A fake api repository.
/// {@endtemplate}
class ApiRepository {
  /// {@macro api_repository}
  const ApiRepository();

  List<String> fetchToDos() => ['make homework', 'go to shop', 'cook the dinner'];
}
