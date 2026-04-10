import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../orcamento_screen.dart';
import '../chat_screen.dart';

class EncomendasTab extends StatefulWidget {
  const EncomendasTab({super.key});

  @override
  State<EncomendasTab> createState() => _EncomendasTabState();
}

class _EncomendasTabState extends State<EncomendasTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ─── Header ──────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.subtleGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.assignment_rounded,
                        color: AppColors.onPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Encomendas',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Gerencie seus pedidos personalizados.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── Encomendas List ──────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final encomenda = mockEncomendas[index];
                return _EncomendaCard(
                  encomenda: encomenda,
                  onTap: () => _handleEncomendaTap(encomenda),
                );
              },
              childCount: mockEncomendas.length,
            ),
          ),
        ),
      ],
    );
  }

  void _handleEncomendaTap(Encomenda encomenda) async {
    if (encomenda.status == 'AGUARDANDO_ARTESAO') {
      // Abre a tela de orçamento e espera o resultado
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => OrcamentoScreen(encomenda: encomenda),
        ),
      );
      // Se o orçamento foi enviado, atualiza a UI e abre o chat
      if (result == true && mounted) {
        setState(() {}); // refresh status
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(encomenda: encomenda),
          ),
        );
      }
    } else {
      // Já tem orçamento, abre o chat direto
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(encomenda: encomenda),
        ),
      );
    }
  }
}

// ──────────────────────────────────────────────────────────────
// ENCOMENDA CARD
// ──────────────────────────────────────────────────────────────

class _EncomendaCard extends StatelessWidget {
  final Encomenda encomenda;
  final VoidCallback onTap;

  const _EncomendaCard({
    required this.encomenda,
    required this.onTap,
  });

  bool get isAguardando => encomenda.status == 'AGUARDANDO_ARTESAO';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: client + status
            Row(
              children: [
                // Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isAguardando
                        ? AppColors.statusAguardando.withValues(alpha: 0.12)
                        : AppColors.statusOrcamentoEnviado.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      encomenda.nomeCliente[0].toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isAguardando
                            ? AppColors.statusAguardando
                            : AppColors.statusOrcamentoEnviado,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        encomenda.nomeCliente,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#${encomenda.id}',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isAguardando: isAguardando),
              ],
            ),
            const SizedBox(height: 14),

            // Peça referência
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      encomenda.pecaReferencia,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // If orçamento enviado, show price and prazo
            if (!isAguardando && encomenda.precoProposto != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  _InfoTag(
                    icon: Icons.payments_outlined,
                    label:
                        'R\$ ${encomenda.precoProposto!.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),
                  const SizedBox(width: 12),
                  if (encomenda.prazoDias != null)
                    _InfoTag(
                      icon: Icons.schedule_outlined,
                      label: '${encomenda.prazoDias} dias',
                    ),
                ],
              ),
            ],

            const SizedBox(height: 14),
            // Action hint
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isAguardando ? 'Enviar Orçamento' : 'Abrir Chat',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAguardando;
  const _StatusBadge({required this.isAguardando});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isAguardando
            ? AppColors.statusAguardando.withValues(alpha: 0.12)
            : AppColors.statusOrcamentoEnviado.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Text(
        isAguardando ? 'Aguardando' : 'Enviado',
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isAguardando
              ? AppColors.statusAguardando
              : AppColors.statusOrcamentoEnviado,
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
