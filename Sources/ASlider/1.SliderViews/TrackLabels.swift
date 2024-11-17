//
//  TrackLabels.swift
//  bindingToClass
//
//  Created by Andrew on 9/6/24.
//

import SwiftUI

struct TrackLabels<LabelMarkContent: View>: View {
    var labelMark: (_:Double) -> LabelMarkContent
    @Environment(SliderHelper.self) var sliderHelper

    var body: some View {
        let markValues = sliderHelper.trackValues(for: .trackLabels)
        if !markValues.isEmpty {
            TrackLayout(hpad: sliderHelper.thumbWidth) {
                ForEach( markValues, id: \.self ) { mark in
                    labelMark(mark)
                }
            }
        }
    }
}

