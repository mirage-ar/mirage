// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Fonts = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum ABCDiatypeMono {
    internal static let regular = FontConvertible(name: "ABCDiatypeMono-Regular", family: "ABC Diatype Mono", path: "ABCDiatypeMono-Regular.otf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum ABCDiatypeMonoUnlicensedTrial {
    internal static let bold = FontConvertible(name: "ABCDiatypeMonoUnlicensedTrial-Bold", family: "ABC Diatype Mono Unlicensed Trial", path: "ABCDiatypeMono-Bold-Trial.otf")
    internal static let boldItalic = FontConvertible(name: "ABCDiatypeMonoUnlicensedTrial-BoldItalic", family: "ABC Diatype Mono Unlicensed Trial", path: "ABCDiatypeMono-BoldItalic-Trial.otf")
    internal static let regular = FontConvertible(name: "ABCDiatypeMonoUnlicensedTrial-Regular", family: "ABC Diatype Mono Unlicensed Trial", path: "ABCDiatypeMono-Regular-Trial.otf")
    internal static let regularItalic = FontConvertible(name: "ABCDiatypeMonoUnlicensedTrial-RegularItalic", family: "ABC Diatype Mono Unlicensed Trial", path: "ABCDiatypeMono-RegularItalic-Trial.otf")
    internal static let all: [FontConvertible] = [bold, boldItalic, regular, regularItalic]
  }
  internal enum Engin {
    internal static let regular = FontConvertible(name: "Engin-Regular", family: "Engin", path: "ENGIN.otf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum HelveticaNeueLTStd {
    internal static let _73BoldExtended = FontConvertible(name: "HelveticaNeueLTStd-BdEx", family: "Helvetica Neue LT Std", path: "HelveticaNeueLTStd-BdEx.otf")
    internal static let _53Extended = FontConvertible(name: "HelveticaNeueLTStd-Ex", family: "Helvetica Neue LT Std", path: "HelveticaNeueLTStd-Ex.otf")
    internal static let _43LightExtended = FontConvertible(name: "HelveticaNeueLTStd-LtEx", family: "Helvetica Neue LT Std", path: "HelveticaNeueLTStd-LtEx.otf")
    internal static let _63MediumExtended = FontConvertible(name: "HelveticaNeueLTStd-MdEx", family: "Helvetica Neue LT Std", path: "HelveticaNeueLTStd-MdEx.otf")
    internal static let all: [FontConvertible] = [_73BoldExtended, _53Extended, _43LightExtended, _63MediumExtended]
  }
  internal enum HelveticaMonospacedW06Bd {
    internal static let regular = FontConvertible(name: "HelveticaMonospacedW06-Bd", family: "HelveticaMonospacedW06-Bd", path: "a6b67044-c1c9-49d9-98a2-0471285ed246.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum HelveticaMonospacedW06Rg {
    internal static let regular = FontConvertible(name: "HelveticaMonospacedW06-Rg", family: "HelveticaMonospacedW06-Rg", path: "a74d4504-60a3-47ac-8b5b-d3421c546dc3.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum RedactionExtraCond35 {
    internal static let extraCondRegular = FontConvertible(name: "Redaction-Extra-Cond-35-Regular", family: "Redaction Extra Cond 35", path: "Redaction35-Regular.otf")
    internal static let regular = FontConvertible(name: "Redaction35-Regular", family: "Redaction Extra Cond 35", path: "Redaction35-Regular.210603-1544.otf")
    internal static let all: [FontConvertible] = [extraCondRegular, regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [ABCDiatypeMono.all, ABCDiatypeMonoUnlicensedTrial.all, Engin.all, HelveticaNeueLTStd.all, HelveticaMonospacedW06Bd.all, HelveticaMonospacedW06Rg.all, RedactionExtraCond35.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
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
