//
//  AcclimatizationViewModel.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import Foundation
import Combine

class AcclimatizationViewModel: ObservableObject {
    @Published var currentPlan: AcclimatizationPlan?
    @Published var plans: [AcclimatizationPlan] = []
    @Published var isCreatingPlan: Bool = false
    
    init() {
        loadPlans()
    }
    
    func createPlan(targetAltitude: Double, startDate: Date, endDate: Date, fitnessLevel: FitnessLevel, experience: AltitudeExperience) {
        let currentAltitude = 0.0 // In real app, get from AltitudeViewModel
        
        var schedule: [DailySchedule] = []
        let totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
        
        var currentAlt = currentAltitude
        for day in 1...totalDays {
            let daySchedule = AcclimatizationCalculator.calculateDailySchedule(
                currentAltitude: currentAlt,
                targetAltitude: targetAltitude,
                experience: experience,
                fitness: fitnessLevel
            )
            var updatedSchedule = daySchedule
            updatedSchedule.dayNumber = day
            schedule.append(updatedSchedule)
            currentAlt = updatedSchedule.maxAltitude
        }
        
        let plan = AcclimatizationPlan(
            targetAltitude: targetAltitude,
            startDate: startDate,
            endDate: endDate,
            schedule: schedule,
            userFitnessLevel: fitnessLevel,
            previousAltitudeExperience: experience
        )
        
        currentPlan = plan
        plans.append(plan)
        savePlans()
    }
    
    var currentDay: Int {
        guard let plan = currentPlan else { return 0 }
        let daysPassed = Calendar.current.dateComponents([.day], from: plan.startDate, to: Date()).day ?? 0
        return daysPassed + 1
    }
    
    var totalDays: Int {
        currentPlan?.totalDays ?? 0
    }
    
    var progress: Double {
        currentPlan?.progress ?? 0.0
    }
    
    func getTodaySchedule() -> DailySchedule? {
        guard let plan = currentPlan else { return nil }
        let day = currentDay
        return plan.schedule.first { $0.dayNumber == day }
    }
    
    private func savePlans() {
        // In a real app, save to CoreData or UserDefaults
    }
    
    private func loadPlans() {
        // In a real app, load from CoreData or UserDefaults
    }
}


