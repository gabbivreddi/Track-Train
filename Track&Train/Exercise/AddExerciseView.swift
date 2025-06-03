//
//  AddExerciseView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI
import SwiftData // Note: SwiftData is imported but not yet used in this specific file.

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var exercises: [Exercise] // Binding to update the exercises list directly

    // State for form fields
    @State private var name: String = ""
    @State private var category: ExerciseCategory = .cardio // Default category
    @State private var description: String = ""
    @State private var stepsString: String = "" // For TextEditor, will be split into [String]
    @State private var pairedExerciseName: String = ""
    @State private var imageName: String = "" // Optional SFSymbol name
    @State private var youtubeVideoId: String = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Details")) {
                    TextField("Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(ExerciseCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("Description", text: $description)
                }

                Section(header: Text("Steps to Perform (one step per line)")) {
                    TextEditor(text: $stepsString)
                        .frame(height: 150) // Adjust height as needed
                        .border(Color.gray.opacity(0.2), width: 1) // Optional border
                }

                Section(header: Text("Optional Details")) {
                    TextField("Paired Exercise Name (Optional)", text: $pairedExerciseName)
                        .frame(height: 150) // Adjust height as needed
                        .border(Color.gray.opacity(0.2), width: 1) // Optional border
                    TextField("SF Symbol Name for Icon (Optional)", text: $imageName)
                        .autocapitalization(.none)
                    TextField("YouTube Video ID (Optional)", text: $youtubeVideoId)
                        .autocapitalization(.none)
                }

                Button("Add Exercise") {
                    saveExercise()
                }
            }
            .navigationTitle("Add New Exercise")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveExercise() {
        // Basic validation
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Exercise name cannot be empty."
            showingAlert = true
            return
        }
        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Description cannot be empty."
            showingAlert = true
            return
        }
        guard !stepsString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Steps cannot be empty. Please provide at least one step."
            showingAlert = true
            return
        }

        let stepsArray = stepsString.split(separator: "\n").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }.filter { !$0.isEmpty }
        
        if stepsArray.isEmpty {
            alertMessage = "Steps cannot be empty after processing. Ensure each step is on a new line."
            showingAlert = true
            return
        }
        
        let pairedExerciseArray = pairedExerciseName.split(separator: "\n").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }.filter { !$0.isEmpty }
    

        let newExercise = Exercise(
            name: name,
            category: category,
            description: description,
            steps: stepsArray,
            pairedExerciseName: pairedExerciseArray.isEmpty ? [] : pairedExerciseArray,
            imageName: imageName.isEmpty ? nil : imageName,
            youtubeVideoId: youtubeVideoId.isEmpty ? nil : youtubeVideoId
        )



        exercises.append(newExercise)
        presentationMode.wrappedValue.dismiss() // Dismiss the sheet
    }
}
