import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;
  final String? helpText;

  const FormFieldWrapper({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        child,
        if (helpText != null) ...[
          const SizedBox(height: 4),
          Text(
            helpText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}