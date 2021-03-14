//
//  MNNetworkManager+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/15.
//

import Foundation
import Alamofire

//For SCWeibo App request
extension MNNetworkManager{
    
    /// fetch home page datas
    /// - Parameters:
    ///   - since_id: 返回比since_id 晚的微博，默认为0(最新) ==> 上拉刷新
    ///   - max_id: 返回 <= max_id 的微博，默认为0
    ///   - completion: 请求完成的回调
    func fetchHomePageList(since_id:Int = 0, max_id:Int = 0, completion:@escaping (_ isSuccess: Bool,_ list:[[String:AnyObject]]?) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        //max_id - 1 ==> 不然会出现两条一模一样的记录
        let maxidValue = max_id > 0 ? max_id - 1 : 0
        let parms = ["since_id":since_id,"max_id": maxidValue]
        
        tokenRequest(URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            let jsonObject = json as?[String:Any]
            let result = jsonObject?["statuses"] as? [[String:AnyObject]]

            completion(isSuccess, result)
        }
    }
    
    // 模拟未读消息
    func unreadCount(completion:@escaping (_ count: Int)->()){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let count = 3
            completion(count)
        }
    }
}

/// MARK: - 发布微博
extension MNNetworkManager{
    
    func createStatus(text: String, completion:@escaping (_ result:[String: Any]?, _ isSuccess: Bool) -> ()) {
        
        //FIXME: 发布接口==>高级写入接口,要权限申请.
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parms = ["status":text]
        
        tokenRequest(method: .POST, URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            
            completion(json as? [String:Any], isSuccess)
        }
    }
}
