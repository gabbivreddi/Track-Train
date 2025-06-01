//
//  CompletedLogDetailView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import SwiftUI

struct CompletedLogDetailView: View {
    let log: CompletedRoutineLog
    
    var body: some View {
        List {
            Section(header: Text("Session Summary")) {
                Text("Routine: \(log.routineName)")
                // Corrected Date Formatting:
                Text("Date: \(log.dateCompleted.formatted(date: .long, time: .omitted))")
                Text("Time: \(log.dateCompleted.formatted(date: .omitted, time: .shortened))")
                if let duration = log.totalDurationMinutes {
                    Text("Total Duration: \(duration) minutes")
                }
            }
            
            Section(header: Text("Logged Exercises (\(log.performedExercises.count))")) {
                if log.performedExercises.isEmpty {
                    Text("No specific exercises were logged for this session.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(log.performedExercises) { exerciseLog in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(exerciseLog.exerciseName)
                                .font(.headline)
                            Text("Category: \(exerciseLog.exerciseCategory.rawValue)")
                                .font(.caption).foregroundColor(.secondary)
                            
                            // Display logged metrics based on what's available
                            if let sets = exerciseLog.sets { Text("Sets: \(sets)") }
                            if let reps = exerciseLog.reps { Text("Reps: \(reps)") }
                            if let weight = exerciseLog.weight { Text("Weight: \(weight, specifier: "%.1f")") } // Format weight
                            if let duration = exerciseLog.durationMinutes { Text("Duration: \(duration) min") }
                            if let distance = exerciseLog.distance { Text("Distance: \(distance, specifier: "%.1f")") } // Format distance
                            if let notes = exerciseLog.notes, !notes.isEmpty {
                                Text("Notes:")
                                    .fontWeight(.medium)
                                Text(notes)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        // Corrected Date Formatting for Navigation Title:
        .navigationTitle("Log on \(log.dateCompleted.formatted(date: .abbreviated, time: .omitted))")
        .listStyle(InsetGroupedListStyle())
    }
}
