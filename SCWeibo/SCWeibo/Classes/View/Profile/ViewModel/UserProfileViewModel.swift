//
//  UserProfileViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/5.
//

import UIKit

class UserProfileViewModel {
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
        tabViewModels.append(UserProfileStatusTabViewModel.init())
        tabViewModels.append(UserProfileStatusTabViewModel.init())
    }
}
