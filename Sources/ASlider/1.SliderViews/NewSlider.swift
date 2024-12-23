//
//  NewSlider.swift
//  ASlider
//
//  Created by Andrew on 10/08/2024.
//

import SwiftUI

/// Creates a slider to select a value from a given range, which displays the provided labels.
/// 
/// init(value:in:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)   
/// 
/// init<V>(
/// value: Binding<V>,   
/// in bounds: ClosedRange<V> = 0...1,   
/// @ViewBuilder label: () -> Label,   
/// @ViewBuilder minimumValueLabel: () -> ValueLabel,   
/// @ViewBuilder maximumValueLabel: () -> ValueLabel,   
/// onEditingChanged: @escaping (Bool) -> Void = { _ in }
/// ) 
/// where `V`is a BinaryFloatingPoint, or an Int   
/// 
/// Available when Label conforms to View and ValueLabel conforms to View.
/// # Parameters   
/// ### value
/// The selected value within bounds.
/// ### bounds
/// The range of the valid values. Defaults to 0...1.
/// ### label
/// A View that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
/// ### minimumValueLabel
/// A view that describes bounds.lowerBound.
/// ### maximumValueLabel
/// A view that describes bounds.lowerBound.
/// ### onEditingChanged
/// A callback for when editing begins and ends.
/// 
/// # Description   
/// A slider where the track can be tapped, the thumb can be dragged, and a label can be displayed.
/// Additionally left and right arrows can be used to decrement/increment the values, as can various accessibility actions.
/// Styling for the slider can be done via the sliderStyle view modifier which accepts a SliderStyle struct and, optionally,
/// a closure for you to modify those settings
/// There is an array of predefined styles to choose from, including
///  .classic which emulates the Apple slider,
///  .newClassic which updates the Apple slider with a bounce animation to the thumb and transparent selection



public struct NewSlider<Label: View, LabelMarkContent: View, ValueLabel: View> : View {
    @Binding var sliderValue: Double
    let range: ClosedRange<Double>
    let step: Double?
    var label: () -> Label = { EmptyView() as! Label }
    var labelMark: (_: Double) -> LabelMarkContent
    var minimumValueLabel: () -> ValueLabel = { EmptyView() as! ValueLabel }
    var maximumValueLabel: () -> ValueLabel = { EmptyView() as! ValueLabel }
    var onEditingChanged: (Bool) -> Void = { _ in }

    let isIntValue: Bool  // record whether we are called with an integer binding or not

    // Classic Apple Slider init (with addition of labelMark to display slider values under the slider)
    public init<V: BinaryFloatingPoint>  (
        value: Binding<V>,
        in range: ClosedRange<V>,
        step: V.Stride? = nil,
        label: @escaping () -> Label = { EmptyView() },
        labelMark: @escaping (_: Double) -> LabelMarkContent = { d in
            Text("\(d.formatted(.number.precision(.fractionLength(1))))")
                .font(.caption2)
        },
        minimumValueLabel: @escaping () -> ValueLabel = { EmptyView() },
        maximumValueLabel: @escaping () -> ValueLabel = { EmptyView() },
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    )  where V.Stride: BinaryFloatingPoint {
        self.init(
            value: Binding {
                Double(value.wrappedValue)
            } set: {
                value.wrappedValue = V($0)
            },
            in: Double(range.lowerBound)...Double(range.upperBound),
            step: step == nil ? nil : Double(step!),
            isIntValue: false,
            label: label,
            labelMark: labelMark,
            minimumValueLabel: minimumValueLabel,
            maximumValueLabel: maximumValueLabel,
            onEditingChanged: onEditingChanged
        )
    }
    public init<U: SignedInteger>(
        value: Binding<U>,
        in range: ClosedRange<U>,
        step: U.Stride? = nil,
        label: @escaping () -> Label = { EmptyView() },
        labelMark: @escaping (_: Double) -> LabelMarkContent = { d in
            Text("\(d.formatted(.number.precision(.fractionLength(0))))")
                .font(.caption2)
        },
        minimumValueLabel: @escaping () -> ValueLabel = { EmptyView() },
        maximumValueLabel: @escaping () -> ValueLabel = { EmptyView() },
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where U.Stride: SignedInteger {
        self.init(
            value: Binding { Double(value.wrappedValue) } 
                set: { value.wrappedValue = U($0.rounded()) },
            in: Double(range.lowerBound)...Double(range.upperBound),
            step:  step == nil ? nil : Double(step!),
            isIntValue: true,
            label: label,
            labelMark: labelMark,
            minimumValueLabel: minimumValueLabel,
            maximumValueLabel: maximumValueLabel,
            onEditingChanged: onEditingChanged
        )
    }
    package init(
            value: Binding<Double>,
            in range: ClosedRange<Double>,
            step: Double.Stride? = nil,
            isIntValue: Bool,
            label: @escaping () -> Label,
            labelMark: @escaping (_: Double) -> LabelMarkContent,
            minimumValueLabel: @escaping () -> ValueLabel,
            maximumValueLabel: @escaping () -> ValueLabel,
            onEditingChanged: @escaping (Bool) -> Void
        )
    {
        _sliderValue = value
        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.step = if let step { Double(step) } else { nil }
        self.isIntValue = isIntValue
        self.label = label
        self.labelMark = labelMark
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onEditingChanged = onEditingChanged
        self._sliderHelper = State(
            initialValue: SliderHelper(range: range, isInt: false, step: step))
    }

    @Environment(\.sliderStyle) var sliderStyle
    @State var sliderHelper: SliderHelper

    var verticalAlignment: VerticalAlignment {
        sliderStyle.trackMarkStyle.isDynamic ? .bottom : .center
    }
    public var body: some View {
        HStack(alignment: verticalAlignment) {
            LeftLabels(alignment: verticalAlignment)
            TheSlider(
                sliderValue: $sliderValue,
                label: label, labelMark: labelMark,
                onEditingChanged: onEditingChanged
            )
            .readFrame {
                sliderHelper.setTrackSize(to: $0)
            }
            RightLabels()
        }
        .onAppear {
            sliderHelper.updateStyle(sliderStyle)
        }
        .environment(sliderHelper)
        .accessibilityRepresentation {
            Slider(value: $sliderValue, in: range, label: label)
        }
    }

    @ViewBuilder
    func LeftLabels(alignment: VerticalAlignment) -> some View {
        if sliderHelper.orientation == .linear {
            HStack(alignment: alignment) {
                label()
                minimumValueLabel()
            }
        }
    }
    @ViewBuilder
    func RightLabels() -> some View {
        if sliderHelper.orientation == .linear {
            maximumValueLabel()
        }
    }
}

struct TheSlider<Label: View, LabelMarkContent: View>: View {
    @Binding var sliderValue: Double
    let label: () -> Label
    let labelMark: (_: Double) -> LabelMarkContent
    @Environment(SliderHelper.self) var sliderHelper
    let onEditingChanged: (Bool) -> Void
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: sliderAlignment()) {
                Track()
                Tint(sliderValue: sliderValue)
                TrackMarks(sliderValue: sliderValue)
                Thumb(sliderValue: $sliderValue)
            }
            .overlay {
                if sliderHelper.orientation == .radial {
                    label()
                }
            }
            .highPriorityGesture(dragGesture)
            if sliderHelper.orientation == .linear {
                TrackLabels(labelMark: labelMark)
            }
        }
        .onAppear { sliderHelper.lastSliderValue = sliderValue }
        .animation(sliderHelper.sliderAnimation, value: sliderValue)
        .animation(
            sliderHelper.sliderAnimation, value: sliderHelper.lastSliderValue
        )
        .sliderAccessibility(sliderValue: $sliderValue)
        .onChange(of: sliderHelper.isDragging) {
            onEditingChanged(sliderHelper.isDragging)
        }
    }

    func sliderAlignment() -> Alignment {
        if sliderHelper.trackMarkStyle.isDynamic {
            .bottomLeading
        } else {
            sliderHelper.orientation == .linear ? .leading : .center
        }
    }
    /// Drag gesture
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                if !sliderHelper.isDragging {
                    /// Drag started
                    sliderHelper.dragStarted.toggle()
                }
                sliderHelper.isDragging = true

                let new =
                    sliderHelper.orientation == .radial
                    ? sliderHelper.getAngleValue(from: gesture.location)
                    : sliderHelper.getSliderValue(of: gesture.location.x)
                sliderHelper.setSlider(value: $sliderValue, to: new)
            }
            .onEnded { _ in
                sliderHelper.isDragging = false
                sliderHelper.lastSliderValue = sliderValue
            }
    }
}
// ****************************************************
// PREVIEWS
// ****************************************************

#Preview("Volume") {
    @Previewable @State var value = 0.2
    let myfont: Font = .system(size: 70, weight: .black, design: .rounded)
    var valueString: String {
        "\((value*10).formatted(.number.precision(.fractionLength(0...1))))"
    }
    VStack {
        NewSlider(value: $value, in: 0...1.1) {
            Text(verbatim: valueString)
                .font(myfont)
                .contentTransition(.numericText(value: value))
                .foregroundStyle(.green)
                .glow(color: .green, radius: 1)
                .opacity(0.05 + value * 0.95)
                .scaleEffect(1 / 3 + (2 / 3) * value)
        }

        Text("Volume")
            .font(myfont)
    }
    .frame(width: 400, height: 550)
    .sliderStyle(.volumeControl) { style in
        style.trackMarkInterval = .auto
        style.name = "Volume Control Preview"
        style.trackMarkWidth = 30
        style.trackMarkHeight = 90
    }
}

#Preview("Radial") {
    @Previewable @State var value = 0.2
    let myfont: Font = .system(size: 70, weight: .black, design: .rounded)
    var valueString: String {
        "\((value*10).formatted(.number.precision(.fractionLength(0...1))))"
    }
    ZStack {
        NewSlider(value: $value, in: 0.0 ... 1.0) {
            Text(verbatim: valueString)
                .font(myfont)
        }
    }
    .sliderStyle(.radial) { sliderStyle in
        sliderStyle.trackHeight = 60
        sliderStyle.thumbWidth = sliderStyle.trackHeight
        sliderStyle.thumbColorDragging = .white
        sliderStyle.thumbColorAtRest = .classicThumb
    }
    .frame(width: 300, height: 300)
    .padding(2)
}
#Preview("classic Stepped") {
    @Previewable @State var num: Double = 2.0
    let range: ClosedRange<Double> = -10...10
    VStack {
        Text("classic")
        NewSlider(value: $num, in: range, step: 2.0 ) {
            Text("\(String(format:"%.2f", num) )")
                .frame(width: 60)
        }
        .padding(5)
        SwiftUI.Slider(value: $num, in: range, step: 2) {
            Text("\(String(format:"%.2f", num) )")
                .frame(width: 60)
        }
        .padding(5)
    }
    .sliderStyle(.classic) { s in
        s.trackMarkInterval = .every(2)
        s.labelInterval = .every(4)
    }
    .frame(width: 400, height: 200)
}

#Preview("classic int") {
    @Previewable @State var num: Int = 2
    let range: ClosedRange<Int> = -10...10
    VStack {
        Text("classic")
        NewSlider(value: $num, in: range) {
//            Text("\(String(format:"%.2f", num) )")
            Text("\(num)")
                .frame(width: 60)
        }
        .padding(5)
//        SwiftUI.Slider(value: $num, in: range) {
//            Text("\(String(format:"%.2f", num) )")
//                .frame(width: 60)
//        }
//        .padding(5)
    }
    .sliderStyle(.classic) { style in
        style.thumbWidth = 20
    }
    .frame(width: 400, height: 200)
}

#Preview("last value") {
    @Previewable @State var num: Double = 2.0
    let range: ClosedRange<Double> = -10.0 ... 10.0
    VStack {
        Text("Last Value")
        NewSlider(value: $num, in: range)
            .sliderStyle(.classic) { s in
                s.name = "last value"
                s.tintCentredOn = .lastValue
                s.trackTintColor = .accentColor
                s.thumbWidth = 20
            }
        SwiftUI.Slider(value: $num, in: range)
    }
    .padding(20)
    .frame(width: 400, height: 100)
}

#Preview("Dynamic") {
    @Previewable @State var num: Double = 2.0
    @Previewable @State var color: Color = .blue
    let range: ClosedRange<Double> = 0...20
    VStack {
        Text("Dynamic with min and max labels")
        NewSlider(
            value: $num, in: range,
            label: {
                Text(
                    "\(num.formatted(.number.precision(.fractionLength(0...1))))"
                )
                .foregroundStyle(color)
                .frame(minWidth: 30)
            },
            minimumValueLabel: { Text("0") },
            maximumValueLabel: { Text("20") },
            onEditingChanged: { editing in color = editing ? .yellow : .blue }
        )
        .sliderStyle(.dynamic) { style in
            style.trackColor = .clear
            style.trackHeight = 40
        }
    }

    .frame(width: 400, height: 100)

}
