//
//  MainTabView.swift
//  Template-iOS
//
//  Created by TEST on 12.12.2024.
//
import SwiftUI

struct MainTabView: View {
    
    init() {
            // Customize the appearance of the Tab Bar
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemGray6 // Light gray background color
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    var body: some View {
            TabView {
                // Placeholder for BirthdayListView
                TicketListView()
                    .tabItem {
                        Label("Tickets", systemImage: "gift")
                    }
                
                // Placeholder for AnniversaryListView
                Text("Feature Two View Placeholder")
                    .tabItem {
                        Label("Feature 2", systemImage: "heart")
                    }
                
                // Placeholder for HolidayListView
                Text("Feature Three View Placeholder")
                    .tabItem {
                        Label("Feature 3", systemImage: "calendar")
                    }

                // Placeholder for ProfileView
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        }
    }
    /*
    var body: some View {
        TabView {
            BirthdayListView()
                .tabItem {
                    Label("Birthdays", systemImage: "gift")
                }
            
            AnniversaryListView()
                .tabItem {
                    Label("Anniversaries", systemImage: "heart")
                }
            
            HolidayListView()
                .tabItem {
                    Label("Holidays", systemImage: "calendar")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
     */

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
