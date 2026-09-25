import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/payments/providers/payments_provider.dart';
import 'features/quotes/providers/quotes_provider.dart';
import 'features/quotes/screens/my_quotes_screen.dart';
import 'features/requests/providers/requests_provider.dart';
import 'features/requests/screens/available_requests_screen.dart';
import 'features/requests/screens/my_requests_screen.dart';
import 'features/reviews/providers/reviews_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuraTechApp());
}

class AuraTechApp extends StatelessWidget {
  const AuraTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => RequestsProvider()),
        ChangeNotifierProvider(create: (_) => QuotesProvider()),
        ChangeNotifierProvider(create: (_) => PaymentsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
      ],
      child: MaterialApp(
        title: 'AuraTech',
        debugShowCheckedModeBanner: false,
        theme: AuraTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const MainNavigationScaffold();
        }
        return const LoginScreen();
      },
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isTecnico = auth.currentUser?.rol == 'TECNICO';

    final screens = [
      if (isTecnico) const AvailableRequestsScreen() else const MyRequestsScreen(),
      if (isTecnico) const MyQuotesScreen() else const AvailableRequestsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(isTecnico ? LucideIcons.briefcase : LucideIcons.clipboardList),
            label: isTecnico ? 'Disponibles' : 'Mis Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(isTecnico ? LucideIcons.fileText : LucideIcons.search),
            label: isTecnico ? 'Mis Ofertas' : 'Explorar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFEFF6FF),
              child: const Icon(LucideIcons.user, size: 40, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            Text(
              user?.nombreCompleto ?? 'Usuario AuraTech',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Text(
                user?.rol ?? 'CLIENTE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(LucideIcons.logOut, size: 16),
                label: Text('Cerrar Sesión', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                onPressed: () => auth.logout(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
