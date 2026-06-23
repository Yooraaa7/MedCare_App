import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Healthcare Dashboard',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const _StatsSection(),

          const SizedBox(height: 30),

          Text(
            'Recent Healthcare Journey',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          TimelineSection(),

          const SizedBox(height: 30),

          Text(
            'Monthly Visit Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          const _VisitTrendChart(),

          const SizedBox(height: 30),

          Text(
            'Appointment Distribution',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          const _AppointmentPieChart(),

          const SizedBox(height: 30),

          Text(
            'Completion Rate',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              width: 280,
              child: const _CompletionRateCard(),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            'Healthcare Insights',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          const _HealthcareInsightsSection(),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: const [
        _StatCard(
          title: "Total Visits",
          value: "18",
          icon: Icons.calendar_month,
        ),
        _StatCard(
          title: "Completed",
          value: "15",
          icon: Icons.check_circle,
        ),
        _StatCard(
          title: "Vaccinations",
          value: "4",
          icon: Icons.vaccines,
        ),
        _StatCard(
          title: "Health Packages",
          value: "3",
          icon: Icons.medical_services,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitTrendChart extends StatelessWidget {
  const _VisitTrendChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun'
                  ];

                  if (value.toInt() >= months.length) {
                    return const SizedBox();
                  }

                  return Text(months[value.toInt()]);
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 4),
                FlSpot(3, 2),
                FlSpot(4, 5),
                FlSpot(5, 6),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentPieChart extends StatelessWidget {
  const _AppointmentPieChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              value: 60,
              title: 'Doctor\n60%',
              radius: 90,
            ),
            PieChartSectionData(
              value: 25,
              title: 'Vaccine\n25%',
              radius: 90,
            ),
            PieChartSectionData(
              value: 15,
              title: 'Package\n15%',
              radius: 90,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionRateCard extends StatelessWidget {
  const _CompletionRateCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: 0.83,
                strokeWidth: 12,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '83%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Appointment Completion Rate'),
          ],
        ),
      ),
    );
  }
}

class _HealthcareInsightsSection extends StatelessWidget {
  const _HealthcareInsightsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Most Visited Department'),
            subtitle: Text('Cardiology (6 visits)'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Primary Service Used'),
            subtitle: Text('Doctor Consultation'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Average Monthly Visits'),
            subtitle: Text('3 visits per month'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text('Latest Health Package'),
            subtitle: Text('Executive Health Screening'),
          ),
        ],
      ),
    );
  }
}

class TimelineSection extends StatefulWidget {
  const TimelineSection({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  bool showAll = false;

  final List<Map<String, dynamic>> journeys = [
    {
      "icon": Icons.medical_services,
      "title": "Cardiology Consultation",
      "date": "15 June 2026",
    },
    {
      "icon": Icons.vaccines,
      "title": "Influenza Vaccination",
      "date": "08 June 2026",
    },
    {
      "icon": Icons.health_and_safety,
      "title": "Executive Health Screening",
      "date": "22 May 2026",
    },
    {
      "icon": Icons.person,
      "title": "Orthopaedic Follow-up",
      "date": "10 May 2026",
    },
    {
      "icon": Icons.medication,
      "title": "Diabetes Check-up",
      "date": "28 April 2026",
    },
    {
      "icon": Icons.monitor_heart,
      "title": "Cardiac Stress Test",
      "date": "16 April 2026",
    },
    {
      "icon": Icons.local_hospital,
      "title": "General Consultation",
      "date": "03 April 2026",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final displayed =
        showAll ? journeys : journeys.take(4).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ...displayed.map(
              (journey) => Column(
                children: [
                  ListTile(
                    leading: Icon(journey["icon"]),
                    title: Text(journey["title"]),
                    subtitle: Text(journey["date"]),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  top: 4,
                  bottom: 8,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(
                    showAll ? "Show Less" : "Show More",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}