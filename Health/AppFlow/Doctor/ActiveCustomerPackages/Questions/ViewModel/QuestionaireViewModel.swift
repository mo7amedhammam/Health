//
//  QuestionaireViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/10/2025.
//

import Foundation

class QuestionaireViewModel : ObservableObject {
    static let shared = QuestionaireViewModel()
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask:Task<Void,Never>? = nil
    
    var CustomerPackageId : Int?
    @Published var questions : [CustomerPackageQuestM]?
    @Published var userAnswers: [Int: String] = [:]

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

extension QuestionaireViewModel{
    @MainActor
    func addCustomerQuestionAnswer() async {
        guard let customerPackageId = CustomerPackageId else { return }

        let answersArray: [[String: Any]] = userAnswers.map { (id, value) in
            let typeid = questions?.first(where: { $0.id == id })?.typeID ?? 0
            var answerDict: [String: Any] = [
                "customerPackageId": customerPackageId,
                "packageQuestionId": id,
                "typeId": typeid,
                "answer": value
            ]
            if typeid == 2 {
                answerDict["mcqId"] = 0
            }
            return answerDict
        }
        print("answersArray", answersArray)

        isLoading = true
        defer { isLoading = false }

        // Send the whole array as top-level JSON
        let target = DocActivePackagesServices.CreatePackageQuestionnaireAnswersArray(items: answersArray)
        do {
            self.errorMessage = nil
            struct EmptyResponse: Codable {}
            _ = try await networkService.request(target, responseType: EmptyResponse.self)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Send multiple answers (already prepared by caller)
    @MainActor
    func addAnswers(_ items: [(qid: Int, typeId: Int, answer: String, mcqId: Int?)]) async {
        guard let customerPackageId = CustomerPackageId else { return }
        isLoading = true
        defer { isLoading = false }

        // Build a single array payload
        let payload: [[String: Any]] = items.map { item in
            var dict: [String: Any] = [
                "customerPackageId": customerPackageId,
                "packageQuestionId": item.qid,
                "typeId": item.typeId,
                "answer": item.answer
            ]
            if item.typeId == 2 {
                dict["mcqId"] = item.mcqId ?? 0
            }
            return dict
        }

        let target = DocActivePackagesServices.CreatePackageQuestionnaireAnswersArray(items: payload)
        do {
            struct EmptyResponse: Codable {}
            _ = try await networkService.request(target, responseType: EmptyResponse.self)
            self.errorMessage = nil
            Task {
                await getCustomerQuestions()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
        
    func updateAnswer(for questionId: Int, answer: String) {
        userAnswers[questionId] = answer
    }
      
    @MainActor
    func getCustomerQuestions() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            isLoading = true
            defer { isLoading = false }
            guard let customerPackageId = CustomerPackageId else { return }
            let parametersarr : [String : Any] =  ["CustomerPackageId": customerPackageId]
            let target = DocActivePackagesServices.GetCustomerPackageQuest(parameters: parametersarr)
            do {
                self.errorMessage = nil
                let response = try await networkService.request(
                    target,
                    responseType: [CustomerPackageQuestM].self
                )
                self.questions = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
}

