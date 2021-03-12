//
//  UserProfileViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/5.
//

import UIKit

class UserProfileViewModel {
    var tabViewModels = [UserProfileTabViewModel]()
    
    
    init() {
        
        tabViewModels.append(UserProfileStatusTabViewModel.init())
        tabViewModels.append(UserProfileStatusTabViewModel.init())
        tabViewModels.append(UserProfileStatusTabViewModel.init())
    }
}
