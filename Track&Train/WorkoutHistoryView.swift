//
//  WorkoutHistoryView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import SwiftUI


struct WorkoutHistoryView: View {
    @Binding var completedLogs: [CompletedRoutineLog]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                if completedLogs.isEmpty {
                    Text("No workouts completed yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(completedLogs) { log in
                        NavigationLink(destination: CompletedLogDetailView(log: log)) {
                            VStack(alignment: .leading) {
                                Text(log.routineName)
                                    .font(.headline)
                                Text("Completed: \(log.dateCompleted.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.subheadline)
                                Text("\(log.performedExercises.count) exercises logged")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                if let duration = log.totalDurationMinutes {
                                    Text("Total Duration: \(duration) min")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteLog)
                }
            }
            .navigationTitle("Workout History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !completedLogs.isEmpty {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func deleteLog(at offsets: IndexSet) {
        completedLogs.remove(atOffsets: offsets)
        // The .onChange modifier in HomeView will handle saving the updated completedLogs
    }
}
