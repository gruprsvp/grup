/// Contains all stateful and stateless widgets used in the presentation layer.
/// This includes all screens, widgets, and containers.
/// * [containers] - Smart widgets that use StoreProvider to access the state.
/// * [screens] - Scaffold widgets that are the root of a page.
/// * [widgets] - Stateless widgets and stateful widgets that do not use StoreProvider.
library;

export 'containers/containers.dart';
export 'screens/screens.dart';
export 'widgets/widgets.dart';
