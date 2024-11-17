//
//  Tint.swift
//  bindingToClass
//
//  Created by Andrew on 9/2/24.
//

import SwiftUI

struct Tint: View {
    let sliderValue: Double
    @Environment(SliderHelper.self) var sliderHelper
    
    var body: some View {
        if shouldShowTintBar {
            switch sliderHelper.orientation {
                case .linear: LinearTint
                case .radial: RadialTint(value: sliderValue)
            }
        }
    }


    var anchor:  Double {
        switch(sliderHelper.tintCentredOn) {
            case .lowest: 0
            case .value(let fixedPoint):
                sliderHelper.sliderPosition(of: fixedPoint)
            case .lastValue:
                sliderHelper.sliderPosition(of: sliderHelper.lastSliderValue)
        }
    }

    /// A capsule overlaid on top of the track start point  would destroy the nice rounded edge of the track
    var showTintBarStart: Bool {
        if case sliderHelper.tintCentredOn = .lowest { false } else { true }
    }
    var shouldShowTintBar: Bool {
        for f in sliderHelper.sliderIndicator {
            if case .tintedTrack = f { return true }
        }
        return false
    }


    var LinearTint: some View {
        ZStack(alignment: .leading) {
            if showTintBarStart {
                TintBarStart
            }
            TintBar(
                sliderLocation: sliderHelper.sliderPosition(of: sliderValue),
                fixedPosition: anchor,
                height: sliderHelper.trackHeight
            )
            .shadow(
                color: sliderHelper.trackShadowColor,
                radius: sliderHelper.trackShadowRadius
            )
        }
        .foregroundStyle(sliderHelper.trackTintColor)
        .allowsHitTesting(false)
    }

    var TintBarStart: some View {
        Capsule()
            .frame(
                width: sliderHelper.trackMarkWidth,
                height: sliderHelper.trackMarkHeight
            )
            .offset(x: anchor - sliderHelper.trackMarkWidth/2)
    }
}

/// Animatable conformance is necessary to properly compute intermediate widths
/// so that the width shrinks when approaching the fixed position, and expands afterwards.
struct TintBar: View, Animatable {
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
                    startPosition = sliderLocation + sliderHelper.thumbWidth*0.5
                    width = fixedPosition - startPosition
                } else {
                    startPosition = fixedPosition
                    width = sliderLocation  - fixedPosition - sliderHelper.thumbWidth*0.5
                }
            }
    }
    }
