// =========================
// MODEL KERANJANG BELANJA
// =========================

/// Model data untuk satu item di keranjang belanja.
class CartItem {
  final int id;
  final String nama;
  final int harga;
  final String gambar;
  int jumlah;

  /// Membuat item keranjang dengan informasi yang wajib diisi.
  CartItem({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.jumlah,
  });

  /// Menghitung subtotal untuk item ini (harga × jumlah).
  int get subtotal => harga * jumlah;
}
