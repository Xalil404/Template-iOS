//
//  SplashScreen.swift
//  Template-iOS
//
//  Created by TEST on 12.12.2024.
//
import SwiftUI

struct SplashScreen: View {
    // Detect the current color scheme (light or dark)
        @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            // Main splash image at the top
            Image("one")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)

            // HStack for logo and text side by side
            HStack(spacing: 10) { // Adjust spacing as needed
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("Welcome to Project")
                    .font(.title)
                    .fontWeight(.bold) // Optional styling
                    .foregroundColor(colorScheme == .dark ? .black : .black) // Adjust text color
            }
            .padding(.top, 40) // Padding to adjust the position

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the VStack fills the available space
        .background(Color(red: 248/255, green: 247/255, blue: 245/255))
        .edgesIgnoringSafeArea(.all) // Extend the background to the edges of the screen
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Navigate to the first onboarding screen
            }
        }
    }
}


struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreen()
                .previewDisplayName("Light Mode")
                .environment(\.colorScheme, .light)
            SplashScreen()
                .previewDisplayName("Dark Mode")
                .environment(\.colorScheme, .dark)
        }
    }
}
