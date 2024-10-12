//
//  Set+contains.swift
//  ASlider
//
//  Created by Andrew on 12/10/2024.
//
import Foundation

extension Set where Element == SliderStyle.SliderIndicator {
    var containsTrackMarks: Bool {
        for f in self {
            if case .trackMarks = f { return true}
        }
        return false
    }
    var containsTintBar: Bool {
        for f in self {
            if case .tintBar = f { return true }
        }
        return false
    }
}
