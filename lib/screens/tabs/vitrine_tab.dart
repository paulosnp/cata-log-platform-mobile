import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';

class VitrineTab extends StatefulWidget {
  const VitrineTab({super.key});

  @override
  State<VitrineTab> createState() => _VitrineTabState();
}

class _VitrineTabState extends State<VitrineTab> {
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
                // ─── Logo SVG ─────────────────────────────
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 40,
                ),
                const SizedBox(height: 20),
                Text(
                  'Minha Vitrine',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.56,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gerencie seus produtos e o status da sua galeria.',
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

        // ─── Stats bar ────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                _StatChip(
                  label: 'Ativos',
                  value: mockProdutos.where((p) => p.ativo && !p.vendido).length.toString(),
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Peças Únicas',
                  value: mockProdutos.where((p) => p.pecaUnica).length.toString(),
                  color: AppColors.tertiary,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Vendidos',
                  value: mockProdutos.where((p) => p.vendido).length.toString(),
                  color: AppColors.statusVendido,
                ),
              ],
            ),
          ),
        ),

        // ─── Product List ────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final produto = mockProdutos[index];
                return _ProdutoCard(
                  produto: produto,
                  onMarcarVendida: () => _confirmarVenda(produto),
                );
              },
              childCount: mockProdutos.length,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmarVenda(Produto produto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Venda'),
        content: Text(
          'Deseja marcar "${produto.titulo}" como vendida?\n\nEsta ação indicará que a peça única já foi comercializada.',
          style: GoogleFonts.manrope(
            fontSize: 14,
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                produto.vendido = true;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 "${produto.titulo}" marcada como vendida!'),
                ),
              );
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// STAT CHIP
// ──────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRODUTO CARD
// ──────────────────────────────────────────────────────────────

class _ProdutoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onMarcarVendida;

  const _ProdutoCard({
    required this.produto,
    required this.onMarcarVendida,
  });

  @override
  Widget build(BuildContext context) {
    final bool showVenderBtn =
        produto.pecaUnica && !produto.vendido;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusMd),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    produto.imagemUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  // Overlay gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  if (produto.pecaUnica)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: produto.vendido
                              ? AppColors.statusVendido
                              : AppColors.tertiary,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          produto.vendido ? 'VENDIDA' : 'PEÇA ÚNICA',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.titulo,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                if (showVenderBtn) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onMarcarVendida,
                      icon: const Icon(Icons.sell_outlined, size: 18),
                      label: Text(
                        'Marcar como Vendida',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
