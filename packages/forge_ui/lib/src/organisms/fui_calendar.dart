import 'package:flutter/material.dart';

import '../tokens/fui_tokens.dart';
import '../atoms/fui_icon_button.dart';
import '../atoms/fui_text.dart';

/// A month-grid date picker. Navigates month-by-month, marks today, highlights
/// the selection, and disables days outside [firstDate]..[lastDate]. Pure
/// `DateTime` — no packages, no locale assets.
class FUICalendar extends StatefulWidget {
  const FUICalendar({
    this.initialMonth,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    super.key,
  });

  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<FUICalendar> createState() => _FUICalendarState();
}

class _FUICalendarState extends State<FUICalendar> {
  late DateTime _month; // first day of the displayed month
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedDate;
    final anchor = widget.initialMonth ?? widget.selectedDate ?? DateTime.now();
    _month = DateTime(anchor.year, anchor.month);
  }

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December', //
  ];
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDisabled(DateTime day) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null &&
        day.isBefore(DateTime(first.year, first.month, first.day))) {
      return true;
    }
    if (last != null &&
        day.isAfter(DateTime(last.year, last.month, last.day))) {
      return true;
    }
    return false;
  }

  void _shiftMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  void _select(DateTime day) {
    setState(() => _selected = day);
    widget.onDateSelected?.call(day);
  }

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);
    final today = DateTime.now();
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leadingBlanks = _month.weekday % 7; // Sunday-first grid

    final cells = <Widget>[
      for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++)
        _DayCell(
          day: DateTime(_month.year, _month.month, d),
          isSelected: _selected != null &&
              _sameDay(_selected!, DateTime(_month.year, _month.month, d)),
          isToday: _sameDay(today, DateTime(_month.year, _month.month, d)),
          isDisabled: _isDisabled(DateTime(_month.year, _month.month, d)),
          onTap: _select,
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            FUIIconButton(
              icon: FUIIcons.chevronLeft,
              onPressed: () => _shiftMonth(-1),
            ),
            Expanded(
              child: Center(
                child: FUIText('${_months[_month.month - 1]} ${_month.year}',
                    variant: FUITextVariant.titleMd),
              ),
            ),
            FUIIconButton(
              icon: FUIIcons.chevronRight,
              onPressed: () => _shiftMonth(1),
            ),
          ],
        ),
        SizedBox(height: fui.spacing.sm),
        Row(
          children: [
            for (final w in _weekdays)
              Expanded(
                child: Center(
                  child: FUIText(w,
                      variant: FUITextVariant.caption,
                      color: FUITextColor.subtle),
                ),
              ),
          ],
        ),
        SizedBox(height: fui.spacing.xs),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cells,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isDisabled,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final fui = FUITheme.of(context);

    final Color fg;
    if (isDisabled) {
      fg = fui.resolve(fui.colors.onDisabled);
    } else if (isSelected) {
      fg = fui.resolve(fui.colors.onPrimary);
    } else {
      fg = fui.resolve(fui.colors.onSurface);
    }

    return Padding(
      padding: EdgeInsets.all(fui.spacing.xs),
      child: GestureDetector(
        onTap: isDisabled ? null : () => onTap(day),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? fui.resolve(fui.colors.primary) : null,
            border: isToday && !isSelected
                ? Border.all(color: fui.resolve(fui.colors.primary))
                : null,
          ),
          child: Text(
            '${day.day}',
            style: fui.typography.bodySm.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}
