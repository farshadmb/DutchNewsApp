//
//  Storage.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

/// CreatableStorage Abstract
protocol CreatableStorage {
    
    /// Create a new object with default values
    ///
    /// - Parameters:
    ///   - model: the type of object
    ///   - completion: a completion block that return an object that is conformed to the `Storable` protocol.
    /// - Throws: throw an error object which describe more about occured error.
    func create<T: Storable>(_ model: T.Type, completion:@escaping (T) -> Void) throws
}

/// SavableStorage Abstract
protocol SavableStorage {
    
    /// Save an object that is conformed to the `Storable` protocol
    ///
    /// - Parameter object: an object that is conformed to the `Storable`.
    /// - Throws: throw an error when saving operation has been failed.
    func save<T: Storable>(object: T) throws
}

/// UpdatableStorage Abstract
protocol UpdatableStorage {
    
    /// Update the object which is conformed to the `Storable` protocol.
    ///
    /// - Parameter object: the `Storable` conformed object.
    /// - Throws: throw the proper error when update failed.
    func update<T: Storable>(object: T) throws
}

/// DeletableStorage Abstract
protocol DeletableStorage {
    
    /// Delete an object that is conformed to the `Storable` protocol
    ///
    /// - Parameter object: <#object description#>
    /// - Throws: throw an error when operation failed.
    func delete(object: Storable) throws
    
    /// Delete an object that is conformed to the `Storable` protocol
    ///
    /// - Parameter object: the storable object
    /// - Throws: throw an error when operation failed.
    func delete(object: [Storable]) throws
    
    /// Delete all objects that are conformed to the `Storable` protocol
    ///
    /// - Parameter model: <#model description#>
    /// - Throws: throw an error when operation failed.
    func deleteAll<T: Storable> (_ model: T.Type) throws
}

/// Abstract `DeletableStorage`
extension DeletableStorage {
    
    func delete(object: [Storable]) throws {
        // make delete object method to optional.
    }
}

/// Abstract `FetchableStorage`
protocol FetchableStorage {
    
    /// The `Sort` type contain `key` and `ascending` object
    typealias Sort = (key: String, ascending: Bool)
    
    ///  Fetch and return a list of objects that are conformed to the `Storable` protocol.
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - predicate: The predicate object of 'NSPredicate'
    ///   - sort: An sort value which the result sorts base on.
    ///   - completion: The completion block return a list of objects that are conformed to the `Storable` protocol
    /// - Throws: <#throws value description#>
    func fetch<T: Storable> (type: T.Type, predicate: NSPredicate?, sort: Sort?, completion:@escaping ([T]) -> Void) throws
}

/// The `Storage` Type combine all abstracts in this file.
typealias Storage = CreatableStorage & SavableStorage & UpdatableStorage & DeletableStorage & FetchableStorage
