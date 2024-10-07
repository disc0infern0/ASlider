//
//  View+readSize.swift
//  bindingToClass
//
//  Created by Andrew on 9/6/24.
//
import SwiftUI

extension View {
    func readSize(_ action: @escaping (CGSize)->Void) -> some View {
        self
            .onGeometryChange(for: CGSize.self, of: {$0.size}, action: action)
    }
}
