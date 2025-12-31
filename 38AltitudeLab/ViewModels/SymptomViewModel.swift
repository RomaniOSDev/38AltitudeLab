//
//  SymptomViewModel.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import Combine

class SymptomViewModel: ObservableObject {
    @Published var symptomChecks: [SymptomCheck] = []
    @Published var currentCheck: SymptomCheck?
    @Published var warnings: [AMSWarning] = []
    
    private let warningSystem = AMSWarningSystem()
    
    init() {
        loadChecks()
    }
    
    func createNewCheck(altitude: Double) {
        currentCheck = SymptomCheck(altitude: altitude)
    }
    
    func addSymptom(type: SymptomType, severity: SymptomSeverity, notes: String? = nil) {
        guard var check = currentCheck else { return }
        
        // Remove existing symptom of this type if any
        check.symptoms.removeAll { $0.type == type }
        
        // Add new symptom if severity is not none
        if severity != .none {
            let symptom = Symptom(type: type, severity: severity, notes: notes)
            check.symptoms.append(symptom)
        }
        
        currentCheck = check
    }
    
    func saveCurrentCheck() {
        guard var check = currentCheck else { return }
        check.date = Date()
        symptomChecks.append(check)
        currentCheck = nil
        
        // Update warnings
        updateWarnings(for: check)
        
        saveChecks()
    }
    
    func updateWarnings(for check: SymptomCheck) {
        // Calculate ascent rate (simplified - in real app get from AltitudeViewModel)
        let ascentRate = 0.0
        
        let newWarnings = warningSystem.checkForAMS(
            symptoms: check.symptoms,
            altitude: check.altitude,
            ascentRate: ascentRate
        )
        
        warnings = newWarnings
    }
    
    var latestCheck: SymptomCheck? {
        symptomChecks.last
    }
    
    var latestAMSRisk: AMSRisk {
        latestCheck?.amsRisk ?? .none
    }
    
    var latestLakeLouiseScore: Int {
        latestCheck?.lakeLouiseScore ?? 0
    }
    
    private func saveChecks() {
        // In a real app, save to CoreData or UserDefaults
    }
    
    private func loadChecks() {
        // In a real app, load from CoreData or UserDefaults
    }
}

