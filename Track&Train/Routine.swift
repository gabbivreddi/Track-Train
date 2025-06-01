//
//  Routine.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

// Routine.swift
// Track&Train
//
// Created by [Your Name] on 5/31/25.
//

import SwiftUI

struct Routine: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var exercises: [Exercise] // Exercise struct must also be Codable and Hashable

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(exercises)
    }

    // Conformance to Equatable (required by Hashable)
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.exercises == rhs.exercises
    }
}
