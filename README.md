# Mirage

## Overview
Mirage is an iOS application that enables users to create and collect geolocated AR Miras. It integrates ARKit, Mapbox, and Apollo GraphQL to provide an interactive and social experience for users to share digital content in augmented reality.

## Features
- **AR Content Creation:** Users can create AR content using images and videos.
- **Location-based Interaction:** Users can collect Miras placed in the real world.
- **Social Integration:** Friends can connect and view shared AR content.
- **User Profiles:** Users can customize their profiles and manage friend connections.
- **GraphQL Backend:** Utilizes Apollo GraphQL for data fetching and mutations.

## Installation
### Prerequisites
- Xcode 14+
- Swift 5+
- CocoaPods or Swift Package Manager (SPM)
- An iOS device with ARKit support (iPhone 8+ recommended)

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/mirage-ar/mirage.git
   cd mirage
   ```
2. Install dependencies:
   ```sh
   pod install
   ```
   or if using Swift Package Manager:
   ```sh
   open Mirage.xcodeproj
   ```
3. Open `Mirage.xcworkspace` in Xcode.
4. Build and run the project on a physical device (ARKit does not work on the simulator).

## Project Structure
```
Mirage
├── Source
│   ├── Application
│   ├── Common (Constants, Extensions, Managers, Models, UserDefaults)
│   ├── Modules (ARModule, Friendship, Home, MapModule, OnBoarding, UserProfile)
│   ├── Networking (Apollo GraphQL, API Interceptors, Download Manager)
│   ├── Resources (Assets, Fonts, Localizations)
├── MirageApp.swift
├── apollo-codegen-config.json
├── swiftgen.yml
```

## Technologies Used
- **SwiftUI & UIKit**: Provides UI for the application.
- **ARKit & RealityKit**: Enables augmented reality features.
- **Apollo GraphQL**: Handles networking and API interactions.
- **Mapbox**: Provides mapping and geolocation services.
- **Combine**: Manages asynchronous events.
- **Reachability**: Detects network availability.
- **KeychainSwift**: Secure storage for user authentication.

## Usage
### Authentication
- Users sign up with their phone number and receive a verification code.
- Authentication is managed via Apollo GraphQL.

### AR View
- Users can place AR content at specific GPS locations.
- They can view, modify, and interact with placed content.

### Map View
- Displays collected Miras on a Mapbox-powered map.
- Users can navigate and explore their surroundings for AR content.

### Social Features
- Users can send and receive friend requests.
- Profiles include collected Miras and friends list.

## Development Guidelines
### Coding Standards
- Use SwiftLint for enforcing Swift coding standards.
- Follow MVVM pattern for structuring UI and business logic.
- Keep network calls within Apollo repositories.

### Contribution
1. Fork the repository.
2. Create a feature branch:
   ```sh
   git checkout -b feature-name
   ```
3. Commit changes:
   ```sh
   git commit -m "Add new feature"
   ```
4. Push to the branch:
   ```sh
   git push origin feature-name
   ```
5. Open a Pull Request.

## Contact
For support or contributions, contact `support@mirage.ar` or open an issue on GitHub.

