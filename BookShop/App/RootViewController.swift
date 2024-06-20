//
//  RootViewController.swift
//  BookShop
//
//  Created by gkang on 6/10/24.
//

import UIKit


class RootViewController: UIViewController {
    private let searchViewController = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interface()
    }

    private func setup() {
        addChild(searchViewController)
        view.addSubview(searchViewController.view)
    }
    
    private func interface() {
        
    }
}

