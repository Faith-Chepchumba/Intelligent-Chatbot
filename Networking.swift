// Networking.swift
import Foundation

class Networking {

    func callDialogflowAPI(with text: String, completion: @escaping (String) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://api.dialogflow.com/v1/query?v=20150910")! // Dialogflow URL

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer YOUR_DIALOGFLOW_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")

        let parameters: [String: Any] = [
            "query": text,
            "lang": "en",
            "sessionId": UUID().uuidString
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("Error calling Dialogflow API: \(String(describing: error))")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let response = json?["result"] as? [String: Any], let fulfillment = response["fulfillment"] as? [String: Any], let speech = fulfillment["speech"] as? String {
                completion(speech)
            }
        }
        task.resume()
    }
}