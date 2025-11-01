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
            let typeid = questions?.first( where: {$0.id == id})?.typeID ?? 0
            var answerDict: [String: Any] = [
                "customerPackageId": customerPackageId,
                "packageQuestionId": id,
                "typeId": typeid,
                "answer": value
            ]
            
            // Add conditional field
            if typeid == 2 {
                answerDict["mcqId"] = 0
            }
            
            return answerDict
        }
        print("answersArray",answersArray)
        
        isLoading = true
        defer { isLoading = false }

        // Assuming backend accepts top-level array, we’ll extend our builder later. For now, send under "answers".
        let parameters: [String: Any] = answersArray.first ?? [:]
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
