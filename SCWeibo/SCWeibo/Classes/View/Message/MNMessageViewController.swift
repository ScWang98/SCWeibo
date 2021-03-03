//
//  MNMessageViewController.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/10.
//

import UIKit

class MNMessageViewController: MNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl?.endRefreshing()
        }
    }
}
