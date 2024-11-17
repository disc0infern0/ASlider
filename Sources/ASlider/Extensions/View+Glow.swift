//
//  View+Glow.swift
//  radial
//
//  Created by Andrew on 28/10/2024.
//
import SwiftUI

extension View {
    /// Enhanced shadow effect by layering 3 shadows in place
    func glow(color: Color = .green, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}

