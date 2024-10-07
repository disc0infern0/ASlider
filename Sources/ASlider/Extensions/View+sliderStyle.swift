//
//  newView.swift
//  bindingToClass
//
//  Created by Andrew on 9/18/24.
//
import SwiftUI

extension View {
    public func sliderStyle(_ s: SliderStyle) -> some View {
        self
            .environment(\.sliderStyle, s)
    }

    /// Place a custom sliderStyle into the environment
    /// Example usage:
    /// struct newView: View {
    ///  @State var num: Double = 1.0
    ///  var body: some View {
    ///   ASlider(value: $num, in 0...5)
    ///   .sliderStyle(.orangey) { style in
    ///    style.thumbWidth = 40
    ///  }
    /// }

    public func sliderStyle(_ base: SliderStyle = .newClassic, modifiers: @escaping (_ style: inout SliderStyle) -> Void  ) -> some View {

        var newSliderStyle = base
        modifiers(&newSliderStyle)

        return self
            .environment(\.sliderStyle, newSliderStyle)

    }
}
