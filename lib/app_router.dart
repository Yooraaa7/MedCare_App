import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/guest_guard.dart';
import 'package:medcare_app/general/components/main_layout_shell.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/screens/appointments_list/appointment_details_screen.dart';
import 'package:medcare_app/screens/appointments_list/appointments_screen.dart';
import 'package:medcare_app/screens/book_appointments/book_appointments_screen.dart';
import 'package:medcare_app/screens/book_appointments/book_package_screen.dart';
import 'package:medcare_app/screens/book_appointments/book_vaccines_screen.dart';
import 'package:medcare_app/screens/find_doctors/doctor_screen.dart';
import 'package:medcare_app/screens/find_doctors/find_doctor_screen.dart';
import 'package:medcare_app/screens/find_doctors/specialty_screen.dart';
import 'package:medcare_app/screens/home/home_screen.dart';
import 'package:medcare_app/screens/manage_payment/input_card_screen.dart';
import 'package:medcare_app/screens/manage_payment/card_details_screen.dart';
import 'package:medcare_app/screens/manage_payment/input_insurance_screen.dart';
import 'package:medcare_app/screens/manage_payment/insurance_details_screen.dart';
import 'package:medcare_app/screens/manage_payment/manage_payment_screen.dart';
import 'package:medcare_app/screens/notifications/notification_screen.dart';
import 'package:medcare_app/screens/packages/dna_decode/dna_decode_details_screen.dart';
import 'package:medcare_app/screens/packages/dna_decode/dna_report_screen.dart';
import 'package:medcare_app/screens/packages/packages_screen.dart';
import 'package:medcare_app/screens/patient_guide/admission_details_screen.dart';
import 'package:medcare_app/screens/patient_guide/contact_location_screen.dart';
import 'package:medcare_app/screens/patient_guide/general_information_screen.dart';
import 'package:medcare_app/screens/patient_guide/hospital_notice_screen.dart';
import 'package:medcare_app/screens/patient_guide/outpatient_registration_screen.dart';
import 'package:medcare_app/screens/patient_guide/patient_guide_screen.dart';
import 'package:medcare_app/screens/payment/bill_summary_screen.dart';
import 'package:medcare_app/screens/payment/card_selection_screen.dart';
import 'package:medcare_app/screens/payment/online_banking_screen.dart';
import 'package:medcare_app/screens/payment/pay_at_counter_screen.dart';
import 'package:medcare_app/screens/payment/payment_selection_screen.dart';
import 'package:medcare_app/screens/payment/payment_summary_screen.dart';
import 'package:medcare_app/screens/pdf_viewing/pdf_preview_screen.dart';
import 'package:medcare_app/screens/profile/edit_profile_screen.dart';
import 'package:medcare_app/screens/profile/help_support_screen.dart';
import 'package:medcare_app/screens/profile/profile_screen.dart';
import 'package:medcare_app/screens/profile/terms_menu_screen.dart';
import 'package:medcare_app/screens/reminders/reminder_screen.dart';
import 'package:medcare_app/screens/reset_password/create_new_password_screen.dart';
import 'package:medcare_app/screens/reset_password/sms_reset_screen.dart';
import 'package:medcare_app/screens/reset_password/otp_screen.dart';
import 'package:medcare_app/screens/signIn/login_screen.dart';
import 'package:medcare_app/screens/register/register_screen.dart';
import 'package:medcare_app/screens/terms_and_policy/privacy_policy.dart';
import 'package:medcare_app/screens/terms_and_policy/terms_screen.dart';
import 'package:medcare_app/services/auth_service.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/screens/chatbot/chatbot.dart';

// Paths that should be BLOCKED if logged in
final authEntryPaths = {'/', '/register'};

// Paths that are allowed for both logged-in and logged-out users
final publicUtilityPaths = {
  '/sms-reset',
  '/verify-otp',
  '/create-new-password',
  '/terms-of-use',
  '/privacy-policy',
};

class AppRouter {
  final AuthService authService;
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter(this.authService);

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authService,
    debugLogDiagnostics: true,

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),

    redirect: (context, state) {
      final isLoggedIn = authService.isAuthenticated;
      final isGuest = authService.isGuest;
      final location = state.matchedLocation;

      final isEntryPath = authEntryPaths.contains(location);
      final isUtilityPath = publicUtilityPaths.contains(location);

      // Force to Login if they try to access a protected page while logged out
      if (!isLoggedIn && !isGuest && !isEntryPath && !isUtilityPath) {
        return '/';
      }

      // ONLY redirect to /home if they try to hit Login or Register while already logged in
      if ((isLoggedIn || isGuest) && isEntryPath) {
        return '/home';
      }

      // Allow /verify-otp to proceed without redirection for BOTH states
      return null;
    },

    routes: [
      // --- ROOT LEVEL: AUTH GROUP (No Bottom Bar) ---
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/sms-reset',
        builder: (context, state) => const SMSResetScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) => const OTPScreen(),
      ),
      GoRoute(
        path: '/create-new-password',
        builder: (context, state) => const CreateNewPasswordScreen(),
      ),

      // --- SHELL LEVEL: MAIN APP (Bottom Bar Visible) ---
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainLayoutShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),

          GoRoute(
            path: '/appointments',
            builder: (context, state) {
              if (authService.isGuest) {
                return const GuestGuardScreen(
                  title: "Appointments",
                  subtitle:
                      "Sign in to manage your medical bookings, view history, and receive real-time updates.",
                  icon: Icons.calendar_today_outlined,
                );
              }
              return AppointmentsScreen(key: UniqueKey());
            },
            routes: [
              GoRoute(
                path: 'appointment-details/:id',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final found = DataService.allAppointments.firstWhere(
                    (a) => a.id == id,
                  );
                  return AppointmentDetailsScreen(appointment: found);
                },
              ),
            ],
          ),

          GoRoute(
            path: '/payment',
            builder: (context, state) {
              if (authService.isGuest) {
                return const GuestGuardScreen(
                  title: "Payment Summary",
                  subtitle:
                      "Securely settle your medical bills and view your transaction history by signing in.",
                  icon: Icons.credit_card,
                );
              }
              return PaymentSummaryScreen(key: UniqueKey());
            },
            routes: [
              GoRoute(
                path: 'bill-summary',
                builder: (context, state) => const BillSummaryScreen(),
              ),
            ],
          ),

          GoRoute(
            path: '/patient-guide',
            builder: (context, state) => const PatientGuideScreen(),
            routes: [
              GoRoute(
                path: 'admission-details',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const AdmissionDetailScreen(),
              ),
              GoRoute(
                path: 'general-information',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const GeneralInfoScreen(),
              ),
              GoRoute(
                path: 'hospital-notice',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const HospitalNoticeScreen(),
              ),
              GoRoute(
                path: 'contact-us',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const ContactLocationScreen(),
              ),
              GoRoute(
                path: 'outpatient-registration',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) =>
                    const OutpatientRegistrationScreen(),
              ),
            ],
          ),

          GoRoute(
            path: '/reminders',
            builder: (context, state) {
              if (authService.isGuest) {
                return const GuestGuardScreen(
                  title: "Reminders",
                  subtitle:
                      "Never miss a dose or an appointment. Sign in to set up personalized health notifications.",
                  icon: Icons.notifications_active_outlined,
                );
              }
              return const ReminderScreen();
            },
          ),
        ],
      ),

      // --- ROOT LEVEL: FULL SCREEN UTILITIES (No Bottom Bar) ---
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationScreen(),
      ),

      GoRoute(
        path: '/profile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit-profile',
            builder: (context, state) =>
                EditProfileScreen(user: state.extra as User),
          ),
          GoRoute(
            path: 'help-and-support',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'terms-menu',
            builder: (context, state) => const TermsMenuScreen(),
          ),
          GoRoute(
            path: 'manage-payment',
            builder: (context, state) => const ManagePaymentScreen(),
            routes: [
              GoRoute(
                path: 'card-details',
                builder: (context, state) =>
                    CardDetailsScreen(card: state.extra as CardDetails),
              ),
              GoRoute(
                path: 'insurance-details',
                builder: (context, state) => InsuranceDetailsScreen(
                  insurance: state.extra as InsuranceDetails,
                ),
              ),
              GoRoute(
                path: 'input-card',
                builder: (context, state) => InputCardScreen(
                  amount: double.tryParse(
                    state.uri.queryParameters['amount'] ?? '',
                  ),
                ),
              ),
              GoRoute(
                path: 'input-insurance',
                builder: (context, state) => const InputInsuranceScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/payment-selection', // Grouped payment flow outside shell
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => PaymentSelectionScreen(
          amount: double.parse(state.uri.queryParameters['amount'] ?? '0.0'),
        ), // Starting point
        routes: [
          GoRoute(
            path: 'card',
            builder: (context, state) => CardSelectionScreen(
              amount: double.parse(
                state.uri.queryParameters['amount'] ?? '0.0',
              ),
            ),
          ),
          GoRoute(
            path: 'online-banking',
            builder: (context, state) => OnlineBankingScreen(
              amount: double.parse(
                state.uri.queryParameters['amount'] ?? '0.0',
              ),
            ),
          ),
          GoRoute(
            path: 'pay-at-counter',
            builder: (context, state) => PayAtCounterScreen(
              amount: double.parse(
                state.uri.queryParameters['amount'] ?? '0.0',
              ),
            ),
          ),
        ],
      ),

      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),

      GoRoute(
        path: '/find-a-doctor',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => FindDoctorScreen(
          selectedSpecialty: state.uri.queryParameters['specialty'],
        ),
        routes: [
          GoRoute(
            path: 'doctor-details',
            builder: (context, state) =>
                DoctorScreen(doctor: state.extra as Doctor),
          ),
          GoRoute(
            path: 'specialty-details',
            builder: (context, state) =>
                SpecialtyScreen(specialty: state.extra as Specialty),
          ),
        ],
      ),

      GoRoute(
        path: '/packages',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PackagesScreen(),
        routes: [
          GoRoute(
            path: 'dna-decode',
            builder: (context, state) => const DnaDecodeDetailsScreen(),
            routes: [
              GoRoute(
                path: 'report-details',
                builder: (context, state) => DnaReportScreen(
                  type: state.uri.queryParameters['type'] ?? 'fit',
                ),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/book-doctor',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookAppointmentsScreen(
            doctor: extra['doctor'] as Doctor,
            existingAppointment: extra['appointment'] as DoctorAppointment?,
          );
        },
      ),

      GoRoute(
        path: '/book-package',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookPackageScreen(
            package: extra['package'] as Package,
            selectedType: state.uri.queryParameters['type'] ?? '',
            existingAppointment: extra['appointment'] as PackageAppointment?,
          );
        },
      ),

      GoRoute(
        path: '/book-vaccine',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BookVaccinesScreen(
          existingAppointment: state.extra as VaccineAppointment?,
        ),
      ),

      GoRoute(
        path: '/terms-of-use',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/pdf-preview',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            PdfPreviewScreen(filePath: state.extra as String),
      ),
    ],
  );
}
