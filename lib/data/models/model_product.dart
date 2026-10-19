// =========================
// MODEL PRODUK
// =========================

/// Model data untuk satu produk pada halaman Home.
class Product {
  final int id;
  final String name;
  final String image;
  final int price;
  final String description;
  final String rating;

  /// Membuat produk dengan informasi yang wajib diisi.
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
  });
}

