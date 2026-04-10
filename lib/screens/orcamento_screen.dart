import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class OrcamentoScreen extends StatefulWidget {
  final Encomenda encomenda;

  const OrcamentoScreen({super.key, required this.encomenda});

  @override
  State<OrcamentoScreen> createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _precoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _observacoesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _precoController.dispose();
    _prazoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrcamento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simula envio
    await Future.delayed(const Duration(milliseconds: 800));

    // Atualiza estado da encomenda
    widget.encomenda.status = 'ORCAMENTO_ENVIADO';
    widget.encomenda.precoProposto =
        double.tryParse(_precoController.text.replaceAll(',', '.'));
    widget.encomenda.prazoDias = int.tryParse(_prazoController.text);

    if (mounted) {
      Navigator.of(context).pop(true); // Retorna sucesso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Enviar Orçamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Client Info ────────────────────────────
              Container(
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
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.statusAguardando.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.encomenda.nomeCliente[0].toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.statusAguardando,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.encomenda.nomeCliente,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.encomenda.pecaReferencia,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ─── Form Title ─────────────────────────────
              Text(
                'Proposta de Orçamento',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Preencha os detalhes da sua proposta para o cliente.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // ─── Price Field ────────────────────────────
              _buildLabel('Preço Proposto (R\$)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[\d,.]'),
                  ),
                ],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  hintText: '0,00',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Text(
                      'R\$',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Informe o preço proposto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ─── Prazo Field ────────────────────────────
              _buildLabel('Prazo de Produção (dias)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _prazoController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Ex: 15',
                  prefixIcon: const Icon(
                    Icons.schedule_outlined,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                  suffixText: 'dias',
                  suffixStyle: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Informe o prazo de produção';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ─── Obs Field ──────────────────────────────
              _buildLabel('Observações (opcional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _observacoesController,
                maxLines: 4,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Materiais, técnicas, detalhes sobre a peça...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 40),

              // ─── Submit Button ──────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitOrcamento,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.onPrimary,
                              ),
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                    label: Text(
                      _isSubmitting ? 'Enviando...' : 'Enviar Orçamento',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),
    );
  }
}
