// SelectExercisesView.swift
// Track&Train
//
// Created by [Your Name] on 5/31/25.
//

import SwiftUI

struct SelectExercisesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // The complete list of available exercises to pick from
    let allExercises: [Exercise]
    
    // Binding to the array of exercises currently selected for the routine being created
    @Binding var exercisesForRoutine: [Exercise]
    
    // To keep track of selections within this view
    @State private var temporarySelectedExercises: Set<Exercise>

    // Initialize with currently selected exercises to pre-populate the selection state
    init(allExercises: [Exercise], exercisesForRoutine: Binding<[Exercise]>) {
        self.allExercises = allExercises
        self._exercisesForRoutine = exercisesForRoutine
        // Initialize temporarySelectedExercises with exercises already in the routine
        _temporarySelectedExercises = State(initialValue: Set(exercisesForRoutine.wrappedValue))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(allExercises) { exercise in
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        if temporarySelectedExercises.contains(exercise) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle()) // Make the whole row tappable
                    .onTapGesture {
                        toggleSelection(for: exercise)
                    }
                }
            }
            .navigationTitle("Select Exercises")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    // Update the binding with the selections made in this view
                    exercisesForRoutine = Array(temporarySelectedExercises).sorted(by: { $0.name < $1.name })
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    // Toggles the selection state for a given exercise
    private func toggleSelection(for exercise: Exercise) {
        if temporarySelectedExercises.contains(exercise) {
            temporarySelectedExercises.remove(exercise)
        } else {
            temporarySelectedExercises.insert(exercise)
        }
    }
}
