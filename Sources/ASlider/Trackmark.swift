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
    let height: Double

    var body: some View {
        Capsule()
            .fill(gradient)
            .frame(
                width: sliderStyle.i_trackMarkWidth,
                height: height
            )
            .animation(.easeInOut, value: height)
    }
}


