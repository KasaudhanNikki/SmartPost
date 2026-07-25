# SmartPost — Flutter App

A beauty consultant social-commerce app with an AI-powered smart feed. Browse posts, edit captions, share to social platforms, and chat with an AI assistant.

---

## Quick Start

### Requirements
- Flutter SDK (Dart 3.9+)
- Android Studio / Xcode
- Physical device recommended for camera testing

### Install & Run
```bash
git clone <repo-url>
cd smartpost
flutter pub get
flutter run
```

---

## App Features

✨ **Smart Post Feed** — TikTok-style vertical swipe feed with posts  
📸 **Image Carousel** — Swipe through post images  
💬 **AI Assistant** — Chat with recommendations  
📷 **Camera** — Take photos directly in app  
✏️ **Edit Captions** — Modify post text before sharing  
🎨 **Product Cards** — Auto-revealing product info  
📱 **Bottom Navigation** — Jump between Rocket, Search, Home, Chat, Profile

---

## Folder Structure

```
lib/
├── screens/           # All pages (Home, Chat, Profile, etc)
├── widgets/           # Reusable UI components
├── services/          # AI chatbot logic
├── models/            # Data structures
├── utils/             # Helpers (camera, spacing)
└── main.dart          # App setup
```

---

## Key Components

| Component | Purpose |
|---|---|
| **Initial Loading** | Animated startup screen |
| **Smart Post Feed** | Main vertical swipe feed |
| **Post Item** | Post card with image, caption, share buttons |
| **AI Assistant Screen** | Chat interface |
| **Edit Caption Screen** | Text editor for posts |
| **Glass Container** | Reusable glassmorphism widget |

---

## How It Works

1. App starts → Loading animation
2. Opens feed → Swipe up/down to browse posts
3. Swipe left/right → Image carousel
4. Tap "Edit" → Modify caption text
5. Tap "Your Assistant" → AI chat opens
6. Tap "Camera" → Native camera launches
7. Bottom nav → Switch between screens

---

## Tech Stack

- **UI Framework** — Flutter + Material 3
- **Typography** — Google Fonts (Inter)
- **Icons** — Font Awesome
- **Images** — Cached Network Image
- **Camera** — Image Picker + Permissions
- **AI** — Mock service (optional OpenAI API)

---

## Design Details

🎨 **Brand Color** — Green `#76C298`  
🌙 **Theme** — Dark background with glassmorphism cards  
📐 **Layout** — Full-screen posts, responsive UI  
⏰ **Product Card** — Fades in after 3 seconds

---

## AI Assistant (Optional)

Works **offline** with hardcoded beauty product advice.

**To enable OpenAI API:**
1. Get API key from [openai.com](https://platform.openai.com)
2. Open `lib/services/ai_chatbot_service.dart`
3. Replace: `static const String openAiApiKey = 'YOUR_KEY'`

Falls back to mock responses if API fails.

---

## Demo

- Animated loading screen
- Browse smart post feed
- Swipe images, edit captions
- AI chat with products
- Camera integration
- Share animations
- Bottom nav

---

## What's Not Built Yet

- 🏗️ Backend/API — All data is hardcoded
- 📚 Library, Communities tabs — Placeholders
- 🔍 Search — Basic UI only

---

**Ready to use — no backend required!** 🚀