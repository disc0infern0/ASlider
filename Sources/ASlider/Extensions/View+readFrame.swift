//
//  View+readSize.swift
//  radial
//
//  Created by Andrew on 23/10/2024.
//

import SwiftUI

extension View {
    typealias CGRectFunction = (_:CGRect) -> Void
    func readFrame(_ fn: @escaping CGRectFunction) -> some View  {
        onGeometryChange( for: CGRect.self, of: {$0.frame(in: .local)}) {
            fn($0)
        }
    }
}
