//
//  DataManager.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 6/1/25.
//

import Foundation

class DataManager {
    static let shared = DataManager() // Singleton instance
    private let routinesKey = "userRoutines" // Key for UserDefaults

    private init() {} // Private initializer for singleton

    // MARK: - Routines Persistence

    /// Loads routines from UserDefaults.
    /// - Returns: An array of Routine objects. Returns an empty array if no data is found or if decoding fails.
    func loadRoutines() -> [Routine] {
        guard let data = UserDefaults.standard.data(forKey: routinesKey) else {
            print("No routine data found in UserDefaults.")
            return []
        }

        do {
            let decoder = JSONDecoder()
            let routines = try decoder.decode([Routine].self, from: data)
            print("Successfully loaded \(routines.count) routines from UserDefaults.")
            return routines
        } catch {
            print("Error decoding routines from UserDefaults: \(error.localizedDescription)")
            return [] // Return empty array on error
        }
    }

    /// Saves an array of routines to UserDefaults.
    /// - Parameter routines: The array of Routine objects to save.
    func saveRoutines(_ routines: [Routine]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(routines)
            UserDefaults.standard.set(data, forKey: routinesKey)
            print("Successfully saved \(routines.count) routines to UserDefaults.")
        } catch {
            print("Error encoding routines for UserDefaults: \(error.localizedDescription)")
        }
    }
    
    // MARK: - (Optional) Exercises Persistence
    // If you also want to persist the main 'exercises' list (sampleExercises might change or be user-editable in future)
    // You can add similar load/save methods for [Exercise] here.
    // For now, we are assuming 'sampleExercises' is the static source for 'allExercises'
    // and only 'routines' (which contain copies of these exercises) are persisted.
}
