//
//  HypoxicTraining.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation

struct HypoxicTraining: Identifiable, Codable {
    let id: UUID
    var simulatedAltitude: Double // meters
    var duration: TimeInterval // minutes
    var oxygenPercentage: Double // %
    var heartRateData: [HeartRatePoint]?
    var perceivedExertion: Int? // 1-10
    var recoveryTime: TimeInterval? // minutes
    
    init(id: UUID = UUID(), simulatedAltitude: Double, duration: TimeInterval, oxygenPercentage: Double, heartRateData: [HeartRatePoint]? = nil, perceivedExertion: Int? = nil, recoveryTime: TimeInterval? = nil) {
        self.id = id
        self.simulatedAltitude = simulatedAltitude
        self.duration = duration
        self.oxygenPercentage = oxygenPercentage
        self.heartRateData = heartRateData
        self.perceivedExertion = perceivedExertion
        self.recoveryTime = recoveryTime
    }
}

struct HeartRatePoint: Codable {
    var timestamp: Date
    var bpm: Int
}



