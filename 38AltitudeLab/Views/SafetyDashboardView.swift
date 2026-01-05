//
//  SafetyDashboardView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct SafetyDashboardView: View {
    @StateObject private var altitudeVM = AltitudeViewModel()
    @StateObject private var symptomVM = SymptomViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Safety Status
                VStack(spacing: 16) {
                    Text("Safety Status")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Circle()
                            .fill(safetyStatusColor)
                            .frame(width: 16, height: 16)
                        Text(safetyStatusText)
                            .font(.title2)
                            .foregroundColor(safetyStatusColor)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Current Conditions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Conditions")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SafetyRow(label: "Altitude", value: "\(Int(altitudeVM.currentAltitude))m", color: altitudeVM.currentZone.color)
                    SafetyRow(label: "Zone", value: altitudeVM.currentZone.rawValue, color: altitudeVM.currentZone.color)
                    SafetyRow(label: "Oxygen", value: "\(Int(altitudeVM.oxygenPercentage))%", color: Color(hex: "00FFFF"))
                    SafetyRow(label: "AMS Risk", value: symptomVM.latestAMSRisk.rawValue, color: symptomVM.latestAMSRisk.color)
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Active Warnings
                if !symptomVM.warnings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Warnings")
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
                
                // Recommendations
                if let zoneData = altitudeZoneData[altitudeVM.currentZone] {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommendations")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(zoneData.description)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                        
                        ForEach(zoneData.recommendations, id: \.self) { recommendation in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "00FF88"))
                                    .font(.caption)
                                Text(recommendation)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "8A8F98"))
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Emergency Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Emergency Actions")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    EmergencyActionRow(
                        title: "Severe AMS",
                        action: "Descend immediately 1000+ meters",
                        color: Color(hex: "FF4757")
                    )
                    
                    EmergencyActionRow(
                        title: "Moderate AMS",
                        action: "Descend 300-500 meters",
                        color: Color(hex: "FF6B35")
                    )
                    
                    EmergencyActionRow(
                        title: "Mild AMS",
                        action: "Stay at current altitude, rest",
                        color: Color(hex: "FFD700")
                    )
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Safety Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var safetyStatusColor: Color {
        if symptomVM.latestAMSRisk == .severe {
            return Color(hex: "FF4757")
        } else if symptomVM.latestAMSRisk == .moderate {
            return Color(hex: "FF6B35")
        } else if symptomVM.latestAMSRisk == .mild {
            return Color(hex: "FFD700")
        } else if altitudeVM.currentZone == .deathZone || altitudeVM.currentZone == .extreme {
            return Color(hex: "FFD700")
        } else {
            return Color(hex: "00FF88")
        }
    }
    
    private var safetyStatusText: String {
        if symptomVM.latestAMSRisk == .severe {
            return "CRITICAL"
        } else if symptomVM.latestAMSRisk == .moderate {
            return "CAUTION"
        } else if symptomVM.latestAMSRisk == .mild {
            return "WARNING"
        } else if altitudeVM.currentZone == .deathZone || altitudeVM.currentZone == .extreme {
            return "EXTREME ALTITUDE"
        } else {
            return "SAFE"
        }
    }
}

struct SafetyRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(Color(hex: "8A8F98"))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct EmergencyActionRow: View {
    let title: String
    let action: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            Text(action)
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
        SafetyDashboardView()
    }
}




