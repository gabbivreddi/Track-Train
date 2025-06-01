//
//  ContentView.swift
//  Track & Train
//
//  Created by Venkata reddy Gabbi on 5/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    // State to hold all exercises, potentially loaded from CoreData or elsewhere in a real app.
    // For now, using the sampleExercises global constant.
    @State private var exercises: [Exercise] = sampleExercises
    
    // State to hold all created routines.
    // In a real app, you'd persist this data (e.g., using CoreData or UserDefaults with Codable).
    @State private var routines: [Routine] = [] // Start with an empty list of routines

    @State private var selectedTab: Tab = .home

        // Enum to represent the different tabs
        enum Tab {
            case history, home, exercises, profile
        }

        var body: some View {
            // ZStack to allow overlaying views
            ZStack(alignment: .bottomLeading) {
                // TabView for the main navigation
                TabView(selection: $selectedTab) {
                    // Placeholder content for each tab
                    // You would replace these Text views with your actual screen content
                    Text("History Screen Content")
                        .tag(Tab.history)
                        .tabItem {
                            Label("History", systemImage: "clock.arrow.circlepath")
                        }

                    // HomeView will now be displayed for the home tab
                    HomeView()
                        .tag(Tab.home)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }

                    // ExercisesListView is now used for the exercises tab
                    ExercisesListView(exercises: $exercises) // Pass the binding if ExercisesListView modifies it
                        .tag(Tab.exercises)
                        .tabItem {
                            Label("Exercises", systemImage: "magnifyingglass")
                        }

                    Text("Profile Screen Content")
                        .tag(Tab.profile)
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                }
                .accentColor(.blue) // You can customize the selected tab item color

            }
        }
}
