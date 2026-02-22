/// A collection of utility functions for checking conditions and throwing
/// appropriate errors.
void checkState(bool condition, [String message = '']) {
  if (!condition) {
    throw StateError(message);
  }
}
