import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysample/data/models/model_transaction.dart';

class LacakScreen extends StatelessWidget {
  const LacakScreen({super.key, required this.transaction});

  final TransactionProduct transaction;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Pesanan diproses', 'Pesanan sudah diterima penjual.'),
      ('Pesanan dikemas', 'Penjual sedang menyiapkan pesanan.'),
      ('Pesanan dikirim', 'Paket sedang dalam perjalanan.'),
      ('Pesanan diterima', 'Pesanan telah sampai di tujuan.'),
    ];
    final isCancelled = [
      'batal',
      'gagal',
    ].contains(transaction.status.toLowerCase());
    final activeStep = switch (transaction.status.toLowerCase()) {
      'selesai' || 'berhasil' => 3,
      'dikirim' => 2,
      'dikemas' => 1,
      'diproses' => 0,
      _ => 2,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),
      appBar: AppBar(title: const Text('Lacak Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 34,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.name,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transaction.date} · ${transaction.status}',
                        style: GoogleFonts.openSans(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCancelled ? 'Status pengiriman' : 'Riwayat pengiriman',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                if (isCancelled)
                  Text(
                    'Pengiriman tidak dapat dilanjutkan karena transaksi berstatus ${transaction.status.toLowerCase()}.',
                    style: GoogleFonts.openSans(color: Colors.black54),
                  )
                else
                  ...List.generate(steps.length, (index) {
                    final complete = index <= activeStep;
                    final current = index == activeStep;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 28,
                          child: Column(
                            children: [
                              Icon(
                                complete
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 20,
                                color: complete
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                              ),
                              if (index < steps.length - 1)
                                Container(
                                  width: 2,
                                  height: 42,
                                  color: index < activeStep
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  steps[index].$1,
                                  style: GoogleFonts.openSans(
                                    fontWeight: current
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: complete
                                        ? Colors.black87
                                        : Colors.black45,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  steps[index].$2,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                if (current) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status saat ini',
                                    style: GoogleFonts.openSans(
                                      fontSize: 11,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pembaruan pelacakan ditampilkan berdasarkan status transaksi saat ini.',
            style: GoogleFonts.openSans(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
