//
//  RadialTint.swift
//  radial
//
//  Created by Andrew on 23/10/2024.
//


import SwiftUI
struct RadialTint: View, Animatable {
    nonisolated var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    var value: Double
    @Environment(SliderHelper.self) var sliderHelper

    var body: some View {
        Polo(
            width: sliderHelper.trackHeight,
            radialAngle: sliderHelper.angle(of: value),
            outerRadius: sliderHelper.outerRadius
        )
        .fill(sliderHelper.trackTintColor)
        .allowsHitTesting(false)
    }
}

//#Preview {
//    @Previewable @State var angle: Angle = Angle(degrees: 45)
//    @Previewable @State var value: Double = 0.5
//    @Previewable @Environment(\.sliderStyle) var sliderStyle
//    VStack {
//        ZStack {
//            RadialTrack(value: $value)
//            RadialTint(value: value)
//        }
//        .sliderStyle { style in
//            style.orientation = .radial
//            style.trackHeight = 40
//            style.offsetAngle = angle
//            style.trackColor = .teal
//        }
//        .frame(width: 300, height: 300)
//        Text("\(value)")
//    }
//    .animation(.easeInOut, value: value)
//    .environment(SliderHelper(range: 0...1,
//                              offset: angle,
//                              centre: .init(x: 150, y: 150)))
//}
