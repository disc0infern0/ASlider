//
//  SliderMovement.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//
import SwiftUI

struct Thumb: View {
    @Binding var sliderValue: Double
    @Environment(SliderHelper.self) var sliderHelper
    @State var sliderValueProxy: Double = .zero // synchronised to sliderValue for keypress repeat bug
    ///
    func arrowKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        let trackMarkStep = sliderHelper.trackMarkStep(of: sliderHelper.trackMarkInterval)
        let increment = trackMarkStep * (keyPress.key == .leftArrow ? -1.0 : 1.0)
        let newSliderValue = sliderValueProxy + increment
        // Not using the proxy triggers an Apple bug; cancelling the repeats
        return sliderHelper.setSlider(value: $sliderValueProxy, to: newSliderValue) ? KeyPress.Result.handled : KeyPress.Result.ignored
    }

    var body: some View {
        if sliderHelper.sliderIndicator.contains(.thumb) {
            TheThumb(sliderValue: sliderValue)
                .onKeyPress(keys: [.leftArrow, .rightArrow], action: arrowKeyPress)
                .onChange(of: sliderValueProxy) {
                    sliderHelper.setSlider(value: $sliderValue, to: sliderValueProxy) }
                .onChange(of: sliderValue, initial: true) { sliderValueProxy = sliderValue }
//            switch sliderStyle.orientation {
//                case .linear:
//                    TheThumb(sliderValue: sliderValue)
//                        .onKeyPress(keys: [.leftArrow, .rightArrow], action: arrowKeyPress)
//                        .onChange(of: sliderValueProxy) {
//                            sliderHelper.setSlider(value: $sliderValue, to: sliderValueProxy) }
//                        .onChange(of: sliderValue, initial: true) { sliderValueProxy = sliderValue }
//                case .radial:
//                    RadialThumb(value: sliderValue)
//            }
        }
    }
}

struct TheThumb: View, Animatable {
    var sliderValue: Double

    nonisolated var animatableData: Double {
        get { sliderValue }
        set { sliderValue = newValue }
    }

    @Environment(\.colorScheme) var colorScheme
    @Environment(SliderHelper.self) var sliderHelper

    var thumbColor: Color {
        sliderHelper.isDragging ? sliderHelper.thumbColorDragging : sliderHelper.thumbColorAtRest
    }

    var body: some View {
        let theThumb = thumb()
            .allowsHitTesting(false)
            .focusable(
                sliderHelper.isDragging ? false : true,
                interactions: .activate
            )
        switch sliderHelper.orientation {
            case .linear:
                theThumb
                    .offset(x: sliderHelper.sliderPosition(of: sliderValue) - sliderHelper.thumbWidth*0.5)
            case .radial:
                let angle = sliderHelper.angle(of: sliderValue)
                // calculate midway on track 
                let r = sliderHelper.innerRadius + 0.5*sliderHelper.trackHeight
                theThumb
                    .position(x: sliderHelper.centre.x, y: sliderHelper.centre.y - r)
                    .rotationEffect(angle)
        }
    }

    @ViewBuilder func thumb() -> some View {
        switch sliderHelper.thumbSymbol {
            case .circle:
                thumbShape()
                    .contentShape( .circle )
            case .capsule:
                /// The symbol for a capsule does not scale well, so use the Capsule shape instead
                thumbShape()
                    .contentShape( .capsule )
            default:
                myThumb(symbol: sliderHelper.thumbSymbol.symbolName)
                    .contentShape(.circle)
        }
    }
    func myThumb(symbol: String) -> some View {
        ZStack {
            Image(systemName: symbol )
                .resizable()
                .symbolVariant( .fill )
                .foregroundStyle(thumbColor)
            Image(systemName: symbol )
                .resizable()
                .symbolVariant( .none )
                .foregroundStyle(sliderHelper.thumbTintedBorder ? sliderHelper.trackTintColor : .clear )
        }
        .imageScale(.small)
        .font(.title.weight(.medium))
        .contentShape(.circle)
        .symbolEffect(.bounce, options: .repeat(1), value: sliderHelper.dragStarted)
        .frame(width: sliderHelper.thumbWidth, height: symbol=="circle" ? sliderHelper.thumbWidth : sliderHelper.thumbHeight)
        .thumbShadow(colorScheme: colorScheme, sliderHelper: sliderHelper)
    }

    func thumbShape() -> some View {
        #if os(macOS)
        let shadowStyle:ShadowStyle = .drop(color: sliderHelper.trackShadowColor.opacity(0.15), radius: 0, x:0, y:1)
        #else
        let i = sliderStyle.thumbWidth/6
        let shadowStyle:ShadowStyle = .drop(color: sliderHelper.trackShadowColor.opacity(0.15), radius: i, x:0, y:i)
        #endif
        return Capsule()
            .fill(thumbColor.shadow(shadowStyle) )
            .strokeBorder( sliderHelper.thumbTintedBorder ? sliderHelper.trackTintColor : .clear, lineWidth: sliderHelper.trackHeight/2, antialiased: true )
            .shapeEffect( sliderHelper.thumbShapeEffect, options: .effectRepeat(1), value: sliderHelper.dragStarted )
            .thumbShadow(colorScheme: colorScheme, sliderHelper: sliderHelper)
            .frame(width: sliderHelper.thumbWidth, height: sliderHelper.thumbSymbol == .circle ? sliderHelper.thumbWidth : sliderHelper.thumbHeight)
    }
}


extension View {
    @ViewBuilder
    func thumbShadow(colorScheme: ColorScheme, sliderHelper: SliderHelper) -> some View {
        if colorScheme == .dark {
            self
        } else {
            self.shadow(color: sliderHelper.trackShadowColor, radius: sliderHelper.trackShadowRadius)
        }
    }
}
