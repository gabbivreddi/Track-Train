//
//  HomeView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var routines: [Routine] = []
    @State private var completedRoutineLogs: [CompletedRoutineLog] = [] // For workout history
    
    @State private var showingCreateRoutineSheet = false
    let allExercises: [Exercise] = sampleExercises // Assuming sampleExercises is globally available or passed in

    // For navigation to ActiveRoutineView
    @State private var selectedRoutineForActivity: Routine? = nil
    @State private var showingActiveRoutineView = false
    
    // For navigation to HistoryView
    @State private var showingHistoryView = false
    
    // Alert for trying to start an empty routine
    @State private var showingEmptyRoutineAlert = false


    var body: some View {
        NavigationView {
            List {
                // Section for creating routines
                Section {
                    Button {
                        showingCreateRoutineSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("Create New Routine")
                        }
                    }
                }

                // Section for existing routines
                Section(header: Text("My Routines (\(routines.count))").font(.headline)) {
                    if routines.isEmpty {
                        Text("No routines created yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(routines) { routine in
                            NavigationLink(destination: RoutineDetailViewEmbedded(
                                routine: routine,
                                startAction: {
                                    // Call the HomeView method to attempt starting the routine
                                    self.attemptToStartRoutine(routine)
                                }
                            )) {
                                VStack(alignment: .leading) {
                                    Text(routine.name)
                                        .font(.headline)
                                    Text("\(routine.exercises.count) exercises")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteRoutine)
                    }
                }
                
                // Section for Workout History
                Section(header: Text("Workout History").font(.headline)) {
                     Button {
                        showingHistoryView = true
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                            Text("View Workout History (\(completedRoutineLogs.count))")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Track & Train")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Show EditButton only if there's content to edit
                    if !routines.isEmpty || !completedRoutineLogs.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingCreateRoutineSheet) {
                CreateRoutineView( // Assuming CreateRoutineView is defined elsewhere
                    routines: $routines,
                    allAvailableExercises: allExercises
                )
            }
            .sheet(isPresented: $showingHistoryView) {
                 WorkoutHistoryView(completedLogs: $completedRoutineLogs) // Assuming WorkoutHistoryView is defined
            }
            // Alert for empty routine, attached to a view within NavigationView
            .alert("Empty Routine", isPresented: $showingEmptyRoutineAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("This routine has no exercises. Please add exercises to the routine before starting it.")
            }
        } // End of NavigationView
        .fullScreenCover(isPresented: $showingActiveRoutineView) {
            if let routineToActivate = selectedRoutineForActivity {
                ActiveRoutineView( // This is the view from your selection
                    routine: routineToActivate,
                    allCompletedLogs: $completedRoutineLogs,
                    routines: $routines
                )
            }
        }
        .onAppear {
            loadRoutines()
            loadCompletedRoutineLogs()
        }
        // Updated onChange syntax for iOS 17+
        .onChange(of: routines) {
            saveRoutines()
        }
        .onChange(of: completedRoutineLogs) {
            saveCompletedRoutineLogs()
        }
    }

    // Method to attempt starting a routine, with a check for empty exercises
    private func attemptToStartRoutine(_ routine: Routine) {
        guard !routine.exercises.isEmpty else {
            showingEmptyRoutineAlert = true // Trigger the alert
            return
        }
        selectedRoutineForActivity = routine
        showingActiveRoutineView = true
    }

    // MARK: - Routines Persistence
    private func getRoutinesFileURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("routinesData.json")
    }

    private func loadRoutines() {
        let fileURL = getRoutinesFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                let decodedRoutines = try JSONDecoder().decode([Routine].self, from: data)
                self.routines = decodedRoutines.sorted(by: { $0.name < $1.name })
            } catch {
                print("Failed to load routines: \(error.localizedDescription)")
                self.routines = [] // Initialize to empty if loading fails
            }
        } else {
            self.routines = [] // Initialize to empty if file doesn't exist
        }
    }

    private func saveRoutines() {
        let fileURL = getRoutinesFileURL()
        do {
            let data = try JSONEncoder().encode(routines)
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Failed to save routines: \(error.localizedDescription)")
        }
    }
    
    private func deleteRoutine(at offsets: IndexSet) {
        routines.remove(atOffsets: offsets)
        // Note: Associated history for the deleted routine will remain.
        // You might want to add logic to optionally delete related history logs.
    }

    // MARK: - CompletedRoutineLogs (History) Persistence
    private func getCompletedLogsFileURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("completedRoutineLogs.json")
    }

    private func loadCompletedRoutineLogs() {
        let fileURL = getCompletedLogsFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                let decodedLogs = try JSONDecoder().decode([CompletedRoutineLog].self, from: data)
                // Sort by most recent first
                self.completedRoutineLogs = decodedLogs.sorted(by: { $0.dateCompleted > $1.dateCompleted })
            } catch {
                print("Failed to load completed logs: \(error.localizedDescription)")
                self.completedRoutineLogs = [] // Initialize to empty if loading fails
            }
        } else {
            self.completedRoutineLogs = [] // Initialize to empty if file doesn't exist
        }
    }

    private func saveCompletedRoutineLogs() {
        let fileURL = getCompletedLogsFileURL()
        do {
            let data = try JSONEncoder().encode(completedRoutineLogs)
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Failed to save completed logs: \(error.localizedDescription)")
        }
    }
}
