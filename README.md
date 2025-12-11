# Quizine (iOS)

Quizine is a small iOS app built with SwiftUI. Instead of scrolling through a giant list of restaurants, you answer a quick quiz hosted by a 3D cat named Leche. The app narrows down what you’re craving (like Korean BBQ, ramen, burgers, etc.) and shows a simple result screen.

I modeled and animated Leche in Blender, rendered the animation as a video, and used that as the background for the quiz.

---

## Screenshots
![1](https://github.com/user-attachments/assets/fe0a2ad7-9c58-42c9-a44a-907463f5140a)
![3](https://github.com/user-attachments/assets/0211d242-6148-4168-bc79-4f933d6fdbba)

---

## Features

- 3D cat host (Leche) rendered as a looping background video.
- Branching quiz that goes from broad categories (like Asian vs American) into more specific food types.
- Simple text bubble dialogue and buttons for answering questions.
- Clean SwiftUI layout with a start screen, intro, quiz flow, and result screen.
- “Try again” button so you can rerun the quiz if your cravings change.

---

## Tech Stack

- **Language:** Swift  
- **UI Framework:** SwiftUI  
- **3D / Assets:** Blender (modeled, animated, and rendered to video)  
- **IDE:** Xcode  

---

## How to Run (Deployment)

1. Clone the repo:

        git clone https://github.com/your-username/food-guesser-ios.git
        cd food-guesser-ios

2. Open the project in Xcode:

   - Double-click the `.xcodeproj` or `.xcworkspace` file.

3. Pick a run target:

   - At the top of Xcode, choose an iOS Simulator (for example, iPhone 16)  
     or your physical iPhone.

4. If you’re using a real device:

   - Sign into Xcode with your Apple ID.  
   - Give the app a unique Bundle Identifier in the project settings.  
   - Choose your development team so Xcode can handle code signing.

5. Build and run:

   - Press `Command + R` or hit the Run button.  
   - The app should launch in the simulator or on your phone.

---

## How to Use the App

1. **Home screen**  
   Tap **Start** to begin. You can also open **About** for a short description of the app.

2. **Meet Leche**  
   Leche introduces themself (“my name is leche, and my job is to guess what you're craving”) in a speech bubble over the animated background.

3. **Answer the questions**  
   You’ll see simple multiple-choice questions like “asian or american?” with buttons you can tap. There’s also a “neither of these” option if nothing fits.

4. **Get your result**  
   After a few steps, the app shows a result screen (for example, “Korean BBQ”) with a “Try again” button.

5. **Run it again**  
   Tap **Try again** to go back through the quiz and get a different suggestion.

---

## Behind the Scenes

I had to learn Blender from scratch for this project. The pipeline was:

1. Model a low-poly cat and a simple ground plane.
2. Animate an idle loop that looks good on a phone screen.
3. Render the animation to a video file.
4. Import that video into Xcode and play it in a SwiftUI view as a looping background.

This setup lets me swap in new animations later (like a shocked or shivering Leche) without changing the main app logic.
