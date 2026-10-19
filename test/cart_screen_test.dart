import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysample/data/dummy/dummy_cart.dart';
import 'package:mysample/pages/cart_screen.dart';

void main() {
  testWidgets('quantity changes update totals without mutating shared data', (
    tester,
  ) async {
    final originalQuantity = cartItems.first.jumlah;
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(find.text('3 produk dipilih'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    expect(find.text('Rp18.000.000'), findsOneWidget);
    expect(cartItems.first.jumlah, originalQuantity);
  });

  testWidgets('removed products can be restored with undo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    await tester.tap(find.byTooltip('Hapus produk').first);
    await tester.pumpAndSettle();
    expect(find.text('2 produk dipilih'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(find.text('3 produk dipilih'), findsOneWidget);
    expect(find.text('Smart Watch'), findsOneWidget);
  });
}
