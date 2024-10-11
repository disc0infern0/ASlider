//
//  TrackMarks.swift
//  ASlider
//
//  Created by Andrew on 9/2/24.
//

import SwiftUI

struct TrackMarks: View {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    let sliderValue: Double
    var alignment: UnitPoint {
        if sliderStyle.dynamicTrackMarks != nil {
            UnitPoint.bottomLeading
        } else { UnitPoint.leading }
    }

    var body: some View {
        let activeGradient = LinearGradient(colors: sliderStyle.trackMarkActiveColor,
                                            startPoint: .top, endPoint: .bottom)
        let inActiveGradient = LinearGradient(colors: sliderStyle.trackMarkInActiveColor,
                                              startPoint: .top, endPoint: .bottom)
        let growth = sliderStyle.dynamicTrackMarks?.growth ?? 1.0
        let markValues = sliderHelper.markValues(from: sliderStyle.trackMarks)
        TrackLayout(
            hpad: max(sliderStyle.thumbWidth, sliderStyle.i_trackMarkWidth) ,
            vpad: sliderStyle.i_trackMarkHeight * (growth - 1),
            alignment: alignment
        ) {
            ForEach(markValues, id: \.self) { markValue in
                let gradient = shouldHighlight(markValue) ? activeGradient : inActiveGradient
                let height = barHeight(for: markValue)
                Trackmark(gradient: gradient, height: height)
            }
        }
    }

    func shouldHighlight(_ markValue: Double) -> Bool {
        var rangeStart: Double
        var rangeEnd: Double
        guard sliderStyle.sliderIndicator.containsTrackMarks else { return false}
        switch sliderStyle.tintCentredOn {
            case .lowest:
                rangeStart = sliderHelper.range.lowerBound
                rangeEnd = sliderValue
            case .value(let fixedValue):
                (rangeStart, rangeEnd) = fixedValue < sliderValue ? (fixedValue,sliderValue) : (sliderValue, fixedValue)
            case .lastValue:
                rangeStart = 0; rangeEnd = sliderHelper.range.upperBound
        }
        return (rangeStart...rangeEnd).contains(markValue)
    }

    func barHeight(for markValue: Double) -> Double {

        guard sliderHelper.isDragging,
              let (percent,growth) = sliderStyle.dynamicTrackMarks, shouldHighlight(markValue)
        else {
            return sliderStyle.i_trackMarkHeight
        }
        let normalisedXValue = getNormalisedXvalue(for: markValue, with: percent)
        guard normalisedXValue >= 0 else {
            return sliderStyle.i_trackMarkHeight
        }
        /// Follow formula y = a.x^3 +c
        ///  when x=1, y= growth*trackheight,  when x = 0, y = trackHeight
        let a = sliderStyle.i_trackMarkHeight * (growth - 1 )
        let x2 = pow(normalisedXValue,3)
        let height = a * x2 + sliderStyle.i_trackMarkHeight
        return height
    }

    func getNormalisedXvalue(for markValue: Double, with percent: Double) -> Double {

        let raisedRange = sliderHelper.range.span * percent

        guard sliderValue - raisedRange <= markValue, markValue <= sliderValue + raisedRange else { return -1 }

        return 1 - abs(markValue - sliderValue) / raisedRange
    }
}
extension ClosedRange<Double> {
    var span: Double { upperBound - lowerBound }
}
#Preview {

    ZStack(alignment: .leading ) {
        Capsule()
            .fill(.red)
            .frame(height: 3.0)
            .border(.red)
        TrackMarks(sliderValue: 18)
            .environment(SliderHelper(range: 0...30, isInt: false))
            .sliderStyle(.classic) { style in
                style.sliderIndicator = [.trackMarks(percent: 0.2, growth: 2.0)]
                style.tintCentredOn = .value(10)
                style.trackMarks = .every(0.4)
                style.trackMarkHeight = 15
                style.trackMarkWidth = 4
                style.trackMarkActiveColor = [.blue, .green, .yellow]
            }
            .border(.teal)
    }
    .padding(20)
    .border(.green)
    .padding(10)
}

