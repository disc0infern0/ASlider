//
//  ClosedRange+span.swift
//  ASlider
//
//  Created by Andrew on 12/10/2024.
//

import Foundation
extension ClosedRange<Double> {
    /// Difference between upper and lower bounds of the range
    var span: Double { upperBound - lowerBound }
}
