//
//  Tint 2.swift
//  bindingToClass
//
//  Created by Andrew on 9/2/24.
//



import SwiftUI

struct TrackMarks: View {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    let sliderValue: Double
    @State var activeGradient: LinearGradient = LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
    @State var inActiveGradient: LinearGradient = LinearGradient(colors: [.primary.opacity(0.5), .secondary.opacity(0.4)], startPoint: .top, endPoint: .bottom)
    var alignment: UnitPoint {
        if case .dynamic = sliderStyle.trackMarkStyle {
            UnitPoint.bottomLeading
        } else { UnitPoint.leading }
    }

    var body: some View {
        var growth: Double {
            if case .dynamic(_, let growth) = sliderStyle.trackMarkStyle {
                return growth
            } else { return 1.0 }
        }
        let markValues = sliderHelper.markValues(from: sliderStyle.trackMarks)
        TrackLayout(
            hpad: max(sliderStyle._thumbWidth, sliderStyle._trackMarkWidth) ,
            vpad: sliderStyle._trackMarkHeight * (growth - 1),
            alignment: alignment
        ) {
            ForEach(markValues, id: \.self) { markValue in
                let gradient = barGradient(for: markValue)
                let height = barHeight(for: markValue)
                Trackmark(gradient: gradient, height: height)
            }
        }
        .task {
            activeGradient = LinearGradient(colors: sliderStyle.trackMarkActiveColor,
                                            startPoint: .top, endPoint: .bottom)
            inActiveGradient = LinearGradient(colors: sliderStyle.trackMarkInActiveColor,
                                              startPoint: .top, endPoint: .bottom)

        }
    }

    func barGradient(for markValue: Double) -> LinearGradient {
        guard sliderStyle.sliderIndicator.contains(.trackMarks) else {
            return activeGradient
        }
        return shouldHighlight(markValue) ? activeGradient : inActiveGradient
    }
    func shouldHighlight(_ markValue: Double) -> Bool {
        var rangeStart: Double
        var rangeEnd: Double
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

        guard sliderHelper.isDragging, shouldHighlight(markValue), case .dynamic(let percent,let growth) = sliderStyle.trackMarkStyle else {
            return sliderStyle._trackMarkHeight
        }
        let normalisedXValue = getNormalisedXvalue(for: markValue, with: percent)
        guard normalisedXValue >= 0 else {
            return sliderStyle._trackMarkHeight
        }
        /// Follow formula y = a.x^3 +c
        ///  when x=1, y= growth*trackheight,  when x = 0, y = trackHeight
        let a = sliderStyle._trackMarkHeight * (growth - 1 )
        let x2 = pow(normalisedXValue,3)
        let height = a * x2 + sliderStyle._trackMarkHeight
        return height
    }

    func getNormalisedXvalue(for markValue: Double, with percent: Double) -> Double {

        let raisedRange = sliderHelper.range.span * percent

        guard sliderValue - raisedRange <= markValue, markValue <= sliderValue + raisedRange else { return -1 }

        return 1 - abs(markValue - sliderValue) / raisedRange
    }
}
extension ClosedRange<Double> {
    var span: Double {
        self.upperBound - self.lowerBound
    }
}
#Preview {

    ZStack(alignment: .leading ) {
        Capsule()
            .fill(.red)
            .frame(height: 3.0)
            .border(.red)
        TrackMarks(sliderValue: 18)
            .environment(SliderHelper(range: 0...30, isInt: false))
            .sliderStyle(.orangey) { style in
                style.sliderIndicator = .trackMarks
                style.trackMarkStyle = .dynamic(percent: 0.2, growth: 3.0)
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
