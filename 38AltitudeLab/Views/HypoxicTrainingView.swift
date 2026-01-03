//
//  HypoxicTrainingView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct HypoxicTrainingView: View {
    @StateObject private var viewModel = TrainingViewModel()
    @State private var simulatedAltitude: Double = 3000
    @State private var duration: Double = 30
    @State private var showingStartConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Current Training
                if viewModel.isTrainingActive, let training = viewModel.currentTraining {
                    VStack(spacing: 16) {
                        Text("Training Active")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("\(Int(training.simulatedAltitude))m")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(hex: "01A2FF"))
                        
                        Text("Oxygen: \(Int(training.oxygenPercentage))%")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                        
                        Text(timeString(from: viewModel.elapsedTime))
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Remaining: \(timeString(from: viewModel.remainingTime))")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                        
                        Button(action: {
                            viewModel.stopTraining()
                        }) {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                Text("Stop Training")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "FF4757"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                } else {
                    // Training Setup
                    VStack(spacing: 16) {
                        Text("Hypoxic Training")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            Text("Simulated Altitude")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "8A8F98"))
                            
                            Text("\(Int(simulatedAltitude))m")
                                .font(.title)
                                .foregroundColor(Color(hex: "01A2FF"))
                            
                            Slider(value: $simulatedAltitude, in: 1000...6000, step: 100)
                            
                            Text("Oxygen: \(Int(viewModel.calculateOxygenPercentage(for: simulatedAltitude)))%")
                                .font(.caption)
                                .foregroundColor(Color(hex: "8A8F98"))
                        }
                        
                        VStack(spacing: 12) {
                            Text("Duration")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "8A8F98"))
                            
                            Text("\(Int(duration)) minutes")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Slider(value: $duration, in: 5...120, step: 5)
                        }
                        
                        Button(action: {
                            showingStartConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                Text("Start Training")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "01A2FF"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Training History
                if !viewModel.trainings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training History")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.trainings.reversed()) { training in
                            TrainingHistoryCard(training: training)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Hypoxic Training")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Start Training", isPresented: $showingStartConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Start") {
                viewModel.startTraining(
                    simulatedAltitude: simulatedAltitude,
                    duration: duration * 60
                )
            }
        } message: {
            Text("Start training at \(Int(simulatedAltitude))m for \(Int(duration)) minutes?")
        }
    }
    
    private func timeString(from seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct TrainingHistoryCard: View {
    let training: HypoxicTraining
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(Int(training.simulatedAltitude))m")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(training.duration / 60)) min")
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            
            Text("Oxygen: \(Int(training.oxygenPercentage))%")
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .padding()
        .background(Color(hex: "090F1E"))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        HypoxicTrainingView()
    }
}



