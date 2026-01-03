//
//  TrainingViewModel.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import Combine

class TrainingViewModel: ObservableObject {
    @Published var trainings: [HypoxicTraining] = []
    @Published var currentTraining: HypoxicTraining?
    @Published var isTrainingActive: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    
    private var trainingTimer: Timer?
    
    init() {
        loadTrainings()
    }
    
    func startTraining(simulatedAltitude: Double, duration: TimeInterval) {
        let oxygenPercentage = calculateOxygenPercentage(for: simulatedAltitude)
        
        currentTraining = HypoxicTraining(
            simulatedAltitude: simulatedAltitude,
            duration: duration,
            oxygenPercentage: oxygenPercentage
        )
        
        isTrainingActive = true
        elapsedTime = 0
        
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1.0
            
            if self.elapsedTime >= duration {
                self.stopTraining()
            }
        }
    }
    
    func stopTraining() {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        guard var training = currentTraining else { return }
        training.recoveryTime = elapsedTime / 2 // Simplified recovery calculation
        
        trainings.append(training)
        currentTraining = nil
        isTrainingActive = false
        elapsedTime = 0
        
        saveTrainings()
    }
    
    func calculateOxygenPercentage(for altitude: Double) -> Double {
        // Simplified calculation based on altitude zones
        let zone: AltitudeZone
        switch altitude {
        case ..<1500: zone = .low
        case 1500..<2500: zone = .moderate
        case 2500..<3500: zone = .high
        case 3500..<4500: zone = .veryHigh
        case 4500..<5500: zone = .extreme
        default: zone = .deathZone
        }
        return zone.oxygenPercentage
    }
    
    var remainingTime: TimeInterval {
        guard let training = currentTraining else { return 0 }
        return max(0, training.duration - elapsedTime)
    }
    
    private func saveTrainings() {
        // In a real app, save to CoreData or UserDefaults
    }
    
    private func loadTrainings() {
        // In a real app, load from CoreData or UserDefaults
    }
}



