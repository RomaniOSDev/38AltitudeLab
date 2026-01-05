//
//  AnalyticsView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var altitudeVM = AltitudeViewModel()
    @StateObject private var symptomVM = SymptomViewModel()
    @StateObject private var acclimatizationVM = AcclimatizationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Altitude vs Symptoms Correlation
                if !altitudeVM.readings.isEmpty && !symptomVM.symptomChecks.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Altitude vs Symptoms")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart {
                            ForEach(Array(altitudeVM.readings.suffix(50).enumerated()), id: \.element.id) { index, reading in
                                LineMark(
                                    x: .value("Time", index),
                                    y: .value("Altitude", reading.altitude)
                                )
                                .foregroundStyle(Color(hex: "01A2FF"))
                            }
                            
                            ForEach(Array(symptomVM.symptomChecks.enumerated()), id: \.element.id) { index, check in
                                BarMark(
                                    x: .value("Check", index),
                                    y: .value("Score", check.lakeLouiseScore * 100)
                                )
                                .foregroundStyle(check.amsRisk.color.opacity(0.6))
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Acclimatization Progress
                if let plan = acclimatizationVM.currentPlan {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Acclimatization Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ProgressView(value: acclimatizationVM.progress)
                            .tint(Color(hex: "01A2FF"))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                        
                        Text("\(Int(acclimatizationVM.progress * 100))% Complete")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Statistics Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics Summary")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    StatSummaryRow(label: "Total Readings", value: "\(altitudeVM.readings.count)")
                    StatSummaryRow(label: "Symptom Checks", value: "\(symptomVM.symptomChecks.count)")
                    StatSummaryRow(label: "Average Score", value: String(format: "%.1f", averageLakeLouiseScore))
                    StatSummaryRow(label: "Max Altitude", value: "\(Int(maxAltitude))m")
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Recommendations
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommendations")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if averageLakeLouiseScore > 3 {
                        RecommendationCard(
                            title: "High Symptom Scores",
                            message: "Consider slower ascent rate and more rest days",
                            color: Color(hex: "FFD700")
                        )
                    }
                    
                    if acclimatizationVM.progress < 0.5 && acclimatizationVM.currentPlan != nil {
                        RecommendationCard(
                            title: "Early Acclimatization",
                            message: "Continue following your plan, monitor symptoms closely",
                            color: Color(hex: "01A2FF")
                        )
                    }
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var averageLakeLouiseScore: Double {
        guard !symptomVM.symptomChecks.isEmpty else { return 0 }
        let total = symptomVM.symptomChecks.reduce(0) { $0 + $1.lakeLouiseScore }
        return Double(total) / Double(symptomVM.symptomChecks.count)
    }
    
    private var maxAltitude: Double {
        altitudeVM.readings.map { $0.altitude }.max() ?? 0
    }
}

struct StatSummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(Color(hex: "8A8F98"))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct RecommendationCard: View {
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            Text(message)
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "090F1E"))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        AnalyticsView()
    }
}




