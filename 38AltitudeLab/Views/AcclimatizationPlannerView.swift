//
//  AcclimatizationPlannerView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct AcclimatizationPlannerView: View {
    @StateObject private var viewModel = AcclimatizationViewModel()
    @State private var showingCreatePlan = false
    @State private var targetAltitude: Double = 4000
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var fitnessLevel: FitnessLevel = .intermediate
    @State private var experience: AltitudeExperience = .moderate
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let plan = viewModel.currentPlan {
                    // Current Plan Display
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Current Plan")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target: \(Int(plan.targetAltitude))m")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "8A8F98"))
                            
                            Text("Day \(viewModel.currentDay) of \(viewModel.totalDays)")
                                .font(.title2)
                                .foregroundColor(Color(hex: "01A2FF"))
                            
                            ProgressView(value: viewModel.progress)
                                .tint(Color(hex: "01A2FF"))
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                        }
                        
                        if let todaySchedule = viewModel.getTodaySchedule() {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's Schedule")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                ScheduleCard(schedule: todaySchedule)
                            }
                            .padding()
                            .background(Color(hex: "090F1E"))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                    
                    // Schedule List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Full Schedule")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(plan.schedule) { schedule in
                            ScheduleCard(schedule: schedule)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                } else {
                    // No Plan State
                    VStack(spacing: 16) {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 64))
                            .foregroundColor(Color(hex: "01A2FF"))
                        
                        Text("No Acclimatization Plan")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Create a plan to safely acclimatize to high altitude")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Button(action: {
                    showingCreatePlan = true
                }) {
                    HStack {
                        Image(systemName: viewModel.currentPlan == nil ? "plus.circle.fill" : "pencil.circle.fill")
                        Text(viewModel.currentPlan == nil ? "Create Plan" : "Edit Plan")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "01A2FF"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Acclimatization")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCreatePlan) {
            CreatePlanView(
                targetAltitude: $targetAltitude,
                startDate: $startDate,
                endDate: $endDate,
                fitnessLevel: $fitnessLevel,
                experience: $experience,
                onCreate: {
                    viewModel.createPlan(
                        targetAltitude: targetAltitude,
                        startDate: startDate,
                        endDate: endDate,
                        fitnessLevel: fitnessLevel,
                        experience: experience
                    )
                    showingCreatePlan = false
                }
            )
        }
    }
}

struct ScheduleCard: View {
    let schedule: DailySchedule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day \(schedule.dayNumber)")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Sleep Altitude")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98"))
                    Text("\(Int(schedule.sleepAltitude))m")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Max Altitude")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98"))
                    Text("\(Int(schedule.maxAltitude))m")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            
            Text("Rest: \(Int(schedule.restPercentage))% | Hydration: \(String(format: "%.1f", schedule.hydrationGoal))L")
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .padding()
        .background(Color(hex: "1A2339"))
        .cornerRadius(12)
    }
}

struct CreatePlanView: View {
    @Binding var targetAltitude: Double
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var fitnessLevel: FitnessLevel
    @Binding var experience: AltitudeExperience
    let onCreate: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Target Altitude") {
                    VStack {
                        Text("\(Int(targetAltitude))m")
                            .font(.title)
                            .foregroundColor(Color(hex: "01A2FF"))
                        Slider(value: $targetAltitude, in: 1000...8000, step: 100)
                    }
                }
                
                Section("Dates") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section("Fitness Level") {
                    Picker("Fitness Level", selection: $fitnessLevel) {
                        ForEach(FitnessLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
                
                Section("Experience") {
                    Picker("Altitude Experience", selection: $experience) {
                        ForEach(AltitudeExperience.allCases, id: \.self) { exp in
                            Text(exp.rawValue).tag(exp)
                        }
                    }
                }
            }
            .navigationTitle("Create Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        onCreate()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        AcclimatizationPlannerView()
    }
}




