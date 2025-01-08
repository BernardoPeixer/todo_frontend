import 'package:fluent_ui/fluent_ui.dart';

import 'outlined_button_default.dart';

/// Class to content dialog default
class ContentDialogDefault extends StatelessWidget {
  /// Actions widget
  final List<Widget> actions;

  /// Content widget
  final Widget content;

  /// Title widget
  final String title;

  /// Boolean to show close button
  final bool? closeButton;

  /// Box constraints
  final BoxConstraints? boxConstraints;

  /// Constructor
  const ContentDialogDefault({
    super.key,
    required this.actions,
    required this.content,
    required this.title,
    this.closeButton,
    this.boxConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: boxConstraints ??
          const BoxConstraints(
            maxWidth: 600,
          ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (closeButton ?? true)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
            ),
          ),
          if (closeButton ?? true)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: OutlinedButtonDefault.withIcon(
                backgroundColor: Colors.grey.withOpacity(0.1),
                title: 'Fechar',
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.black,
                fontColor: Colors.black,
                icon: FluentIcons.cancel,
                iconInLeft: true,
                buttonPadding: const EdgeInsets.all(6),
              ),
            ),
        ],
      ),
      content: content,
      actions: actions,
    );
  }
}
