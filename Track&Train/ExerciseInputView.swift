//
//  ExerciseInputView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import SwiftUI

struct ExerciseInputView: View {
    let exercise: Exercise // The current exercise to log
    @Binding var loggedData: PerformedExerciseLog // Binding to the data being logged for this exercise
    let lastLog: PerformedExerciseLog? // Last logged data for this exercise in this routine

    // Local state for text fields to ensure they are strings
    @State private var weightString: String
    @State private var repsString: String
    @State private var setsString: String
    @State private var durationString: String
    @State private var distanceString: String
    @State private var notesString: String
    
    @State private var isCompleted: Bool = false // For non-metric exercises

    init(exercise: Exercise, loggedData: Binding<PerformedExerciseLog>, lastLog: PerformedExerciseLog?) {
        self.exercise = exercise
        self._loggedData = loggedData
        self.lastLog = lastLog

        // Initialize string states from the binding or last log
        _weightString = State(initialValue: loggedData.wrappedValue.weight.map { String($0) } ?? "")
        _repsString = State(initialValue: loggedData.wrappedValue.reps.map { String($0) } ?? "")
        _setsString = State(initialValue: loggedData.wrappedValue.sets.map { String($0) } ?? "")
        _durationString = State(initialValue: loggedData.wrappedValue.durationMinutes.map { String($0) } ?? "")
        _distanceString = State(initialValue: loggedData.wrappedValue.distance.map { String($0) } ?? "")
        _notesString = State(initialValue: loggedData.wrappedValue.notes ?? "")
        
        // If it's a simple "mark as complete" type and notes are already there, consider it completed.
        if loggedData.wrappedValue.notes != nil && !isWeightOrCardio(category: exercise.category) {
            _isCompleted = State(initialValue: true)
        }
    }
    
    private func isWeightOrCardio(category: ExerciseCategory) -> Bool {
        switch category {
        case .strengthTraining, .weightTraining, .cardio, .hiit:
            return true
        default:
            return false
        }
    }

    var body: some View {
        Form {
            Section(header: Text(exercise.name).font(.title2)) {
                Text("Category: \(exercise.category.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if !exercise.description.isEmpty {
                    DisclosureGroup("Description & Steps") {
                        Text(exercise.description)
                            .font(.body)
                            .padding(.bottom, 5)
                        Text("Steps:")
                            .fontWeight(.semibold)
                        ForEach(exercise.steps.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                Text("\(index + 1).")
                                Text(exercise.steps[index])
                            }
                        }
                    }
                    .padding(.bottom)
                }


                // Input fields based on category
                switch exercise.category {
                case .strengthTraining, .weightTraining:
                    lastPerformedWeightSetSection
                    
                    TextField("Sets", text: $setsString)
                        .keyboardType(.numberPad)
                        .onChange(of: setsString) { newValue in
                            loggedData.sets = Int(newValue)
                        }
                    TextField("Reps per set", text: $repsString)
                        .keyboardType(.numberPad)
                        .onChange(of: repsString) { newValue in
                            loggedData.reps = Int(newValue)
                        }
                    TextField("Weight (e.g., kg/lbs)", text: $weightString)
                        .keyboardType(.decimalPad)
                        .onChange(of: weightString) { newValue in
                            loggedData.weight = Double(newValue)
                        }
                    
                case .cardio, .hiit:
                    lastPerformedCardioSection
                    
                    TextField("Duration (minutes)", text: $durationString)
                        .keyboardType(.numberPad)
                        .onChange(of: durationString) { newValue in
                            loggedData.durationMinutes = Int(newValue)
                        }
                    TextField("Distance (e.g., km/miles)", text: $distanceString)
                        .keyboardType(.decimalPad)
                        .onChange(of: distanceString) { newValue in
                            loggedData.distance = Double(newValue)
                        }
                    
                case .warmup, .cooldown, .flexibility, .core:
                    Toggle(isOn: $isCompleted) {
                        Text("Mark as Completed")
                    }
                    .onChange(of: isCompleted) { completed in
                        if completed {
                            // When marked complete, we can set a default note or ensure notes field is active
                            if loggedData.notes == nil || loggedData.notes!.isEmpty {
                                 loggedData.notes = "Completed" // Default note
                            }
                        } else {
                            // Optionally clear notes if unmarked, or handle as needed
                            if loggedData.notes == "Completed" {
                                loggedData.notes = nil
                            }
                        }
                    }
                    if isCompleted || !notesString.isEmpty { // Show notes if completed or notes exist
                         TextEditor(text: $notesString)
                            .frame(height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .onChange(of: notesString) { newValue in
                                loggedData.notes = newValue.isEmpty && isCompleted && loggedData.notes == "Completed" ? "Completed" : (newValue.isEmpty && !isCompleted ? nil : newValue)
                            }
                    }
                }
                
                // Common notes field for all, unless it's a simple "mark as complete" type
                if exercise.category == .strengthTraining || exercise.category == .weightTraining || exercise.category == .cardio || exercise.category == .hiit {
                    Section(header: Text("Notes (Optional)")) {
                        TextEditor(text: $notesString)
                            .frame(height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .onChange(of: notesString) { newValue in
                                loggedData.notes = newValue.isEmpty ? nil : newValue
                            }
                        if let lastNotes = lastLog?.notes, !lastNotes.isEmpty {
                             Text("Last time: \(lastNotes)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Ensure the bound object reflects the initial state strings
            // This is important if the binding is reused for different exercises
            // or if initial values are critical.
            loggedData.weight = Double(weightString)
            loggedData.reps = Int(repsString)
            loggedData.sets = Int(setsString)
            loggedData.durationMinutes = Int(durationString)
            loggedData.distance = Double(distanceString)
            if exercise.category != .strengthTraining && exercise.category != .weightTraining && exercise.category != .cardio && exercise.category != .hiit {
                 loggedData.notes = notesString.isEmpty && isCompleted ? "Completed" : (notesString.isEmpty && !isCompleted ? nil : notesString)
            } else {
                 loggedData.notes = notesString.isEmpty ? nil : notesString
            }
        }
    }

    @ViewBuilder
    private var lastPerformedWeightSetSection: some View {
        if let last = lastLog, last.weight != nil || last.reps != nil || last.sets != nil {
            Section(header: Text("Last Performed")) {
                if let sets = last.sets { Text("Sets: \(sets)") }
                if let reps = last.reps { Text("Reps: \(reps)") }
                if let weight = last.weight { Text("Weight: \(weight, specifier: "%.1f")") }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private var lastPerformedCardioSection: some View {
        if let last = lastLog, last.durationMinutes != nil || last.distance != nil {
            Section(header: Text("Last Performed")) {
                if let duration = last.durationMinutes { Text("Duration: \(duration) min") }
                if let distance = last.distance { Text("Distance: \(distance, specifier: "%.1f")") }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
    }
}
