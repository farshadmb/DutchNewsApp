//
//  ArticlesPageViewController.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/23/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Pageboy

class ArticlePageViewController: PageboyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interPageSpacing = 8.0
        self.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ArticlePageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        10
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        let id = String(describing: ArticleDetailViewController.self)
        if #available(iOS 13.0, *) {
            return self.storyboard?.instantiateViewController(identifier: id)
        } else {
            return self.storyboard?.instantiateViewController(withIdentifier: id)
        }
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
}
