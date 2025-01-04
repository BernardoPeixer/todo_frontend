import 'package:fluent_ui/fluent_ui.dart';

/// Class responsible to set a padding
class PanelPadding {
  /// Padding to text form
  static EdgeInsets textFormPadding = const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 8,
  );

  /// Padding to modal
  static EdgeInsets modalPadding = const EdgeInsets.all(20);

  /// Padding to headers
  static EdgeInsets headerPadding = const EdgeInsets.symmetric(vertical: 2);

  /// Padding to button
  static EdgeInsets buttonPadding = const EdgeInsets.all(4);

  /// Padding to horizontal items
  static EdgeInsets horizontalItem = const EdgeInsets.symmetric(horizontal: 4);

  /// Padding to vertical items
  static EdgeInsets verticalItem = const EdgeInsets.symmetric(vertical: 8);
}
