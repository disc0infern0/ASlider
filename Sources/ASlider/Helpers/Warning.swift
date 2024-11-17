//
//  Warning.swift
//  ASlider
//
//  Created by Andrew on 11/12/24.
//
import OSLog
enum Warning {
    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "New Slider",
        category: "Runtime warning")
    @MainActor static let log: (_ message: String)->Void = { message in
        Self.logger.warning("\(message, privacy: .public)")
    }
}
