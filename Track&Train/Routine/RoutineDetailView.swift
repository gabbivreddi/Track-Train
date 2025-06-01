//
//  RoutineDetailView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 6/1/25.
//
import SwiftUI

struct RoutineDetailView: View {
    let routine: Routine
    // To allow navigation to ExerciseDetailView from here
    @State private var selectedExerciseForDetail: Exercise? = nil


    var body: some View {
        List {
            // Section for Routine Name (Optional, as title might be enough)
            // Section(header: Text("Routine Name")) {
            //     Text(routine.name)
            //         .font(.title2)
            //         .fontWeight(.semibold)
            // }

            Section(header: Text("Exercises (\(routine.exercises.count))")) {
                if routine.exercises.isEmpty {
                    Text("This routine has no exercises.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(routine.exercises) { exercise in
                        // Make each exercise row tappable to show ExerciseDetailView
                        Button(action: {
                            self.selectedExerciseForDetail = exercise
                        }) {
                            HStack {
                                // Icon similar to ExercisesListView
                                if let imageName = exercise.imageName, !imageName.isEmpty {
                                    Image(systemName: imageName)
                                        .foregroundColor(.blue)
                                        .frame(width: 30, alignment: .center)
                                } else {
                                    Image(systemName: "figure.walk") // Default icon
                                        .foregroundColor(.gray)
                                        .frame(width: 30, alignment: .center)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(exercise.name)
                                        .font(.headline)
                                        .foregroundColor(Color(UIColor.label)) // Ensure text color is appropriate for list
                                    Text(exercise.category.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right") // Indicate tappable row
                                   .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(routine.name) // Set the routine name as the navigation title
        .listStyle(InsetGroupedListStyle()) // Use InsetGroupedListStyle for better visual separation
        // Sheet to present ExerciseDetailView when an exercise is tapped
        .sheet(item: $selectedExerciseForDetail) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
    }
}
