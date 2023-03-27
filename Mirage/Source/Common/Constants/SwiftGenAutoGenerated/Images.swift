// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Images {
  internal static let alignC24 = ImageAsset(name: "align-c-24")
  internal static let alignL24 = ImageAsset(name: "align-l-24")
  internal static let alignR24 = ImageAsset(name: "align-r-24")
  internal static let arCreate24 = ImageAsset(name: "ar-create-24")
  internal static let arExplore24 = ImageAsset(name: "ar-explore-24")
  internal static let arrowB24 = ImageAsset(name: "arrow-b-24")
  internal static let arrowL24 = ImageAsset(name: "arrow-l-24")
  internal static let arrowR24 = ImageAsset(name: "arrow-r-24")
  internal static let arrowT24 = ImageAsset(name: "arrow-t-24")
  internal static let checkMark24 = ImageAsset(name: "check-mark-24")
  internal static let cross24 = ImageAsset(name: "cross-24")
  internal static let findMe24 = ImageAsset(name: "find-me-24")
  internal static let findNorth24 = ImageAsset(name: "find-north-24")
  internal static let flag24 = ImageAsset(name: "flag-24")
  internal static let friends24 = ImageAsset(name: "friends-24")
  internal static let loader16 = ImageAsset(name: "loader-16")
  internal static let loader24 = ImageAsset(name: "loader-24")
  internal static let longArrowR24 = ImageAsset(name: "long-arrow-r-24")
  internal static let mail24 = ImageAsset(name: "mail-24")
  internal static let mapFilterAll24 = ImageAsset(name: "map-filter-all-24")
  internal static let mapFilterFriends24 = ImageAsset(name: "map-filter-friends-24")
  internal static let minus16 = ImageAsset(name: "minus-16")
  internal static let more24 = ImageAsset(name: "more-24")
  internal static let new16 = ImageAsset(name: "new-16")
  internal static let notInZone24 = ImageAsset(name: "not-in-zone-24")
  internal static let pin24 = ImageAsset(name: "pin-24")
  internal static let plus16 = ImageAsset(name: "plus-16")
  internal static let plus24 = ImageAsset(name: "plus-24")
  internal static let profile24 = ImageAsset(name: "profile-24")
  internal static let profileWoPic24 = ImageAsset(name: "profile-wo-pic-24")
  internal static let qr24 = ImageAsset(name: "qr-24")
  internal static let refresh24 = ImageAsset(name: "refresh-24")
  internal static let route24 = ImageAsset(name: "route-24")
  internal static let save24 = ImageAsset(name: "save-24")
  internal static let search16 = ImageAsset(name: "search-16")
  internal static let settings24 = ImageAsset(name: "settings-24")
  internal static let share24 = ImageAsset(name: "share-24")
  internal static let soundOff24 = ImageAsset(name: "sound-off-24")
  internal static let soundOn24 = ImageAsset(name: "sound-on-24")
  internal static let text24 = ImageAsset(name: "text-24")
  internal static let trash24 = ImageAsset(name: "trash-24")
  internal static let trim24 = ImageAsset(name: "trim-24")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
