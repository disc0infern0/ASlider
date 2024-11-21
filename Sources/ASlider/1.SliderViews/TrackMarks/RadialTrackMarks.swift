//
//  RadialTrackMarks.swift
//  radial
//
//  Created by Andrew on 23/10/2024.
//

import SwiftUI

struct RadialTrackMarks: View, Animatable {
    var value: Double
    nonisolated var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    @Environment(SliderHelper.self) var sliderHelper

    var body: some View {
        let activeAngle = sliderHelper.angle(of: value)
        let angles = sliderHelper.trackAngles
        ForEach(angles, id: \.self.degrees) { angle in
            TrackMark(
                height: sliderHelper.trackMarkHeight,
                status: angle <= activeAngle ? .active : .inactive
            )
            .offset(
                x: 0,
                y: -(sliderHelper.outerRadius-sliderHelper.trackHeight*0.5 )
            )
            .rotationEffect(angle)
        }
        .frame(
            width: sliderHelper.outerRadius,
            height: sliderHelper.outerRadius
        )
        .allowsHitTesting(false)
    }
}

#Preview("Radial track marks") {
    @Previewable @State var sliderValue: Double = 0.7
    @Previewable @State var style: SliderStyle = .radial
    @Previewable @State var sliderHelper = SliderHelper(
        range: 0...1, isInt: false)
    ZStack {
        Track()
        RadialTrackMarks(value: sliderValue)
    }
    .frame(width: 320, height: 400)
    .readFrame {
        style.sliderIndicator = [.tintedTrackMarks]
        style.trackMarkInterval = .auto
        style.trackMarkActiveColors = [.green]
        style.trackMarkInActiveColors = [.classicThumb]
        style.trackMarkWidth = 30
        style.trackMarkHeight = 70
        style.trackHeight = 40
        sliderHelper.updateStyle(style)
        sliderHelper.setTrackSize(to: $0)
    }
    .environment(sliderHelper)
}
#Preview("Radial tinted track") {
    @Previewable @State var sliderValue: Double = 0.7

    ZStack {
        NewSlider(value: $sliderValue, in: 0.0 ... 1.0)
    }
    .frame(width: 400, height: 400)
    .sliderStyle(.volumeControl)
    .padding(2)
}
