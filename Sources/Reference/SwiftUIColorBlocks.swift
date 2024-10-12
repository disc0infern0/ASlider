//
//  SwiftUIColorBlocks.swift
//  ASlider
//
//  Created by Andrew on 10/10/2024.
//

import SwiftUI

struct SwiftUIColorBlocks: View {
    var body: some View {
        let thumbColor = Color("classicThumb", bundle: .module)
        let trackColor = Color("classicTrack", bundle: .module)
        VStack {
            HStack{ Text("thumb"); thumbColor }
            HStack{ Text("track"); trackColor }
            HStack{ Text("accent"); Color.accentColor }
            HStack{ Text("primary"); Color.primary }
            HStack{ Text("secondary"); Color.secondary.opacity(1.0) }
            HStack{ Text("tertiary lbl"); Color(nsColor: .tertiaryLabelColor) }
            HStack{ Text("tertiary fill"); Color(nsColor: .tertiarySystemFill) }
            HStack{ Text("quaternary lbl"); Color(nsColor: .quaternaryLabelColor) }
            HStack{
                Text("quaternary fill"); 
                Rectangle().fill(Color(nsColor: .quaternarySystemFill))
                    .border(Color.primary)
            }
        }
        .padding()
        .background(.yellow)
    }
}

#Preview {
    SwiftUIColorBlocks()
}
