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
    @Environment(\.sliderStyle) var sliderStyle
    
    var body: some View {
        let markValues = sliderHelper.markValues(
            from: sliderStyle.labelMarks
        )
        TrackLayout(hpad: sliderStyle.thumbWidth) {
            ForEach( markValues, id: \.self ) { mark in
                labelMark(mark)
            }
        }

    }
}

