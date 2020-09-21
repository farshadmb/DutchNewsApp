//
//  AlertableView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import MaterialComponents
import UIKit

/// Abstract `AlertableView`
protocol AlertableView: class {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - message: <#message description#>
    ///   - actionTitle: <#actionTitle description#>
    ///   - actionHandler: <#actionHandler description#>
    func presentAlert(message: String, actionTitle: String?, actionHandler:@escaping () -> Void)
}

// Abstract `AlertableView` impelementation
extension AlertableView {
    
    func presentAlert(message: String, actionTitle: String?, actionHandler:@escaping () -> Void) {
        let alert = MDCSnackbarMessage(text: message)
        
        // if actionTitle has a value, create snackbar action and assign to alert
        if let actionTitle = actionTitle {
            alert.action = MDCSnackbarMessageAction()
            alert.action?.title = actionTitle
            alert.action?.handler = actionHandler
        }
        
        MDCSnackbarManager.show(alert)
    }
}
