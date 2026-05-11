import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';

/// HistoryScreen
/// Foydalanuvchi ko‘rgan videolar tarixini ko‘rsatadi
class HistoryScreen extends StatefulWidget {

  /// Constructor
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

/// HistoryScreen state qismi
class _HistoryScreenState extends State<HistoryScreen> {

  /// Search field uchun controller
  /// TextField ichidagi yozuvni boshqaradi
  final TextEditingController _searchController =
  TextEditingController();

  /// Qidiruv matni
  String _query = '';

  @override
  Widget build(BuildContext context) {

    /// Filter qilingan videolar ro‘yxati
    /// Faqat qidiruvga mos videolar chiqadi
    final filtered = AppData.videos

    // where() orqali filter qilinmoqda
        .where((v) =>

    // Video title ni kichik harfga o‘tkazadi
    // va qidiruv bilan solishtiradi
    v.title
        .toLowerCase()
        .contains(_query.toLowerCase()))

    // Natijani List ga aylantiradi
        .toList();

    return Scaffold(

      /// Sahifa orqa fon rangi
      backgroundColor: Colors.white,

      /// Tepki panel
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0,

        /// Orqaga qaytish tugmasi
        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),

          // Oldingi sahifaga qaytadi
          onPressed: () => Navigator.pop(context),
        ),

        /// Sahifa nomi
        title: const Text(
          'History',

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        /// O‘ng tomondagi iconlar
        actions: [

          /// Cast icon
          IconButton(
            icon: const Icon(
              Icons.cast,
              color: Colors.black,
            ),

            onPressed: () {},
          ),

          /// Notification icon
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),

            onPressed: () {},
          ),

          /// Search icon
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),

            onPressed: () {},
          ),

          /// User avatar
          const Padding(
            padding: EdgeInsets.only(right: 8),

            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1565C0),

              child: Text(
                'A',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),

      /// Body qismi
      body: Column(
        children: [

          // ───────────────── SEARCH BAR ─────────────────

          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(

              /// TextField controller
              controller: _searchController,

              /// Har safar text o‘zgarganda ishlaydi
              onChanged: (v) =>

              // UI ni qayta chizadi
              setState(() => _query = v),

              decoration: InputDecoration(

                /// Placeholder text
                hintText: 'Search watch history',

                /// Placeholder style
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),

                /// Chap tomondagi search icon
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),

                /// Background color ishlatish
                filled: true,

                /// Search field background color
                fillColor: Colors.grey[100],

                /// Border style
                border: OutlineInputBorder(

                  /// Radius
                  borderRadius:
                  BorderRadius.circular(24),

                  /// Border ni olib tashlash
                  borderSide: BorderSide.none,
                ),

                /// Ichki padding
                contentPadding:
                const EdgeInsets.symmetric(
                  vertical: 0,
                ),
              ),
            ),
          ),

          // ───────────────── DATE LABEL ─────────────────

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),

            child: Row(
              children: [

                /// Sana label
                Text(
                  'Today',

                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ───────────────── VIDEO LIST ─────────────────

          Expanded(

            /// Scroll bo‘ladigan video list
            child: ListView(

              children:

              /// Filter qilingan videolarni map qiladi
              filtered

                  .map(

                /// Har bir video uchun card yaratadi
                    (v) => HorizontalVideoCard(
                  video: v,
                ),
              )

              /// Iterable ni List ga aylantiradi
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}