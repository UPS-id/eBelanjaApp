import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysample/data/models/model_transaction.dart';

class DatailTransactionScreen extends StatelessWidget {
  const DatailTransactionScreen({super.key, required this.transaction});

  final TransactionProduct transaction;

  String _formatPrice(int price) {
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailSection(
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status transaksi',
                        style: GoogleFonts.openSans(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.status,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: 'Produk',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    transaction.img,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 76,
                      height: 76,
                      color: Colors.black12,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.name,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1 barang',
                        style: GoogleFonts.openSans(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatPrice(transaction.price),
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: 'Rincian pembayaran',
            child: Column(
              children: [
                _DetailRow(
                  label: 'Subtotal produk',
                  value: _formatPrice(transaction.price),
                ),
                const SizedBox(height: 10),
                const _DetailRow(label: 'Jumlah produk', value: '1 barang'),
                const Divider(height: 24),
                _DetailRow(
                  label: 'Total pembayaran',
                  value: _formatPrice(transaction.price),
                  emphasized: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: 'Informasi transaksi',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Tanggal', value: transaction.date),
                const SizedBox(height: 12),
                _DetailRow(label: 'Status', value: transaction.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.child, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.openSans(
      fontSize: emphasized ? 14 : 13,
      fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
      color: emphasized ? Colors.black87 : Colors.black54,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
