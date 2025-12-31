//
//  SettingsView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        List {
            Section {
                SettingsRow(
                    icon: "star.fill",
                    iconColor: Color(hex: "FFD700"),
                    title: "Rate Us",
                    action: {
                        rateApp()
                    }
                )
            }
            .listRowBackground(Color(hex: "1A2339"))
            
            Section {
                SettingsRow(
                    icon: "lock.shield.fill",
                    iconColor: Color(hex: "01A2FF"),
                    title: "Privacy Policy",
                    action: {
                        openURL("https://www.termsfeed.com/live/43b4be87-c64a-4574-92c8-0a1bd2faf988")
                    }
                )
                
                SettingsRow(
                    icon: "doc.text.fill",
                    iconColor: Color(hex: "00FFFF"),
                    title: "Terms of Service",
                    action: {
                        openURL("https://www.termsfeed.com/live/625a2bbe-7a7e-44f4-a8bc-b862a23301da")
                    }
                )
            } header: {
                Text("Legal")
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            .listRowBackground(Color(hex: "1A2339"))
            
            Section {
                HStack {
                    Text("Version")
                        .foregroundColor(.white)
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(Color(hex: "8A8F98"))
                }
            } header: {
                Text("About")
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            .listRowBackground(Color(hex: "1A2339"))
            
            Section {
                Button(action: {
                    hasSeenOnboarding = false
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color(hex: "01A2FF"))
                        Text("Show Onboarding Again")
                            .foregroundColor(Color(hex: "01A2FF"))
                    }
                }
            }
            .listRowBackground(Color(hex: "1A2339"))
        }
        .scrollContentBackground(.hidden)
        .background(Color(hex: "090F1E").ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version) (\(build))"
        }
        return "1.0.0"
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "8A8F98"))
                    .font(.caption)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

