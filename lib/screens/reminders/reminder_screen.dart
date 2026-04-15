import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/switch_theme_button.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/reminders/custom_form.dart';
import 'package:medcare_app/screens/reminders/components/reminder_dialogs.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> reminders = DataService.allReminders;
  bool _selectionMode = false;
  final Set<Reminder> _selectedReminders = {};

  // Reusable form launcher for both Add and Edit
  void _showForm([Reminder? item]) async {
    if (!mounted) return;

    // Await the result from the bottom sheet
    final result = await ReminderDialogs.showForm(
      context,
      CustomForm(reminder: item),
    );

    // If the form returned true, refresh the UI
    if (result == true && mounted) {
      setState(() {
        // Re-assigning the reference ensures the ListView updates
        reminders = List.from(DataService.allReminders);
      });
    }
  }

  // Allow adding and removing items for deletion
  void _toggleSelection(Reminder item) => setState(() {
    _selectedReminders.contains(item)
        ? _selectedReminders.remove(item)
        : _selectedReminders.add(item);
    if (_selectedReminders.isEmpty) _selectionMode = false;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectionMode
              ? '${_selectedReminders.length} selected'
              : 'Reminders',
        ),
        backgroundColor: _selectionMode ? AppColors.strongRed : null,
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectionMode = false;
                  _selectedReminders.clear();
                }),
              )
            : null,
        actions: _selectionMode
            ? _buildSelectionActions()
            : [SwitchThemeButton()],
      ),
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => _showForm(),
              child: const Icon(Icons.add),
            ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 150),
        itemCount: reminders.length,
        itemBuilder: (context, i) {
          final item = reminders[i];
          final selected = _selectedReminders.contains(item);
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 12,
              ),
              onTap: _selectionMode
                  ? () => _toggleSelection(item)
                  : () {
                      if (item.type == ReminderType.custom) {
                        _showForm(
                          item,
                        ); // Only allow editing for custom reminders
                      }
                    },
              // Enter deletion mode after long press
              onLongPress: () => setState(() {
                _selectionMode = true;
                _selectedReminders.add(item);
                item.debugPrintSchedule();
              }),
              selected: selected,
              selectedTileColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(50),
              leading: CircleAvatar(
                backgroundColor: _getCategoryColor(item.type).withAlpha(50),
                child: Icon(
                  _getCategoryIcon(item.type),
                  color: _getCategoryColor(item.type),
                  size: 20,
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: _buildSubtitle(item),
              trailing: _selectionMode
                  ? Icon(
                      selected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selected ? Colors.blue : null,
                    )
                  : Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: item.enabled,
                        // Enable reminder
                        onChanged: (v) => setState(() => item.enabled = v),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSelectionActions() => [
    IconButton(
      icon: Icon(
        _selectedReminders.length == reminders.length
            ? Icons.select_all
            : Icons.checklist_rtl,
      ),
      onPressed: () => setState(
        () => _selectedReminders.length == reminders.length
            ? _selectedReminders.clear()
            : _selectedReminders.addAll(reminders),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: _selectedReminders.isEmpty ? null : _confirmGroupDelete,
    ),
  ];

  void _confirmGroupDelete() => showWarningDialog(
    context,
    title: 'Delete',
    content: 'Delete ${_selectedReminders.length} items?',
    actionText: 'Delete',
    actionColor: AppColors.strongRed,
    onTapAction: () {
      setState(() {
        reminders.removeWhere((r) => _selectedReminders.contains(r));
        _selectionMode = false;
        _selectedReminders.clear();
      });
      showCustomSnackbar(
        context,
        'Reminder deleted successfully!',
        type: SnackbarType.success,
      );
      context.pop();
    },
    onTapBack: () => context.pop(),
  );

  IconData _getCategoryIcon(ReminderType t) => t == ReminderType.medication
      ? Icons.medication
      : Icons.notifications_active;
  Color _getCategoryColor(ReminderType t) => t == ReminderType.medication
      ? const Color(0xFF27AE60)
      : const Color(0xFFFD79A8);
  Widget _buildSubtitle(Reminder item) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "${item.formatReminderDisplay()}\n",
          style: const TextStyle(fontSize: 14),
        ),
        TextSpan(
          text: item.frequencyLabel,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        ),
      ],
    ),
  );
}
