//
//  StatusDetailViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import Foundation

class StatusDetailViewModel {
    var tabViewModels = [UserProfileTabViewModel]()
    
    var tabNames: [String] {
        var names = [String]()
        for tab in tabViewModels {
            names.append(tab.tabName)
        }
        return names
    }
    
    
    init() {
        
        tabViewModels.append(UserProfileStatusTabViewModel.init())
        tabViewModels.append(UserProfileVideosTabViewModel.init())
        tabViewModels.append(UserProfilePhotosTabViewModel.init())
    }
}
