//
//  ViewModelState.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

enum ViewModelState {
    
    case idle
    case loading(isRefreshing: Bool)
    case loaded
    case error(Error)
    
}

extension ViewModelState: Hashable {
    
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (idle,idle),
             (loaded,loaded):
            return true
        case (error(let lhs),error(let rhs)) where type(of: lhs.self) == type(of: rhs.self):
            return true
        case (loading(isRefreshing: let lValue),loading(isRefreshing: let rValue)) where rValue == lValue:
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
}
