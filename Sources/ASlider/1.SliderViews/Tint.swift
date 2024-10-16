//
//  Tint.swift
//  bindingToClass
//
//  Created by Andrew on 9/2/24.
//

import SwiftUI

struct Tint: View {
    let sliderValue: Double
    let lastSliderValue: Double
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    var anchor:  Double {
        switch(sliderStyle.tintCentredOn) {
            case .lowest: 0
            case .value(let fixedPoint):
                sliderHelper.sliderLocation(of: fixedPoint)
            case .lastValue:
                sliderHelper.sliderLocation(of: lastSliderValue)
        }
    }

    /// A capsule overlaid on top of the track start point  would destroy the nice rounded edge of the track
    var showTintBarStart: Bool {
        if case sliderStyle.tintCentredOn = .lowest { false } else { true }
    }
    var shouldShowTintBar: Bool {
        for f in sliderStyle.sliderIndicator {
            if case .tintBar = f { return true }
        }
        return false
    }
    var body: some View {
        if shouldShowTintBar {
            ZStack(alignment: .leading) {
                if showTintBarStart {
                    TintBarStart
                }
                TintBar(
                    sliderLocation: sliderHelper.sliderLocation(of: sliderValue),
                    fixedPosition: anchor,
                    height: sliderStyle.trackHeight
                )
                .foregroundStyle(sliderStyle.trackTintColor)
                .shadow(
                    color: sliderStyle.trackShadowColor,
                    radius: sliderStyle.trackShadowRadius
                )
                .drawingGroup() // compose animations with Metal optimisation
            }
        } 
    }
    var TintBarStart: some View {
        Capsule()
            .frame(
                width: sliderStyle.i_trackMarkWidth,
                height: sliderStyle.i_trackMarkHeight
            )
            .offset(x: anchor - sliderStyle.i_trackMarkWidth/2)
            .foregroundStyle(sliderStyle.trackTintColor)
    }
}

/// Animatable conformance is necessary to properly compute intermediate widths
/// so that the width shrinks when approaching the fixed position, and expands afterwards.
struct TintBar: View, Animatable {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    var sliderLocation: Double
    var fixedPosition: Double
    let height: Double
    var id: String { "\(sliderLocation):\(fixedPosition)" }

    @State private var width: Double = 0
    @State private var startPosition: Double = 0.0

    nonisolated var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sliderLocation, fixedPosition) }
        set { sliderLocation = newValue.first; fixedPosition = newValue.second}
    }
    var body: some View {
        RoundedRectangle(cornerRadius: height/2)
            .frame(width: max(width,0), height: max(height,0))
            .offset(x: startPosition)
            .task(id: id) {
                if sliderLocation < fixedPosition {
                    startPosition = sliderLocation + sliderStyle.thumbWidth*0.5
                    width = fixedPosition - startPosition
                } else {
                    startPosition = fixedPosition
                    width = sliderLocation  - fixedPosition - sliderStyle.thumbWidth*0.5
                }
            }
    }
    }
