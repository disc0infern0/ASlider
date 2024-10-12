//
//  Trackmark.swift
//  bindingToClass
//
//  Created by Andrew on 9/25/24.
//
import SwiftUI

struct Trackmark: View {
    @Environment(\.sliderStyle) var sliderStyle
    let gradient: LinearGradient
    var height: Double
//    nonisolated var animatableData: Double {
//        get { height }
//        set { height = newValue}
//    }

    var body: some View {
        Capsule()
            .fill(gradient)
            .frame(
                width: sliderStyle.i_trackMarkWidth,
                height: height
            )
            .animation(.easeOut(duration: 0.5), value: height)
    }
}


