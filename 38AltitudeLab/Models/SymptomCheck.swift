//
//  SymptomCheck.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import SwiftUI

struct SymptomCheck: Identifiable, Codable {
    let id: UUID
    var date: Date
    var altitude: Double
    var symptoms: [Symptom]
    
    init(id: UUID = UUID(), date: Date = Date(), altitude: Double, symptoms: [Symptom] = []) {
        self.id = id
        self.date = date
        self.altitude = altitude
        self.symptoms = symptoms
    }
    
    var lakeLouiseScore: Int {
        symptoms.reduce(0) { $0 + $1.severity.rawValue }
    }
    
    var amsRisk: AMSRisk {
        switch lakeLouiseScore {
        case 0..<3: return .none
        case 3..<5: return .mild
        case 5..<8: return .moderate
        default: return .severe
        }
    }
}

struct Symptom: Identifiable, Codable {
    let id: UUID
    var type: SymptomType
    var severity: SymptomSeverity
    var notes: String?
    
    init(id: UUID = UUID(), type: SymptomType, severity: SymptomSeverity, notes: String? = nil) {
        self.id = id
        self.type = type
        self.severity = severity
        self.notes = notes
    }
}

enum SymptomType: String, CaseIterable, Codable {
    case headache = "Headache"
    case nausea = "Nausea"
    case fatigue = "Fatigue"
    case dizziness = "Dizziness"
    case insomnia = "Insomnia"
    case shortnessOfBreath = "Shortness of Breath"
    case lossOfAppetite = "Loss of Appetite"
    
    var lakeLouisePoints: Int {
        switch self {
        case .headache: return 2
        case .nausea: return 1
        case .fatigue: return 1
        case .dizziness: return 1
        case .insomnia: return 1
        case .shortnessOfBreath: return 1
        case .lossOfAppetite: return 1
        }
    }
}

enum SymptomSeverity: Int, CaseIterable, Codable {
    case none = 0
    case mild = 1
    case moderate = 2
    case severe = 3
    
    var description: String {
        switch self {
        case .none: return "None"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        }
    }
}

enum AMSRisk: String, Codable {
    case none = "No Risk"
    case mild = "Mild AMS"
    case moderate = "Moderate AMS"
    case severe = "Severe AMS"
    
    var color: Color {
        switch self {
        case .none: return Color(hex: "00FF88")
        case .mild: return Color(hex: "FFD700")
        case .moderate: return Color(hex: "FF6B35")
        case .severe: return Color(hex: "FF4757")
        }
    }
    
    var recommendation: String {
        switch self {
        case .none: return "Continue acclimatization"
        case .mild: return "Stay at current altitude, rest more"
        case .moderate: return "Descend 300-500 meters"
        case .severe: return "Immediately descend 1000+ meters"
        }
    }
}




