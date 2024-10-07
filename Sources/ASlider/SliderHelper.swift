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
    func setTrackLength(to width: Double, thumbWidth: Double, trackMarkWidth: Double) {
        self.thumbWidth = thumbWidth
        buffer = max(thumbWidth, trackMarkWidth)
        self.trackLength = width - buffer
        scaling = (self.trackLength  ) / (range.upperBound - range.lowerBound)
    }
    /// Helper function to convert from a slider value to a track location
    func sliderLocation(of sliderValue: Double) -> Double {
        buffer*0.5 + (sliderValue - range.lowerBound) * scaling
    }

    func getSliderValue(of location: Double) -> Double {
        // MARK: TODO  Use the rotation value and x/y position of thumb to calculate sliderValue
         range.lowerBound + (location - buffer*0.5)  / scaling
    }
    /// List of values (not offsets)  for where trackMarks or trackLabels should be placed
    func markValues(from trackMarks: SliderStyle.Marks) -> [Double] {
        var marks: [Double] = []
        let interval: Double = switch trackMarks {
            case .every(let interval): interval
            case .auto: (range.upperBound - range.lowerBound) / 9.0
        }
        guard interval != 0 else { return marks }
        var next = range.lowerBound
        while next <= range.upperBound {
            marks.append(next)
            next += interval
        }
        return marks
    }

    @discardableResult
    func moveSlider(sliderValue: inout Double, direction: SliderMovement, trackMarks: SliderStyle.Marks) -> KeyPress.Result {
        let trackMarkStep = trackMarkStep(of: trackMarks )
        let newSliderValue = sliderValue + trackMarkStep*direction.rawValue
        if newSliderValue <= range.upperBound, newSliderValue >= range.lowerBound {
            sliderValue = newSliderValue
            return KeyPress.Result.handled
        } else {
            return KeyPress.Result.ignored
        }
    }

    enum SliderMovement: Double { case left = -1; case right = 1 }

    /// Called by moveSlider and ArrowKeyPress in Thumb
    func trackMarkStep(of trackMarks: SliderStyle.Marks) -> Double {
        var increment: Double
        if case .every(let step) = trackMarks, step > 0 {
            /// a specific step has been asked for, so use it (even if it may be zero for integers)
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

    func isValidSliderValue(_ sliderValue: Double) -> Bool {
        sliderValue <= range.upperBound &&
        sliderValue >= range.lowerBound
    }

}
