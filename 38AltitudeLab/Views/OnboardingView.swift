//
//  OnboardingView.swift
//  38AltitudeLab
//
//  Created by Роман Главацкий on 29.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(hex: "090F1E")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        image: "mountain.2.fill",
                        title: "Altitude Monitoring",
                        description: "Track your altitude in real-time using advanced barometric sensors. Monitor your elevation with precision and accuracy.",
                        color: Color(hex: "01A2FF")
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        image: "heart.text.square.fill",
                        title: "Acclimatization Planning",
                        description: "Plan your high-altitude journey safely. Get personalized acclimatization schedules based on your fitness level and experience.",
                        color: Color(hex: "00FF88")
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        image: "shield.fill",
                        title: "Safety First",
                        description: "Monitor symptoms, track AMS risk, and get real-time safety recommendations. Your health is our priority.",
                        color: Color(hex: "FFD700")
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Section
                VStack(spacing: 20) {
                    // Page Indicators
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color(hex: "01A2FF") : Color(hex: "1A2339"))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 30)
                    
                    // Continue Button
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                        }
                    }) {
                        HStack {
                            Text(currentPage < 2 ? "Next" : "Get Started")
                                .font(.headline)
                            Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "01A2FF"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    // Skip Button
                    if currentPage < 2 {
                        Button(action: {
                            hasSeenOnboarding = true
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "8A8F98"))
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: image)
                .font(.system(size: 80))
                .foregroundColor(color)
                .padding(.bottom, 20)
            
            // Title
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // Description
            Text(description)
                .font(.system(size: 17))
                .foregroundColor(Color(hex: "8A8F98"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}

