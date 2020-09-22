//
//  Collection+Additionals.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

// MARK: - Equatable
extension Array where Element: Equatable {
    
    /// Remove first collection element that is equal to the given `object`
    ///
    /// - Parameter object: the object to remove from collection
    /// - Returns: if find object return true, otherwise return false
    @discardableResult
    mutating func remove(object: Element) -> Bool {
        if let index = firstIndex(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    /// Remove first collection element that predicate block return true
    ///
    /// - Parameter predicate: the predicate block
    /// - Returns: a true value if operation meet success, otherwise return false.
    @discardableResult
    mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.firstIndex(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    /// append the object which does not exist in the collection.
    ///
    /// - Parameter object: the object that insert into a collection.
    /// - Returns: a true value if operation meet success, otherwise return false.
    @discardableResult
    mutating func append(unique object: Element) -> Bool {
        guard contains(object) == false else {
            return false
        }
        
        append(object)
        return true
    }
    
}

extension Optional where Wrapped: Collection {
    
    /// indicate the current optional Collection is empty or not.
    var isEmpty: Bool {
        switch self {
        case .some(let collection):
            return collection.isEmpty
        case .none :
            return true
        }
    }
    
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/// append right dictionary into left dictionary
///
/// - Parameters:
///   - left: the `Dictionary` object that append.
///   - right: the `Dictionary` object insert into left collection.
func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (key, value) in right {
        left[key] = value
    }
}

///  Contact the two same dictionary into the new one.
///
/// - Parameters:
///   - left: the left operand `Dictionary` object.
///   - right: the right operand `Dictionray' object.
/// - Returns: <#return value description#>
func + <K, V>(left: [K: V], right: [K: V]) -> [K: V] {
    var newValue = left
    newValue += right
    return newValue
}
