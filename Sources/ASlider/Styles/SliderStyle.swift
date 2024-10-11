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
@Observable
public final class SliderStyle {
    /// regular trackmarkstyles have constant sizing.
    /// dynamic trackmarkstyles have the bar marks increase in size with the dragging event
    /// For dynamic styles;
    ///     percent: governs  the width of the track that expands upwards
    ///     growth:  multiplier dicating the maximum increase in height of the bar mark
    ///
    public init() { }

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
    public var trackHeight: Double = 4
    public var trackColor: Color = .primary.opacity(0.5)
    public var trackMarks: Marks = .none
    /// Allow modification of the trackMarks from the step: parameter of NewSlider.task (aka onAppear)
    internal func setTrackMarks(_ m: Marks) {
        trackMarks = m
    }
    public var trackMarkWidth: Double?
    public var trackMarkHeight: Double?
    public var trackMarkActiveColor: [Color] = [.secondary]
    public var trackMarkInActiveColor: [Color] = [Color(nsColor: .tertiaryLabelColor)]

    internal var i_trackMarkWidth: Double {
        if let width = trackMarkWidth {width} else { trackHeight * 0.4}
    }
    internal var i_trackMarkHeight: Double {
        if let height = trackMarkHeight  { height } else {
            max(thumbHeight/2.5, trackHeight ) }
    }

    public var labelMarks: Marks = .none

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
}






extension Set where Element == SliderStyle.SliderIndicator {
    var containsTrackMarks: Bool {
        for f in self {
            if case .trackMarks = f { return true}
        }
        return false
    }
    var containsTintBar: Bool {
        for f in self {
            if case .tintBar = f { return true }
        }
        return false
    }
}

