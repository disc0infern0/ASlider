//
//  SliderStyle.swift
//  NewSlider
//
//  Created by Andrew on 08/07/2024.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var sliderStyle: SliderStyle = SliderStyle()
}

/// Control the style of a slider through various configurable settings,  such
/// as trackHeight, thumbWidth, thumbSymbol
/// Or use prefined settings:
/// .classic - similar to SwiftUI slider
/// .newClassic - similar to above, but with additional thumb bounce and tint
/// .orangey - bigger and bolder and ... more orangey!
public struct SliderStyle: Equatable, Hashable {
//public final class SliderStyle {
    /// dynamic trackmarkstyles have the bar marks increase in size with the dragging event
    /// For dynamic styles;
    ///     percent: governs  the width of the track that expands upwards
    ///     growth:  multiplier dicating the maximum increase in height of the bar mark
    ///
    public init() { }

    public enum TrackMarks: Equatable, Hashable, Sendable {
        case every(Double), auto
        public static let none = Self.every(0)
    }
    public enum TrackShadow: Equatable, Hashable, Sendable {
        case radius(Double)
        public static let none = Self.radius(0)
    }
    public enum ThumbShape: Equatable, Hashable, Sendable {
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
    public enum CentredOn: Equatable, Hashable, Sendable {
        case value(Double), lastValue, lowest
        @MainActor public static var zero = Self.value(0)
    }
    public enum SliderIndicator : Sendable, Equatable, Hashable {
        case thumb, tintBar, trackMarks(percent: Double, growth: Double)
    }

    public var sliderAnimation: Animation = .smooth(duration: 0.2)
    public var sliderIndicator: Set<SliderIndicator> = [.thumb, .tintBar]
    public var dynamicTrackMarks: (percent: Double,growth: Double)? {
        for indicator in sliderIndicator {
            if case .trackMarks(let percent, let growth) = indicator {
                return (percent, growth)
            }
        }
        return nil
    }
    internal var trackBuffer: Double { max(thumbWidth, i_trackMarkWidth)}
    public var trackHeight: Double = 4
    public var trackColor: Color = .classicTrack
    public var trackMarks: TrackMarks = .none
    /// trackMarkSnapping controls whether trackmarks are the only permissible values
    public var trackMarkSnapping = false
    public var trackMarkWidth: Double?
    public var trackMarkHeight: Double?
    public var trackMarkActiveColor: [Color] = [.secondary]
    public var trackMarkInActiveColor: [Color] = [.tertiary]

    internal var i_trackMarkWidth: Double {
        if let width = trackMarkWidth {width} else { trackHeight * 0.4}
    }
    internal var i_trackMarkHeight: Double {
        if let height = trackMarkHeight  { height } else {
            max(thumbHeight/2.5, trackHeight ) }
    }

    public var labelMarks: TrackMarks = .none

    public var tintCentredOn: CentredOn = .lowest
    public var trackTintColor: Color = .accentColor
    public var trackShadow: TrackShadow = .radius(0.3)
    public var trackShadowRadius: Double {
        switch trackShadow {
            case .radius(let r): return r
        }
    }
    public var trackShadowColor: Color {
        if trackShadowRadius > 0 {
            .gray
        } else { .clear }
    }
    public var thumbSymbol: ThumbShape = .circle
    public var thumbTintedBorder = false
    public var thumbColor: Color = Color.classicThumb
#if os(macOS)
    public var thumbWidth: Double = 21
    public var thumbHeight: Double = 21
#else
    public var thumbWidth: Double = 27
    public var thumbHeight: Double = 27
#endif
    public var thumbShapeEffect: ShapeEffects = .bounce
}

/*
 //MARK: currently unused
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

 /// Allow modification of the trackMarks from the step: parameter of NewSlider.task (aka onAppear)
 internal func setTrackMarks(_ m: TrackMarks) {
 trackMarks = m
 }

 */
