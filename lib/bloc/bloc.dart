enum UiState { normal, loading, error, networkError, complete }
enum ErrorType { networkError, accessForbidden, notFoundException }

abstract class Bloc {
  void dispose();
}