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
    public init(_ name: String) {self.name = name }
    var name: String = ""
    public enum Orientation: Equatable, Hashable, Sendable {
        case linear, radial
    }
    /// Determins whether the slider has a regular, or linear, slider presentation or as a rounded, or radial display.
    public var orientation: Orientation = .linear

    /// A Type for specifying intervals along the slider. Used for both track marks and for labels.
    /// Settings:   
    /// `.none` to disable ,   
    /// `.auto` to calculate the interval based on the tracklength and/or range specified on the slider,   
    /// `.every(_: Double)` specify the interval in absolute terms. For radial sliders, this setting specifies an angle in degrees.
    public enum TrackIntervals: Equatable, Hashable, Sendable {
        case every(Double),
             auto
        public static let none = Self.every(0)
    }
    public enum TrackShadow: Equatable, Hashable, Sendable {
        case radius(Double)
        public static let none = Self.radius(0)
    }
    public enum ThumbShape: Equatable, Hashable, Sendable {
        case none, circle, capsule, bolt, volume, custom(String)
        var symbolName: String {
            switch self {
                case .none: ""
                case .circle: "circle"
                case .capsule: "capsule.portrait"
                case .bolt: "bolt"
                case .volume: "speaker.wave.2.circle.fill"
                case .custom(let symbolName): symbolName
            }
        }
    }
    public enum CentredOn: Equatable, Hashable, Sendable {
        case value(Double), lastValue, lowest
        @MainActor public static var zero = Self.value(0)
    }
    /// Specifies how the slider valus should be indicated.   
    /// Any combination of the following three values is possible:-   
    /// `.thumb`:  Displays a draggable thumb symbol   
    /// `.tintedTrack`: Displays a tint along the track from a start position to the value. Note:the start position is normally the range lowerBound, however this can be overriden by the `centredOn` property.   
    /// `tintedTrackMarks`:  The trackMarks will be tinted based on whether the trackmark is less than or equal to the current slider value
    ///  
    public enum SliderIndicator : Sendable, Equatable, Hashable {
        case thumb, tintedTrack, tintedTrackMarks
    }
    /// A type to indicate whether track marks displayed on the slider should be a fixed size (`.fiexedSize`), or if the height will vary based on the current drag position (`.dynamicSizing(percentOfTrack: Double, percentGrowth: Double)`).    
    /// For dynammic sizing:   
    /// `percentOfTrack`: The percentage of the slider that displayes increases in size   
    /// `percentGrowth`: The percentage increase of a trackMark, e.g. 2.0 to increase the size of the trackMark within the percentOfTrack area by up to two times. Note the increase is exponential up to this value.
    public enum TrackMarkStyle: Equatable, Hashable, Sendable {
        case fixedSize, dynamicSizing(percentOfTrack: Double, percentGrowth: Double)
        var isDynamic: Bool {
            if case .dynamicSizing = self { true } else { false }
        }
    }
    /// The track mark style, which defaults to `.fixedSize`
    public var trackMarkStyle: TrackMarkStyle = .fixedSize
    /// The animation to use for the slider thumb and tint
    public var sliderAnimation: Animation = .smooth(duration: 0.2)
    /// Controls what will indicate the slider value. An empty set will generate warnings in the console  and system log.
    public var sliderIndicator: Set<SliderIndicator> = [.thumb, .tintedTrack]
    /// Internal convenience variable
    var dynamicTrackMarks: (percentOfTrack: Double, percentGrowth: Double)? {
        if case .dynamicSizing(let percentOfTrack, let percentGrowth) = trackMarkStyle {
            (percentOfTrack, percentGrowth)
        } else { nil }
    }
    /// Height of the track
    public var trackHeight: Double = 4
    /// Color of the track
    public var trackColor: Color = .classicTrack
    /// Specify track mark interval
    public var trackMarkInterval: TrackIntervals = .none
    /// trackMarkSnapping controls whether trackmarks are the only permissible values
    public var trackMarkSnapping = false
    /// The Color of track marks which are less than the current slider value [ only if the track mark interval is non zero, and the `sliderIndicator` is set to  `tintedTrackMark`, ]  
    public var trackMarkActiveColors: [Color] = [.secondary]
    /// The default color of a track mark. Also, the color of the track marks which are greater than the current slider value if the track mark interval is non zero, and the `sliderIndicator` is set to  `tintedTrackMark` 
    public var trackMarkInActiveColors: [Color] = [.tertiary]

    // Two overwritable variables, which are computed values by default
    ///Width of a trackmark. Defaults to 0.4 of the track height
    public var trackMarkWidth: Double {
        get { if let i_trackMarkWidth { i_trackMarkWidth } else { trackHeight * 0.4 } }
        set { i_trackMarkWidth = newValue}
    }
    internal var i_trackMarkWidth: Double?

    ///Height of a trackmark, defaults to the greater of 2/5ths of the thumbHeight, and the trackHeight
    public var trackMarkHeight: Double {
        get { if let i_trackMarkHeight { i_trackMarkHeight } else { max(thumbHeight/2.5, trackHeight )} }
        set { i_trackMarkHeight = newValue}
    }
    internal var i_trackMarkHeight: Double?

    /// The interval for labels underneath a linear slider. If set to `.none`, then labels will not be displayed
    public var labelInterval: TrackIntervals = .none

    /// Specify whete the tint position should start from. By default, it is the range lowerbound
    public var tintCentredOn: CentredOn = .lowest
    public var trackTintColor: Color = .accentColor
    public var trackShadow: TrackShadow = .radius(0.3)
    var trackShadowRadius: Double {
        switch trackShadow {
            case .radius(let r): return r
        }
    }
    public var trackShadowColor: Color {
        get { 
            if let i_trackShadowColor { 
                i_trackShadowColor 
            } else { trackShadowRadius > 0 ? .gray : .clear }
        } 
        set { i_trackShadowColor = newValue }
    }
    internal var i_trackShadowColor: Color?
    public var thumbSymbol: ThumbShape = .circle
    public var thumbTintedBorder = false
    public var thumbColorAtRest: Color = Color.classicThumb
    public var thumbColorDragging: Color = Color.classicThumb.opacity(0.4)
#if os(macOS)
    public var thumbWidth: Double = 21
    public var thumbHeight: Double = 21
#else
    public var thumbWidth: Double = 27
    public var thumbHeight: Double = 27
#endif
    public var thumbShapeEffect: ShapeEffects = .bounce

    /// How far around the circle should the track go - or how close to the beginning?.
    /// 30 degrees would represent 330 from the vertical axis
    public var offsetAngle:Angle = Angle(degrees:30)
}

