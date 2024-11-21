//
//  PredefinedStyles.swift
//  ASlider
//
//  Created by Andrew on 07/10/2024.
//
import SwiftUI

extension SliderStyle {
    @MainActor
    public static let classic = SliderStyle("Classic")

    @MainActor
    public static let volumeControl = {
        var style = SliderStyle("Volume Control")
        style.sliderIndicator = [.tintedTrackMarks]
        style.orientation = .radial
        style.thumbWidth = 0
        style.tintCentredOn = .lowest
        style.trackColor = .clearIsh
        style.trackHeight = 70
        style.trackMarkWidth = 30
        style.trackMarkHeight = 70
        style.trackMarkInterval = .auto
        if #available(iOS 18.0, macOS 15.0, *) {
            style.trackMarkActiveColors = [.green]
            style.trackMarkInActiveColors = [ .black.mix(with: .green, by: 0.1) ]
        } else {
            // Fallback on earlier versions
            style.trackMarkActiveColors = [ .green]
            style.trackMarkInActiveColors = [ .black.opacity(0.2) ]
        }
        return style
    }()
    @MainActor
    public static let radial = {
        var style = SliderStyle("Radial")
        style.sliderIndicator = [.thumb,.tintedTrack]
        style.orientation = .radial
        style.tintCentredOn = .lowest
        style.trackHeight = 30
        return style
    }()
    @MainActor
    public static let dynamic = {
        var style = SliderStyle("Dynamic TrackMarks")
        style.sliderIndicator = [.tintedTrackMarks]
        style.trackMarkStyle = .dynamicSizing(percentOfTrack: 0.2, percentGrowth: 2.0)
        style.tintCentredOn = .lowest
        style.trackMarkInterval = .every(0.4)
        style.trackMarkHeight = 15
        style.trackMarkWidth = 4
        style.trackMarkActiveColors = [.blue, .green, .yellow]
        return style
    }()
    @MainActor
    public static let newClassic = {
        var style = SliderStyle("New Classic")
        style.sliderIndicator = [.thumb, .tintedTrack]
        style.trackHeight = 4
        style.trackColor = .classicTrack
        style.trackMarkInterval = .auto
        style.trackMarkWidth = 4
        style.labelInterval = .none
        style.tintCentredOn = .zero
        style.trackTintColor = .accentColor
        style.trackShadow = .radius(0.4)
        style.thumbSymbol = .circle
        style.thumbTintedBorder = true
        style.thumbColorAtRest = .classicThumb
        style.thumbWidth = 20
        style.thumbShapeEffect = .bounce
        return style
    } ()

    @MainActor
    public static let orangey = {
        var style = SliderStyle("Orangey")
        style.trackHeight = 8
        style.trackColor = .orange
        style.trackMarkInterval = .auto
        style.trackMarkWidth = 8
        style.trackTintColor = .yellow
        style.trackShadow = .radius(5)
        style.thumbSymbol = .capsule
        style.thumbTintedBorder = true
        style.thumbColorAtRest = .orange
        style.thumbWidth = 35
        style.thumbHeight = 50
        style.thumbShapeEffect = .bounce
        return style
    } ()

}




