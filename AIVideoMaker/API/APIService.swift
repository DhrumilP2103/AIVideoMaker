//
//  APIService.swift
//  NexTrac
//
//  Created by MB Infoways on 03/06/25.
//

import Foundation
import Alamofire
import UIKit

class APIService: NSObject {
    
    func getURLRequest(endPoint:String) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(APIConstants.baseURL + endPoint)")!)
        request.httpMethod = "POST"
        
        // HTTP Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.value(forKey: "bearer_token")
            as? String {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("\(token)", forHTTPHeaderField: "x-access-token")
            request.addValue("\(token)", forHTTPHeaderField: "Api-Key")
            request.addValue("en-US", forHTTPHeaderField: "Accept-Language")
            DEBUGLOG("URLRequest => \(APIConstants.baseURL + endPoint)")
            DEBUGLOG("x-access-token => \(token)")
        } else {
            let token = "29b4d4f941820fa5d9777990300d041b"
            request.addValue("\(token)", forHTTPHeaderField: "Api-Key")
            request.addValue("en-US", forHTTPHeaderField: "Accept-Language")
        }
        
        return request
    }
    
    func postAPI<T: Decodable>(modelType: T.Type, endPoint: String, parameter: [String: AnyObject], completion: @escaping (T?, Int, Bool) -> Void) {
        
        var request = getURLRequest(endPoint: endPoint)
        // Capture the generic type in a local constant to avoid Sendable capture warnings
        nonisolated(unsafe) let decodeType = modelType
        
        // Debug logging
        #if DEBUG
        DEBUGLOG("🌐 [REQUEST] URL => \(request.url?.absoluteString ?? "")")
        DEBUGLOG("📝 [REQUEST] Parameters => \(parameter)")
        #endif
        
        let formDataString = parameter.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        request.httpBody = formDataString.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DEBUGLOG(data as Any)
            if let data = data {
                let httpResponse = response as? HTTPURLResponse
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DEBUGLOG(json)
                    
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(decodeType.self, from: data)
                    completion(model,httpResponse?.statusCode ?? 0,true)
                } catch {
                    DEBUGLOG(error)
                    completion(nil,httpResponse?.statusCode ?? 0,false)
                }
            }
        }.resume()
    }
    
    func getAPI<T: Decodable>(modelType: T.Type, endPoint: String, parameter: [String: AnyObject], completion: @escaping (T?, Int, Bool) -> Void) {
        
        var request = getURLRequest(endPoint: endPoint)
        // Capture the generic type in a local constant to avoid Sendable capture warnings
        nonisolated(unsafe) let decodeType = modelType
        
        // Debug logging
        #if DEBUG
        DEBUGLOG("🌐 [REQUEST] URL => \(request.url?.absoluteString ?? "")")
        DEBUGLOG("📝 [REQUEST] Parameters => \(parameter)")
        #endif
        
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DEBUGLOG(data as Any)
            if let data = data {
                let httpResponse = response as? HTTPURLResponse
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DEBUGLOG(json)
                    
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(decodeType.self, from: data)
                    completion(model,httpResponse?.statusCode ?? 0,true)
                } catch {
                    DEBUGLOG(error)
                    completion(nil,httpResponse?.statusCode ?? 0,false)
                }
            }
        }.resume()
    }
}

extension APIService {
    public func makePostHeaderImageCall(url: String, parameters: [String: Any], isVideo: Bool = false, completionHandler: @escaping (AnyObject?,Int, NSError?) -> ()) {
        
        let token : String = UserDefaults.standard.value(forKey: "bearer_token") as? String ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        DEBUGLOG("API Name :::::::::::::::::: \(url)")
        DEBUGLOG("Parameters ::::::::::::::::::")
        DEBUGLOG(parameters)
        DEBUGLOG("::::::::::::::::::")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let image = value as? UIImage {
                        if image != UIImage(){
                            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: key,fileName: ".jpg", mimeType: "image/jpg")
                            
                        } else {
                            
                        }
                    } else if let image = value as? Data {
                        if isVideo {
                            multipartFormData.append(image, withName: key,fileName: ".mp4", mimeType: "video/mp4")
                        } else {
                            multipartFormData.append(image, withName: key,fileName: ".pdf", mimeType: "application/pdf")
                        }
                    }
                    else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            },
            to: url,
            method: HTTPMethod.post,
            headers: headers).responseData(queue: .main) { (response) in
                DEBUGLOG(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                switch response.result {
                    
                case .success(_):
                    if let value = response.value {
                        let statusCode = response.response?.statusCode ?? 0
                        if statusCode == 200 {
                            let dictString = String(decoding: value, as: UTF8.self)
//                            DEBUGLOG(dictString)
                            completionHandler(dictString as AnyObject, statusCode, nil)
                        } else{
                            let error = NSError(domain: "com.eezytutorials.iosTuts", code: (response.response?.statusCode)!, userInfo: ["Error reason" : "Invalid Outut"])
                            completionHandler(nil, statusCode, error)
                        }
                    }
                    
                case .failure(_):
                    let error = NSError(domain: "com.eezytutorials.iosTuts", code: (response.response?.statusCode ?? 0), userInfo: ["Error reason" : "Invalid Outut"])
                    completionHandler(nil, 100, error as NSError)
                }
            }
    }
}
