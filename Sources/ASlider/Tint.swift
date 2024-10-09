//
//  Tint.swift
//  bindingToClass
//
//  Created by Andrew on 9/2/24.
//

import SwiftUI

struct Tint: View {
    let sliderValue: Double
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper

//    var markWidth: Double {
//        sliderStyle.trackMarkWidth
//    }

    var body: some View {
        let fixedPosition = getAnchorCenter()
        ZStack(alignment: .leading) {
            Capsule()
                .frame(
                    width: sliderStyle._trackMarkWidth,
                    height: sliderStyle.trackHeight
                )
                .offset(x: fixedPosition - sliderStyle._trackMarkWidth/2)
                .foregroundStyle(.clear)
            TintBar(
                sliderLocation: sliderHelper.sliderLocation(of: sliderValue),
                fixedPosition: fixedPosition,
                height: sliderStyle.trackHeight
            )
            .foregroundStyle(sliderStyle.trackTintColor)
            .shadow(
                color: sliderStyle.trackShadowColor,
                radius: sliderStyle.trackShadowRadius)
        }
    }

    func getAnchorCenter() -> Double {
        var base: Double
        base = switch(sliderStyle.tintCentredOn) {
            case .lowest:
                sliderHelper.sliderLocation( of: sliderHelper.range.lowerBound )
            case .value(let fixedPoint):
                sliderHelper.sliderLocation(of: fixedPoint)
            case .lastValue:
                0.0 // MARK: todo - store the last thumbPos on dragEnded or onTap
        }
        
        return base
    }
}


/// Animatable conformance is necessary to properly compute intermediate widths
/// so that the width shrinks when approaching the fixed position, and expands afterwards.
struct TintBar: View, Animatable {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    var sliderLocation: Double
    let fixedPosition: Double
    let height: Double

    @State private var width: Double = 0
    @State private var startPosition: Double = 0.0
    nonisolated var animatableData: Double {
        get { sliderLocation }
        set { sliderLocation = newValue }
    }
    var body: some View {
        if sliderStyle.sliderIndicator.contains(.tintBar) {
            RoundedRectangle(cornerRadius: height/2)
                .frame(width: max(width,0), height: max(height,0))
                .offset(x: startPosition)
                .task(id: sliderLocation) {
                    if sliderLocation < fixedPosition {
                        startPosition = sliderLocation + sliderStyle._thumbWidth*0.5
                        width = fixedPosition - startPosition
                    } else {
                        startPosition = fixedPosition
                        width = sliderLocation  - fixedPosition - sliderStyle._thumbWidth*0.5
                    }
                }
        }
    }
}
