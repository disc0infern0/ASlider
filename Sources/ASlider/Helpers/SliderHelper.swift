//
//  SliderHelper.swift
//  bindingToClass
//
//  Created by Andrew on 8/31/24.
//
import SwiftUI

//extension EnvironmentValues {
//    @Entry var sliderHelper: SliderHelper = SliderHelper()
//}

@Observable
@MainActor
@dynamicMemberLookup
final class SliderHelper {
    // Set from init
    var range: ClosedRange<Double>
    var isInt = false
    let step: Double?
    var sliderStyle: SliderStyle = .classic
    var rect: CGRect = .zero

    subscript<T>(dynamicMember keyPath: KeyPath<SliderStyle, T>) -> T {
        sliderStyle[keyPath: keyPath]
    }


    // to enable the "last" option for tint bar
    var lastSliderValue: Double
    // Radial style specifics
    var centre: CGPoint = .init(x: 100, y: 100)
    var outerRadius: Double = 200
    /// Distance from the centre to the inside of the track
    var innerRadius: Double = 100
    var trackLength: Double = 200
    var scaling: Double = 1.0

    /// Record the drag state. used to help toggle the dragStarted value.which triggers thumb animations
    /// Also will be used for dynamic bar marks
    var isDragging: Bool = false
    /// A value that changes when a drag gesture is started. Used to (optionally) animate the thumb
    var dragStarted: Bool = false
    /// The padding necessary to a linear slider track so that the thumb and/or trackmarks can be shown without
    /// exceeding the given space
    var trackBuffer: Double = 21

    var trackMarkDynamicSizing: Bool {
        if case .dynamicSizing = sliderStyle.trackMarkStyle {
            true
        } else {
            false
        }
    }
    init(
        range: ClosedRange<Double>, isInt: Bool, step: Double? = nil
            //        ,style: SliderStyle, rect: CGRect
    ) {
        guard range.lowerBound < range.upperBound else {
            fatalError("Range start must be lower than upper bound")
        }
        self.range = range
        self.isInt = isInt
        self.step = step
        self.sliderStyle = SliderStyle.classic
        //        self.sliderStyle = style
        //        self.rect = rect
        self.lastSliderValue = range.lowerBound
    }
    func updateStyle(_ style: SliderStyle) {
        sliderStyle = style
        // Warnings
        if sliderStyle.sliderIndicator.isEmpty {
            Warning.log("A valid slider indicator was not set.")
        }
        sliderStyle.thumbWidth =
            style.sliderIndicator.contains(.thumb) ? style.thumbWidth : 0

        if sliderStyle.sliderIndicator.contains(.tintedTrackMarks) {
            sliderStyle.trackHeight = sliderStyle.trackMarkHeight
        }

        if let step {
            /// When the step parameter is used, Apple switches the slider to snapping mode
            sliderStyle.trackMarkSnapping = true
            // On Mac, when the step indicator is used, the slider
            // thumb switches to a capsule, amd track marks are turned on
            #if os(macOS)
                sliderStyle.thumbSymbol = .capsule
                sliderStyle.thumbWidth = 10
                sliderStyle.trackMarkInterval = .every(step)
                sliderStyle.trackMarkActiveColors =
                    sliderStyle.trackMarkInActiveColors
            #endif
        }

        // correct for clear colour track not being clickable
        if sliderStyle.trackColor == .clear {
            sliderStyle.trackColor = .clearIsh  // almost clear. more clear than somewhat. less clear than totally transparent.
            let maxTrackMarkHeight =
                if case .dynamicSizing(_, let growth) = sliderStyle
                    .trackMarkStyle
                {
                    sliderStyle.trackMarkHeight * growth
                } else { sliderStyle.trackMarkHeight }
            sliderStyle.trackHeight = maxTrackMarkHeight
        }
    }

    func setTrackSize(to rect: CGRect) {
        centre = .init(x: rect.midX, y: rect.midY)
        switch sliderStyle.orientation {
        case .linear:
            trackBuffer = max(
                sliderStyle.thumbWidth, sliderStyle.trackMarkWidth)
            trackLength = max(0, rect.width - trackBuffer)
            scaling = trackLength / range.span
        case .radial:
            trackBuffer = 0
            trackLength = (Angle.threeSixty - sliderStyle.offsetAngle).radians
            scaling = trackLength / range.span
            let smallestDimension = min(rect.width, rect.height)
            outerRadius = max(0, smallestDimension * 0.5)
            innerRadius = max(0, outerRadius - sliderStyle.trackMarkHeight)
            let heightDifference =
                0.5 * (sliderStyle.trackMarkHeight - sliderStyle.trackHeight)
            if heightDifference > 0, outerRadius > heightDifference {
                outerRadius -= heightDifference
                innerRadius -= heightDifference
            }
        }
    }

    /// Two Helper functions to convert from a slider value to a track position
    func sliderPosition(of sliderValue: Double) -> Double {
        return trackBuffer * 0.5 + (sliderValue - range.lowerBound) * scaling
    }
    func angle(of value: Double) -> Angle {
        return Angle(radians: (value - range.lowerBound) * scaling)
    }

    /// Two helper functions to convert a position on the track to a sliderValue
    /// Get a new slider value from a location clicked on the track
    func getSliderValue(of xlocation: Double) -> Double {
        return range.lowerBound + ((xlocation - trackBuffer * 0.5) / scaling)
    }

    /// Calculate the clockwise angle from the y axis to the centre of the circle given to the location of a click point on the track
    /// Use the formula angle = 2 x arcsin (0.5 x |P1 - P2| / radius)
    /// to get the shortest angle, and then adjust negative values for clockwise positive values
    func getAngleValue(from location: CGPoint) -> Double {
        let p1 = CGPoint(x: location.x - centre.x, y: centre.y - location.y)
        let r = p1.hypotenuse
        let p2 = CGPoint(x: 0, y: r)
        let shortestAngle = Angle(
            radians: 2 * asin(0.5 * p1.distance(to: p2) / r))
        // adjust for negative angles since we always want the clockwise rotation from the y axis
        let angle =
            p1.x.sign == .plus ? shortestAngle : .threeSixty - shortestAngle

        /// If the location is in the offset range, i.e. not on the track, set the value to the closest maximal or minimal value by bisectingn the offsetAngle
        if angle > Angle.threeSixty - sliderStyle.offsetAngle {
            return Angle.threeSixty - angle < sliderStyle.offsetAngle / 2
                ? range.lowerBound : range.upperBound
        }
        let result = angle.radians / scaling
        // Range check failsafes - should never be needed.
        if result > range.upperBound {
            Warning.log("Angle value too high, adjusted to upper bound")
            return range.upperBound
        }
        if result < range.lowerBound {
            Warning.log("Angle value too low, adjusted to lower bound")
            return range.lowerBound
        }
        return result
    }

    enum TrackValues {
        case trackMarks, trackLabels, trackAngles
    }
    var trackAngles: [Angle] {
        trackValues(for: .trackAngles).map { Angle(radians: $0) }
    }
    
    struct TrackInterval: Identifiable, Equatable, Sendable, Hashable {
        let id: UUID = UUID()
        let value: Double
    }
    var trackIntervals: [TrackValues: [TrackInterval]] = [:] // to-do
    
    /// Get array of values (not offsets)  for where trackMarks or trackLabels should be placed
    func trackValues(for trackValue: TrackValues) -> [Double] {
        var marks: [Double] = []
        let interval: Double = increment(of: trackValue)
        guard interval != 0 else { return [] }
        var next = startValue()
        let maxVal = maxValue()
        while next <= maxVal {
            marks.append(next)
            next += interval
        }
        return marks

        func startValue() -> Double {
            switch trackValue {
            case .trackAngles: 0
            default: range.lowerBound
            }
        }
        func maxValue() -> Double {
            switch trackValue {
            case .trackAngles:
                (Angle.threeSixty - sliderStyle.offsetAngle).radians
            default: range.upperBound
            }
        }
        func increment(of trackValues: TrackValues) -> Double {
            switch trackValues {
            case .trackLabels:
                if case .every(let increment) = sliderStyle.labelInterval {
                    increment
                } else {
                    range.span * 0.5
                }  //Auto labels are beginning, middle and end
            case .trackMarks:
                increment(for: sliderStyle.trackMarkInterval, linear: true)
            case .trackAngles:
                increment(for: sliderStyle.trackMarkInterval, linear: false)
            }
        }
        func increment(for trackMarks: SliderStyle.TrackIntervals, linear: Bool)
            -> Double
        {
            switch trackMarks {
            case .every(let interval):
                linear ? interval : Angle(degrees: interval).radians
            case .auto:
                auto(linear: linear)
            }
        }
        func auto(linear: Bool) -> Double {
            if linear {
                range.span / 20
            } else {
                2.2
                    * Angle(
                        radians: atan(
                            sliderStyle.trackMarkWidth * 0.5 / innerRadius)
                    )
                    .radians
            }
        }
    }

    // #################################################
    enum SliderMovement: Double {
        case left = -1
        case right = 1
    }

    @discardableResult
    func moveSlider(
        sliderValue: Binding<Double>, direction: SliderMovement,
        trackMarks: SliderStyle.TrackIntervals
    ) -> KeyPress.Result {
        let trackMarkStep = trackMarkStep(of: trackMarks)
        let newValue =
            sliderValue.wrappedValue + trackMarkStep * direction.rawValue
        return setSlider(value: sliderValue, to: newValue)
            ? KeyPress.Result.handled : KeyPress.Result.ignored
    }

    @discardableResult
    func setSlider(value: Binding<Double>, to newValue: Double) -> Bool {
        var returnValue = true
        var new: Double = newValue
        if newValue > range.upperBound {
            new = range.upperBound
            returnValue = false
        }
        if returnValue, newValue < range.lowerBound {
            new = range.lowerBound
            returnValue = false
        }

        if !isDragging {
            lastSliderValue = value.wrappedValue
        }
        value.wrappedValue =
            sliderStyle.trackMarkSnapping ? closestMark(to: new) : new
        return returnValue
    }

    func closestMark(to value: Double) -> Double {
        let m = trackValues(for: .trackMarks)
        guard !m.isEmpty else { return value }
        let pairs = zip(m, m.dropFirst())
        for pair in pairs {
            if pair.0 <= value && value < pair.1 {
                return value - pair.0 < pair.1 - value ? pair.0 : pair.1
            }
        }
        return value
    }

    /// Called by moveSlider and ArrowKeyPress in Thumb
    func trackMarkStep(of trackMarks: SliderStyle.TrackIntervals) -> Double {
        var increment: Double
        if case .every(let step) = trackMarks, step > 0 {
            /// a specific step has been asked for, so use it
            increment = step
        } else {
            increment = (range.upperBound - range.lowerBound) / 20
        }
        if isInt {
            increment = increment.rounded()
            if increment < 1 { increment = 1 }
        }
        return increment
    }
}
