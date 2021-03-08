//
//  String+MNPath.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/21.
//

import Foundation

extension String{
    
    func mn_appendDocumentDir() -> String?{
        
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        let path = "/userInfo.json"
        return dir + path
    }
}
