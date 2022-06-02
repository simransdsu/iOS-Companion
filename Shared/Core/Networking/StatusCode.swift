import Foundation

enum StatusCode : Int {
    case InvalidURL = -1002
    case Timeout = -1001
    case JSONParsing = -1
    case Reachability = 0
    case OK = 200
    case BadRequest = 400
    case Unauthorized = 401
    case InvalidCredentials = 403
    case NotFound = 404
    case SomethingElse
}
