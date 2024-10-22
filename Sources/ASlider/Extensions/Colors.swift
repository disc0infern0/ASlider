//
//  File.swift
//  ASlider
//
//  Created by Andrew on 15/10/2024.
//

import SwiftUI

extension Color {
#if os(macOS)
    public static let tertiary: Color = Color(nsColor: .tertiaryLabelColor)
    public static let quaternary: Color = Color(nsColor: .quaternaryLabelColor)

    public static let classicThumb = Color("classicThumb", bundle: .module)
    public static let classicTrack = Color("classicTrack", bundle: .module)
#else
    public static let tertiary: Color = Color(.tertiaryLabel)
    public static let quaternary: Color =
        Color(.quaternaryLabel)

    public static let classicThumb = Color("classicThumbIOS", bundle: .module)
    public static let classicTrack = Color("classicTrackIOS", bundle: .module)
#endif
}
