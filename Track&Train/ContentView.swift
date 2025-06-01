//
//  ContentView.swift
//  Track & Train
//
//  Created by Venkata reddy Gabbi on 5/10/25.
//

import SwiftUI
import SwiftData

import SwiftUI
// Removed SwiftData import as it's not directly used for routines here yet.
// If you plan to persist routines with SwiftData, you'll need to re-integrate it.

struct ContentView: View {
    // State to hold all exercises.
    @State private var exercises: [Exercise] = sampleExercises

    // State to hold all routines.
    @State private var routines: [Routine] = [] // Initialize with an empty array

    @State private var selectedTab: Tab = .home

    // State to control the presentation of sheets
    @State private var showingCreateRoutineSheet = false
    @State private var showingPickRoutineSheet = false

    // Enum to represent the different tabs
    enum Tab {
        case history, home, exercises, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Placeholder content for History tab
            Text("History Screen Content")
                .tag(Tab.history)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            // Home tab with routine management
            NavigationView { // Added NavigationView for Home tab for titles and buttons
                VStack(spacing: 20) {
                    Text("Manage Your Routines")
                        .font(.title2)
                        .padding(.top)

                    Button {
                        showingCreateRoutineSheet = true
                    } label: {
                        Text("Create New Routine")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Button {
                        showingPickRoutineSheet = true
                    } label: {
                        Text("Pick Existing Routine")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer() // Pushes buttons up
                }
                .navigationTitle("Home") // Title for the Home tab's NavigationView
            }
            .tag(Tab.home)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            // Sheet for creating a new routine
            .sheet(isPresented: $showingCreateRoutineSheet) {
                CreateRoutineView(routines: $routines, allExercises: exercises)
            }
            // Sheet for picking an existing routine
            // Note: The showingCreateRoutineSheet binding is passed to PickRoutineView
            // so it can trigger the CreateRoutineView from there.
            .sheet(isPresented: $showingPickRoutineSheet) {
                PickRoutineView(routines: $routines, showingCreateRoutineSheet: $showingCreateRoutineSheet)
            }


            // ExercisesListView for the exercises tab
            ExercisesListView(exercises: $exercises)
                .tag(Tab.exercises)
                .tabItem {
                    Label("Exercises", systemImage: "magnifyingglass")
                }

            // Placeholder content for Profile tab
            Text("Profile Screen Content")
                .tag(Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(.blue) // Customize the selected tab item color
        
        // You might want to load/save routines here, e.g., in .onAppear / .onChange
        // For now, routines are in-memory.
    }
}
