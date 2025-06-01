
import Foundation

// Represents the data logged for a single exercise during a completed routine session.
struct PerformedExerciseLog: Identifiable, Codable, Hashable {
    var id = UUID() // Unique ID for this specific log entry
    var exerciseID: UUID // ID of the Exercise performed
    var exerciseName: String // Name of the exercise (for easier display in history)
    var exerciseCategory: ExerciseCategory // Category of the exercise (for logic and display)

    // Metrics - store as optionals, use based on category
    var weight: Double?
    var reps: Int?
    var sets: Int? // Added sets
    var durationMinutes: Int?
    var distance: Double? // For cardio like running/cycling
    var notes: String?

    // Initializer
    init(id: UUID = UUID(),
         exerciseID: UUID,
         exerciseName: String,
         exerciseCategory: ExerciseCategory,
         weight: Double? = nil,
         reps: Int? = nil,
         sets: Int? = nil,
         durationMinutes: Int? = nil,
         distance: Double? = nil,
         notes: String? = nil) {
        self.id = id
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.exerciseCategory = exerciseCategory
        self.weight = weight
        self.reps = reps
        self.sets = sets
        self.durationMinutes = durationMinutes
        self.distance = distance
        self.notes = notes
    }
}
