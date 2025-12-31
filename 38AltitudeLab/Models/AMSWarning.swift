//
//  AMSWarning.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import SwiftUI

struct AMSWarning: Identifiable {
    let id = UUID()
    var type: WarningType
    var severity: WarningSeverity
    var message: String
    var recommendation: String
}

enum WarningType: String {
    case lakeLouiseScore = "Lake Louise Score"
    case ascentRate = "Ascent Rate"
    case absoluteAltitude = "Absolute Altitude"
    case oxygenSaturation = "Oxygen Saturation"
    case weather = "Weather Conditions"
}

enum WarningSeverity: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return Color(hex: "01A2FF")
        case .medium: return Color(hex: "FFD700")
        case .high: return Color(hex: "FF6B35")
        case .critical: return Color(hex: "FF4757")
        }
    }
}


