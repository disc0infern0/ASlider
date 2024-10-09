//
//  Track.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//
import SwiftUI

struct Track: View {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    @State private var clickHeight: Double = 0
    @State private var color: Color = .clear
    var body: some View {

        Capsule()
            .fill(color)
            .frame(height: sliderStyle.trackHeight)
            .frame(height: clickHeight)     // } larger area for
            .contentShape(.rect)            // } tap gestures to hit
            .readSize {
                sliderHelper
                    .setTrackLength(
                        to: $0.width,
                        thumbWidth: sliderStyle._thumbWidth,
                        trackMarkWidth: sliderStyle._trackMarkWidth
                    )
            }
            .task {
                color = (sliderStyle.dynamicTrackMarks != nil) ? Color.clear : sliderStyle.trackColor
                if sliderStyle.sliderIndicator.contains(.thumb) {
                    clickHeight = sliderStyle.thumbHeight
                }
                else {
                    clickHeight = sliderStyle._trackMarkHeight
                }
            }
    }
}

#Preview {
    Track()
        .frame(width:300)
        .sliderStyle(.classic)
}



