//
//  Trackmark.swift
//  bindingToClass
//
//  Created by Andrew on 9/25/24.
//
import SwiftUI
struct TrackMark: View, Animatable {
    @Environment(SliderHelper.self) var sliderHelper

    enum Status { case active, inactive }
    var height: Double
    var status: Status
    nonisolated var animatableData: Double {
        get { height }
        set { height = newValue }
    }

    var colors: [Color] {
        switch status {
            case .active: sliderHelper.sliderIndicator.contains( .tintedTrackMarks ) ? sliderHelper.trackMarkActiveColors : sliderHelper.trackMarkInActiveColors
            case .inactive: sliderHelper.trackMarkInActiveColors
        }
    }

    var colorGradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .bottomTrailing, endPoint: .topLeading)
    }

    var body: some View {
        Capsule()
            .fill(colorGradient)
            .frame(
                width: sliderHelper.trackMarkWidth,
                height: height
            )
            .glow(color: sliderHelper.trackMarkActiveColors.first!.opacity(status == .active ? 1.0 : 0.2), radius: status == .active ? 2.5 : 0)
            .allowsHitTesting(false)
    }
}

#Preview("Track Mark") {
    @Previewable @State var rect: CGRect = .zero
    @Previewable @State var style: SliderStyle = .classic
    @Previewable @State var sliderHelper =  SliderHelper( range: 0...1, isInt: false )
    ZStack {
        TrackMark(height: 100, status: .active)
            .offset(x: -50)
        TrackMark(height: 100, status: .inactive)
            .offset(x: 50)
    }
    .frame(width: 300, height: 300)
    .readFrame { rect = $0
        style.name = "Generic Track Mark Style"
        style.trackMarkWidth = 50
        style.trackMarkHeight=100
        style.trackMarkActiveColors = [.green]
        style.trackHeight=50
        style.sliderIndicator = [.tintedTrackMarks]
        sliderHelper.setTrackSize(to: rect)
        sliderHelper.updateStyle(style)
    }
    .environment(sliderHelper)
}

