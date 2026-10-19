import 'package:flutter/material.dart';
import 'package:mysample/widgets/my_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysample/data/models/model_product.dart';
import 'package:mysample/data/dummy/dummy_category.dart';
import 'package:mysample/data/dummy/dummy_product.dart';
import 'package:mysample/pages/detail_product_screen.dart';

// =========================
// HOME PAGE
// =========================

/// Halaman utama yang menampilkan daftar produk.
class HomeScreen extends StatelessWidget {
  /// Membuat halaman Home.
  const HomeScreen({super.key});

  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  }

  /// Membangun scaffold dan grid produk.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(),
      // =========================
      // BODY
      // =========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategori',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Menyesuaikan ukuran kolom dengan kontennya
                        children: [
                          Container(
                            width: 80, // Tentukan lebar kotak sesuai kebutuhan
                            height:
                                80, // Tentukan tinggi kotak sesuai kebutuhan
                            alignment: Alignment
                                .center, // Membuat gambar otomatis di tengah kotak
                            decoration: BoxDecoration(
                              color: Colors.white, // Warna dasar kotak
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Membuat sudut kotak melengkung
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.1,
                                  ), // Warna bayangan yang halus
                                  blurRadius: 8, // Tingkat keburaman bayangan
                                  offset: const Offset(
                                    0,
                                    4,
                                  ), // Posisi bayangan (x, y)
                                ),
                              ],
                            ),
                            child: Image.network(
                              category.image,
                              width:
                                  60, // Ukuran gambar lebih kecil dari kotak agar tidak memenuhi ruang
                              height: 60,
                              fit: BoxFit
                                  .contain, // Memastikan gambar proporsional di dalam area center
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ), // Memberi jarak antara kotak dan teks nama
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Produk Terbaru',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),

                // index menunjukkan posisi produk yang sedang dibuat.
                itemBuilder: (context, index) {
                  final product = products[index];

                  return _productItemView(product, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membuat kartu visual untuk satu [product].
  ///
  /// Kartu berisi gambar, nama, harga, dan rating produk.
  Widget _productItemView(Product product, BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProductScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Expanded(
              child: Image.asset(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Informasi produk
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        product.rating,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
