//
//  PredefinedStyles.swift
//  ASlider
//
//  Created by Andrew on 07/10/2024.
//
import SwiftUI

extension SliderStyle {
    @MainActor
    public static let classic = {
        var base = SliderStyle()
        base.trackColor =   Color("classicTrack", bundle: .module)
        base.trackMarks =  .none
        base.trackMarkWidth =  2
        base.labelMarks =  .none
        base.trackTintColor =  .accentColor
        base.trackShadow =  .radius(0.06)
        base.thumbSymbol =  .circle
        base.thumbColor =  Color("classicThumb", bundle: .module)
        base.thumbWidth =  21
        base.thumbHeight =  21
        base.thumbShapeEffect =  .none
        return base
    }()

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
        var base = SliderStyle()
        base.sliderIndicator = [.thumb, .tintBar]
        base.trackHeight = 4
        base.trackColor = .primary
        base.trackMarks = .auto
        base.trackMarkWidth = 4
        base.labelMarks = .none
        base.tintCentredOn = .zero
        base.trackTintColor = .accentColor
        base.trackShadow = .radius(0.4)
        base.thumbSymbol = .circle
        base.thumbTintedBorder = false
        base.thumbColor = Color("classicThumb", bundle: .module)
        base.thumbWidth = 21
        base.thumbShapeEffect = .bounce
        return base
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




