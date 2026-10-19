import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysample/data/dummy/dummy_product.dart';
import 'package:mysample/data/dummy/dummy_transaction.dart';
import 'package:mysample/data/models/model_transaction.dart';
import 'package:mysample/pages/datail_transaction_screen.dart';
import 'package:mysample/pages/detail_product_screen.dart';
import 'package:mysample/pages/lacak_screen.dart';
import 'package:mysample/pages/rating_screen.dart';
import 'package:mysample/widgets/my_app_bar.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Warna Khas Tokopedia
  static const Color tokoGreen = Color.fromARGB(255, 13, 72, 161);
  static const Color tokoBgGrey = Color(0xFFF3F4F5);

  int selectedFilterIndex = 0;

  String formatRupiah(int harga) {
    return 'Rp${harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  }

  // Helper untuk menentukan warna status ala Tokopedia
  Color _getStatusColor(String status) {
    final lower = status.trim().toLowerCase();
    switch (lower) {
      case 'selesai':
      case 'berhasil':
        return Colors.green.shade100;
      case 'dikemas':
      case 'diproses':
      case 'dikirim':
        return Colors.orange.shade100;
      case 'batal':
      case 'gagal':
        return Colors.red.shade100;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusTextColor(String status) {
    final lower = status.trim().toLowerCase();
    switch (lower) {
      case 'selesai':
      case 'berhasil':
        return Colors.green;
      case 'dikemas':
      case 'diproses':
      case 'dikirim':
        return Colors.orange;
      case 'batal':
      case 'gagal':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String _getStatusText(String status) {
    final lower = status.trim().toLowerCase();
    switch (lower) {
      case 'batal':
      case 'gagal':
        return 'Beli Lagi';
      case 'selesai':
      case 'berhasil':
        return 'Berikan Rating';
      case 'dikirim':
        return 'Lacak';
      case 'dikemas':
      case 'diproses':
      default:
        return 'Lihat Detail';
    }
  }

  void _handleTransactionAction(TransactionProduct item) {
    switch (item.status.trim().toLowerCase()) {
      case 'selesai':
      case 'berhasil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RatingScreen(transaction: item)),
        );
        break;
      case 'dikirim':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LacakScreen(transaction: item)),
        );
        break;
      case 'batal':
      case 'gagal':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailProductScreen(product: products[item.id]),
          ),
        );
        break;
      case 'dikemas':
      case 'diproses':
      default:
        _openTransactionDetail(item);
    }
  }

  void _openTransactionDetail(TransactionProduct item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatailTransactionScreen(transaction: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tokoBgGrey,
      appBar: const Myappbar(),
      body: Column(
        children: [
          // ==========================================
          // 2. DAFTAR TRANSAKSI (CARD STYLE TOKOPEDIA)
          // ==========================================
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final item = transactions[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER CARD: Icon Belanja, Tanggal & Status Badge ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 18,
                                  color: tokoGreen,
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Belanja',
                                      style: GoogleFonts.openSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      item.date,
                                      style: GoogleFonts.openSans(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Badge Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(item.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.status,
                                style: GoogleFonts.openSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusTextColor(item.status),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 20, thickness: 0.8),

                        // --- CONTENT CARD: Gambar Produk & Info Nama ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail Gambar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.img,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Nama & Rincian Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '1 barang',
                                    style: GoogleFonts.openSans(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // --- FOOTER CARD: Total Harga & Tombol Aksi ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Total Belanja
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Belanja',
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  formatRupiah(item.price),
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            // Tombol Beli Lagi (Aksi Utama Tokopedia)
                            Row(
                              children: [
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _handleTransactionAction(item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: tokoGreen,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _getStatusText(item.status),
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _openTransactionDetail(item),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.more_horiz,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
