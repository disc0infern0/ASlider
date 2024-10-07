//
//  ASlider.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//

import SwiftUI

/// A slider where the track can be tapped, the thumb can be dragged, and a label can be displayed.
/// Additionally left and right arrows can be used to decrement/increment the values, as can various accessibility actions.
/// Styling for the slider can be done via the sliderStyle view modifier which accepts a SliderStyle struct and, optionally,
/// a closure for you to modify those settings
/// There is an array of predefined styles to choose from, including
///  .classic which emulates the Apple slider,
///  .newClassic which updates the Apple slider with a bounce animation to the thumb and transparent selection

public struct NewSlider<LabelContent: View, LabelMarkContent: View>: View {
    @Binding var sliderValue: Double
    let range: ClosedRange<Double>
    var label: () -> LabelContent
    var labelMark: (_:Double) -> LabelMarkContent
    let isIntValue: Bool  // record whether we are called with an integer binding or not
    @Environment(\.sliderStyle) var sliderStyle
    @State var sliderHelper: SliderHelper

    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        label: @escaping () -> LabelContent = { EmptyView() },
        labelMark: @escaping (_:Double)->LabelMarkContent = { d in
            Text("\(d.formatted(.number.precision(.fractionLength(1))))")
                .font(.caption2)
        }
    ) {
        self.init(value: value,
                  in: range,
                  isIntValue: false,
                  label: label,
                  labelMark: labelMark)
    }
    init( value: Binding<Int>, in range: ClosedRange<Int>,
          label: @escaping () -> LabelContent = { EmptyView() },
          labelMark: @escaping (_:Double)->LabelMarkContent = { d in
        Text("\(d.formatted(.number.precision(.fractionLength(1))))")
            .font(.caption2)
    }
    ) {
        self.init(
            value: Binding { Double(value.wrappedValue) } set: { value.wrappedValue = Int($0.rounded()) },
            in: Double(range.lowerBound)...Double(range.upperBound),
            isIntValue: true,
            label: label,
            labelMark: labelMark
        )
    }
    private init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        isIntValue: Bool,
        label: @escaping () -> LabelContent,
        labelMark: @escaping (_:Double) -> LabelMarkContent
    ) {
        _sliderValue = value
        self.range = range
        self.isIntValue = isIntValue
        self.label = label
        self.labelMark = labelMark
        _sliderHelper = State(wrappedValue: SliderHelper( range: range, isInt: isIntValue))


    }
    @State private var alignment: Alignment = .leading
    public var body: some View {
        HStack(alignment: .center) {
            label()

            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: alignment) {
                    Track()
                    TrackMarks(sliderValue: sliderValue)
                    Tint(sliderValue: sliderValue)
                        .allowsHitTesting(false)
                    Thumb( sliderValue: $sliderValue)
//                        .allowsHitTesting(false)
                }
                .onTapGesture {
                    sliderValue = sliderHelper.getSliderValue(of: $0.x)
                }
                .highPriorityGesture(dragGesture() )
//                .border(.red)
                //                .overlay(Color.red.opacity(0.5))
                TrackLabels(labelMark: labelMark)
            }
        }
        .sliderAccessibility(sliderValue: $sliderValue)
        .environment(sliderHelper)
        .task {
            if case .dynamic = sliderStyle.trackMarkStyle {
                alignment = .bottomLeading
            }
            if sliderStyle.sliderIndicator.isEmpty  {
                print("!!Warning!! A valid slider indicator has not been set")
//                let logger = Logger(
//                    subsystem: Bundle.main.bundleIdentifier ?? "New Slider",
//                    category: "Initialization"
//                )
//                logger.log(level: .info, "A valid slider indicator has not been set")
            }
        }
    }

    /// Drag gesture for the thumb
    func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                if !sliderHelper.isDragging { sliderHelper.dragStarted.toggle() }
                sliderHelper.isDragging = true
                let new = sliderHelper.getSliderValue(of: gesture.location.x )
                if sliderHelper.isValidSliderValue(new) { sliderValue = new }
            }
            .onEnded { _ in sliderHelper.isDragging = false }
    }
}
