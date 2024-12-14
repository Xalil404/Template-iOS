//
//  OnboardingView.swift
//  Template-iOS
//
//  Created by TEST on 12.12.2024.
//
import SwiftUI

struct OnboardingView: View {
    
    @State private var currentIndex = 0
    @State private var showWelcomeScreen = false // State variable for navigation
    
    // Detect the current color scheme (light or dark)
        @Environment(\.colorScheme) var colorScheme
    
    private let onboardingData = [
        OnboardingData(imageName: "one", title: "On boarding feature 1", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "two", title: "On boarding feature 2", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "three", title: "On boarding feature 3", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan.")
    ]

    var body: some View {
        NavigationStack { // Use NavigationStack instead of NavigationView
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPage(data: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Progress indicators
                
                Button(action: {
                    if currentIndex < onboardingData.count - 1 {
                        withAnimation {
                            currentIndex += 1
                        }
                    } else {
                        // Navigate to the welcome screen
                        showWelcomeScreen = true
                    }
                }) {
                    Text(currentIndex < onboardingData.count - 1 ? "N e x t" : "G e t  S t a r t e d")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 232/255, green: 191/255, blue: 115/255))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .padding(.top, 60)
                }
            }
            .padding(.bottom, 50)
            .background(Color(red: 248/255, green: 247/255, blue: 245/255)) // Set background color
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $showWelcomeScreen) { // Navigate to WelcomeView
                WelcomeView()
            }
        }
    }
}

struct OnboardingPage: View {
    let data: OnboardingData
    
    // Detect the current color scheme (light or dark)
        @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Image(data.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
            
            Text(data.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
            
            Text(data.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
        }
    }
}

struct OnboardingData {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
                .previewDisplayName("Light Mode")
                .environment(\.colorScheme, .light)
            OnboardingView()
                .previewDisplayName("Dark Mode")
                .environment(\.colorScheme, .dark)
        }
    }
}
