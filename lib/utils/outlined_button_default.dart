import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/style/panel_colors.dart';
import '../core/style/panel_padding.dart';

/// Util created to button default
class OutlinedButtonDefault extends StatelessWidget {
  /// Constructor
  const OutlinedButtonDefault({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.buttonPadding,
    this.iconInLeft = false,
    this.alignment,
    this.textStyle,
    this.fontColor,
  });

  /// Constructor to button with icon
  const OutlinedButtonDefault.withIcon({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.buttonPadding,
    this.iconInLeft = false,
    this.alignment,
    this.textStyle,
    this.fontColor,
  });

  /// Button title
  final String title;

  /// Button on tap
  final VoidCallback onTap;

  /// Background button color
  final Color? backgroundColor;

  /// Button with icon
  final IconData? icon;

  /// Color from icon button
  final Color? iconColor;

  /// Button padding
  final EdgeInsets? buttonPadding;

  /// Icon stay in left
  final bool? iconInLeft;

  /// Button content alignment
  final MainAxisAlignment? alignment;

  /// Button text style
  final TextStyle? textStyle;

  /// Button text color
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: backgroundColor ?? PanelColors.lightBlue,
          ),
          padding: buttonPadding ?? PanelPadding.buttonPadding,
          child: Row(
            mainAxisAlignment: alignment ?? MainAxisAlignment.center,
            children: [
              if (icon != null && (iconInLeft ?? false)) ...[
                Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                ),
                Padding(padding: PanelPadding.horizontalItem),
              ],
              Text(
                title,
                style: textStyle ??
                    GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: fontColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              ),
              if (icon != null && !(iconInLeft ?? false)) ...[
                Padding(padding: PanelPadding.horizontalItem),
                Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
