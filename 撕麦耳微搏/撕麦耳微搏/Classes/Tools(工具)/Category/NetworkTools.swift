import UIKit
import Alamofire


/// 定义枚举
///
/// - GET: GET请求方式
/// - POST: POST请求方式
enum methodType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools : NSObject {
//    创建单例
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()

        return tools
    }()
}

//    MARK:- 网络请求
extension NetworkTools {
    func request(methodType : methodType, urlString : String, parameters : [String : AnyObject]? = nil, finishCallBack : @escaping (_ result : AnyObject?, _ error : Error?) -> ()) {
        
        let method = methodType == .GET ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
            guard let result = response.result.value else {
                SiMaiEr_Log(message: response.result.error)
                return
            }
            finishCallBack(result as AnyObject, nil)
        }
    }
}

//    MARK:- 请求AccessToken
extension NetworkTools {
    func loadAccessToken(code :String, finished : @escaping (_ result : [String : AnyObject]?, _ error : Error?) -> ()) {
//        1.获取请求的urlString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
//        2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        SiMaiEr_Log(message: parameters)
        
//        3.发送网络请求
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject], error)
            SiMaiEr_Log(message: result)
        }
        
        
    }
}

//    MARK:- 请求用户信息
extension NetworkTools {
    func loadUserInfo(access_token : String, uid : String, finished : @escaping (_ result : [String : AnyObject]?, _ error : Error?) -> ()) {
//        1.获取请求的urlString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
//        2.获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
//        3.发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject], error)
            SiMaiEr_Log(message: result)
        }
    }
}

//    MARK:- 请求首页数据
extension NetworkTools {
    func loadStatuses(since_id : Int ,max_id : Int,finished : @escaping (_ result : [[String : AnyObject]]?, _ error : Error?) -> ()) {
//        1.获取请求的urlString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
//        2.获取请求的参数
        let accessToken = (UserAccountViewModel.shareIntance.account?.access_token)!
        
        let parameters = ["access_token" : accessToken, "since_id" : "\(since_id)","max_id" : "\(max_id)"]
        SiMaiEr_Log(message: parameters)
        
//        3.发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            
//            1.获取字典属性
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil,error)
                return
            }
//            2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
            
        }
        
        
    }
}

//    MARK:- 发送微博
extension NetworkTools {
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
//        1.获取请求的UrlString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
//        2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)! , "status" : statusText]
        
//        3.发送网络请求
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            if result != nil {
                isSuccess(true)
                SiMaiEr_Log(message: result)
            }else {
                isSuccess(false)
            }
        }
        
    }
}

//    MARK:- 发送微博并且携带照片
extension NetworkTools {
    func sendStatus(statusText : String, image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
//        1.获取请求的urlString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
//        2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)! , "status" : statusText]
        
//        3.发送网络请求
        Alamofire.upload(multipartFormData: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.append(imageData, withName: "pic", fileName: "123.png", mimeType: "image/png")
                for (key , value) in parameters {
                    formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: nil) { (encodingResult) in
            switch encodingResult {
            case.success(let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                   isSuccess(true)
                })
            case .failure(let encodingError):
                SiMaiEr_Log(message: encodingError)
            }
            
        }
        
        
    }
}
