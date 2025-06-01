//
//  RoutineDetailViewEmbedded.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/31/25.
//

import SwiftUI

struct RoutineDetailViewEmbedded: View {
    let routine: Routine
    var startAction: () -> Void // Action to trigger starting the routine

    var body: some View {
        List {
            Section {
                Button(action: startAction) { // This action is provided by HomeView
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.green)
                        Text("Start This Routine")
                            .font(.headline)
                    }
                }
                .padding(.vertical, 5)
            }
            
            Section(header: Text("Exercises (\(routine.exercises.count))")) {
                if routine.exercises.isEmpty {
                    Text("This routine has no exercises.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(routine.exercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text("Category: \(exercise.category.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if !exercise.steps.isEmpty {
                                DisclosureGroup("Show Steps") {
                                     ForEach(exercise.steps.indices, id: \.self) { index in
                                        HStack(alignment: .top) {
                                            Text("\(index + 1).").fontWeight(.medium)
                                            Text(exercise.steps[index])
                                        }
                                    }
                                }
                                .font(.caption)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(routine.name)
        .listStyle(InsetGroupedListStyle()) // Consistent list style
    }
}
