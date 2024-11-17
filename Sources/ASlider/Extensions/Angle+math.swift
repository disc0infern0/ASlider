//
//  File.swift
//  radial
//
//  Created by Andrew on 23/10/2024.
//
import SwiftUI

extension Angle {
    static let threeSixty: Angle = .radians(2*Double.pi)
    static let oneEighty: Angle = .radians(Double.pi)
    static let ninety: Angle = .radians(0.5*Double.pi)
}

extension Angle {
    var sin: Double {
        CoreGraphics.sin(self.radians)
    }
    var cos: Double {
        CoreGraphics.cos(self.radians)
    }
    var tan: Double {
        CoreGraphics.tan(self.radians)
    }
}
