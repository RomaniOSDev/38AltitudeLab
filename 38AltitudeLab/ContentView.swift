//
//  ContentView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                TabView(selection: $selectedTab) {
            MainDashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            AltitudeMonitorView()
                .tabItem {
                    Image(systemName: "mountain.2.fill")
                    Text("Altitude")
                }
                .tag(1)
            
            AcclimatizationPlannerView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Acclimatization")
                }
                .tag(2)
            
            SymptomTrackerView()
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("Symptoms")
                }
                .tag(3)
            
            HypoxicTrainingView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Training")
                }
                .tag(4)
            
            SafetyDashboardView()
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Safety")
                }
                .tag(5)
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(6)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            .tag(7)
        }
        .accentColor(Color(hex: "01A2FF"))
        .onAppear {
            // Configure tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "1A2339")
            appearance.shadowColor = .clear
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
            } else {
                OnboardingView()
            }
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
