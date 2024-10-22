//
//  PredefinedStyles.swift
//  ASlider
//
//  Created by Andrew on 07/10/2024.
//
import SwiftUI

extension SliderStyle {
    @MainActor
    public static let classic = SliderStyle()

    @MainActor
    public static let dynamic = {
        var style = SliderStyle()
        style.sliderIndicator = [.trackMarks(percent: 0.2, growth: 2.0)]
        style.tintCentredOn = .lowest
        style.trackMarks = .every(0.4)
        style.trackMarkHeight = 15
        style.trackMarkWidth = 4
        style.trackMarkActiveColor = [.blue, .green, .yellow]
        return style
    }()
    @MainActor
    public static let newClassic = {
        var style = SliderStyle()
        style.sliderIndicator = [.thumb, .tintBar]
        style.trackHeight = 4
        style.trackColor = .classicTrack
        style.trackMarks = .auto
        style.trackMarkWidth = 4
        style.labelMarks = .none
        style.tintCentredOn = .zero
        style.trackTintColor = .accentColor
        style.trackShadow = .radius(0.4)
        style.thumbSymbol = .circle
        style.thumbTintedBorder = true
        style.thumbColor = .classicThumb
        style.thumbWidth = 21
        style.thumbShapeEffect = .bounce
        return style
    } ()

    @MainActor
    public static let orangey = {
        var style = SliderStyle()
        style.trackHeight = 8
        style.trackColor = .orange
        style.trackMarks = .auto
        style.trackMarkWidth = 8
        style.trackTintColor = .yellow
        style.trackShadow = .radius(5)
        style.thumbSymbol = .capsule
        style.thumbTintedBorder = true
        style.thumbColor = .orange
        style.thumbWidth = 35
        style.thumbHeight = 50
        style.thumbShapeEffect = .bounce
        return style
    } ()

}




