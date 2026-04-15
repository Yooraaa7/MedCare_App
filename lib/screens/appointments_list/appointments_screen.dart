import 'package:flutter/material.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/switch_theme_button.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_card.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Appointments'),
        actions: [SwitchThemeButton()],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onTertiary,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildCompletedTab(),
          _buildCancelledTab(),
        ],
      ),
    );
  }

  // Upcoming tab
  Widget _buildUpcomingTab() {
    // Group data
    final appointments = DataService.getActiveBookings();
    if (appointments.isEmpty)
      return _buildEmptyState("No upcoming appointments found.");

    final groupedAppointments = _groupAppointmentsByDate(appointments);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: groupedAppointments.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppointmentCard(
              date: DateTime.parse(entry.key),
              appointments: entry.value,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Completed Tab
  Widget _buildCompletedTab() {
    final completed = DataService.getAppointmentsByStatus(
      AppointmentStatus.completed,
      order: 'desc',
    );
    if (completed.isEmpty)
      return _buildEmptyState("No completed appointments found.");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children:
            DataService.getAppointmentsByStatus(
              AppointmentStatus.completed,
              order: 'desc',
            ).map((appointment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppointmentCard(
                  date: appointment.date,
                  appointments: [appointment],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCancelledTab() {
    final cancelled = DataService.getAppointmentsByStatus(
      AppointmentStatus.cancelled,
      order: 'desc',
    );

    if (cancelled.isEmpty) {
      return _buildEmptyState("No cancelled appointments found.");
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: cancelled.map((appointment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppointmentCard(
              date: appointment.date,
              appointments: [appointment],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Sort appointments of the same day to a single group
Map<String, List<BaseAppointment>> _groupAppointmentsByDate(
  List<BaseAppointment> appointments,
) {
  Map<String, List<BaseAppointment>> grouped = {};

  for (var app in appointments) {
    String dateKey = DateFormat('yyyy-MM-dd').format(app.date);

    if (grouped[dateKey] == null) {
      grouped[dateKey] = [];
    }

    grouped[dateKey]!.add(app);
  }

  return grouped;
}
