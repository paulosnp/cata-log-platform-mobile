import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'tabs/vitrine_tab.dart';
import 'tabs/encomendas_tab.dart';
import 'tabs/financeiro_tab.dart';
import 'nova_obra_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Usamos GlobalKeys para poder chamar setState nas tabs quando necessário
  final _vitrineKey = GlobalKey<State>();

  List<Widget> get _tabs => [
    VitrineTab(key: _vitrineKey),
    const EncomendasTab(),
    const FinanceiroTab(),
  ];

  void _abrirNovaObra() async {
    final result = await Navigator.of(context).push<bool>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NovaObraScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (result == true && mounted) {
      // Volta para a aba Vitrine e força rebuild
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _tabs[_currentIndex],
      ),
      // ─── FAB: Botão + acima do BottomNav ─────────────
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _abrirNovaObra,
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.onPrimary,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_outlined),
                  activeIcon: Icon(Icons.storefront_rounded),
                  label: 'Minha Vitrine',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_outlined),
                  activeIcon: Icon(Icons.assignment_rounded),
                  label: 'Encomendas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payments_outlined),
                  activeIcon: Icon(Icons.payments_rounded),
                  label: 'Financeiro',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
