//
//  PredefinedStyles.swift
//  ASlider
//
//  Created by Andrew on 07/10/2024.
//
import SwiftUI

extension SliderStyle {
    @MainActor
    public static let classic = Self.init(
        trackHeight: 4,
        trackColor: .gray.opacity(0.3),
        trackMarks: .none,
        trackMarkWidth: 4,
        labelMarks: .none,
        zeroBased: false,
        trackTintColor: .accentColor,
        trackShadow: .radius(0.06),
        thumbSymbol: .circle,
        thumbColor: .gray,
        thumbWidth: 21,
        thumbHeight: 21,
        thumbShapeEffect: .none
    )

    @MainActor
    public static let newClassic = Self.init(
        trackHeight: 4,
        trackColor: .primary,
        trackMarks: .auto,
        trackMarkWidth: 4,
        labelMarks: .none,
        tintCentredOn: .zero,
        trackTintColor: .accentColor,
        trackShadow: .radius(0.4),
        thumbSymbol: .capsule,
        thumbTintedBorder: true,
        thumbColor: .primary,
        thumbWidth: 20,
        thumbHeight: 30,
        thumbShapeEffect: .bounce
    )
    @MainActor
    public static let orangey = Self.init(
        trackHeight: 8  ,
        trackColor: .orange,
        trackMarks: .auto,
        trackMarkWidth: 8,
        trackTintColor: .yellow,
        trackShadow: .radius(5),
        thumbSymbol: .capsule,
        thumbTintedBorder: true,
        thumbColor: .orange,
        thumbWidth: 35,
        thumbHeight: 50,
        thumbShapeEffect: .bounce
    )

}



