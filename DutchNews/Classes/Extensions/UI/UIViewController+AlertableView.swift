//
//  UIViewController+AlertableView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewController extension for AlertableView Abstract.
extension AlertableView where Self: UIViewController {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - message: <#message description#>
    ///   - actionTitle: <#actionTitle description#>
    ///   - actionHandler: <#actionHandler description#>
    func presentAlertView(withMessage message: String, actionTitle: String? = nil, actionHandler: @escaping () -> Void = {}) {
        presentAlert(message: message, actionTitle: actionTitle, actionHandler: actionHandler)
    }
    
}
