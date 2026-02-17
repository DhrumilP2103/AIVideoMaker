import Foundation

protocol HomeServiceProto {
    func homeList(completion: @escaping (Result<HomeResponseModel, APIError>) -> Void)
}

struct HomeAPIService: HomeServiceProto {
    func homeList(completion: @escaping (Result<HomeResponseModel, APIError>) -> Void) {
        let parameter: [String: AnyObject] = [:]
        
        APIService().getAPI(modelType: HomeResponseModel.self, endPoint: APIConstants.Endpoints.home, parameter: parameter) { data, statusCode, success in
            switch statusCode {
            case 200:
                if let response = data {
                    completion(.success(response))
                } else {
                    completion(.failure(.unexpected(NSLocalizedString("Unexpected server response.", comment: ""))))
                }
                
            case 401:
                if let response = data {
                    completion(.failure(.unAuthorizationError(response.message ?? "401")))
                } else {
                    completion(.failure(.unAuthorizationError(NSLocalizedString("UnAuthorized. Please login again.", comment: ""))))
                }
                
            case 500:
                if let response = data {
                    completion(.failure(.internalServerError(response.message ?? "500")))
                } else {
                    completion(.failure(.internalServerError(NSLocalizedString("Internal server error. Please try again later.", comment: ""))))
                }
                
            default:
                if let response = data {
                    completion(.failure(.unexpected(response.message ?? "default")))
                } else {
                    completion(.failure(.unexpected(NSLocalizedString("Login failed. Please try again.", comment: ""))))
                }
            }
        }
    }
}
