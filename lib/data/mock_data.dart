
class Produto {
  final String id;
  final String titulo;
  final double preco;
  final String imagemUrl;
  final bool ativo;
  final bool pecaUnica;
  bool vendido;

  Produto({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.imagemUrl,
    this.ativo = true,
    this.pecaUnica = false,
    this.vendido = false,
  });
}

class Encomenda {
  final String id;
  final String nomeCliente;
  final String pecaReferencia;
  String status; // 'AGUARDANDO_ARTESAO' | 'ORCAMENTO_ENVIADO'
  double? precoProposto;
  int? prazoDias;

  Encomenda({
    required this.id,
    required this.nomeCliente,
    required this.pecaReferencia,
    required this.status,
    this.precoProposto,
    this.prazoDias,
  });
}

class Mensagem {
  final String texto;
  final bool isArtesao;
  final DateTime data;

  Mensagem({
    required this.texto,
    required this.isArtesao,
    required this.data,
  });
}


final List<Produto> mockProdutos = [
  Produto(
    id: '1',
    titulo: 'Vaso de Cerâmica Orgânica',
    preco: 180.00,
    imagemUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=400',
    pecaUnica: true,
    vendido: false,
  ),
  Produto(
    id: '2',
    titulo: 'Cesta de Palha Trançada',
    preco: 120.00,
    imagemUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e35ca?w=400',
    pecaUnica: false,
  ),
  Produto(
    id: '3',
    titulo: 'Escultura em Jacarandá',
    preco: 450.00,
    imagemUrl: 'https://images.unsplash.com/photo-1602928321679-560bb453f190?w=400',
    pecaUnica: true,
    vendido: false,
  ),
  Produto(
    id: '4',
    titulo: 'Bracelete Prata & Turquesa',
    preco: 320.00,
    imagemUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400',
    pecaUnica: true,
    vendido: true,
  ),
  Produto(
    id: '5',
    titulo: 'Luminária de Macramê',
    preco: 250.00,
    imagemUrl: 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=400',
    pecaUnica: false,
  ),
  Produto(
    id: '6',
    titulo: 'Tapete Artesanal Kilim',
    preco: 580.00,
    imagemUrl: 'https://images.unsplash.com/photo-1600166898405-da9535204843?w=400',
    pecaUnica: true,
    vendido: false,
  ),
];

final List<Encomenda> mockEncomendas = [
  Encomenda(
    id: 'E001',
    nomeCliente: 'Ana Beatriz',
    pecaReferencia: 'Vaso personalizado estilo orgânico',
    status: 'AGUARDANDO_ARTESAO',
  ),
  Encomenda(
    id: 'E002',
    nomeCliente: 'Carlos Eduardo',
    pecaReferencia: 'Conjunto de cestarias para decoração',
    status: 'ORCAMENTO_ENVIADO',
    precoProposto: 340.00,
    prazoDias: 15,
  ),
  Encomenda(
    id: 'E003',
    nomeCliente: 'Maria José',
    pecaReferencia: 'Escultura sob medida em madeira nobre',
    status: 'AGUARDANDO_ARTESAO',
  ),
  Encomenda(
    id: 'E004',
    nomeCliente: 'Fernanda Lima',
    pecaReferencia: 'Bracelete com pedras naturais',
    status: 'ORCAMENTO_ENVIADO',
    precoProposto: 290.00,
    prazoDias: 7,
  ),
  Encomenda(
    id: 'E005',
    nomeCliente: 'Roberto Nascimento',
    pecaReferencia: 'Luminária artesanal para sala de estar',
    status: 'AGUARDANDO_ARTESAO',
  ),
];

List<Mensagem> mockMensagens(String encomendaId) => [
  Mensagem(
    texto: 'Olá! Vi sua peça na vitrine e adorei o estilo. Gostaria de uma peça semelhante.',
    isArtesao: false,
    data: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Mensagem(
    texto: 'Que bom que gostou! Posso sim fazer algo parecido. Tem alguma preferência de cor ou tamanho?',
    isArtesao: true,
    data: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
  ),
  Mensagem(
    texto: 'Penso em tons terrosos, algo que combine com uma sala de estar moderna. Tamanho médio, por volta de 30cm.',
    isArtesao: false,
    data: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Mensagem(
    texto: 'Perfeito! Vou preparar o orçamento com base nisso. Em breve te retorno com os valores e prazo.',
    isArtesao: true,
    data: DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
  ),
  Mensagem(
    texto: 'Ótimo, agradeço! Fico no aguardo 😊',
    isArtesao: false,
    data: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
  ),
];
