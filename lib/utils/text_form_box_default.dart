import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/style/panel_colors.dart';
import '../core/style/panel_padding.dart';

/// Util created to form box default
class TextFormBoxDefault extends StatelessWidget {
  /// Constructor
  const TextFormBoxDefault({
    super.key,
    this.controller,
    this.focus,
    this.padding,
    this.maxLines,
    this.validator,
    this.header,
    this.placeholder,
    this.maxLength,
    this.autoFocus,
    this.enabled,
  });

  /// Text controller
  final TextEditingController? controller;

  /// Focus form box
  final FocusNode? focus;

  /// Padding form box
  final EdgeInsets? padding;

  /// Max lines form box
  final int? maxLines;

  /// Validator function
  final FormFieldValidator<String>? validator;

  /// Form box header
  final String? header;

  /// Form box placeholder
  final String? placeholder;

  /// Form box max length
  final int? maxLength;

  /// Form box has auto focus
  final bool? autoFocus;

  /// Form box is enabled
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Text(
            header ?? '',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Padding(padding: PanelPadding.headerPadding),
        TextFormBox(
          placeholder: placeholder,
          focusNode: focus ?? FocusNode(),
          controller: controller ?? TextEditingController(),
          padding: padding ?? PanelPadding.textFormPadding,
          decoration: BoxDecoration(
            color: PanelColors.offWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PanelColors.littleGrey, width: 1.5),
          ),
          autofocus: autoFocus ?? false,
          unfocusedColor: Colors.transparent,
          highlightColor: Colors.blue,
          enabled: enabled ?? true,
          style: GoogleFonts.roboto(
            fontSize: 16,
          ),
          maxLines: maxLines ?? 1,
          validator: validator,
          maxLength: maxLength,
        ),
      ],
    );
  }
}
