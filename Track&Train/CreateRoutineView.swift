// CreateRoutineView.swift
// Track&Train
//
// Created by [Your Name] on 5/31/25.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Binding to the main list of routines in your app
    @Binding var routines: [Routine]
    
    // All available exercises to pick from (e.g., sampleExercises)
    let allAvailableExercises: [Exercise]

    // State for the new routine's details
    @State private var routineName: String = ""
    @State private var exercisesInCurrentRoutine: [Exercise] = []
    
    // State to control the presentation of the exercise selection sheet
    @State private var showingSelectExercisesSheet = false
    
    // State for alert
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                // Section for Routine Name
                Section(header: Text("Routine Name")) {
                    TextField("Enter routine name", text: $routineName)
                }

                // Section for Exercises in this Routine
                Section(header: Text("Exercises in this Routine (\(exercisesInCurrentRoutine.count))")) {
                    if exercisesInCurrentRoutine.isEmpty {
                        Text("No exercises added yet. Tap 'Add Exercise' below.")
                            .foregroundColor(.gray)
                    } else {
                        List {
                            ForEach(exercisesInCurrentRoutine) { exercise in
                                Text(exercise.name)
                            }
                            .onDelete(perform: removeExercise)
                        }
                    }
                    Button {
                        showingSelectExercisesSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Exercise to Routine")
                        }
                    }
                }

                // Section for Save Button
                Section {
                    Button("Save Routine") {
                        saveRoutine()
                    }
                    .disabled(routineName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || exercisesInCurrentRoutine.isEmpty)
                }
            }
            .navigationTitle("Create New Routine")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingSelectExercisesSheet) {
                // Present the SelectExercisesView to pick exercises
                SelectExercisesView(
                    allExercises: allAvailableExercises,
                    exercisesForRoutine: $exercisesInCurrentRoutine
                )
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Cannot Save Routine"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Removes an exercise from the current routine's list
    private func removeExercise(at offsets: IndexSet) {
        exercisesInCurrentRoutine.remove(atOffsets: offsets)
    }

    // Saves the new routine
    private func saveRoutine() {
        let trimmedName = routineName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            alertMessage = "Routine name cannot be empty."
            showingAlert = true
            return
        }
        guard !exercisesInCurrentRoutine.isEmpty else {
            alertMessage = "A routine must have at least one exercise."
            showingAlert = true
            return
        }

        let newRoutine = Routine(name: trimmedName, exercises: exercisesInCurrentRoutine)
        routines.append(newRoutine) // Add to the main list
        routines.sort { $0.name < $1.name } // Optional: keep the list sorted
        presentationMode.wrappedValue.dismiss() // Close the creation view
    }
}
