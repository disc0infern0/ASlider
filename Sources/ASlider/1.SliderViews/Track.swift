//
//  Track.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//
import SwiftUI

struct Track: View {
    @Environment(SliderHelper.self) var sliderHelper

    var body: some View {
        switch sliderHelper.orientation {
        case .linear: LinearTrack
        case .radial: RadialTrack
        }
        //            .gesture(dragGesture)
        //            .id(sliderStyle) // redraw and recalculate size if sliderStyle changes
    }

    var LinearTrack: some View {
        let color = sliderHelper.trackColor
        let clickHeight =
            sliderHelper.sliderIndicator.contains(.thumb)
            ? sliderHelper.thumbHeight : sliderHelper.trackMarkHeight
        return Capsule()
            .fill(color)
            .frame(height: sliderHelper.trackHeight)
//            .readSize { size in
//                sliderHelper.setTrackLength( to: size.width)
//            }
            .frame(height: clickHeight)  // } larger area for
            .contentShape(.rect)  // } tap gestures to hit
    }

    var RadialTrack: some View {
        Polo(
            width: sliderHelper.trackHeight,
            radialAngle: Angle.threeSixty - sliderHelper.offsetAngle,
            outerRadius: sliderHelper.outerRadius
        )
        .fill(sliderHelper.trackColor)
        //        .highPriorityGesture(rotation)
    }

    //    var rotation: some Gesture {
    //        RotateGesture()
    //            .onChanged { gesture in
    //                if sliderHelper.orientation == .radial {
    //                    let adjustment = gesture.rotation.degrees/3600.0
    //                    sliderHelper.setSlider(value: $sliderValue, to: sliderValue+adjustment)
    //                }
    //            }
    //    }
    //
    //
}

#Preview("RadialTrack") {
    @Previewable @State var sliderValue = 10.0
    @Previewable @State var sliderStyle: SliderStyle = .radial
    @Previewable @State var sliderHelper =  SliderHelper( range: 0...30, isInt: false )
    ZStack {
        Track()
        RadialTint(value: sliderValue)
    }
    .task {
        sliderStyle.trackHeight = 50
        sliderStyle.trackMarkHeight = 80
        sliderHelper.updateStyle(sliderStyle)
    }
    .frame(width: 400, height: 400)
    .border(.red)
//    .readFrame { r in
//        sliderHelper.setTrackSize(to: r)
//    }
    .environment( sliderHelper)
    .frame(width: 400, height: 400)
}

#Preview("Linear Track") {
    @Previewable @State var sliderValue: Double = 2
    @Previewable @State var sliderStyle: SliderStyle = .classic
    @Previewable @State var sliderHelper =  SliderHelper( range: 0...30, isInt: false )
    Track()
        .readFrame { r in
            sliderHelper.setTrackSize(to: r)
        }
        .environment( sliderHelper)
        .frame(width: 400, height: 400)
}
