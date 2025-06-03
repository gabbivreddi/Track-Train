//
//  PickRoutineView.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 6/1/25.
//

import SwiftUI

struct PickRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var routines: [Routine] // Binding to the list of routines
    @Binding var showingCreateRoutineSheet: Bool // To present CreateRoutineView from ContentView

    var body: some View {
        // NavigationView is already part of the parent context (ContentView's Home tab)
        // or this view is presented as a sheet which itself has a NavigationView.
        // If this view were standalone and needed its own navigation bar for the title
        // and "+" button, then it would need its own NavigationView here.
        // Since it's presented as a sheet, the NavigationView inside its body
        // provides the bar for "Pick a Routine" title and buttons.
        NavigationView {
            VStack {
                if routines.isEmpty {
                    VStack { // Center the message
                        Spacer()
                        Text("No routines available.")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Tap the '+' button to create one.")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(routines) { routine in
                            NavigationLink(destination: RoutineDetailView(routine: routine)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(routine.name)
                                            .font(.headline)
                                        Text("\(routine.exercises.count) exercise\(routine.exercises.count == 1 ? "" : "s")")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    // Chevron is automatically added by NavigationLink
                                }
                            }
                        }
                        .onDelete(perform: deleteRoutine)
                    }
                    .listStyle(InsetGroupedListStyle()) // Consistent list style
                }
            }
            .navigationTitle("Pick a Routine")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                     if !routines.isEmpty { EditButton() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // This logic correctly dismisses PickRoutineView and signals ContentView
                        // to present CreateRoutineView.
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Ensure sheet is dismissed
                           showingCreateRoutineSheet = true
                        }
                    } label: {
                        Label("Create New Routine", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }
    
    // Function to delete routines from the list
    private func deleteRoutine(at offsets: IndexSet) {
        routines.remove(atOffsets: offsets)
    }
}
