//
//  SliderMovement.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//
import SwiftUI

struct Thumb: View {
    @Binding var sliderValue: Double
    @State var sliderValueProxy: Double = .zero // synchronised to sliderValue for keypress repeat bug

    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper

    var opacity:Double  { sliderHelper.isDragging ? 0.3: 1.0 }

    var body: some View {

        if sliderStyle.sliderIndicator.contains(.thumb) {
            let offset = sliderHelper.sliderLocation(of: sliderValue) - sliderStyle.thumbWidth*0.5
            thumb()
                .focusable(
                    sliderHelper.isDragging ? false : true,
                    interactions: .activate
                )
                .onKeyPress(keys: [.leftArrow, .rightArrow], action: arrowKeyPress)
                .onChange(of: sliderValueProxy) {
                    sliderHelper.setSlider(value: $sliderValue, to: sliderValueProxy) }
                .onChange(of: sliderValue, initial: true) { sliderValueProxy = sliderValue }
                .offset(x: offset)
        }
    }
    ///
    func arrowKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        let trackMarkStep = sliderHelper.trackMarkStep(of: sliderStyle.trackMarks)
        let increment = trackMarkStep * (keyPress.key == .leftArrow ? -1.0 : 1.0)
        let newSliderValue = sliderValueProxy + increment
        // Not using the proxy triggers an Apple bug; cancelling the repeats
        return sliderHelper.setSlider(value: $sliderValueProxy, to: newSliderValue) ? KeyPress.Result.handled : KeyPress.Result.ignored
    }

    @ViewBuilder
    func thumb() -> some View {
        switch sliderStyle.thumbSymbol {
            case .circle:
                thumbShape(color: sliderStyle.thumbColor.opacity(opacity))
                    .contentShape( .circle )
            case .capsule:
                /// The symbol for a capsule does not scale well, so make our own
                thumbShape(color: sliderStyle.thumbColor.opacity(opacity))
                    .contentShape( .capsule )
            default:
                myThumb(symbol: sliderStyle.thumbSymbol.symbolName)
                    .contentShape(.circle)
        }
    }

    func myThumb(symbol: String) -> some View {
        ZStack {
            Image(systemName: symbol )
                .resizable()
                .symbolVariant( .fill )
                .foregroundStyle(sliderStyle.thumbColor.opacity(opacity))
            Image(systemName: symbol )
                .resizable()
                .symbolVariant( .none )
                .foregroundStyle(sliderStyle.thumbTintedBorder ? sliderStyle.trackTintColor : .clear )
        }
        .imageScale(.small)
        .font(.title.weight(.medium))
        .contentShape(.circle)
        .symbolEffect(.bounce, options: .repeat(1), value: sliderHelper.dragStarted)
        .frame(width: sliderStyle.thumbWidth, height: symbol=="circle" ? sliderStyle.thumbWidth : sliderStyle.thumbHeight)
        .shadow(color: sliderStyle.trackShadowColor, radius: sliderStyle.trackShadowRadius)
    }


    func thumbShape(color: Color) -> some View {
        #if os(macOS)
        let shadowStyle:ShadowStyle = .drop(color: sliderStyle.trackShadowColor.opacity(0.15), radius: 0, x:0, y:1)
        #else
        let i = sliderStyle.thumbWidth/6
        let shadowStyle:ShadowStyle = .drop(color: sliderStyle.trackShadowColor.opacity(0.15), radius: i, x:0, y:i)
        #endif
        return Capsule()
            .fill(color.shadow(shadowStyle) )
            .strokeBorder( sliderStyle.thumbTintedBorder ? sliderStyle.trackTintColor : .clear, lineWidth: sliderStyle.trackHeight/2, antialiased: true )
            .shapeEffect( sliderStyle.thumbShapeEffect, options: .effectRepeat(1), value: sliderHelper.dragStarted )
            .shadow(color: sliderStyle.trackShadowColor, radius: sliderStyle.trackShadowRadius)
            .frame(width: sliderStyle.thumbWidth, height: sliderStyle.thumbSymbol == .circle ? sliderStyle.thumbWidth : sliderStyle.thumbHeight)
            .contentShape(.capsule)
    }
}

