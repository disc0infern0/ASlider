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

        if sliderStyle.sliderIndicator.contains(.thumb),
           case .regular = sliderStyle.trackMarkStyle
        {
            
            let offset = sliderHelper.sliderLocation(of: sliderValue) - sliderStyle._thumbWidth*0.5
            thumb()
                .shadow(color: sliderStyle.trackShadowColor, radius: sliderStyle.trackShadowRadius)
                .focusable()  //(true, interactions: .activate)
                .onKeyPress(keys: [.leftArrow, .rightArrow], action: arrowKeyPress)
                .onChange(of: sliderValueProxy) { sliderValue = sliderValueProxy }
                .onChange(of: sliderValue, initial: true) { sliderValueProxy = sliderValue }
                .offset(x: offset)
            //            .highPriorityGesture(thumbDragGesture())
        }
    }
    ///
    func arrowKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        let trackMarkStep = sliderHelper.trackMarkStep(of: sliderStyle.trackMarks)
        let increment = trackMarkStep * (keyPress.key == .leftArrow ? -1.0 : 1.0)
        let newSliderValue = sliderValueProxy + increment
        guard sliderHelper.isValidSliderValue(newSliderValue) else { return KeyPress.Result.ignored }
        sliderValueProxy = newSliderValue  // Not using the proxy triggers an Apple bug; cancelling the repeats
        return KeyPress.Result.handled
    }




    @ViewBuilder
    func thumb() -> some View {
        switch sliderStyle.thumbSymbol {
            case .capsule:
                /// The symbol for a capsule does not scale well, so make our own
                thumbCapsule(color: sliderStyle.thumbColor, opacity: opacity)
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
    }


    func thumbCapsule(color: Color, opacity: Double) -> some View {
        Capsule()
            .fill(color.opacity(opacity))
            .strokeBorder( sliderStyle.thumbTintedBorder ? sliderStyle.trackTintColor : .clear,
                           lineWidth: sliderStyle.trackHeight/2,
                           antialiased: true )
            .frame(width: sliderStyle.thumbWidth, height: sliderStyle.thumbHeight)
            .contentShape(.capsule)  //avoid a rectangular focus indicator
            .shapeEffect( sliderStyle.thumbShapeEffect, options: .effectRepeat(1), value: sliderHelper.dragStarted )
    }
}
