import Foundation
import Combine
// MARK: - Runtime models

struct QuizChoice: Identifiable {
    let id = UUID()
    let label: String
    let nextNodeID: String?
    let resultCuisine: String?
}

struct QuizNode {
    let id: String
    let question: String
    let choices: [QuizChoice]
    let alternativeNodeID: String?
}

struct QuizResult {
    let cuisine: String
}

// MARK: - Engine

final class QuizEngine: ObservableObject {

    // Current node (question + choices)
    @Published private(set) var currentNode: QuizNode

    // Non-nil when we’ve picked a final cuisine
    @Published private(set) var result: QuizResult?

    // For the “Neither of these” button
    var hasNeitherOption: Bool {
        currentNode.alternativeNodeID != nil
    }

    // All nodes by id
    private let allNodes: [String: QuizNode]
    private let startNodeID: String

    // MARK: - Init

    init() {
        // Load from quiz_data.json via QuizDatabase
        let data = QuizDatabase.load()
        self.startNodeID = data.startNodeID

        var nodesDict: [String: QuizNode] = [:]

        for nodeData in data.nodes {
            let choices = nodeData.choices.map { choiceData in
                QuizChoice(
                    label: choiceData.label,
                    nextNodeID: choiceData.nextNodeID,
                    resultCuisine: choiceData.resultCuisine
                )
            }

            let node = QuizNode(
                id: nodeData.id,
                question: nodeData.question,
                choices: choices,
                alternativeNodeID: nodeData.alternativeNodeID
            )

            nodesDict[node.id] = node
        }

        self.allNodes = nodesDict

        guard let start = allNodes[startNodeID] else {
            fatalError("❌ quiz_data.json: no node with id \(startNodeID)")
        }

        self.currentNode = start
    }

    // MARK: - Public API (used by QuizView)

    func restart() {
        result = nil
        guard let start = allNodes[startNodeID] else { return }
        currentNode = start
    }

    func choose(_ choice: QuizChoice) {
        SoundManager.shared.play(.click)

        // If this choice leads to another node, go there
        if let nextID = choice.nextNodeID,
           let next = allNodes[nextID] {
            currentNode = next
            return
        }

        // Otherwise, if it has a result cuisine, finish
        if let cuisine = choice.resultCuisine {
            result = QuizResult(cuisine: cuisine)
        }
    }

    func chooseNeither() {
        SoundManager.shared.play(.click)

        if let altID = currentNode.alternativeNodeID,
           let next = allNodes[altID] {
            currentNode = next
        } else {
            // no alternative defined → loop back to start
            restart()
        }
    }
}
