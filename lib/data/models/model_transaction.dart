// =========================
// MODEL TRANSAKSI
// =========================

/// Model data untuk transaksi.
class TransactionProduct {
  final int id;
  final String date;
  final String name;
  final String img;
  final int price;
  final String status;

  TransactionProduct({
    required this.id,
    required this.date,
    required this.name,
    required this.img,
    required this.price,
    required this.status,
  });
}
