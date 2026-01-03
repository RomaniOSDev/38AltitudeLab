//
//  AcclimatizationPlan.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation

struct AcclimatizationPlan: Identifiable, Codable {
    let id: UUID
    var targetAltitude: Double
    var startDate: Date
    var endDate: Date
    var schedule: [DailySchedule]
    var userFitnessLevel: FitnessLevel
    var previousAltitudeExperience: AltitudeExperience
    
    init(id: UUID = UUID(), targetAltitude: Double, startDate: Date, endDate: Date, schedule: [DailySchedule] = [], userFitnessLevel: FitnessLevel, previousAltitudeExperience: AltitudeExperience) {
        self.id = id
        self.targetAltitude = targetAltitude
        self.startDate = startDate
        self.endDate = endDate
        self.schedule = schedule
        self.userFitnessLevel = userFitnessLevel
        self.previousAltitudeExperience = previousAltitudeExperience
    }
    
    var totalDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
    
    var progress: Double {
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(Double(daysPassed) / Double(max(totalDays, 1)), 1.0)
    }
}

struct DailySchedule: Identifiable, Codable {
    let id: UUID
    var dayNumber: Int
    var sleepAltitude: Double
    var maxAltitude: Double
    var activities: [Activity]
    var restPercentage: Double // % of day for rest
    var hydrationGoal: Double // liters of water
    var symptomsCheck: [Symptom]?
    
    init(id: UUID = UUID(), dayNumber: Int, sleepAltitude: Double, maxAltitude: Double, activities: [Activity] = [], restPercentage: Double, hydrationGoal: Double, symptomsCheck: [Symptom]? = nil) {
        self.id = id
        self.dayNumber = dayNumber
        self.sleepAltitude = sleepAltitude
        self.maxAltitude = maxAltitude
        self.activities = activities
        self.restPercentage = restPercentage
        self.hydrationGoal = hydrationGoal
        self.symptomsCheck = symptomsCheck
    }
}

enum FitnessLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case athlete = "Athlete"
    case elite = "Elite"
    
    var acclimatizationSpeed: Double {
        // Acclimatization speed multiplier
        switch self {
        case .beginner: return 1.0
        case .intermediate: return 0.9
        case .advanced: return 0.8
        case .athlete: return 0.7
        case .elite: return 0.6
        }
    }
}

enum AltitudeExperience: String, CaseIterable, Codable {
    case none = "No Experience"
    case low = "Low Altitude (<2500m)"
    case moderate = "Moderate Altitude (2500-4000m)"
    case high = "High Altitude (4000-5500m)"
    case extreme = "Extreme Altitude (>5500m)"
}

struct Activity: Identifiable, Codable {
    let id: UUID
    var name: String
    var intensity: ActivityIntensity
    var duration: TimeInterval // minutes
    var altitudeDuring: Double
    var notes: String?
    
    init(id: UUID = UUID(), name: String, intensity: ActivityIntensity, duration: TimeInterval, altitudeDuring: Double, notes: String? = nil) {
        self.id = id
        self.name = name
        self.intensity = intensity
        self.duration = duration
        self.altitudeDuring = altitudeDuring
        self.notes = notes
    }
}

enum ActivityIntensity: String, CaseIterable, Codable {
    case rest = "Rest"
    case light = "Light"
    case moderate = "Moderate"
    case hard = "Hard"
    case extreme = "Extreme"
}



