// RoutinesListView.swift
// Track&Train
//
// Created by [Your Name] on 5/31/25.
//

import SwiftUI

struct RoutinesListView: View {
    @Binding var routines: [Routine]
    @State private var showingCreateRoutineSheet = false
    
    // All available exercises, to be passed to CreateRoutineView
    let allExercises: [Exercise] = sampleExercises // Or from your data source

    var body: some View {
        NavigationView {
            List {
                if routines.isEmpty {
                    Text("No routines created yet. Tap the '+' button to add one.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(routines) { routine in
                        NavigationLink(destination: RoutineDetailView(routine: routine)) {
                            VStack(alignment: .leading) {
                                Text(routine.name)
                                    .font(.headline)
                                Text("\(routine.exercises.count) exercises")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteRoutine)
                }
            }
            .navigationTitle("My Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateRoutineSheet = true
                    } label: {
                        Label("Create Routine", systemImage: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !routines.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingCreateRoutineSheet) {
                CreateRoutineView(routines: $routines, allAvailableExercises: allExercises)
            }
        }
    }

    private func deleteRoutine(at offsets: IndexSet) {
        routines.remove(atOffsets: offsets)
    }
}

// Simple detail view for a routine
struct RoutineDetailView: View {
    let routine: Routine

    var body: some View {
        List {
            Section(header: Text("Exercises")) {
                if routine.exercises.isEmpty {
                    Text("This routine has no exercises.")
                } else {
                    ForEach(routine.exercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text(exercise.category.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle(routine.name)
    }
}
