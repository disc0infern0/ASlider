//
//  Polo.swift
//  radial
//
//  Created by Andrew on 23/10/2024.
//



import SwiftUI
struct Polo: Shape {
    let width: Double
    var radialAngle : Angle // as measured from the y axis
    let outerRadius: Double

    var tangentExtension: Double {
        radialAngle.degrees > 355 ? 360 - radialAngle.degrees : width*0.5
    }
    func path(in rect: CGRect) -> Path {
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let newRadialAngle = radialAngle - Angle.ninety  // converted to SwiftUI angle from horizontal
//        let outerRadius = min(rect.midX,rect.midY) //radius+width
        let innerRadius = outerRadius - width

        var path: Path = Path()

        // move to top of inner circle
        path.move(to: CGPoint( x: centre.x, y: centre.y - innerRadius ))
        // line to top of outer circle
        path.addLine(to: CGPoint(x: centre.x, y: centre.y - outerRadius ))
        // clockwise arc to 360 degrees + `offset` degrees on the outer circle.
        // (offset is negative)
        path.addArc( center: centre, radius: outerRadius,
                     startAngle: -Angle.ninety,
                     endAngle: newRadialAngle, clockwise: false)

        // define control point for curved end of track
        // The control point is some distance along a tangent to the circe with radius of radius+width*0.5
        // tangent line y = gradientOfTangent*x+yIntercept
        // radius line of control; y = tan(theta) * x
        let controlRadius = innerRadius + width*0.5

        let yintercept = controlRadius/newRadialAngle.sin
        /*
         /// Alternative method to calculate a control point
         /// Calculate where the tangent meets a radius offset
        let controlOffset: Angle = Angle(degrees: 5)
        let controlAngle = newRadialAngle + controlOffset
        let gradientOfTangent: Double = -1/newRadialAngle.tan
        // equation of tangent:  y = gradientofTangent * x + yintercept

        let gradientOfControl: Double = controlAngle.tan
        // equation of Control radius: y = x * gradientofControl
        // solving for y:
        // gradientOfTangent * x + yintercept = gradientOfControl * x
        // x * gradientOfControl - x* gradientOfTangent = yIntercept
        // x = yIntercept / (gradientOfControl-gradientOfTangent)
        let controlx =  yintercept/( gradientOfControl-gradientOfTangent)
        let controlPoint = CGPoint(
            x:centre.x+controlx,
            y:centre.y + controlx * gradientOfControl)
        */

        //extend tangent by fixed amount
        let yt = controlRadius*newRadialAngle.sin - yintercept
        let length = yt/radialAngle.sin + tangentExtension
        let newAngle =  -radialAngle
        let newControlPoint = CGPoint(
            x: centre.x + length*newAngle.cos,
            y: centre.y + yintercept-length*newAngle.sin
        )

        // end of inner radius line
        let destinationPoint = CGPoint(
            x: centre.x + innerRadius * newRadialAngle.cos,
            y: centre.y + innerRadius * newRadialAngle.sin
        )
        path.addQuadCurve(to: destinationPoint, control: newControlPoint)
        path.addArc( center: centre, radius: innerRadius, startAngle: newRadialAngle, endAngle: -Angle.ninety, clockwise: true )
        path.closeSubpath()
        return path
    }
}

#Preview {
    let frameWidth = 300.0
    Polo(width: 50, radialAngle: Angle(degrees: 296), outerRadius: frameWidth*0.5-30)
//        .frame(width: 300, height: 300)
        .frame(width: frameWidth, height: frameWidth)
}
