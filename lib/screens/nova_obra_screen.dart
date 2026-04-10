import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class NovaObraScreen extends StatefulWidget {
  const NovaObraScreen({super.key});

  @override
  State<NovaObraScreen> createState() => _NovaObraScreenState();
}

class _NovaObraScreenState extends State<NovaObraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _pecaUnica = false;
  bool _isSubmitting = false;
  String _categoriaSelecionada = 'Cerâmica';

  final List<String> _categorias = [
    'Cerâmica',
    'Cestaria',
    'Escultura',
    'Joalheria',
    'Macramê',
    'Tecelagem',
    'Outro',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _submitNovoProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final novoProduto = Produto(
      id: 'P${DateTime.now().millisecondsSinceEpoch}',
      titulo: _tituloController.text.trim(),
      preco: double.tryParse(
              _precoController.text.replaceAll(',', '.')) ??
          0,
      imagemUrl:
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
      pecaUnica: _pecaUnica,
    );

    mockProdutos.insert(0, novoProduto);

    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✨ "${novoProduto.titulo}" adicionada à vitrine!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Nova Obra'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
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
              // ─── Image Placeholder ──────────────────────
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '📷 Upload de imagem disponível na versão final'),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Adicionar fotos da sua obra',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG • Máx. 5 fotos',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ─── Title ──────────────────────────────────
              _buildLabel('Nome da Obra'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tituloController,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Ex: Vaso de Cerâmica Rústica',
                  prefixIcon: const Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o nome da obra';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ─── Category ───────────────────────────────
              _buildLabel('Categoria'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categorias.map((cat) {
                  final selected = cat == _categoriaSelecionada;
                  return GestureDetector(
                    onTap: () => setState(() => _categoriaSelecionada = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? AppColors.onPrimary
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ─── Price ──────────────────────────────────
              _buildLabel('Preço (R\$)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                ],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  hintText: '0,00',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
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
                    return 'Informe o preço';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ─── Description ────────────────────────────
              _buildLabel('Descrição (opcional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Conte a história desta peça, materiais usados, dimensões...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // ─── Peça Única Toggle ──────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.diamond_outlined,
                        color: AppColors.tertiary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peça Única',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            'Exclusiva, sem reprodução',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _pecaUnica,
                      onChanged: (v) => setState(() => _pecaUnica = v),
                      activeThumbColor: AppColors.primary,
                      activeTrackColor:
                          AppColors.primaryContainer.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // ─── Submit ─────────────────────────────────
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
                    onPressed: _isSubmitting ? null : _submitNovoProduto,
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
                        : const Icon(Icons.publish_rounded, size: 20),
                    label: Text(
                      _isSubmitting
                          ? 'Publicando...'
                          : 'Publicar na Vitrine',
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
