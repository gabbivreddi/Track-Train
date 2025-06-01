// ExerciseCategory.swift
// Track&Train
//
// Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI

// Enum to represent the category of an exercise
// Added Codable conformance
enum ExerciseCategory: String, CaseIterable, Identifiable, Codable {
    case warmup = "Warm-up"
    case cardio = "Cardio"
    case strengthTraining = "Strength Training"
    case weightTraining = "Weight Training"
    case flexibility = "Flexibility"
    case cooldown = "Cooldown"
    case hiit = "HIIT" // Added HIIT
    case core = "Core" // Added Core

    var id: String { self.rawValue }
}
