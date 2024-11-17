//
//  CGPoint.swift
//  ASlider
//
//  Created by Andrew on 11/2/24.
//
import SwiftUI

extension CGPoint {
    /// Calculate distance to another `CGPoint`
    func distance(to other: CGPoint) -> Double {
        Self.calcHypotenuse(of: CGPoint(x: self.x-other.x,y: self.y - other.y ))
    }
    /// Calculate length of hypotenuse of the triange from the origin to this `CGPoint`
    var hypotenuse: Double {
        Self.calcHypotenuse(of: self)
    }
    // Good ol' Pythagoras
    private static func calcHypotenuse(of cgp: CGPoint) -> Double {
        sqrt(cgp.x*cgp.x+cgp.y*cgp.y)
    }
}
