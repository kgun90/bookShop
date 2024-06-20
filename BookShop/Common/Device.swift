//
//  Device.swift
//  BookShop
//
//  Created by gkang on 6/14/24.
//

import UIKit

struct Device {
    // MARK: 노치 디자인인지 아닌지
    static var isNotch: Bool {
//        let scene = UIApplication.shared.delegate?.window.
        return Double(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? -1) > 0
    }
    
    // MARK: 상태바 높이
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    // MARK: 네비게이션 바 높이
    static var navigationBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.height
    }
    
    // MARK: 디바이스의 위쪽 여백 (Safe Area 위쪽 여백)
    static var topInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    
    // MARK: 디바이스의 아래쪽 여백 (Safe Area 아래쪽 여백)
    static var bottomInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    // ** 위쪽 여백의 전체 높이 : topInset + statusBarHeight + navigationBarHeight(존재하는 경우) **
    static var topHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }

    static var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.height
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func heightScale(_ size: CGFloat) -> CGFloat {
        return self.isNotch ? UIScreen.main.bounds.height * (size / 844) : UIScreen.main.bounds.height * (size / 667)
    }
    
    static func widthScale(_ size: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * (size / 390)
    }
}
