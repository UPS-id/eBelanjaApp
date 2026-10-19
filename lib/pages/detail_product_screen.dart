import 'dart:ui'; // Diperlukan untuk efek kaca (BackdropFilter & ImageFilter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysample/data/models/model_product.dart';

class DetailProductScreen extends StatefulWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  // State sederhana untuk varian & wishlist
  bool isWishlist = false;
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x0ffafafa), // Background netral yang lembut
      // Menggunakan Stack agar AppBar dan BottomBar bisa melayang dengan efek kaca
      body: Stack(
        children: [
          // ==========================================
          // 1. CONTENT UTAMA (Dapat Di-scroll)
          // ==========================================
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------
                // A. GAMBAR PRODUK & FLOATING WISHLIST
                // ------------------------------------------
                Stack(
                  children: [
                    // Container Gambar Utama
                    Container(
                      width: double.infinity,
                      height: 380,
                      color: Colors.grey[100],
                      child: Image.asset(
                        widget.product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                      ),
                    ),

                    // Tombol Floating Wishlist (Kanan Bawah Gambar)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: _buildGlassIconButton(
                        icon: isWishlist
                            ? Icons.favorite
                            : Icons.favorite_border,
                        iconColor: isWishlist ? Colors.red : Colors.indigo,
                        onTap: () {
                          setState(() {
                            isWishlist = !isWishlist;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // ------------------------------------------
                // B. DETAIL INFORMASI PRODUK
                // ------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Diskon & Tag Promo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Diskon 20%',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Bebas Ongkir',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Harga Utama & Harga Coret
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Rp ${widget.product.price}',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Rp ${(double.tryParse(widget.product.price.toString()) ?? 100000) * 1.25}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Nama Produk
                      Text(
                        widget.product.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Stat Rating, Terjual, & Diskusi
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.product.rating,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  100+ Terjual',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  42 Diskusi',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const Divider(height: 32, thickness: 1),

                      // ------------------------------------------
                      // D. DESKRIPSI PRODUK
                      // ------------------------------------------
                      Text(
                        'Deskripsi Produk',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          color: Colors.grey[800],
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),

                      const Divider(height: 32, thickness: 1),

                      // ------------------------------------------
                      // E. PROFIL TOKO / SELLER (FITUR BARU)
                      // ------------------------------------------
                      _buildSellerCard(),

                      const Divider(height: 32, thickness: 1),

                      // ------------------------------------------
                      // F. SECTION ULASAN PEMBELI
                      // ------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ulasan Pembeli',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(color: Colors.indigo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildReviewItem(
                        userName: 'Budi Santoso',
                        rating: 5,
                        comment: 'Barangnya bagus banget, pengiriman cepat!',
                      ),
                      _buildReviewItem(
                        userName: 'Siti Rahma',
                        rating: 4,
                        comment: 'Kualitas sesuai harga, recommended seller.',
                      ),

                      const Divider(height: 32, thickness: 1),

                      // ------------------------------------------
                      // G. PRODUK TERKAIT / REKOMENDASI (FITUR BARU)
                      // ------------------------------------------
                      Text(
                        'Produk Terkait',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRelatedProducts(),

                      // Spacing bawah agar konten tidak tertutup Bottom Bar melayang
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. FLOATING GLASS APPBAR (Atas)
          // ==========================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildGlassAppBar(context),
          ),

          // ==========================================
          // 3. FLOATING GLASS BOTTOM BAR (Bawah)
          // ==========================================
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildGlassBottomBar(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS (Komponen Tambahan untuk Kebersihan Kode)
  // ===========================================================================

  // 1. App Bar dengan Efek Kaca Transparan (Glassmorphism)
  Widget _buildGlassAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withValues(alpha: 0.7),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Icon(
                    Icons.store_rounded,
                    color: Colors.indigo,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'E-Belanja',
                    style: GoogleFonts.comicRelief(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Bottom Navigation Bar dengan Efek Kaca & Tombol Modern
  Widget _buildGlassBottomBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Tombol Tambah ke Keranjang (Outlined)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  label: const Text('+ Keranjang'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.indigo, width: 1.5),
                    foregroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Beli Sekarang (Filled Indigo)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Tombol Icon Melayang dengan Efek Kaca
  Widget _buildGlassIconButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
      ),
    );
  }

  // 4. Kartu Informasi Penjual / Toko
  Widget _buildSellerCard() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.indigo,
          child: Icon(Icons.store, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'E-Belanja Official Store',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Online 5 menit lalu • Jakarta Selatan',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.indigo),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('Follow', style: TextStyle(color: Colors.indigo)),
        ),
      ],
    );
  }

  // 5. Item Ulasan Pembeli
  Widget _buildReviewItem({
    required String userName,
    required int rating,
    required String comment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  userName[0],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                size: 16,
                color: index < rating ? Colors.amber : Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(comment, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }

  // 6. Section Produk Terkait (Horizontal List)
  Widget _buildRelatedProducts() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 380,
                    color: Colors.grey[100],
                    child: Image.asset(
                      widget.product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp. ${widget.product.price}',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
