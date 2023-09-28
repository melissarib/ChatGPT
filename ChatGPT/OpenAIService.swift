//
//  OpenAIService.swift
//  ChatGPT
//
//  Created by Melissa Ribeiro on 22/03/23.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/"
    
    func sendMessage(message:String) -> AnyPublisher<OpenAICompletationsResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 256)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            AF.request(self.baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletationsResponse.self) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct OpenAICompletationsResponse: Decodable {
    let id: String
    let choices: [OpenAICompetionsChoice]
}

struct OpenAICompetionsChoice: Decodable {
    let text: String
}
