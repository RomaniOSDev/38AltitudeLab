//
//  AltitudeViewModel.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import CoreMotion
import Combine

class AltitudeViewModel: ObservableObject {
    @Published var currentReading: AltitudeReading?
    @Published var readings: [AltitudeReading] = []
    @Published var isMonitoring: Bool = false
    @Published var errorMessage: String?
    
    private let altimeter = CMAltimeter()
    private var cancellables = Set<AnyCancellable>()
    private var monitoringTimer: Timer?
    private var simulatedAltitude: Double = 100.0 // For simulated monitoring
    
    init() {
        // Load saved readings
        loadReadings()
    }
    
    func startMonitoring() {
        isMonitoring = true
        errorMessage = nil
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // Use real barometer if available
            altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isMonitoring = false
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No altitude data received"
                    self.isMonitoring = false
                    return
                }
                
                // Convert relative altitude to absolute (approximate)
                // This is a simplified calculation - in real app you'd use GPS + barometer
                let altitude = data.relativeAltitude.doubleValue * 1000 // Convert to meters
                let pressure = data.pressure.doubleValue * 10 // Convert to hPa
                
                let reading = AltitudeReading(
                    altitude: altitude,
                    pressure: pressure,
                    timestamp: Date()
                )
                
                self.currentReading = reading
                self.readings.append(reading)
                
                // Keep only last 1000 readings
                if self.readings.count > 1000 {
                    self.readings.removeFirst()
                }
                
                self.saveReadings()
            }
        } else {
            // Fallback: simulate altitude data for simulator/devices without barometer
            errorMessage = "Using simulated altitude data (barometer not available)"
            startSimulatedMonitoring()
        }
    }
    
    private func startSimulatedMonitoring() {
        // Stop any existing timer first
        monitoringTimer?.invalidate()
        
        // Reset simulated altitude if starting fresh
        if readings.isEmpty {
            simulatedAltitude = 100.0
        } else if let lastReading = readings.last {
            simulatedAltitude = lastReading.altitude
        }
        
        // Create initial reading immediately
        let initialPressure = 1013.25 * pow(1 - (simulatedAltitude / 44330), 5.255)
        let initialReading = AltitudeReading(
            altitude: simulatedAltitude,
            pressure: initialPressure,
            timestamp: Date()
        )
        currentReading = initialReading
        readings.append(initialReading)
        
        // Create timer on main run loop
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, self.isMonitoring else {
                timer.invalidate()
                return
            }
            
            // Simulate small altitude changes
            self.simulatedAltitude += Double.random(in: -5...5)
            self.simulatedAltitude = max(0, self.simulatedAltitude) // Don't go below sea level
            
            // Simulate pressure based on altitude (simplified barometric formula)
            let pressure = 1013.25 * pow(1 - (self.simulatedAltitude / 44330), 5.255)
            
            let reading = AltitudeReading(
                altitude: self.simulatedAltitude,
                pressure: pressure,
                timestamp: Date()
            )
            
            self.currentReading = reading
            self.readings.append(reading)
            
            // Keep only last 1000 readings
            if self.readings.count > 1000 {
                self.readings.removeFirst()
            }
            
            self.saveReadings()
        }
    }
    
    func stopMonitoring() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.stopRelativeAltitudeUpdates()
        }
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        isMonitoring = false
    }
    
    var currentAltitude: Double {
        currentReading?.altitude ?? 0.0
    }
    
    var currentZone: AltitudeZone {
        currentReading?.altitudeZone ?? .low
    }
    
    var equivalentAltitude: Double? {
        currentReading?.equivalentAltitude
    }
    
    var oxygenPercentage: Double {
        currentZone.oxygenPercentage
    }
    
    var ascentRate: Double {
        guard readings.count >= 2 else { return 0.0 }
        let recent = readings.suffix(2)
        let altitudes = recent.map { $0.altitude }
        guard altitudes.count == 2 else { return 0.0 }
        let timeDiff = recent.last!.timestamp.timeIntervalSince(recent.first!.timestamp)
        guard timeDiff > 0 else { return 0.0 }
        let altitudeDiff = altitudes[1] - altitudes[0]
        // Convert to meters per day
        return (altitudeDiff / timeDiff) * 86400.0
    }
    
    private func saveReadings() {
        // In a real app, save to CoreData or UserDefaults
        // For MVP, we'll keep in memory
    }
    
    private func loadReadings() {
        // In a real app, load from CoreData or UserDefaults
    }
}

