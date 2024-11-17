//
//  TrackMarks.swift
//  ASlider
//
//  Created by Andrew on 9/2/24.
//

import SwiftUI

struct TrackMarks: View {
    @Environment(SliderHelper.self) var sliderHelper
    var sliderValue: Double

    var body: some View {
        if sliderHelper.trackMarkInterval != .none {
            switch sliderHelper.orientation {
            case .radial: RadialTrackMarks(value: sliderValue)
            case .linear: LinearTrackMarks
            }
        }
    }
    var LinearTrackMarks: some View {
        let growth = sliderHelper.dynamicTrackMarks?.percentGrowth ?? 1.0
        let markValues = sliderHelper.trackValues(for: .trackMarks)
        return TrackLayout(
            hpad: sliderHelper.trackBuffer,
            vpad: sliderHelper.trackMarkHeight * (growth - 1),
            alignment: sliderHelper.trackMarkDynamicSizing
                ? .bottomLeading : .leading
        ) {
            ForEach(markValues, id: \.self) { markValue in
                TrackMark(
                    height: barHeight(for: markValue),
                    status: shouldHighlight(markValue)
                )
            }
        }
    }

    func shouldHighlight(_ markValue: Double) -> TrackMark.Status {
        var rangeStart: Double
        var rangeEnd: Double
        guard sliderHelper.sliderIndicator.contains(.tintedTrackMarks) else {
            return .inactive
        }
        switch sliderHelper.tintCentredOn {
        case .lowest:
            rangeStart = sliderHelper.range.lowerBound
            rangeEnd = sliderValue
        case .value(let fixedValue):
            (rangeStart, rangeEnd) =
                fixedValue < sliderValue
                ? (fixedValue, sliderValue) : (sliderValue, fixedValue)
        case .lastValue:
            rangeStart = 0
            rangeEnd = sliderHelper.range.upperBound
        }
        return (rangeStart...rangeEnd).contains(markValue) ? .active : .inactive
    }

    /// for mark values in the percentage range of the slidervalue,
    /// calculate height based on the formula y = a.x^3 + c
    func barHeight(for markValue: Double) -> Double {
        guard sliderHelper.isDragging,
            shouldHighlight(markValue) == .active,
            let (percent, growth) = sliderHelper.dynamicTrackMarks,
            let normalisedXValue = getNormalisedXvalue(
                for: markValue, with: percent)
        else {
            return sliderHelper.trackMarkHeight
        }
        /// Fit shape to y = a.x^3 + c
        ///  when x=1, y= growth*trackheight,  when x = 0, y = trackHeight
        let c = sliderHelper.trackMarkHeight
        /// growth*c = a + c
        let a = c * (growth - 1)
        let x3 = pow(normalisedXValue, 3)

        return a * x3 + c
    }

    /// return a value between 0 and 1 if the markValue is within a given percent range of the slidervalue
    /// or -1 if not in range.
    func getNormalisedXvalue(for markValue: Double, with percent: Double)
        -> Double?
    {
        let raisedRange = sliderHelper.range.span * percent
        guard sliderValue - raisedRange <= markValue,
            markValue <= sliderValue + raisedRange
        else { return nil }
        return 1 - abs(markValue - sliderValue) / raisedRange
    }
}

#Preview("regular") {
    @Previewable @State var rect: CGRect = .zero
    @Previewable @State var sliderHelper = SliderHelper(range:0...20, isInt: false )
    @Previewable @State var style: SliderStyle = .classic

    ZStack {
        Track()
        Capsule().frame(width: 2).position(x: 10, y: 50)
        Capsule().frame(width: 2).position(x: 310, y: 50)
        Capsule().frame(width: 2).position(x: 610, y: 50)
        TrackMarks(sliderValue: 12)
            .readFrame {
                style.sliderIndicator = [
                    .thumb,
                    .tintedTrack
                ]
                style.thumbWidth=20
                style.trackColor = .red
                style.trackMarkInterval = .every(2)
                style.trackMarkHeight = 15
                style.trackMarkWidth = 4
                style.trackMarkActiveColors = [.blue]
                style.trackMarkInActiveColors = [.gray]
                sliderHelper.setTrackSize(to: $0)
                sliderHelper.updateStyle(style)
            }
            .border(.teal)
    }
    .environment( sliderHelper )
    .frame(width: 620, height: 100)
    .border(.teal)
    .padding(20)
}
//#Preview("dynamic") {
//    @Previewable @State var rect: CGRect = .zero
//
//    ZStack(alignment: .center) {
//        Capsule()
//            .fill(.red)
//            .frame(height: 3.0)
//        TrackMarks(sliderValue: 18)
//    }
//    .frame(width: 500, height: 200)
//    .readFrame { rect = $0 }
//    .environment(
//        SliderHelper(
//            range: 0...30, isInt: false,
//            style: {
//                var style: SliderStyle = .dynamic
//                style.sliderIndicator = [.tintedTrackMarks]
//                style.trackMarkStyle =
//                    .dynamicSizing(percentOfTrack: 0.2, percentGrowth: 2.0)
//                style.tintCentredOn = .value(0)
//                style.trackMarks = .every(0.7)
//                style.trackMarkHeight = 15
//                style.trackMarkWidth = 4
//                style.trackMarkActiveColors = [.blue, .green, .yellow]
//                return style
//            }(), rect: rect)
//    )
//    .border(.teal)
//    .padding(20)
//    .border(.blue)
//    .padding(10)
//
//}
//
//#Preview("Radial track marks") {
//    @Previewable @State var value = 0.2
//    let rect: CGRect = .init(x: 0, y: 0, width: 300, height: 300)
//    ZStack {
//        Track()
//        Tint(sliderValue: value)
//        TrackMarks(sliderValue: value)
//    }
//    .environment(
//        SliderHelper(
//            range: 0...1, isInt: false,
//            style: {
//                var style: SliderStyle = .classic
//                style.sliderIndicator = [.tintedTrack]
//                style.trackColor = .clear
//                style.trackTintColor = .black
//                return style
//            }(), rect: rect)
//    )
//    .frame(width: 300, height: 300)
//    .padding(2)
//}
