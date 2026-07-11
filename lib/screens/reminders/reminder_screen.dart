import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/switch_theme_button.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/reminders/components/reminder_dialogs.dart';
import 'package:medcare_app/screens/reminders/custom_form.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/services/user_service.dart';

class ReminderScreen
    extends StatefulWidget {
  const ReminderScreen({
    super.key,
  });

  @override
  State<ReminderScreen> createState() =>
      _ReminderScreenState();
}

class _ReminderScreenState
    extends State<ReminderScreen> {
  late List<Reminder> reminders;

  bool _selectionMode = false;

  final Set<Reminder>
      _selectedReminders = {};

  @override
  void initState() {
    super.initState();

    DataService.configureUserScopedData(
      isDemoUser:
          UserService.isDemoUser,
      userId:
          UserService.currentUserId,
    );

    reminders =
        DataService.allReminders;
  }

  Future<void> _showForm([
    Reminder? item,
  ]) async {
    if (!mounted) {
      return;
    }

    final bool? result =
        await ReminderDialogs.showForm(
      context,
      CustomForm(
        reminder: item,
      ),
    );

    if (result == true &&
        mounted) {
      setState(() {
        reminders =
            DataService.allReminders;
      });
    }
  }

  void _toggleSelection(
    Reminder item,
  ) {
    setState(() {
      if (_selectedReminders
          .contains(item)) {
        _selectedReminders
            .remove(item);
      } else {
        _selectedReminders
            .add(item);
      }

      if (_selectedReminders
          .isEmpty) {
        _selectionMode = false;
      }
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectionMode
              ? '${_selectedReminders.length} selected'
              : 'Reminders',
        ),
        backgroundColor:
            _selectionMode
                ? AppColors.strongRed
                : null,
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () {
                  setState(() {
                    _selectionMode =
                        false;

                    _selectedReminders
                        .clear();
                  });
                },
              )
            : null,
        actions: _selectionMode
            ? _buildSelectionActions()
            : const [
                SwitchThemeButton(),
              ],
      ),
      floatingActionButton:
          _selectionMode
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    _showForm();
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                ),
      body: reminders.isEmpty
          ? _buildEmptyState()
          : _buildReminderList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .notifications_none_rounded,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onTertiary,
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'No reminders yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Tap the + button to create '
              'a medication or custom reminder.',
              textAlign:
                  TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderList() {
    return ListView.builder(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        150,
      ),
      itemCount: reminders.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        final Reminder item =
            reminders[index];

        final bool selected =
            _selectedReminders
                .contains(item);

        return Card(
          margin:
              const EdgeInsets.only(
            bottom: 20,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
            onTap: _selectionMode
                ? () {
                    _toggleSelection(
                      item,
                    );
                  }
                : () {
                    if (item.type ==
                        ReminderType
                            .custom) {
                      _showForm(item);
                    }
                  },
            onLongPress: () {
              setState(() {
                _selectionMode = true;

                _selectedReminders
                    .add(item);

                item
                    .debugPrintSchedule();
              });
            },
            selected: selected,
            selectedTileColor:
                Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(50),
            leading: CircleAvatar(
              backgroundColor:
                  _getCategoryColor(
                item.type,
              ).withAlpha(50),
              child: Icon(
                _getCategoryIcon(
                  item.type,
                ),
                color:
                    _getCategoryColor(
                  item.type,
                ),
                size: 20,
              ),
            ),
            title: Text(
              item.title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            subtitle:
                _buildSubtitle(item),
            trailing: _selectionMode
                ? Icon(
                    selected
                        ? Icons.check_circle
                        : Icons
                            .radio_button_unchecked,
                    color: selected
                        ? Colors.blue
                        : null,
                  )
                : Transform.scale(
                    scale: 0.8,
                    child:
                        Switch.adaptive(
                      value:
                          item.enabled,
                      onChanged:
                          (bool value) {
                        setState(() {
                          item.enabled =
                              value;
                        });
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }

  List<Widget>
      _buildSelectionActions() {
    return [
      IconButton(
        icon: Icon(
          _selectedReminders.length ==
                  reminders.length
              ? Icons.select_all
              : Icons.checklist_rtl,
        ),
        onPressed: () {
          setState(() {
            if (_selectedReminders
                    .length ==
                reminders.length) {
              _selectedReminders
                  .clear();
            } else {
              _selectedReminders
                  .addAll(
                reminders,
              );
            }
          });
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.delete_outline,
        ),
        onPressed:
            _selectedReminders
                    .isEmpty
                ? null
                : _confirmGroupDelete,
      ),
    ];
  }

  void _confirmGroupDelete() {
    showWarningDialog(
      context,
      title: 'Delete',
      content:
          'Delete '
          '${_selectedReminders.length} '
          'items?',
      actionText: 'Delete',
      actionColor:
          AppColors.strongRed,
      onTapAction: () {
        setState(() {
          DataService.allReminders
              .removeWhere(
            (Reminder reminder) =>
                _selectedReminders
                    .contains(
              reminder,
            ),
          );

          reminders =
              DataService.allReminders;

          _selectionMode = false;

          _selectedReminders
              .clear();
        });

        showCustomSnackbar(
          context,
          'Reminder deleted successfully!',
          type:
              SnackbarType.success,
        );

        context.pop();
      },
      onTapBack: () {
        context.pop();
      },
    );
  }

  IconData _getCategoryIcon(
    ReminderType type,
  ) {
    return type ==
            ReminderType.medication
        ? Icons.medication
        : Icons.notifications_active;
  }

  Color _getCategoryColor(
    ReminderType type,
  ) {
    return type ==
            ReminderType.medication
        ? const Color(0xFF27AE60)
        : const Color(0xFFFD79A8);
  }

  Widget _buildSubtitle(
    Reminder item,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                '${item.formatReminderDisplay()}\n',
            style:
                const TextStyle(
              fontSize: 14,
            ),
          ),
          TextSpan(
            text:
                item.frequencyLabel,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}