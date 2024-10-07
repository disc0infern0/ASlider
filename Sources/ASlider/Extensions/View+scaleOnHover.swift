//
//  ScaleOnHover.swift
//  bindingToClass
//
//  Created by Andrew on 9/10/24.
//
import SwiftUI

struct ScaleOnHover: ViewModifier  {
    let activeScale: Double
    @State var scale: Double = 1

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .animation(.default, value: scale)
            .onContinuousHover { phase in
                switch phase {
                    case .active:
                        scale = activeScale
                    case .ended:
                        scale = 1
                }
            }
    }
    /// .hoverEffect is not usable on macOS
    //                .hoverEffect { effect, isActive, geometry in
    //                    effect.scaleEffect(isActive ? 1.1 : 1.0)
    //                }
}

extension View {
    func scaleOnHover(_ scale: Double = 1.2) -> some View {
        modifier(ScaleOnHover(activeScale: scale))
    }
}



