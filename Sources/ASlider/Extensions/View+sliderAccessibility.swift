//
//  View+Accessibility.swift
//  bindingToClass
//
//  Created by Andrew on 9/13/24.
//
import SwiftUI

struct SliderAccessibility: ViewModifier  {
    @Binding var sliderValue: Double

    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper
    func body(content: Content) -> some View {
        content
            .accessibilityElement()
            .accessibilityLabel(Text("slider"))
            .accessibilityValue("\(sliderValue)")
            .accessibilityAction(named: Text("more")) {
                sliderHelper
                    .moveSlider(
                        sliderValue: $sliderValue,
                        direction: .right,
                        trackMarks: sliderStyle.trackMarkInterval
                    )
            }
            .accessibilityAction(named: Text("less")) {
                sliderHelper.moveSlider(sliderValue: $sliderValue, direction: .left,
                                        trackMarks: sliderStyle.trackMarkInterval)
            }
            .accessibilityAdjustableAction { direction in
                switch direction {
                    case .increment:
                        sliderHelper.moveSlider(sliderValue: $sliderValue, direction: .right,
                                                trackMarks: sliderStyle.trackMarkInterval)
                    case .decrement:
                        sliderHelper.moveSlider(sliderValue: $sliderValue, direction: .left,
                                                trackMarks: sliderStyle.trackMarkInterval)
                    @unknown default:
                        break
                }
            }
    }
}

extension View {
    @MainActor
    func sliderAccessibility(sliderValue: Binding<Double>) -> some View {
        modifier(SliderAccessibility(sliderValue: sliderValue))
    }
}



