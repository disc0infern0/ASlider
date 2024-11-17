//
//  File.swift
//  ASlider
//
//  Created by Andrew on 15/10/2024.
//

import SwiftUI

/// A set of monochrome colours for use throughout the package.
/// The referenced colours are defined in the 'Colors' asset catalog. 
extension Color {
    // Of course Apple couldn't make the thumb and track colors of their built in slider the same on both macOS and iOS/iPadOS could they?
#if os(macOS)
    public static let tertiary: Color = Color(nsColor: .tertiaryLabelColor)
    public static let quaternary: Color = Color(nsColor: .quaternaryLabelColor)

    public static let classicThumb = Color("classicThumb", bundle: .module)
    public static let classicTrack = Color("classicTrack", bundle: .module)
#else
    public static let tertiary: Color = Color(.tertiaryLabel)
    public static let quaternary: Color = Color(.quaternaryLabel)

    public static let classicThumb = Color("classicThumbIOS", bundle: .module)
    public static let classicTrack = Color("classicTrackIOS", bundle: .module)
#endif
    /// Really quite clear. Definitely more clear than somewhat, whilst being less clear than totally transparent. A big step up in clarity from murky. Clear-ish.
    public static let clearIsh = Color("clearIsh", bundle: .module)
}
