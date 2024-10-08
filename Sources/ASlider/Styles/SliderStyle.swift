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
        public static let none = Self.every(0)
    }
    public enum Shadow: Equatable, Sendable {
        case radius(Double)
        public static let none = Self.radius(0)
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
        @MainActor public static var zero = Self.value(0)
    }

    public struct SliderIndicator: OptionSet, Sendable {
        public let rawValue: Int
        public init(rawValue: Int) {
            fatalError("This initializer is not supported")
        }
        private init(raw: Int) {
            self.rawValue = raw
        }

        public static let thumb = SliderIndicator(raw: 1 << 0)
        public static let tintBar = SliderIndicator(raw: 1 << 1)
        public static let trackMarks = SliderIndicator(raw: 1 << 2)
        public static let all: SliderIndicator = [.thumb, .tintBar, .trackMarks]
    }

    public var sliderIndicator: SliderIndicator = [.thumb,.tintBar]
    public var trackHeight: Double = 4
    public var trackColor: Color = .primary.opacity(0.5)
    public var trackMarks: Marks = .auto
    public var trackMarkWidth: Double?
    public var trackMarkHeight: Double?
    public var trackMarkActiveColor: [Color] = [.primary]
    public var trackMarkInActiveColor: [Color] = [.primary.opacity(0.5), .secondary.opacity(0.4)]
    public var trackMarkStyle: TrackMarkStyle = .regular

    internal var _trackMarkWidth: Double {
        if let width = trackMarkWidth {width} else { trackHeight * 0.4}
    }
    internal var _trackMarkHeight: Double {
        if let height = trackMarkHeight  { height } else {
            max(_thumbWidth, trackHeight ) }
    }

    public var labelMarks: Marks = .none

    public var zeroBased = true
//    var showTrackTint: Bool = true
    public var tintCentredOn: CentredOn = .lowest
    public var trackTintColor: Color = .blue
    public var trackShadow: Shadow = .none
    public var trackShadowRadius: Double {
        switch trackShadow {
            case .radius(let r): return r
        }
    }
    public var trackShadowColor: Color {
        if trackShadowRadius > 0 {
            trackTintColor
        } else { .clear }
    }
    public var thumbSymbol: ThumbShape = .circle
    public var thumbTintedBorder = false
    public var thumbColor: Color = .gray
    public var thumbWidth: Double = 21
    public var thumbHeight: Double = 21
    public var thumbShapeEffect: ShapeEffects = .bounce

    var _thumbWidth: Double {
        if sliderIndicator.contains(.thumb) { thumbWidth } else { 0 }
    }
}


