//
//  SliderHelper.swift
//  bindingToClass
//
//  Created by Andrew on 8/31/24.
//
import SwiftUI
import OSLog

//extension EnvironmentValues {
//    @Entry var sliderHelper: SliderHelper = SliderHelper()
//}

@Observable
final class SliderHelper {
    var range: ClosedRange<Double>
    var isInt = false

    var trackLength: Double = 1  // must be reset
    var thumbWidth: Double = 1 // must be reset
    var scaling = 1.0
    /// Record the drag state. used to help toggle the dragStarted value.which triggers thumb animations
    /// Also will be used for dynamic bar marks
    var isDragging: Bool = false
    /// A value that changes when a drag gesture is started. Used to (optionally) animate the thumb
    var dragStarted: Bool = false

    init(range: ClosedRange<Double>, isInt: Bool) {
        guard range.lowerBound < range.upperBound else {
            fatalError("Range must be lower than upper bound")
        }
        self.range = range
        self.isInt = isInt
    }

    var minThumbPos: Double {
        sliderLocation(of: range.lowerBound)
    }
    var maxThumbPos: Double {
        sliderLocation(of: range.upperBound)
    }

    private var buffer: Double = 0
    // Calculations for positioning
    func setTrackLength(to width: Double, trackBuffer: Double) {
        buffer = trackBuffer
        trackLength = width - trackBuffer
        scaling = trackLength/range.span
    }
    /// Helper function to convert from a slider value to a track location
    func sliderLocation(of sliderValue: Double) -> Double {
        return buffer*0.5 + (sliderValue - range.lowerBound) * scaling
    }
    func thumbPos(of sliderValue: Double, thumbWidth: Double) -> Double {
        sliderLocation(of: sliderValue) - thumbWidth/2
    }

    /// Get a new slider value from a location clicked on the track
    func getSliderValue(of x: Double) -> Double {
        return  range.lowerBound + ((x - buffer*0.5)  / scaling)
    }
    /// List of values (not offsets)  for where trackMarks or trackLabels should be placed
    func markValues(from trackMarks: SliderStyle.TrackMarks) -> [Double] {
        var marks: [Double] = [] 
        let interval: Double = switch trackMarks {
            case .every(let interval): interval
            case .auto: (range.upperBound - range.lowerBound) / 9.0
        }
        guard interval != 0 else { return [] }
        var next = range.lowerBound
        while next <= range.upperBound {
            marks.append(next)
            next += interval
        }
        return marks
    }

    @discardableResult
    func moveSlider(sliderValue: inout Double, direction: SliderMovement, trackMarks: SliderStyle.TrackMarks) -> KeyPress.Result {
        let trackMarkStep = trackMarkStep(of: trackMarks )
        let newValue = sliderValue + trackMarkStep*direction.rawValue
        if newValue > range.upperBound {
            sliderValue = range.upperBound
            return KeyPress.Result.ignored
        }
        if newValue < range.lowerBound {
            sliderValue = range.lowerBound
            return KeyPress.Result.ignored
        }
        sliderValue = newValue
        return KeyPress.Result.handled
    }

    @discardableResult
    func setSlider(value: Binding<Double>, to newValue: Double) -> Bool {
        if newValue > range.upperBound {
            value.wrappedValue = range.upperBound
            return false
        }
        if newValue < range.lowerBound {
            value.wrappedValue = range.lowerBound
            return false
        }
        value.wrappedValue = trackMarkSnapping ? closestMark(to: newValue) : newValue
        return true
    }

    func closestMark(to value: Double) -> Double {
        guard let trackMarks = self.trackMarks else { return value}
        let m = markValues(from: trackMarks)
        let pairs = zip(m, m.dropFirst())
        for pair in pairs {
            if pair.0 <= value && value < pair.1 {
                return value - pair.0 < pair.1 - value ? pair.0 : pair.1
            }
        }
        return value
    }

    enum SliderMovement: Double { case left = -1; case right = 1 }

    /// Called by moveSlider and ArrowKeyPress in Thumb
    func trackMarkStep(of trackMarks: SliderStyle.TrackMarks) -> Double {
        var increment: Double
        if case .every(let step) = trackMarks, step > 0 {
            /// a specific step has been asked for, so use it 
            increment = step
        } else {
            increment = (range.upperBound - range.lowerBound)/20
        }
        if isInt {
            increment = increment.rounded()
            if increment < 1 { increment = 1 }
        }
        return increment
    }

    /// to be copied from sliderStyle so that trackmark snapping can be done here.
    var trackMarks: SliderStyle.TrackMarks?
    var trackMarkSnapping: Bool = false

    func styleUpdate(style: SliderStyle, step: Double?) -> SliderStyle {
        var style = style
        
        if style.sliderIndicator.isEmpty  {
            let logger = Logger(
                subsystem: Bundle.main.bundleIdentifier ?? "New Slider",
                category: "Init")
            let message = "A valid slider indicator was not set."
            logger.warning("\(message, privacy: .public)")
        }
        if let step {
            style.trackMarks = .every(step)
            #if os(macOS)
            style.thumbSymbol = .capsule
            style.thumbWidth = 10
            #endif
            style.trackMarkSnapping = true
        }
        if !style.sliderIndicator.contains(.thumb) {
            style.thumbWidth = 0
        }
        self.trackMarks = style.trackMarks
        self.trackMarkSnapping = style.trackMarkSnapping
        return style
    }
}

