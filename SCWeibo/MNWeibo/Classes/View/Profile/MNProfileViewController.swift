//
//  MNProfileViewController.swift
//  MNWeibo
//
//  Created by miniLV on 2020/3/10.
//  Copyright © 2020 miniLV. All rights reserved.
//

import UIKit
import FLEX

class MNProfileViewController: MNBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl?.endRefreshing()
        }
        
        naviItem.rightBarButtonItem = UIBarButtonItem(title: "FLEX", fontSize: 16, target: self, action: #selector(showFLEX))
    }
    
    @objc func showFLEX() {
//        if FLEXManager.shared.isHidden {
//            FLEXManager.shared.showExplorer()
//        }
//        else {
//            FLEXManager.shared.hideExplorer()
//        }
        let vc = UserProfileViewController.init()
        self.present(vc, animated: true, completion: nil)
    }
}
