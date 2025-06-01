//
//  CompletedRoutineLog.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import Foundation

// Represents a single completed session of a routine.
struct CompletedRoutineLog: Identifiable, Codable, Hashable {
    var id = UUID() // Unique ID for this completed session
    var routineID: UUID // ID of the Routine that was completed
    var routineName: String // Name of the routine (for easier display in history)
    var dateCompleted: Date
    var performedExercises: [PerformedExerciseLog] // Array of exercises logged in this session
    var totalDurationMinutes: Int? // Optional: total workout duration

    // Initializer
    init(id: UUID = UUID(),
         routineID: UUID,
         routineName: String,
         dateCompleted: Date,
         performedExercises: [PerformedExerciseLog],
         totalDurationMinutes: Int? = nil) {
        self.id = id
        self.routineID = routineID
        self.routineName = routineName
        self.dateCompleted = dateCompleted
        self.performedExercises = performedExercises
        self.totalDurationMinutes = totalDurationMinutes
    }
}
