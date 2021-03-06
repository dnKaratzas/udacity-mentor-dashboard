/*
 * Copyright 2018 Dionysios Karatzas
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case Me
    case SubmissionsCompleted
    case SubmissionsAssigned
    case StudentFeedback(id: String)
    case PeerFeedback(id: String)
    case TotalEarnings
    case Earnings(stardDate: String, endDate: String)
    case Statements

    var method: HTTPMethod {
        switch self {
        case .Me, .SubmissionsCompleted, .SubmissionsAssigned, .PeerFeedback, .StudentFeedback, .TotalEarnings, .Earnings, .Statements:
            return .get
        }
    }

    var path: String {
        switch self {
        case .Me:
            return UdacityApi.Routes.Me.Me
        case .SubmissionsCompleted:
            return UdacityApi.Routes.Me.SubmissionsCompleted
        case .SubmissionsAssigned:
            return UdacityApi.Routes.Me.SubmissionsAssigned
        case .StudentFeedback(let id):
            return String(format: UdacityApi.Routes.Me.StudentFeedback, id)
        case .PeerFeedback(let id):
            return String(format: UdacityApi.Routes.Me.PeerFeedback, id)
        case .TotalEarnings:
            return UdacityApi.Routes.Me.TotalEarnings
        case .Earnings(let stardDate, let endDate):
            return String(format: UdacityApi.Routes.Me.Earnings, stardDate, endDate)
        case .Statements:
            return String(format: UdacityApi.Routes.Me.Statements)
        }
    }

    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }

    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: UdacityApi.EndPoint + path)!)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue("Bearer \(UdacityApi.Token)", forHTTPHeaderField: "Authorization")

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }


}
