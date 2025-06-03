//
//  ExerciseDetailView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI
import SwiftData // Note: SwiftData is imported but not yet used in this specific file.

// View to display the details of a single exercise

struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Exercise Name
                    Text(exercise.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    // Category
                    Text("Category: \(exercise.category.rawValue)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // YouTube Video Player
                    if let videoId = exercise.youtubeVideoId, !videoId.isEmpty {
                        Text("Instructional Video")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top)
                        YouTubePlayerView(videoID: videoId)
                            .frame(height: 250) // Adjust height as needed
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                    }


                    // Description
                    Text("Description")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    Text(exercise.description)
                        .font(.body)

                    // Steps
                    Text("Steps to Perform")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    ForEach(exercise.steps.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.medium)
                            Text(exercise.steps[index])
                        }
                        .padding(.bottom, 2)
                    }

                    // Paired Exercise
                    if !exercise.pairedExerciseName.isEmpty { // Check if the array is not empty
                        Text("Pairs well with:")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top)

                        ForEach(exercise.pairedExerciseName, id: \.self) { name in
                            Text(name)
                                .font(.body)
                        }
                    }
                    
                    Spacer() // Pushes content up if it's short
                }
                .padding()
            }
            .navigationTitle("Exercise Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
