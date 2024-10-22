//
//  NewSlider.swift
//  ASlider
//
//  Created by Andrew on 10/08/2024.
//

import SwiftUI
import OSLog

/// A slider where the track can be tapped, the thumb can be dragged, and a label can be displayed.
/// Additionally left and right arrows can be used to decrement/increment the values, as can various accessibility actions.
/// Styling for the slider can be done via the sliderStyle view modifier which accepts a SliderStyle struct and, optionally,
/// a closure for you to modify those settings
/// There is an array of predefined styles to choose from, including
///  .classic which emulates the Apple slider,
///  .newClassic which updates the Apple slider with a bounce animation to the thumb and transparent selection
public struct NewSlider<LabelContent: View, LabelMarkContent: View>: View {
    @Binding var sliderValue: Double
    @State var lastSliderValue: Double
    let range: ClosedRange<Double>
    var label: () -> LabelContent
    var labelMark: (_:Double) -> LabelMarkContent
    let isIntValue: Bool  // record whether we are called with an integer binding or not
    @Environment(\.sliderStyle) var sliderStyle
    @State var sliderHelper: SliderHelper

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        step: Double? = nil,
        label: @escaping () -> LabelContent = { EmptyView() },
        labelMark: @escaping (_:Double)->LabelMarkContent = { d in
            Text("\(d.formatted(.number.precision(.fractionLength(1))))")
                .font(.caption2)
        }
    ) {
        self.init(
            value: value,
            in: range,
            step: step,
            isIntValue: false,
            label: label,
            labelMark: labelMark)
    }
    public init(
        value: Binding<Int>,
        in range: ClosedRange<Int>,
        step: Int? = nil,
        label: @escaping () -> LabelContent = { EmptyView() },
        labelMark: @escaping (_:Double)->LabelMarkContent = { d in
            Text("\(d.formatted(.number.precision(.fractionLength(1))))")
                .font(.caption2)
        }
    ) {
        let doubleStep: Double? = if let step { Double(step) } else { nil }
        self.init(
            value: Binding { Double(value.wrappedValue) } set: { value.wrappedValue = Int($0.rounded()) },
            in: Double(range.lowerBound)...Double(range.upperBound),
            step: doubleStep,
            isIntValue: true,
            label: label,
            labelMark: labelMark
        )
    }
    private init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        step: Double? = nil,
        isIntValue: Bool,
        label: @escaping () -> LabelContent,
        labelMark: @escaping (_:Double) -> LabelMarkContent
    ) {
        _sliderValue = value
        self.range = range
        self.isIntValue = isIntValue
        self.label = label
        self.labelMark = labelMark
        _sliderHelper = State(wrappedValue: SliderHelper( range: range, isInt: isIntValue, step: step))
        lastSliderValue = value.wrappedValue
    }
    @State private var alignment: Alignment = .leading
    public var body: some View {
        HStack(alignment: .center) {
            label()
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: alignment) {
                    Track()
                    TrackMarks(sliderValue: sliderValue)
                    Tint(sliderValue: sliderValue, lastSliderValue: lastSliderValue)
                        .allowsHitTesting(false)
                    Thumb( sliderValue: $sliderValue)
                        .allowsHitTesting(false) // allow for click on thumb to animate
                }
                .onTapGesture { location in
                    let new = sliderHelper.getSliderValue(of: location.x)
                    sliderHelper.setSlider(value: $sliderValue, to: new)
                }
                .highPriorityGesture(dragGesture() )
                TrackLabels(labelMark: labelMark)
            }
        }
        .animation(sliderStyle.sliderAnimation, value: sliderValue)
        .animation(sliderStyle.sliderAnimation, value: lastSliderValue)
        .sliderAccessibility(sliderValue: $sliderValue)
        .environment(sliderHelper)
        .sliderStyle(sliderHelper.styleUpdate(style: sliderStyle))
        .onAppear {
            if sliderStyle.sliderIndicator.containsTrackMarks  {
                alignment = .bottomLeading
            }
        }
        .task(id: sliderValue) {
            if !sliderHelper.isDragging {
                lastSliderValue = sliderValue
            }
        }
    }

    /// Drag gesture for the thumb
    func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                if !sliderHelper.isDragging {
                    /// Drag started
                    sliderHelper.dragStarted.toggle()
                }
                sliderHelper.isDragging = true
                let new = sliderHelper.getSliderValue(of: gesture.location.x)
                sliderHelper.setSlider(value: $sliderValue, to: new)
            }
            .onEnded { _ in
                sliderHelper.isDragging = false
                lastSliderValue = sliderValue
            }
    }
}

#Preview("classic") {
    @Previewable @State var num: Double = 2.0
    let range: ClosedRange<Double> = -10 ... 10
    VStack {
        Text("classic")
        NewSlider(value: $num, in: range, step: 2) {
            Text("\(String(format:"%.2f", num) )")
                .frame(width: 60)
        }
            .padding(5)
        Slider(value: $num, in: range, step: 2){
            Text("\(String(format:"%.2f", num) )")
                .frame(width: 60)
        }
            .padding(5)
    }.sliderStyle(.classic) { s in
        s.trackMarks = .every(2)
        s.labelMarks = .every(4)
    }
    .frame(width: 400, height: 100)
}

#Preview("last value") {
    @Previewable @State var num: Double = 2.0
    let range: ClosedRange<Double> = -10 ... 10
    VStack {
        Text("Last Value")
        NewSlider(value: $num, in: range)
            .sliderStyle(.classic) { s in
                s.tintCentredOn = .lastValue
                s.trackTintColor = .accentColor
                s.trackMarks = .every(2)
            }
        Slider(value: $num, in: range)
    }
    .padding(20)
    .frame(width: 400, height: 100)
}
#Preview("Dynamic") {
    @Previewable @State var num: Double = 2.0
    let range: ClosedRange<Double> = 0 ... 20
    VStack {
        Text("Dynamic")
        NewSlider(value: $num, in: range)
            .sliderStyle(.dynamic)
    }

    .frame(width: 400, height: 100)

}
