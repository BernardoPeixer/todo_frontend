// ignore_for_file: unused_element

import 'package:fluent_ui/fluent_ui.dart';

OverlayEntry? _overlayEntry;

/// Function to open a custom menu
void showCustomMenu({
  required BuildContext context,
  required TapDownDetails event,
  required Widget child,
}) {
  _overlayEntry = OverlayEntry(builder: (context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: removeOverlay,
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Positioned(
          left: event.globalPosition.dx + 40,
          top: event.globalPosition.dy,
          child: child,
        ),
      ],
    );
  });

  Overlay.of(context).insert(_overlayEntry!);
}

/// Menu card item
class DefaultCustomMenuCard extends StatelessWidget {
  /// Constructor
  const DefaultCustomMenuCard({
    super.key,
    required this.child,
    this.constraints,
    this.backgroundColor,
  });

  /// Constructor with background transparent
  const DefaultCustomMenuCard.transparent({
    super.key,
    this.constraints,
    required this.child,
    this.backgroundColor = Colors.transparent,
  });

  /// Box constraints
  final BoxConstraints? constraints;

  /// Chiild to container
  final Widget child;

  /// Background color
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? Colors.white,
      ),
      constraints: constraints ??
          const BoxConstraints(
            minWidth: 100,
            maxHeight: 200,
          ),
      child: child,
    );
  }
}

/// Function to remove a overlay
void removeOverlay() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}
