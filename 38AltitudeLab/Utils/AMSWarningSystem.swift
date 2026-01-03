//
//  AMSWarningSystem.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation

class AMSWarningSystem {
    func checkForAMS(symptoms: [Symptom], altitude: Double, ascentRate: Double) -> [AMSWarning] {
        var warnings: [AMSWarning] = []
        
        let lakeLouiseScore = symptoms.reduce(0) { $0 + $1.severity.rawValue }
        
        // Warning by Lake Louise Score
        if lakeLouiseScore >= 3 {
            warnings.append(AMSWarning(
                type: .lakeLouiseScore,
                severity: lakeLouiseScore >= 5 ? .high : .medium,
                message: "Lake Louise Score: \(lakeLouiseScore)",
                recommendation: lakeLouiseScore >= 5 ? "Descend 300-500 meters" : "Stay at current altitude"
            ))
        }
        
        // Warning by ascent rate
        if ascentRate > 500.0 { // meters per day
            warnings.append(AMSWarning(
                type: .ascentRate,
                severity: .high,
                message: "Too fast ascent rate: \(Int(ascentRate))m/day",
                recommendation: "Reduce ascent rate to 300m/day"
            ))
        }
        
        // Warning by absolute altitude
        if altitude >= 3500 {
            warnings.append(AMSWarning(
                type: .absoluteAltitude,
                severity: altitude >= 4500 ? .critical : .medium,
                message: "Altitude: \(Int(altitude))m",
                recommendation: altitude >= 4500 ? "Maximum caution, be ready to descend" : "Increase acclimatization time"
            ))
        }
        
        return warnings
    }
}



