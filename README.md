# Offbeat

**Offbeat** is an iOS social platform focused on discovering and sharing offbeat travel destinations.
Users can document, share, discover and explore unique "offbeat" cities, hidden gems, and local experiences.
Implemented with coordinate-based deep linking to seamlessly launch external navigation apps.

## Features

- **Landing Page:** Scrollable list of cities with images. Add new cities or view details.
- **Add Destination:** Add posts with photos, ratings, descriptions, and geolocation tied to a specific city.
- **Profile View:** Guided onboarding/profile steps.
- **Posts Feed:** Social sharing, view posts for cities, like/unlike, and see other users’ experiences.
- **Photo Sharing:** Add and view images for destinations.
- **Firebase Integration:** All data (cities, posts, users) is synced and stored in Firebase Firestore.
- **Splash Screen:** Animated launch splash introducing the Offbeat adventure.

## Tech Stack

- **Language:** Swift (SwiftUI)
- **Data Storage:** Firebase Firestore
- **Photo Input:** iOS Photos framework integration
- **Architecture:** MVVM

## Getting Started

### Prerequisites
- iOS 15.0+
- Swift 5.0+
- An active Firebase account/project

### Setup Instructions

1. **Clone the repo:**
   ```sh
   git clone https://github.com/abhishek-lumen/Offbeat.git
   cd Offbeat
   ```

2. **Install Firebase dependencies:**
   - Using Swift Package Manager *(recommended)*:  
     Open the project in Xcode, go to Settings > Packages, and add `https://github.com/firebase/firebase-ios-sdk`.

   - Or using CocoaPods:  
     ```sh
     pod install
     open Offbeat.xcworkspace
     ```

3. **Configure Firebase:**
   - Create a new iOS app in the [Firebase Console](https://console.firebase.google.com/).
   - Download the `GoogleService-Info.plist` for your app and add it to the Xcode project root.
   - Ensure capabilities for *Background Modes* and *Photo Library Usage* are enabled in your app settings.

4. **Build and Run:**
   - Open in Xcode, select a simulator or device, then build (`Cmd+B`) and run (`Cmd+R`).

### File Structure
```
Offbeat/
  ├── OffbeatApp.swift           // App entry point
  ├── AppDelegate.swift          // Sets up Firebase
  ├── SplashScreenView.swift     // Animated splash
  ├── LandingPageView.swift      // Main city/explore feed
  ├── ProfileView.swift          // Profile/checklist page
  ├── CityView.swift             // Show posts mapped with selected city
  ├── PostView.swift             // Show/post destination content
  ├── AddDestinationView.swift   // Form for new places
  ├── AddPhotoView.swift         // Photo picker
  ├── PhotoDetailView.swift      // Fullscreen photo viewer
  └── FBHandler/FBHandler.swift  // Firebase data abstraction
```

### Main Components

- **LandingPageView**: Explore list of cities, add cities, and browse posts.
- **CityView**: View all posts for a selected city and create new experiences.
- **ProfileView**: User setup, walkthrough, or progress tracker.
- **PostView**: View or manage (edit/delete) destination posts, add photos.
- **FBHandler.swift**: Handles all Firestore reads/writes for cities/posts.

### Customization

- You may swap out icons or images in the Assets catalog.
- App color themes are easy to tweak in the SwiftUI views.
- Expand with new social features (comments, follows) using Firestore best practices.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

---

Made with ❤️ by [Abhishek Gupta](https://github.com/abhishek-lumen)
