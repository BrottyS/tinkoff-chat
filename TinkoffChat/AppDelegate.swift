//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.09.17.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    
    private var timer = Timer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.conversationListAssembly.conversationListViewController()
        let navController = UINavigationController(rootViewController: controller)
        //navController.addChildViewController(controller)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        longPressGesture.minimumPressDuration = 0.1
        window?.addGestureRecognizer(longPressGesture)
        
        return true
    }
    
    @objc func didLongPress(longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began, .changed:
            let tapPoint = longPressGesture.location(in: topView())
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(showLogo), userInfo: ["TapPoint": tapPoint], repeats: false)
        case .ended, .cancelled:
            timer.invalidate()
        default:
            break
        }
    }
    
    @objc func showLogo(sender: Timer) {
        if let userInfo = sender.userInfo as? [String: Any],
            let tapPoint = userInfo["TapPoint"] as? CGPoint {
            let logoView = LogoView(frame: CGRect(x: tapPoint.x, y: tapPoint.y, width: 20, height: 20))
            
            if let view = topView() {
                view.addSubview(logoView)
                logoView.animate()
            }
        }
    }
    
    private func topView() -> UIView? {
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            
            return topViewController.view
        }
        
        return nil
    }

}

