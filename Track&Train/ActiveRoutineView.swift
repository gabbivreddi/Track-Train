//
//  ActiveRoutineView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import SwiftUI

struct ActiveRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    let routine: Routine
    
    // All completed logs to find the last performance of exercises
    @Binding var allCompletedLogs: [CompletedRoutineLog]
    // Binding to add the newly completed log to HomeView's state
    @Binding var routines: [Routine] // To potentially update routine details if needed in future
                                     // Not directly modified now but good to have if routine structure changes

    @State private var currentExerciseIndex: Int = 0
    @State private var performedExerciseLogs: [PerformedExerciseLog]
    @State private var startTime: Date = Date()

    init(routine: Routine, allCompletedLogs: Binding<[CompletedRoutineLog]>, routines: Binding<[Routine]>) {
        self.routine = routine
        self._allCompletedLogs = allCompletedLogs
        self._routines = routines
        
        // Initialize performedExerciseLogs with placeholders for each exercise in the routine
        _performedExerciseLogs = State(initialValue: routine.exercises.map { exercise in
            PerformedExerciseLog(exerciseID: exercise.id, exerciseName: exercise.name, exerciseCategory: exercise.category)
        })
    }

    var currentExercise: Exercise {
        routine.exercises[currentExerciseIndex]
    }
    
    var currentLoggedDataBinding: Binding<PerformedExerciseLog> {
        $performedExerciseLogs[currentExerciseIndex]
    }

    // Find the last log for the current exercise within this specific routine
    func findLastLogForCurrentExercise() -> PerformedExerciseLog? {
        let relevantLogs = allCompletedLogs
            .filter { $0.routineID == routine.id } // Logs for this specific routine
            .sorted { $0.dateCompleted > $1.dateCompleted } // Most recent first

        for log in relevantLogs {
            if let exerciseLog = log.performedExercises.first(where: { $0.exerciseID == currentExercise.id }) {
                return exerciseLog // Found the last performance of this exercise in this routine
            }
        }
        return nil // No previous log found for this exercise in this routine
    }

    var body: some View {
        NavigationView {
            VStack {
                // Progress Indicator (Optional)
                Text("Exercise \(currentExerciseIndex + 1) of \(routine.exercises.count)")
                    .font(.headline)
                    .padding(.top)
                
                // Pass the current exercise, a binding to its log data, and its last performance
                ExerciseInputView(
                    exercise: currentExercise,
                    loggedData: currentLoggedDataBinding,
                    lastLog: findLastLogForCurrentExercise()
                )
                .id(currentExercise.id) // Ensures view redraws when exercise changes

                Spacer()

                HStack {
                    Button("Previous") {
                        if currentExerciseIndex > 0 {
                            currentExerciseIndex -= 1
                        }
                    }
                    .padding()
                    .disabled(currentExerciseIndex == 0)

                    Spacer()

                    Button(currentExerciseIndex == routine.exercises.count - 1 ? "Finish Routine" : "Next Exercise") {
                        if currentExerciseIndex < routine.exercises.count - 1 {
                            currentExerciseIndex += 1
                        } else {
                            finishRoutine()
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle(routine.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel Workout") {
                        // Add confirmation dialog here
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }

    func finishRoutine() {
        let endTime = Date()
        let totalDuration = Int(endTime.timeIntervalSince(startTime) / 60) // Duration in minutes
        
        // Filter out any logs that weren't touched (e.g. if user skipped an exercise and didn't mark complete)
        // Or, ensure all have some default "skipped" state if necessary.
        // For now, we assume all entries in performedExerciseLogs are intended to be saved.
        // A more robust solution might check if any data was entered or if it was marked complete.
        let finalLogs = performedExerciseLogs.filter { log in
            // Only include if some data was logged or it's a non-metric type that was marked completed
            return log.weight != nil || log.reps != nil || log.sets != nil || log.durationMinutes != nil || log.distance != nil || (log.notes != nil && !log.notes!.isEmpty)
        }


        let newCompletedLog = CompletedRoutineLog(
            routineID: routine.id,
            routineName: routine.name,
            dateCompleted: Date(),
            performedExercises: finalLogs, // Use the potentially filtered logs
            totalDurationMinutes: totalDuration
        )
        
        allCompletedLogs.append(newCompletedLog)
        allCompletedLogs.sort { $0.dateCompleted > $1.dateCompleted } // Keep history sorted

        presentationMode.wrappedValue.dismiss()
    }
}
