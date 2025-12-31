//
//  SymptomTrackerView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct SymptomTrackerView: View {
    @StateObject private var viewModel = SymptomViewModel()
    @StateObject private var altitudeVM = AltitudeViewModel()
    @State private var showingNewCheck = false
    @State private var selectedSymptomType: SymptomType?
    @State private var selectedSeverity: SymptomSeverity = .none
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Current Status
                if let latestCheck = viewModel.latestCheck {
                    VStack(spacing: 16) {
                        Text("Latest Check")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Lake Louise Score")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "8A8F98"))
                                Text("\(viewModel.latestLakeLouiseScore)")
                                    .font(.title)
                                    .foregroundColor(viewModel.latestAMSRisk.color)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("AMS Risk")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "8A8F98"))
                                Text(viewModel.latestAMSRisk.rawValue)
                                    .font(.headline)
                                    .foregroundColor(viewModel.latestAMSRisk.color)
                            }
                        }
                        
                        if viewModel.latestAMSRisk != .none {
                            Text(viewModel.latestAMSRisk.recommendation)
                                .font(.subheadline)
                                .foregroundColor(viewModel.latestAMSRisk.color)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(hex: "090F1E"))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Warnings
                if !viewModel.warnings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Warnings")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.warnings) { warning in
                            WarningCard(warning: warning)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Symptom Checklist
                VStack(alignment: .leading, spacing: 16) {
                    Text("Symptom Checklist")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(SymptomType.allCases, id: \.self) { symptomType in
                        SymptomRow(
                            type: symptomType,
                            severity: getSeverity(for: symptomType),
                            onSelect: { severity in
                                viewModel.addSymptom(type: symptomType, severity: severity)
                            }
                        )
                    }
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // History
                if !viewModel.symptomChecks.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("History")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.symptomChecks.reversed()) { check in
                            SymptomCheckCard(check: check)
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Save Button
                Button(action: {
                    if viewModel.currentCheck == nil {
                        viewModel.createNewCheck(altitude: altitudeVM.currentAltitude)
                    }
                    viewModel.saveCurrentCheck()
                    viewModel.createNewCheck(altitude: altitudeVM.currentAltitude)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Check")
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
        .navigationTitle("Symptom Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.currentCheck == nil {
                viewModel.createNewCheck(altitude: altitudeVM.currentAltitude)
            }
        }
    }
    
    private func getSeverity(for type: SymptomType) -> SymptomSeverity {
        viewModel.currentCheck?.symptoms.first(where: { $0.type == type })?.severity ?? .none
    }
}

struct SymptomRow: View {
    let type: SymptomType
    let severity: SymptomSeverity
    let onSelect: (SymptomSeverity) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.rawValue)
                .font(.subheadline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(SymptomSeverity.allCases, id: \.self) { sev in
                    Button(action: {
                        onSelect(sev)
                    }) {
                        Text(sev.description)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(severity == sev ? Color(hex: "01A2FF") : Color(hex: "090F1E"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(hex: "090F1E"))
        .cornerRadius(12)
    }
}

struct SymptomCheckCard: View {
    let check: SymptomCheck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(check.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(check.altitude))m")
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            
            HStack {
                Text("Score: \(check.lakeLouiseScore)")
                    .font(.headline)
                    .foregroundColor(check.amsRisk.color)
                Spacer()
                Text(check.amsRisk.rawValue)
                    .font(.caption)
                    .foregroundColor(check.amsRisk.color)
            }
        }
        .padding()
        .background(Color(hex: "090F1E"))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        SymptomTrackerView()
    }
}

