//
//  Track.swift
//  bindingToClass
//
//  Created by Andrew on 10/08/2024.
//
import SwiftUI

struct Track: View {
    @Environment(\.sliderStyle) var sliderStyle
    @Environment(SliderHelper.self) var sliderHelper

    var body: some View {
        let color = sliderStyle.sliderIndicator.containsTrackMarks ? Color.clear : sliderStyle.trackColor
        let clickHeight = sliderStyle.sliderIndicator.contains(.thumb) ? sliderStyle.thumbHeight : sliderStyle.i_trackMarkHeight
        Capsule()
            .fill(color)
            .frame(height: sliderStyle.trackHeight)
            .readSize { size in
                sliderHelper.setTrackLength( to: size.width, trackBuffer: sliderStyle.trackBuffer)
            }
            .frame(height: clickHeight)     // } larger area for
            .contentShape(.rect)            // } tap gestures to hit
            .id(sliderStyle) // redraw and recalculate size if sliderStyle changes
    }
}

#Preview {
    @Previewable @State var num: Double = 2.0
    Track()
        .frame(width:300, height: 100)
        .sliderStyle(.classic)
        .environment(SliderHelper(range: 0...10, isInt: false))
}

/// Below is an option for future consideration - draw a tint bar with configurable end shapes; - useful primarily to fit nicely alongside different symbols

/*

 /// Draw a shape that matches a rounded rectangle on the left, but is flexible in the shape of its
 /// right hand side - to either sit flush with a circle (endShape = .convext) , a straight edge (.straight) for sitting against a capsule.portrait,
 /// or, in the case of .convex, match the shape of the rounded rectangle.

 @MainActor
 struct TintedTrackShape: Shape {
 enum EndShape { case concave, convex, straight }
 let endShape: EndShape

 init(endShape: EndShape) {
 self.endShape = endShape
 }
 func path(in rect: CGRect) -> Path {
 let cornerRadius: Double = rect.height * 0.3

 return Path { path in
 /// start drawing in top right
 if endShape == .convex {
 path.move( to: CGPoint( x: max(0,rect.width-cornerRadius/2) , y: max(0, cornerRadius - rect.width) ) )
 } else {
 path.move( to: CGPoint( x: rect.width , y: 0 ) )
 }
 /// top right to bottom right
 switch endShape {
 case .straight:
 path.addLine(to: CGPoint(x: rect.width, y: rect.height))
 case .concave:// Roughly match a circle
 path.addQuadCurve(
 to: CGPoint( x: rect.width, y: rect.height ),
 control: CGPoint( x: max(0,rect.width - (cornerRadius/2.0)), y: rect.height * 0.5 ))
 case .convex: // Rounded rectangle
 path.addQuadCurve(
 to: CGPoint( x: rect.width, y: rect.height/2 ),
 control: CGPoint( x: rect.width, y: 0))
 path.addQuadCurve(
 to: CGPoint( x: max(0,rect.width-cornerRadius/2), y: min(rect.height, rect.height - cornerRadius + rect.width) ),
 control: CGPoint( x: rect.width, y: rect.height ))
 }
 /// bottom right to bottom left
 path.addLine(
 to: CGPoint(
 x: min(cornerRadius, rect.width),
 y: rect.height
 )
 )
 /// bottom left to mid left
 path.addQuadCurve(
 to: CGPoint( x: 0, y: rect.height * 0.5 ),
 control: CGPoint( x: 0, y: min(rect.height, rect.height - cornerRadius + rect.width) ))
 /// bottom mid left to top left
 path.addQuadCurve(
 to: CGPoint( x: min(cornerRadius, rect.width), y: max(0, cornerRadius - rect.width) ),
 control: CGPoint( x:  0, y: 0 )
 )
 /// top left to top right
 path.closeSubpath()
 }
 //            .fill(.linearGradient(
 //                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
 //                startPoint: UnitPoint(x: 0.5, y: 0),
 //                endPoint: UnitPoint(x: 0.5, y: 0.6)
 //            ))

 }
 //    static let gradientStart = rgb(r: 239, g: 120, b: 221)
 //    static let gradientEnd = rgb(r: 239, g: 172, b: 120)
 //

 }

 struct TintedTrackShapePreview: View {
 let trackHeight: Double = 42
 @State var width: Double = 10
 let height: Double = 42
 var endShape: TintedTrackShape.EndShape

 init(endShape: TintedTrackShape.EndShape) {
 self.endShape = endShape
 }
 var body : some View {
 ZStack {
 Color.clear
 TintedTrackShape( endShape: .convex )
 .foregroundStyle(.yellow.opacity(0.5))
 .background( RoundedRectangle(cornerRadius: trackHeight*0.3, style: .continuous)
 .foregroundStyle(Color.red.opacity(0.9))
 )
 .animation(.easeInOut(duration: 1.2), value: width)
 .frame(width: width, height: trackHeight)
 }
 .onTapGesture { loc in width =  loc.x }
 .padding()
 .frame(width: 274, height: 100)
 }
 }
 #Preview {
 TintedTrackShapePreview(endShape: .convex)
 }

 */

