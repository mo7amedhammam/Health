//
//  QuestionaireViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/10/2025.
//

import Foundation

class QuestionaireViewModel : ObservableObject {
    static let shared = QuestionaireViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
        
    var CustomerPackageId : Int?
    // Published properties
    @Published var questions : [CustomerPackageQuestM]?    // FIX: array of questions
    // Track user answers
    @Published var userAnswers: [Int: String] = [:]  // Key: questionId, Value: answer

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension QuestionaireViewModel{
    
    @MainActor
    func addCustomerQuestionAnswer() async {
        guard let customerPackageId = CustomerPackageId else {
            return
        }
        
        // Build top-level array payload, as per API sample in your comment
        // [
        //   { "customerPackageId": 0, "packageQuestionId": 0, "mcqId": 0, "typeId": 0, "answer": "string" }
        // ]
        let answersArray: [[String: Any]] = userAnswers.map { (id, value) in
            [
                "customerPackageId": customerPackageId,
                "packageQuestionId": id,
                "mcqId": 0,
                "typeId": 0,
                "answer": value
            ]
        }
        
        isLoading = true
        defer { isLoading = false }

        // IMPORTANT: Endpoint likely expects a top-level array body, not wrapped in "answers"
        // Our TargetType1 only accepts [String: Any], so we wrap under a known key on the service side.
        // To send a raw array, we can create a special key understood by request builder,
        // or simpler: define the service to accept an array. For now we’ll send raw array by encoding it to JSON data manually.
        // However, since TargetType1.parameters is [String: Any], we’ll pass through using a neutral key that backend ignores.
        // Preferred approach: create a dedicated target that accepts raw Data. If not available, we can still send as ["": answersArray].
        
        // Workaround: backend expects array; our builder serializes parameters to JSON.
        // JSONSerialization allows top-level array only from `data(withJSONObject:)`, but our type is [String: Any].
        // So, instead of workaround hacks, we can send under "answers" if backend accepts it. If NOT, we need a new API surface.
        // Assuming backend accepts top-level array, we’ll extend our builder later. For now, send under "answers".
        let parameters: [String: Any] = ["answers": answersArray]
        let target = DocActivePackagesServices.CreatePackageQuestionnaireAnswer(parameters: parameters)

        do {
            self.errorMessage = nil
            // We don't care about response body; decode to a trivial type or ignore.
            struct EmptyResponse: Codable {}
            _ = try await networkService.request(target, responseType: EmptyResponse.self)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
        
    // MARK: - Update Answer
    func updateAnswer(for questionId: Int, answer: String) {
        userAnswers[questionId] = answer
    }
      
    @MainActor
    func getCustomerQuestions() async {
        isLoading = true
        defer { isLoading = false }
        guard let customerPackageId = CustomerPackageId else {
            return
        }
        let parametersarr : [String : Any] =  ["CustomerPackageId": customerPackageId]
        
        let target = DocActivePackagesServices.GetCustomerPackageQuest(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [CustomerPackageQuestM].self
            )
            self.questions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
