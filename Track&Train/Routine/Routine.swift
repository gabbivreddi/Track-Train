//
//  Routine.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 6/1/25.
//

import SwiftUI

// Struct to represent a workout routine
struct Routine: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var exercises: [Exercise] // Array of Exercise objects

    // Initialize a new routine
    init(id: UUID = UUID(), name: String, exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Conformance to Equatable (required by Hashable)
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        lhs.id == rhs.id
    }
}
