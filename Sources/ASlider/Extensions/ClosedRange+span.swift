//
//  ClosedRange+span.swift
//  ASlider
//
//  Created by Andrew on 12/10/2024.
//

import Foundation
extension ClosedRange<Double> {
    var span: Double { upperBound - lowerBound }
}
