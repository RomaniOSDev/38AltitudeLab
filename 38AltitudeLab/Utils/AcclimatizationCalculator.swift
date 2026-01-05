//
//  AcclimatizationCalculator.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation

struct AcclimatizationCalculator {
    // "Climb high, sleep low" rule
    static func calculateDailySchedule(currentAltitude: Double,
                                     targetAltitude: Double,
                                     experience: AltitudeExperience,
                                     fitness: FitnessLevel) -> DailySchedule {
        
        let maxDailyGain = calculateMaxDailyGain(experience: experience, fitness: fitness)
        let safeSleepAltitude = calculateSafeSleepAltitude(currentAltitude: currentAltitude)
        
        // Calculate daily activities
        let activities = recommendActivities(for: currentAltitude)
        
        return DailySchedule(
            dayNumber: 1,
            sleepAltitude: safeSleepAltitude,
            maxAltitude: min(currentAltitude + maxDailyGain, targetAltitude),
            activities: activities,
            restPercentage: calculateRestPercentage(altitude: currentAltitude),
            hydrationGoal: calculateHydrationGoal(altitude: currentAltitude)
        )
    }
    
    private static func calculateMaxDailyGain(experience: AltitudeExperience, fitness: FitnessLevel) -> Double {
        let baseGain: Double
        switch experience {
        case .none: baseGain = 300.0
        case .low: baseGain = 400.0
        case .moderate: baseGain = 500.0
        case .high: baseGain = 600.0
        case .extreme: baseGain = 700.0
        }
        
        return baseGain * fitness.acclimatizationSpeed
    }
    
    private static func calculateSafeSleepAltitude(currentAltitude: Double) -> Double {
        // Don't sleep higher than 300-500m above previous night
        return currentAltitude - 100.0 // Sleep slightly lower
    }
    
    private static func recommendActivities(for altitude: Double) -> [Activity] {
        var activities: [Activity] = []
        
        if altitude < 2500 {
            activities.append(Activity(name: "Light Walking", intensity: .light, duration: 180, altitudeDuring: altitude + 200))
        } else if altitude < 3500 {
            activities.append(Activity(name: "Acclimatization Hike", intensity: .moderate, duration: 120, altitudeDuring: altitude + 300))
            activities.append(Activity(name: "Rest", intensity: .rest, duration: 240, altitudeDuring: altitude))
        } else {
            activities.append(Activity(name: "Short Hike", intensity: .light, duration: 60, altitudeDuring: altitude + 150))
            activities.append(Activity(name: "Extended Rest", intensity: .rest, duration: 360, altitudeDuring: altitude))
        }
        
        return activities
    }
    
    private static func calculateRestPercentage(altitude: Double) -> Double {
        switch altitude {
        case ..<2500: return 30.0
        case 2500..<3500: return 40.0
        case 3500..<4500: return 50.0
        default: return 60.0
        }
    }
    
    private static func calculateHydrationGoal(altitude: Double) -> Double {
        // Liter of water per 1000m altitude above base 2L
        let baseWater = 2.0
        let additionalWater = max(0, altitude / 1000.0)
        return baseWater + additionalWater
    }
}

let altitudeZoneData: [AltitudeZone: (description: String, recommendations: [String])] = [
    .low: (
        description: "Low altitude, minimal AMS risk",
        recommendations: [
            "No altitude preparation needed",
            "Can ascend quickly",
            "Normal physical activity"
        ]
    ),
    .moderate: (
        description: "Moderate altitude, mild symptoms possible",
        recommendations: [
            "Ascend no more than 300m/day for sleep",
            "Drink 3+ liters of water per day",
            "Listen to your body"
        ]
    ),
    .high: (
        description: "High altitude, AMS risk increases",
        recommendations: [
            "Follow 'climb high, sleep low' rule",
            "Rest day every 3-4 days",
            "Monitor symptoms daily"
        ]
    ),
    .veryHigh: (
        description: "Very high altitude, significant risk",
        recommendations: [
            "Only for experienced mountaineers",
            "Mandatory rest day every 2 days",
            "Be prepared for immediate descent"
        ]
    ),
    .extreme: (
        description: "Extreme altitude, life-threatening danger",
        recommendations: [
            "Only for expeditions with support",
            "Oxygen may be necessary",
            "Constant condition monitoring"
        ]
    ),
    .deathZone: (
        description: "Death zone, survival time limited",
        recommendations: [
            "Only for short-term ascents",
            "Mandatory oxygen use",
            "Emergency descent at first symptoms"
        ]
    )
]




