//
//  newView.swift
//  bindingToClass
//
//  Created by Andrew on 9/18/24.
//
import SwiftUI

extension View {
    public func sliderStyle(_ s: SliderStyle) -> some View {
        environment(\.sliderStyle, s)
    }

    /// Place a custom sliderStyle into the environment
    /// Example usage:
    ///   NewSlider(value: $num, in 0...5)
    ///   .sliderStyle(.orangey) { style in
    ///    style.thumbWidth = 40
    ///  }
    public func sliderStyle(_ base: SliderStyle = .newClassic, modifiers: @escaping (_ style: inout SliderStyle) -> Void  ) -> some View {
        environment(\.sliderStyle, { var new = base; modifiers(&new); return new }())
    }
}
