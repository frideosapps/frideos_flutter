/// Interface to extend to define the own app state model
/// to use along with the [AppStateProvider]
///
abstract class AppStateModel {
  /// This method is called in the `initState` method of the `State` class
  /// associated to the [AppStateProvider].
  void init();

  void dispose();
}
