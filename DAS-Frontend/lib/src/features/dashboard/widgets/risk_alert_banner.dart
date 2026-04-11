import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pm/src/features/dashboard/dashboard_service.dart';

class RiskAlertBanner extends StatefulWidget {
  final List<Risk> risks;
  const RiskAlertBanner({super.key, required this.risks});

  @override
  State<RiskAlertBanner> createState() => _RiskAlertBannerState();
}

class _RiskAlertBannerState extends State<RiskAlertBanner> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.risks.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final criticalCount = widget.risks.where((r) => r.isCritical).length;
    final warningCount = widget.risks.length - criticalCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3F1D1D) : Colors.red.shade50,
        border: Border(left: BorderSide(color: Colors.red.shade600, width: 4)),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const Icon(FontAwesomeIcons.triangleExclamation,
                          color: Colors.red),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle))),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Attention Required",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade900,
                                fontSize: 16)),
                        if (!isExpanded)
                          Text(
                              "$criticalCount critical, $warningCount warnings.",
                              style: TextStyle(
                                  color: Colors.red.shade700, fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.red.shade400),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: widget.risks.map((risk) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: risk.isCritical
                              ? (isDark
                                  ? Colors.red.shade800
                                  : Colors.red.shade100)
                              : (isDark
                                  ? Colors.orange.shade800
                                  : Colors.orange.shade100)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                            risk.isCritical
                                ? FontAwesomeIcons.circleExclamation
                                : FontAwesomeIcons.triangleExclamation,
                            size: 14,
                            color:
                                risk.isCritical ? Colors.red : Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(risk.message,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
