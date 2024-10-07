//
//  TrackMarks 2.swift
//  bindingToClass
//
//  Created by Andrew on 9/3/24.
//
import SwiftUI



struct TrackLayout: Layout {
    var hpad: Double = 0
    var vpad: Double = 0
    var alignment: UnitPoint = .leading

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        guard !subviews.isEmpty, subviews.indices.first != subviews.indices.last else { return .zero }

        // Calculate and return the size of the layout container.
        var width = (proposal.width ?? 0) - hpad
        let height = subviews.reduce( Double.greatestFiniteMagnitude ) { next, subview in
            let size = subview.sizeThatFits(.unspecified)
            return min(next,size.height)
        }

        width += min(hpad*0.5,subviews.first!.sizeThatFits(.unspecified).width * 0.5)
        width += min(hpad*0.5,subviews.last!.sizeThatFits(.unspecified).width * 0.5)
        return CGSize(width: width, height: height+vpad)
    }
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard !subviews.isEmpty, subviews.indices.first != subviews.indices.last else { return }
        // Tell each subview where to appear.
        // we will ignore the bounds width, because we know best.. we will use proposed width calculated above

        //get subview ideal sizes
        let subviewSizes = subviews.map { subview in
            subview.sizeThatFits(.unspecified)
        }
        let increment = ((proposal.width ?? 0) - hpad) / Double(subviews.count - 1)
        let minX = bounds.minX
        let y = if [.top, .topLeading, .topTrailing].contains(alignment) {
            bounds.minY
        } else if [.bottom,.bottomLeading,.bottomTrailing].contains(alignment) {
            bounds.maxY
        } else { bounds.midY}

        for index in subviews.indices {
            let subview = subviews[index]
            let subviewSize = subviewSizes[index]
            let sizeProposal = ProposedViewSize( width: subviewSize.width, height: subviewSize.height)
            var x = minX + hpad*0.5 + increment*Double(index) - subviewSize.width*0.5
            if x < minX {
                x = minX }
            else if x + subviewSize.width > bounds.minX + (proposal.width ?? 0)  {
                x = bounds.minX + (proposal.width ?? 0) - subviewSize.width }
            subview.place(
                at: CGPoint(x: x, y: y ),
                anchor: alignment,
                proposal: sizeProposal
            )
        }
    }
}
