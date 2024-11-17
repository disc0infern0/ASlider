//
//  RadialThumb.swift
//  radial
//
//  Created by Andrew on 26/10/2024.
//

import SwiftUI

struct RadialThumb: View, Animatable {
    var value: Double

    nonisolated var animatableData: Double {
        get { value }
        set { value = newValue }
    }


    var body: some View {
        ThumbCircle(value: value)
            .allowsHitTesting(false)
    }

    struct ThumbCircle: View {
        let value: Double
        @Environment(SliderHelper.self) var sliderHelper
        @Environment(\.sliderStyle) var sliderStyle
        var thumbColor: Color {
            sliderHelper.isDragging ? sliderStyle.thumbColorDragging : sliderStyle.thumbColorAtRest
        }
        var body: some View {
            let thumbWidth = sliderStyle.thumbWidth // sliderStyle.trackHeight
            let angle = sliderHelper.angle(of: value)
            let r = sliderHelper.outerRadius - 0.5*thumbWidth
            ZStack {
                Image(systemName: "circle.fill").resizable()
                    .frame(width: thumbWidth, height: thumbWidth)
                    .position(x: sliderHelper.centre.x ,
                              y: sliderHelper.centre.y - r)
                    .rotationEffect(angle)
            }
            .foregroundStyle(thumbColor)
        }
    }

}
//
//#Preview {
//    @Previewable @Environment(\.sliderStyle) var sliderStyle
//    @Previewable @State var value: Double = 0.7
//    VStack {
//        RadialThumb(value: value)
//        Slider(value: $value, in: 0...1)
//    }
//    .frame(width: 300, height: 300)
//    .environment(
//        SliderHelper(
//            range: 0...1,
//            offset: sliderStyle.offsetAngle,
//            centre: .init(x: 150, y: 150)
//        )
//    )
//}
