//
//  ShapeEffectOptions.swift
//  bindingToClass
//
//  Created by Andrew on 09/08/2024.
//



import SwiftUICore

/// Recreates the symbol bouncey effect  when an equatable toggle value changes;-
///    .symbolEffect(.bounce, options: .repeat(1), value: helper.dragStarted)
///

internal enum ShapeEffectOptions {
    case effectRepeat(Int)
    static let none = Self.effectRepeat(0)
    static let once = Self.effectRepeat(1)
}

internal enum ShapeEffects { case none, pulse, bounce } //, breathe, scale, wiggle }

struct ShapeEffect<EQ: Equatable>: ViewModifier {
    let effect: ShapeEffects
    let options: ShapeEffectOptions
    let toggle: EQ
    @State var effectValue = 1.0
    var repeats: Int { switch options { case .effectRepeat(let repeats): repeats } }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        // MARK: TODO - Exercise: create effects for remaining symbol Effect effects
        switch effect {
            case .none:
                content
            case .bounce:
                bounce(content: content, repeats: repeats)
            case .pulse:
                pulse(content: content, repeats: repeats)
        }
    }

    func pulse(content: Content, repeats: Int) -> some View {
        let duration = 0.5
        return content
            .opacity(effectValue)
            .animation(.easeInOut(duration: duration), value: effectValue)
            .task(id: toggle) {
                for _ in (0...repeats) {
                    effectValue = 1 - effectValue
                    try? await Task.sleep(for: .seconds(duration))
                    if Task.isCancelled { return }
                }
            }
    }

    func bounce(content: Content, repeats: Int) -> some View {
        let duration = 0.3
        return content
            .scaleEffect(effectValue)
            .animation(
                .bouncy(duration: duration, extraBounce: 0.4),
                value: effectValue
            )
            .task(id: toggle) {
                for _ in (0...repeats) {
                    effectValue = 1.3
                    try? await Task.sleep(for: .seconds(duration/3))
                    if Task.isCancelled { return }
                    effectValue = 1.0
                }
            }
    }
}

extension View {
    func shapeEffect<EQ: Equatable>(_ effect: ShapeEffects, options: ShapeEffectOptions = .effectRepeat(0), value: EQ) -> some View {
        modifier(ShapeEffect(effect: effect, options: options, toggle: value))
    }
}
