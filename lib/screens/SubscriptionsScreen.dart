import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';

/// SubscriptionsScreen
/// Foydalanuvchi obuna bo‘lgan kanallar va videolar sahifasi
class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState
    extends State<SubscriptionsScreen> {

  /// Hozir tanlangan tab
  String _selectedTab = 'Today';

  /// Yuqoridagi filter tablar
  final List<String> _tabs = [
    'Today',
    'Yesterday',
    'This week',
    'Older',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// Asosiy fon rangi
      backgroundColor: Colors.white,

      // ───────────────── APP BAR ─────────────────

      /// YouTube style app bar
      appBar: const YouTubeTopBar(
        showLogo: true,
      ),

      // ───────────────── BODY ─────────────────

      body: Column(
        children: [

          // ───────────────── CHANNEL LIST ─────────────────

          /// Obuna bo‘lgan kanallar
          Container(
            height: 80,
            color: Colors.white,

            child: ListView.builder(

              /// Gorizontal scroll
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              /// Kanal soni
              itemCount: AppData.channels.length,

              itemBuilder: (context, index) {

                /// Hozirgi kanal
                final ch =
                AppData.channels[index];

                return Padding(

                  padding:
                  const EdgeInsets.only(
                    right: 16,
                  ),

                  child: Column(
                    children: [

                      Stack(
                        children: [

                          // ───────── CHANNEL AVATAR ─────────

                          CircleAvatar(

                            radius: 24,

                            /// Kanal rangi
                            backgroundColor:
                            ch['color']
                            as Color,

                            /// Kanal nomining bosh harfi
                            child: Text(

                              (ch['name']
                              as String)[0],

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight
                                    .bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          // ───────── RED DOT ─────────

                          /// Yangi video belgisi
                          Positioned(
                            bottom: 0,
                            right: 0,

                            child: Container(
                              width: 12,
                              height: 12,

                              decoration:
                              const BoxDecoration(

                                color: Colors.red,

                                shape:
                                BoxShape.circle,

                                border:
                                Border.fromBorderSide(
                                  BorderSide(
                                    color:
                                    Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Divider
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // ───────────────── FILTER TABS ─────────────────

          /// Today / Yesterday / This week ...
          SizedBox(
            height: 42,

            child: ListView.builder(

              scrollDirection:
              Axis.horizontal,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              itemCount: _tabs.length,

              itemBuilder: (context, i) {

                /// Hozirgi tab
                final tab = _tabs[i];

                /// Tanlanganmi
                final isSelected =
                    tab == _selectedTab;

                return Padding(

                  padding:
                  const EdgeInsets.only(
                    right: 8,
                  ),

                  child: GestureDetector(

                    /// Tab bosilganda
                    onTap: () {

                      setState(() {

                        _selectedTab = tab;
                      });
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(

                        /// Tanlangan tab qora
                        color: isSelected
                            ? Colors.black
                            : Colors.grey[200],

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(

                        tab,

                        style: TextStyle(

                          color: isSelected
                              ? Colors.white
                              : Colors.black87,

                          fontSize: 12,

                          fontWeight:
                          isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Divider
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // ───────────────── VIDEO LIST ─────────────────

          Expanded(

            child: ListView(

              /// VideoCard list
              children: AppData.videos

                  .map(

                    (v) => VideoCard(

                  /// Video modeli
                  video: v,

                  /// Compact mode
                  compact: true,
                ),
              )

                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}