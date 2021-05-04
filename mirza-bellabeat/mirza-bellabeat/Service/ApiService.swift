import Foundation

protocol ApiService {
    func fetchDesign(completionHandler: @escaping (Result<DesignApiResponseModel, Error>) -> Void)
}

class ApiDataService: ApiService {
    private let domainUrlString = "https://d2t41j3b4bctaz.cloudfront.net/"

    func fetchDesign(completionHandler: @escaping (Result<DesignApiResponseModel, Error>) -> Void) {
        guard let url = URL(string: domainUrlString + "interview.json") else {
            return
        }

        var request: URLRequest = URLRequest(url: url)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                print("Error with fetching design: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }

            if let data = data,
               let designResponseModel = try? JSONDecoder().decode(DesignApiResponseModel.self, from: data) {
                completionHandler(.success(designResponseModel))
            }
        })

        task.resume()
    }
}
