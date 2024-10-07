//
//  Styling.swift
//  MySlider
//
//  Created by Andrew on 08/07/2024.
//

import SwiftUI

/// Control the style of a slider through various configurable settings,  such
/// as trackHeight, thumbWidth, thumbSymbol
/// Or use prefined settings:
/// .classic - similar to SwiftUI slider
/// .newClassic - similar to above, but with additional thumb bounce and tint
/// .orangey - bigger and bolder and ... more orangey!
///
public extension EnvironmentValues {
    @Entry var sliderStyle: SliderStyle = SliderStyle()
}


public struct SliderStyle: Equatable, Sendable {
    /// regular trackmarkstyles have constant sizing.
    /// dynamic trackmarkstyles have the bar marks increase in size with the dragging event
    /// For dynamic styles;
    ///     percent: governs  the width of the track that expands upwards
    ///     growth:  multiplier dicating the maximum increase in height of the bar mark
    public enum TrackMarkStyle: Equatable, Sendable {
        case regular, dynamic(percent: Double, growth: Double)
    }
    public enum Marks: Equatable, Sendable {
        case every(Double), auto
        static let none = Self.every(0)
    }
    public enum Shadow: Equatable, Sendable {
        case radius(Double)
        static let none = Self.radius(0)
    }
    public enum ThumbShape: Equatable, Sendable {
        case none, circle, capsule, bolt, custom(String)
        var symbolName: String {
            switch self {
                case .none: ""
                case .circle: "circle"
                case .capsule: "capsule.portrait"
                case .bolt: "bolt"
                case .custom(let symbolName): symbolName
            }
        }
    }
    public enum Rotation: Equatable, Sendable {
        static let conversionFactor = Double.pi / 180
        case radians(Double), degrees(Double)
        var radian: Double {
            switch self {
                case .radians(let r):   r
                case .degrees(let d):   d * Self.conversionFactor
            }
        }
    }
    public enum CentredOn: Equatable, Sendable {
        case value(Double), lastValue, lowest
        @MainActor static var zero = Self.value(0)
    }

    struct SliderIndicator: OptionSet {
        let rawValue: Int

        static let thumb = SliderIndicator(rawValue: 1 << 0)
        static let tintBar = SliderIndicator(rawValue: 1 << 1)
        static let trackMarks = SliderIndicator(rawValue: 1 << 2)
        static let all: SliderIndicator = [.thumb, .tintBar, .trackMarks]
    }

    var sliderIndicator: SliderIndicator = [.thumb,.tintBar]
    var trackHeight: Double = 4
    var trackColor: Color = Color( white: 0.3, opacity: 1.0)
    var trackMarks: Marks = .auto
    var trackMarkWidth: Double?
    var trackMarkHeight: Double?
    var trackMarkActiveColor: [Color] = [.white]
    var trackMarkInActiveColor: [Color] = [.primary.opacity(0.5), .secondary.opacity(0.4)]
    var trackMarkStyle: TrackMarkStyle = .regular

    internal var _trackMarkWidth: Double {
        if let width = trackMarkWidth {width} else { trackHeight * 0.4}
    }
    internal var _trackMarkHeight: Double {
        if let height = trackMarkHeight  { height } else {
            max(_thumbWidth, trackHeight ) }
    }

    var labelMarks: Marks = .none

    var zeroBased = true
//    var showTrackTint: Bool = true
    var tintCentredOn: CentredOn = .lowest
    var trackTintColor: Color = .blue
    var trackShadow: Shadow = .none
    var trackShadowRadius: Double {
        switch trackShadow {
            case .radius(let r): return r
        }
    }
    var trackShadowColor: Color {
        if trackShadowRadius > 0 {
            trackTintColor
        } else { .clear }
    }
    var thumbSymbol: ThumbShape = .circle
    var thumbTintedBorder = false
    var thumbColor: Color = .gray
    var thumbWidth: Double = 21
    var thumbHeight: Double = 21
    var thumbShapeEffect: ShapeEffects = .bounce

    var _thumbWidth: Double {
        if sliderIndicator.contains(.thumb) { thumbWidth } else { 0 }
    }
}


