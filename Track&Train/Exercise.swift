// Exercise.swift
// Track&Train
//
// Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI

// Struct to represent an exercise
// Added Hashable and Codable conformance
struct Exercise: Identifiable, Hashable, Codable {
    let id = UUID() // Unique identifier for each exercise
    var name: String
    var category: ExerciseCategory // ExerciseCategory also needs to be Codable
    var description: String
    var steps: [String]
    var pairedExerciseName: [String] // Name of a complementary exercise
    var imageName: String? // Optional: SFSymbol name for an icon
    var youtubeVideoId: String?

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Conformance to Equatable (required by Hashable)
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

// Array of sample exercises (assuming this remains the same or is managed elsewhere)
// Make sure this list is accessible where needed, e.g., globally or passed around.
let sampleExercises: [Exercise] = [
    // Warm-up
    Exercise(name: "Jumping Jacks", category: .warmup, description: "A full-body warm-up exercise.", steps: ["Stand with feet together and arms at your sides.", "Jump, spreading your feet wide while bringing your arms overhead.", "Return to the starting position."], pairedExerciseName: ["High Knees"], imageName: "figure.jumprope", youtubeVideoId: "c4DAnQ6DtF8"),
    Exercise(name: "Arm Circles", category: .warmup, description: "Warms up the shoulder joints.", steps: ["Stand with feet shoulder-width apart, arms extended to the sides.", "Make small circles with your arms forward for 30 seconds.", "Reverse direction and make circles backward for 30 seconds."], pairedExerciseName: ["Shoulder Rolls"], youtubeVideoId: "1823G-Gj1wA"),
    Exercise(name: "High Knees", category: .warmup, description: "Dynamic warm-up to elevate heart rate.", steps: ["Stand in place.", "Lift one knee towards your chest as high as possible.", "Quickly switch to the other knee, mimicking running in place."], pairedExerciseName: ["Butt Kicks"], imageName: "figure.walk"),
    Exercise(name: "Dynamic Chest Stretch", category: .warmup, description: "Prepares chest and shoulder muscles.", steps: ["Stand tall.", "Swing both arms horizontally outwards and backwards, feeling a stretch in your chest.", "Bring arms forward, crossing them in front of your body.", "Repeat smoothly."], pairedExerciseName: ["Arm Swings"]),
    Exercise(name: "Leg Swings (Forward & Sideways)", category: .warmup, description: "Improves hip mobility and warms up leg muscles.", steps: ["Stand tall, hold onto a support if needed.", "Swing one leg forward and backward like a pendulum for 10-15 reps.", "Then swing the same leg side to side across your body for 10-15 reps.", "Repeat with the other leg."], pairedExerciseName: ["Torso Twists"]),
    Exercise(name: "Torso Twists", category: .warmup, description: "Warms up the core and improves spinal mobility.", steps: ["Stand with feet shoulder-width apart, knees slightly bent.", "Rotate your torso gently from side to side.", "Allow your arms to swing naturally."], pairedExerciseName: ["Cat-Cow Stretch"]),

    // Cardio
    Exercise(name: "Running", category: .cardio, description: "Effective cardiovascular exercise.", steps: ["Maintain a steady pace.", "Keep your core engaged and posture upright.", "Land midfoot to reduce impact."], pairedExerciseName: ["Cycling"], imageName: "figure.running", youtubeVideoId: "8F2h_n0WHpU"),
    Exercise(name: "Cycling", category: .cardio, description: "Low-impact cardio exercise.", steps: ["Adjust bike settings for proper fit.", "Maintain a consistent cadence.", "Vary resistance for intensity."], pairedExerciseName: ["Swimming"], imageName: "figure.outdoor.cycle"),
    Exercise(name: "Burpees", category: .cardio, description: "Full-body exercise that builds strength and endurance.", steps: ["Start standing, drop into a squat with hands on the ground.", "Kick feet back to a plank position.", "Optional: Do a push-up.", "Return feet to squat position.", "Jump up explosively."], pairedExerciseName: ["Mountain Climbers"], imageName: "figure.core.training", youtubeVideoId: "auBLPXO8Fww"),
    Exercise(name: "Jump Rope", category: .cardio, description: "Excellent for coordination and calorie burning.", steps: ["Hold rope handles with a relaxed grip.", "Rotate wrists to swing the rope.", "Jump just high enough for the rope to pass."], pairedExerciseName: ["Jumping Jacks"], imageName: "figure.jumprope", youtubeVideoId: "1BZM2Vre5oc"),
    Exercise(name: "Elliptical Trainer", category: .cardio, description: "Low-impact, full-body cardio workout.", steps: ["Step onto the pedals and grab the handles.", "Move in a smooth, gliding motion.", "Adjust resistance and incline for desired intensity."], pairedExerciseName: ["Rowing Machine"]),
    Exercise(name: "Stair Climbing", category: .cardio, description: "Builds lower body strength and cardiovascular fitness.", steps: ["Use a stair machine or actual stairs.", "Maintain an upright posture.", "Push through your heels to engage glutes."], pairedExerciseName: ["Incline Walking"]),

    // Strength Training
    Exercise(name: "Push-ups", category: .strengthTraining, description: "Builds upper body and core strength.", steps: ["Start in a plank position, hands shoulder-width apart.", "Lower your body until your chest nearly touches the floor.", "Push back up to the starting position."], pairedExerciseName: ["Plank"], imageName: "figure.strengthtraining.traditional", youtubeVideoId: "IODxDxX7oi4"),
    Exercise(name: "Squats (Bodyweight)", category: .strengthTraining, description: "Targets legs and glutes.", steps: ["Stand with feet shoulder-width apart.", "Lower your hips as if sitting in a chair, keeping your chest up.", "Go as low as comfortable, then push back up."], pairedExerciseName: ["Lunges"], imageName: "figure.squat", youtubeVideoId: "C_VtOYc6j5c"),
    Exercise(name: "Plank", category: .strengthTraining, description: "Core strengthening exercise.", steps: ["Hold a push-up position, resting on forearms or hands.", "Keep your body in a straight line from head to heels.", "Engage your core and glutes."], pairedExerciseName: ["Side Plank"], imageName: "figure.core.training", youtubeVideoId: "ASdvN_XEl_c"),
    Exercise(name: "Lunges", category: .strengthTraining, description: "Works quads, glutes, and hamstrings.", steps: ["Step forward with one leg.", "Lower your hips until both knees are bent at a 90-degree angle.", "Push back to the starting position and repeat with the other leg."], pairedExerciseName: ["Glute Bridges"], imageName: "figure.lunge", youtubeVideoId: "QOVaHwm-Q6U"),
    Exercise(name: "Glute Bridges", category: .strengthTraining, description: "Strengthens glutes, hamstrings, and lower back.", steps: ["Lie on your back with knees bent and feet flat on the floor, hip-width apart.", "Place arms by your sides, palms down.", "Lift your hips off the floor until your body forms a straight line from shoulders to knees.", "Squeeze glutes at the top. Lower slowly."], pairedExerciseName: ["Bird Dog"], imageName: "figure.cooldown"), // Using cooldown icon as placeholder
    Exercise(name: "Tricep Dips (on chair/bench)", category: .strengthTraining, description: "Targets triceps and shoulders.", steps: ["Sit on the edge of a sturdy chair or bench, hands gripping the edge next to your hips.", "Slide your hips forward off the bench.", "Lower your body by bending your elbows until they are at a 90-degree angle.", "Push back up to the starting position."], pairedExerciseName: ["Diamond Push-ups"], youtubeVideoId: "0326dyfKj38"),

    // Weight Training (assuming access to weights)
    Exercise(name: "Bench Press", category: .weightTraining, description: "Builds chest, shoulders, and triceps.", steps: ["Lie on a bench, grip the barbell slightly wider than shoulder-width.", "Lower the bar to your chest.", "Press the bar back up until arms are fully extended."], pairedExerciseName: ["Dumbbell Flyes"], imageName: "figure.strengthtraining.traditional", youtubeVideoId: "gRVjAtPip0Y"),
    Exercise(name: "Deadlifts", category: .weightTraining, description: "Full-body compound exercise.", steps: ["Stand with mid-foot under the barbell.", "Bend at hips and knees to grip the bar, keeping your back straight.", "Lift the bar by extending hips and knees.", "Lower the bar controllably."], pairedExerciseName: ["Rows"], imageName: "figure.strengthtraining.traditional", youtubeVideoId: "ytGaGIn3SjE"),
    Exercise(name: "Overhead Press (Barbell/Dumbbell)", category: .weightTraining, description: "Builds shoulder strength.", steps: ["Stand or sit, holding dumbbells or a barbell at shoulder height.", "Press the weight(s) overhead until arms are fully extended.", "Lower controllably."], pairedExerciseName: ["Lateral Raises"], imageName: "figure.strengthtraining.functional", youtubeVideoId: "2yjwXTZQDDI"),
    Exercise(name: "Bicep Curls (Dumbbell/Barbell)", category: .weightTraining, description: "Isolates and builds bicep muscles.", steps: ["Stand or sit, holding dumbbells with an underhand grip.", "Curl the weights up towards your shoulders, keeping elbows stable.", "Lower controllably."], pairedExerciseName: ["Tricep Extensions"], imageName: "figure.strengthtraining.traditional", youtubeVideoId: "kwG2ZqtG0AE"),
    Exercise(name: "Dumbbell Rows", category: .weightTraining, description: "Strengthens back muscles (lats, rhomboids, traps).", steps: ["Place one knee and hand on a bench, back flat.", "Hold a dumbbell in the other hand, arm extended.", "Pull the dumbbell up towards your hip, squeezing your back muscles.", "Lower slowly. Repeat on other side."], pairedExerciseName: ["Pull-ups"]),
    Exercise(name: "Goblet Squats", category: .weightTraining, description: "Excellent for leg strength and core stability.", steps: ["Hold one dumbbell vertically against your chest with both hands.", "Stand with feet slightly wider than shoulder-width, toes pointed out slightly.", "Lower into a squat, keeping your chest up and back straight.", "Push through heels to return to start."], pairedExerciseName: ["Romanian Deadlifts"], youtubeVideoId: "MeCDU_34C0k"),

    // Flexibility
    Exercise(name: "Hamstring Stretch", category: .flexibility, description: "Stretches the back of your thighs.", steps: ["Sit with one leg extended, the other bent with foot against inner thigh.", "Lean forward from the hips towards the extended foot.", "Hold for 20-30 seconds, repeat on other side."], pairedExerciseName: ["Quad Stretch"], imageName: "figure.flexibility", youtubeVideoId: "HUXsFmSFB1g"),
    Exercise(name: "Quad Stretch", category: .flexibility, description: "Stretches the front of your thighs.", steps: ["Stand on one leg, optionally holding onto a support.", "Bring your heel towards your glutes, holding your ankle.", "Keep knees close together. Hold for 20-30 seconds.", "Repeat on other side."], pairedExerciseName: ["Hamstring Stretch"], imageName: "figure.flexibility"),
    Exercise(name: "Triceps Stretch", category: .flexibility, description: "Stretches the back of your upper arm.", steps: ["Reach one arm overhead, bend elbow and let hand fall behind your head.", "Gently pull the elbow with your other hand.", "Hold for 20-30 seconds. Repeat on other side."], pairedExerciseName: ["Biceps Stretch"], imageName: "figure.flexibility"),
    Exercise(name: "Chest Stretch (Doorway)", category: .flexibility, description: "Opens up the chest and shoulders.", steps: ["Stand in a doorway, place forearms on the frame at shoulder height.", "Lean forward gently until you feel a stretch in your chest.", "Hold for 20-30 seconds."], pairedExerciseName: ["Upper Back Stretch"]),
    Exercise(name: "Hip Flexor Stretch (Kneeling)", category: .flexibility, description: "Stretches the front of your hip.", steps: ["Kneel on one knee, with the other foot flat on the floor in front of you (lunge position).", "Gently push your hips forward, keeping your back straight.", "Hold for 20-30 seconds. Repeat on other side."], pairedExerciseName: ["Piriformis Stretch"]),

    // Cooldown
    Exercise(name: "Child's Pose", category: .cooldown, description: "Gentle resting pose to calm the body.", steps: ["Kneel on the floor, big toes touching.", "Sit back on your heels (or as close as comfortable).", "Fold forward, resting your forehead on the floor, arms extended or by your sides."], pairedExerciseName: ["Light Walk"], imageName: "figure.cooldown", youtubeVideoId: "2MJGg-dUKh0"),
    Exercise(name: "Slow Walk", category: .cooldown, description: "Gradually lowers heart rate.", steps: ["Walk at a slow, comfortable pace.", "Focus on deep breathing.", "Continue for 5-10 minutes."], pairedExerciseName: ["Static Stretching"], imageName: "figure.walk"),
    Exercise(name: "Cat-Cow Stretch", category: .cooldown, description: "Improves spinal flexibility and relieves tension.", steps: ["Start on all fours, hands under shoulders, knees under hips.", "Inhale, drop your belly, arch your back, look up (Cow).", "Exhale, round your spine, tuck your chin (Cat).", "Repeat slowly for 5-10 breaths."], pairedExerciseName: ["Child's Pose"], youtubeVideoId: "kqnua4rHVVA"),
    Exercise(name: "Full Body Static Stretch", category: .cooldown, description: "Hold various static stretches for major muscle groups.", steps: ["Hold each stretch for 20-30 seconds.", "Focus on hamstrings, quads, chest, back, shoulders, and arms.", "Breathe deeply throughout."], pairedExerciseName:["Deep Breathing Exercises"]),

    // HIIT (High-Intensity Interval Training)
    Exercise(name: "Sprint Intervals", category: .hiit, description: "Alternating bursts of maximum effort sprints with recovery periods.", steps: ["Warm up thoroughly.", "Sprint as fast as you can for 20-30 seconds.", "Recover with slow walking or jogging for 40-60 seconds.", "Repeat for a set number of intervals (e.g., 8-10).", "Cool down afterwards."], pairedExerciseName: ["Bodyweight Squat Jumps"], imageName: "figure.run", youtubeVideoId: "TvUZe_qJq44"),
    Exercise(name: "Tabata Push-ups", category: .hiit, description: "20 seconds of push-ups, 10 seconds of rest, for 8 rounds (4 minutes).", steps: ["Perform as many push-ups as possible in 20 seconds.", "Rest for 10 seconds.", "Repeat this cycle 8 times.", "Modify to knee push-ups if needed."], pairedExerciseName: ["Tabata Squats"], imageName: "figure.strengthtraining.traditional"),
    Exercise(name: "Mountain Climber Sprints", category: .hiit, description: "Fast-paced mountain climbers for a short duration.", steps: ["Start in a plank position.", "Drive your knees towards your chest as quickly as possible, alternating legs.", "Perform for 20-45 seconds, then rest briefly.", "Repeat."], pairedExerciseName: ["Burpees"], imageName: "figure.core.training", youtubeVideoId: "nmwgirgXLYM"),

    // Core
    Exercise(name: "Crunches", category: .core, description: "Basic abdominal exercise.", steps: ["Lie on your back, knees bent, feet flat on the floor.", "Place hands behind your head or across your chest.", "Lift your head and shoulders off the floor, engaging your abs.", "Lower slowly."], pairedExerciseName: ["Leg Raises"], imageName: "figure.core.training", youtubeVideoId: "Xyd_fa5zoEU"),
    Exercise(name: "Leg Raises", category: .core, description: "Targets lower abdominal muscles.", steps: ["Lie on your back, legs straight out.", "Place hands under your lower back for support.", "Slowly raise your legs towards the ceiling until they are perpendicular to the floor.", "Lower slowly without letting your feet touch the ground completely."], pairedExerciseName: ["Flutter Kicks"], imageName: "figure.core.training", youtubeVideoId: "l4kQd9eWnAY"),
    Exercise(name: "Russian Twists", category: .core, description: "Works oblique muscles.", steps: ["Sit on the floor, lean back slightly with knees bent, feet off the ground (or on ground for modification).", "Clasp hands together in front of your chest.", "Twist your torso from side to side.", "Optionally hold a weight for added resistance."], pairedExerciseName: ["Side Plank Dips"], imageName: "figure.core.training", youtubeVideoId: "wkD8rjkodUI"),
    Exercise(name: "Bird Dog", category: .core, description: "Improves stability, coordination, and core strength.", steps: ["Start on all fours (tabletop position).", "Extend one arm straight forward and the opposite leg straight backward, keeping your core engaged and back flat.", "Hold for a few seconds, then slowly return to start.", "Repeat on the other side."], pairedExerciseName: ["Plank"], imageName: "figure.core.training", youtubeVideoId: "wiFNA3sqjCA")
]
