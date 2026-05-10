# YouTube Clone - Flutter

YouTube UI ning to'liq Flutter kloni.

## Ekranlar

| Ekran | Tavsif |
|-------|--------|
| 🏠 Home | Asosiy sahifa — videolar, Shorts bo'limi, kategoriya chiplari |
| ⚡ Shorts | Vertikal scroll — TikTok uslubida, like/dislike/share |
| 📺 Subscriptions | Obunalar — kanallar avatari, tab filtrlari |
| 📚 Library | Kutubxona — History, Downloads, Playlists |
| 🕐 History | Ko'rish tarixi — qidiruv bilan |
| ⬇️ Downloads | Yuklangan videolar — saqlash hajmi ko'rsatkich |
| ▶️ Video Player | Video pleyer — ON/OFF, progress bar, like, subscribe |
| 🔍 Search | Qidiruv — real vaqtda filter |

## Loyiha tuzilmasi

```
lib/
├── main.dart                    # App + BottomNav
├── models/
│   └── app_data.dart           # VideoModel + ma'lumotlar
├── widgets/
│   ├── video_card.dart         # VideoCard + HorizontalVideoCard
│   └── top_bar.dart            # YouTubeTopBar
└── screens/
    ├── home_screen.dart
    ├── shorts_screen.dart
    ├── subscriptions_screen.dart
    ├── library_screen.dart
    ├── history_screen.dart
    ├── downloads_screen.dart
    ├── video_player_screen.dart
    └── search_screen.dart
```

## Ishga tushirish

```bash
# Flutter loyiha yarating
flutter create youtube_clone
cd youtube_clone

# lib/ papkasini yuklangan fayllar bilan almashtiring

# Paketlarni o'rnating
flutter pub get

# Ishga tushiring
flutter run
```

## Xususiyatlar

- ✅ Material 3 dizayn
- ✅ To'liq navigatsiya (BottomNav + Navigator.push)
- ✅ Video pleyer (ON/OFF, progress, fullscreen toggle)
- ✅ Shorts vertikal scroll + like/unlike
- ✅ Real vaqtda qidiruv
- ✅ Downloads progress indikatori
- ✅ Barcha ekranlar o'zaro bog'liq
