//
//  MainTabController.swift
//  FinancialCalApp2
//
//  Created by Randimal Geeganage on 2022-04-08.
//

import Foundation
import UIKit

class MainTabController : UITabBarController {
    
    @IBOutlet weak var userInterfaceTabBarItem: UITabBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize:14)]
        
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        
        
    }
}
