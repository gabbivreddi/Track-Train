import SwiftUI
// SwiftData import is present but not actively used for 'exercises' in this modified version.
// If you intend to use SwiftData for exercises, this structure will need further changes.

// View to display the list of exercises
struct ExercisesListView: View {
    // Changed from @State to @Binding to accept exercises from a parent view
    @Binding var exercises: [Exercise]
    
    @State private var selectedExercise: Exercise? = nil
    @State private var searchTerm: String = ""
    @State private var selectedCategory: ExerciseCategory? = nil
    
    @State private var showingAddExerciseSheet = false // To present the AddExerciseView

    let categories = ExerciseCategory.allCases

    var filteredExercises: [Exercise] {
        // Now uses the @Binding variable directly
        var activelyFiltered = exercises
        
        if let category = selectedCategory {
            activelyFiltered = activelyFiltered.filter { $0.category == category }
        }

        if !searchTerm.isEmpty {
            activelyFiltered = activelyFiltered.filter {
                $0.name.localizedCaseInsensitiveContains(searchTerm) ||
                $0.description.localizedCaseInsensitiveContains(searchTerm)
            }
        }
        return activelyFiltered.sorted { $0.name < $1.name } // Keep the list sorted
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search exercises...", text: $searchTerm)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)

                Picker("Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as ExerciseCategory?)
                    ForEach(categories) { category in
                        Text(category.rawValue).tag(category as ExerciseCategory?)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)

                List(filteredExercises) { exercise in
                    HStack {
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
                            Text(exercise.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedExercise = exercise
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExerciseSheet = true
                    } label: {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                }
                // If you want an EditButton for the exercises list (e.g., to delete)
                // ToolbarItem(placement: .navigationBarLeading) {
                //     EditButton()
                // }
            }
            .sheet(item: $selectedExercise) { exercise in
                ExerciseDetailView(exercise: exercise)
            }
            // Sheet for adding a new exercise
            // The AddExerciseView will now append to the binding,
            // which updates the source of truth in the parent view (e.g., ContentView).
            .sheet(isPresented: $showingAddExerciseSheet) {
                AddExerciseView(exercises: $exercises) // Pass the binding
            }
        }
    }
}
