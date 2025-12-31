//
//  MainDashboardView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct MainDashboardView: View {
    @StateObject private var altitudeVM = AltitudeViewModel()
    @StateObject private var acclimatizationVM = AcclimatizationViewModel()
    @StateObject private var symptomVM = SymptomViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large Altitude Display
                VStack(spacing: 16) {
                    Text("\(Int(altitudeVM.currentAltitude))")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "01A2FF"))
                    
                    Text("meters")
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    // Zone Indicator
                    HStack {
                        Circle()
                            .fill(altitudeVM.currentZone.color)
                            .frame(width: 12, height: 12)
                        Text(altitudeVM.currentZone.rawValue)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(20)
                }
                .padding(.top, 20)
                
                // Quick Stats
                VStack(spacing: 12) {
                    QuickStatRow(
                        label: "Current",
                        value: "\(Int(altitudeVM.currentAltitude))m",
                        icon: "arrow.up.circle.fill",
                        color: Color(hex: "01A2FF")
                    )
                    
                    if let equivalent = altitudeVM.equivalentAltitude {
                        QuickStatRow(
                            label: "Equivalent",
                            value: "\(Int(equivalent))m",
                            icon: "equal.circle.fill",
                            color: Color(hex: "00FFFF")
                        )
                    }
                    
                    QuickStatRow(
                        label: "Oxygen",
                        value: "\(Int(altitudeVM.oxygenPercentage))%",
                        icon: "wind",
                        color: Color(hex: "00FFFF")
                    )
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Acclimatization Progress
                if acclimatizationVM.currentPlan != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Acclimatization")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Day \(acclimatizationVM.currentDay) of \(acclimatizationVM.totalDays)")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "8A8F98"))
                        }
                        
                        ProgressView(value: acclimatizationVM.progress)
                            .tint(Color(hex: "01A2FF"))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                        
                        Text("\(Int(acclimatizationVM.progress * 100))% Complete")
                            .font(.caption)
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Error Message
                if let errorMessage = altitudeVM.errorMessage {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color(hex: "FFD700"))
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(12)
                }
                
                // AMS Warnings
                if !symptomVM.warnings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Safety Warnings")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(symptomVM.warnings) { warning in
                            WarningCard(warning: warning)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Control Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        if altitudeVM.isMonitoring {
                            altitudeVM.stopMonitoring()
                        } else {
                            altitudeVM.startMonitoring()
                        }
                    }) {
                        HStack {
                            Image(systemName: altitudeVM.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                            Text(altitudeVM.isMonitoring ? "Stop" : "Start")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(altitudeVM.isMonitoring ? Color(hex: "FF4757") : Color(hex: "01A2FF"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
    }
}

struct QuickStatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(label)
                .foregroundColor(Color(hex: "8A8F98"))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct WarningCard: View {
    let warning: AMSWarning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(warning.severity.color)
                    .frame(width: 8, height: 8)
                Text(warning.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
            }
            
            Text(warning.message)
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98"))
            
            Text(warning.recommendation)
                .font(.caption)
                .foregroundColor(warning.severity.color)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(hex: "090F1E"))
        .cornerRadius(12)
    }
}

#Preview {
    MainDashboardView()
}

