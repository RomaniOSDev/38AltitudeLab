//
//  AltitudeMonitorView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI
import Charts

struct AltitudeMonitorView: View {
    @StateObject private var viewModel = AltitudeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Current Reading
                VStack(spacing: 16) {
                    Text("Current Altitude")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(Int(viewModel.currentAltitude))m")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color(hex: "01A2FF"))
                    
                    if let equivalent = viewModel.equivalentAltitude {
                        Text("Equivalent: \(Int(equivalent))m")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Chart
                if !viewModel.readings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Altitude History")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart {
                            ForEach(Array(viewModel.readings.enumerated()), id: \.element.id) { index, reading in
                                LineMark(
                                    x: .value("Time", index),
                                    y: .value("Altitude", reading.altitude)
                                )
                                .foregroundStyle(Color(hex: "01A2FF"))
                            }
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisValueLabel()
                                    .foregroundStyle(Color(hex: "8A8F98"))
                            }
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisValueLabel()
                                    .foregroundStyle(Color(hex: "8A8F98"))
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "1A2339"))
                    .cornerRadius(16)
                }
                
                // Statistics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    StatRow(label: "Ascent Rate", value: "\(Int(viewModel.ascentRate))m/day")
                    StatRow(label: "Current Zone", value: viewModel.currentZone.rawValue)
                    StatRow(label: "Oxygen Level", value: "\(Int(viewModel.oxygenPercentage))%")
                }
                .padding()
                .background(Color(hex: "1A2339"))
                .cornerRadius(16)
                
                // Control Button
                Button(action: {
                    if viewModel.isMonitoring {
                        viewModel.stopMonitoring()
                    } else {
                        viewModel.startMonitoring()
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                        Text(viewModel.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isMonitoring ? Color(hex: "FF4757") : Color(hex: "01A2FF"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Altitude Monitor")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatRow: View {
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

#Preview {
    NavigationView {
        AltitudeMonitorView()
    }
}

