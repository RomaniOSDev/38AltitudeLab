//
//  AltitudeReading.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import SwiftUI

struct AltitudeReading: Identifiable, Codable {
    let id: UUID
    var altitude: Double // meters
    var pressure: Double? // hPa
    var temperature: Double? // °C
    var timestamp: Date
    var location: LocationData?
    var oxygenSaturation: Double? // SpO2 in %
    
    init(id: UUID = UUID(), altitude: Double, pressure: Double? = nil, temperature: Double? = nil, timestamp: Date = Date(), location: LocationData? = nil, oxygenSaturation: Double? = nil) {
        self.id = id
        self.altitude = altitude
        self.pressure = pressure
        self.temperature = temperature
        self.timestamp = timestamp
        self.location = location
        self.oxygenSaturation = oxygenSaturation
    }
    
    var equivalentAltitude: Double? {
        // Calculate equivalent altitude based on pressure
        guard let pressure = pressure else { return nil }
        // Standard atmospheric pressure at sea level: 1013.25 hPa
        let pressureRatio = pressure / 1013.25
        // Formula: h = 44330 * (1 - (P/P0)^(1/5.255))
        return 44330.0 * (1.0 - pow(pressureRatio, 1/5.255))
    }
    
    var altitudeZone: AltitudeZone {
        switch altitude {
        case ..<1500: return .low
        case 1500..<2500: return .moderate
        case 2500..<3500: return .high
        case 3500..<4500: return .veryHigh
        case 4500..<5500: return .extreme
        default: return .deathZone
        }
    }
}

enum AltitudeZone: String, CaseIterable, Codable {
    case low = "Low (<1500m)"
    case moderate = "Moderate (1500-2500m)"
    case high = "High (2500-3500m)"
    case veryHigh = "Very High (3500-4500m)"
    case extreme = "Extreme (4500-5500m)"
    case deathZone = "Death Zone (>5500m)"
    
    var color: Color {
        switch self {
        case .low: return Color(hex: "00FF88")
        case .moderate: return Color(hex: "00FFFF")
        case .high: return Color(hex: "01A2FF")
        case .veryHigh: return Color(hex: "FFD700")
        case .extreme: return Color(hex: "FF6B35")
        case .deathZone: return Color(hex: "FF4757")
        }
    }
    
    var oxygenPercentage: Double {
        switch self {
        case .low: return 100.0
        case .moderate: return 82.0
        case .high: return 73.0
        case .veryHigh: return 65.0
        case .extreme: return 57.0
        case .deathZone: return 50.0
        }
    }
    
    var acclimatizationDays: Int {
        switch self {
        case .low: return 0
        case .moderate: return 2
        case .high: return 4
        case .veryHigh: return 7
        case .extreme: return 14
        case .deathZone: return 21
        }
    }
}

struct LocationData: Codable {
    var latitude: Double
    var longitude: Double
    var name: String?
}

