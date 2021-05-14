//
//  MNWeiboCommon.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/17.
//

import UIKit

// MARK: - App infomation
let MNAppKey = "3653489348"

let MNAppSecret = "d19096bc6daa57b1f35860371c7ba41d"
// 登录完成-跳转的地址
let MNredirectUri = "https://api.weibo.com/oauth2/default.html"

//MARK: - global notification

let MNUserShouldLoginNotification = "MNUserShouldLoginNotification"

let UserLoginStateDidChangeNotification = "UserLoginStateDidChangeNotification"

let MNWeiboCellBrowserPhotoIndexKey = "MNWeiboCellBrowserPhotoIndexKey"
let MNWeiboCellBrowserPhotoURLsKeys = "MNWeiboCellBrowserPhotoURLsKeys"
let MNWeiboCellBrowserPhotoImageViewsKeys = "MNWeiboCellBrowserPhotoImageViewsKeys"


// iPhone X
let MN_iPhoneX = (UIScreen.sc.screenWidth >= 375 && UIScreen.sc.screenHeight >= 812)

// Status bar height.
let MN_statusBarHeight:CGFloat = MN_iPhoneX ? 44 : 20

let MN_naviContentHeight:CGFloat = 44

let MN_bottomTabBarContentHeigth:CGFloat = 49

let MN_bottomTabBarSpeacing:CGFloat = MN_iPhoneX ? 34 : 0

// Tabbar height.
let MN_bottomTabBarHeight:CGFloat  =  MN_iPhoneX ? (MN_bottomTabBarContentHeigth + MN_bottomTabBarSpeacing) : MN_bottomTabBarContentHeigth

// Status bar & navigation bar height.
var MN_naviBarHeight:CGFloat = MN_statusBarHeight + MN_naviContentHeight
