//
//  CreateRoutineView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 6/1/25.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var routines: [Routine] // Binding to the list of routines in ContentView
    let allExercises: [Exercise] // All available exercises to choose from

    @State private var routineName: String = ""
    @State private var selectedExerciseIDs: Set<UUID> = Set<UUID>() // Store IDs of selected exercises
    
    // States for search and filter, similar to ExercisesListView
    @State private var searchTerm: String = ""
    @State private var selectedCategory: ExerciseCategory? = nil
    let categories = ExerciseCategory.allCases
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    // Computed property to filter and sort exercises based on search and category
    var filteredAndSortedExercises: [Exercise] {
        var activelyFiltered = allExercises
        
        if let category = selectedCategory {
            activelyFiltered = activelyFiltered.filter { $0.category == category }
        }

        if !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            activelyFiltered = activelyFiltered.filter {
                $0.name.localizedCaseInsensitiveContains(searchTerm) ||
                $0.description.localizedCaseInsensitiveContains(searchTerm) // Optional: include description in search
            }
        }
        return activelyFiltered.sorted { $0.name < $1.name } // Keep the list sorted by name
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) { // Use VStack for more control
                // Routine Name Input
                Text("Routine Name")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                TextField("Enter routine name", text: $routineName)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom)

                // Search Bar
                TextField("Search exercises...", text: $searchTerm)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                // Category Picker
                Picker("Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as ExerciseCategory?)
                    ForEach(categories) { category in
                        Text(category.rawValue).tag(category as ExerciseCategory?)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                HStack {
                    Text("Select Exercises")
                        .font(.headline)
                    Spacer()
                    Text("\(selectedExerciseIDs.count) selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)


                // List of Exercises
                List {
                    ForEach(filteredAndSortedExercises) { exercise in
                        HStack {
                            // Icon similar to ExercisesListView
                            if let imageName = exercise.imageName, !imageName.isEmpty {
                                Image(systemName: imageName)
                                    .foregroundColor(.blue)
                                    .frame(width: 30, alignment: .center)
                            } else {
                                Image(systemName: "figure.walk") // Default icon
                                    .foregroundColor(.gray)
                                    .frame(width: 30, alignment: .center)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(exercise.name)
                                    .font(.headline)
                                Text(exercise.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if selectedExerciseIDs.contains(exercise.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray) // Use gray for unselected
                            }
                        }
                        .contentShape(Rectangle()) // Make the whole row tappable
                        .onTapGesture {
                            toggleSelection(for: exercise.id)
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Use PlainListStyle for a cleaner look
            }
            .navigationTitle("Create New Routine")
            .navigationBarTitleDisplayMode(.inline) // Keep title inline
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Routine") {
                        saveRoutine()
                    }
                    .disabled(routineName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedExerciseIDs.isEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Toggles the selection state for a given exercise ID
    private func toggleSelection(for exerciseID: UUID) {
        if selectedExerciseIDs.contains(exerciseID) {
            selectedExerciseIDs.remove(exerciseID)
        } else {
            selectedExerciseIDs.insert(exerciseID)
        }
    }

    // Saves the new routine
    private func saveRoutine() {
        let trimmedName = routineName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            alertTitle = "Missing Name"
            alertMessage = "Please enter a name for the routine."
            showingAlert = true
            return
        }
        
        guard !selectedExerciseIDs.isEmpty else {
            alertTitle = "No Exercises"
            alertMessage = "Please select at least one exercise for the routine."
            showingAlert = true
            return
        }

        // Get the actual Exercise objects based on selected IDs
        // Important: Maintain the order of selection if needed, or sort them.
        // Here, we fetch them and they will be in the order they appear in `allExercises`
        // if not sorted further. If you want them sorted by name in the routine:
        let chosenExercises = allExercises
            .filter { selectedExerciseIDs.contains($0.id) }
            .sorted { ex1, ex2 in // Optional: sort selected exercises by name for consistency in the routine
                // If you want to preserve selection order, you'd need a different mechanism
                // (e.g., an array of selected IDs in order)
                if let index1 = filteredAndSortedExercises.firstIndex(where: { $0.id == ex1.id }),
                   let index2 = filteredAndSortedExercises.firstIndex(where: { $0.id == ex2.id }) {
                    return index1 < index2 // This would sort by current display order
                }
                return ex1.name < ex2.name // Fallback to name sort
            }


        let newRoutine = Routine(name: trimmedName, exercises: chosenExercises)
        routines.append(newRoutine)
        presentationMode.wrappedValue.dismiss()
    }
}
