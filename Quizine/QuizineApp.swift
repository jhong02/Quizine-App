//
//  QuizineApp.swift
//  Quizine
//
//  Created by Samantha Pham on 12/2/25.
//

import SwiftUI
import CoreData

@main
struct QuizineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
