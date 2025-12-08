import Foundation

struct QuizChoiceData: Codable {
    let label: String
    let nextNodeID: String?
    let resultCuisine: String?
}

struct QuizNodeData: Codable {
    let id: String
    let question: String
    let alternativeNodeID: String?
    let choices: [QuizChoiceData]
}

struct QuizData: Codable {
    let startNodeID: String
    let nodes: [QuizNodeData]
}

enum QuizDatabase {
    static func load() -> QuizData {
        guard let url = Bundle.main.url(forResource: "quiz_data", withExtension: "json") else {
            fatalError("❌ quiz_data.json not found in bundle")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(QuizData.self, from: data)
            return decoded
        } catch {
            fatalError("❌ Failed to decode quiz_data.json: \(error)")
        }
    }
}
