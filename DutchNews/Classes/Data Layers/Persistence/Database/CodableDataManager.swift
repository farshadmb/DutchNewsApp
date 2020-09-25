//
//  RealmDataManager.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import CryptoSwift

/// The `CodableDataManager` class extended and implemented `Storage` abstract.
/// The Default DataManager of this application.
class CodableDataManager: Storage {
    
    /// Rhe default instace of `CodableDataManager`
    static let `default` = CodableDataManager(fileProvider: .default)
    
    /// The Stored fileURL object.
    private let fileURL: URL
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    /// Constructor
    ///
    /// - Parameter fileProvider: the file provider options
    init(fileProvider: FileProvider) {
        
        self.fileURL = fileProvider.url
        
        decoder.dateDecodingStrategy = .iso8601
        decoder.dataDecodingStrategy = .base64
        
        encoder.dateEncodingStrategy = .iso8601
        encoder.dataEncodingStrategy = .base64
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
    }
    
    deinit {
        
    }
    
    // MARK: - Storage Implementation methods
    
    func create<T>(_ model: T.Type, completion: @escaping (T) -> Void) throws where T: Storable {
        fatalError("not implemented for demo")
    }
    
    func save<T: Storable>(object: T) throws {
        
        let data = try encoder.encode(object)
        try data.write(to: makeFileURL(for: object),options: [.withoutOverwriting])
    }
    
    func update<T: Storable> (object: T) throws {
        let data = try encoder.encode(object)
        try data.write(to: makeFileURL(for: object))
    }
    
    func delete(object: Storable) throws {
        fatalError("not implemented for demo")
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T: Storable {
        fatalError("not implemented for demo")
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sort: Sort?, completion: @escaping ([T]) -> Void) throws where T: Storable {
        
        let url = self.fileURL
        perform(onQueue: .global(qos: .utility), block: {[weak self] in
            
            let fileManager = FileManager.default
            guard let list = fileManager.enumerator(at: url,
                                                    includingPropertiesForKeys: [],
                                                    options: [.skipsHiddenFiles],
                                                    errorHandler: { (url,error) -> Bool in
                                                        Logger.errorLog("Error \(error) for url \(url)", tag: "FileManager")
                                                        return true
            }) else {
                self?.perform {
                    completion([])
                }
                return
            }
            
            let result = list.compactMap({ $0 as? URL })
            
            var objects = [T]()
            for path in result {
                
                guard let data = try? Data(contentsOf: path), let objc = try? self?.decoder.decode(type, from: data) else {
                    continue
                }
                
                objects.append(objc)
            }
            
            let output = objects.filter({ predicate?.evaluate(with: $0) ?? true })
            
            self?.perform {
                completion(output)
            }
        })
        
    }
    
    private func makeFileURL<T: Storable> (for obj: T) -> URL {
        
        let fileName = "\(obj.primaryKeyValue().md5())-\(String(describing: T.self)).json"
        let url = fileURL.appendingPathComponent(fileName)
        return url
    }
    
    private func perform(onQueue queue: DispatchQueue = .main,
                         block workItem:@escaping () -> Void) {
        
        guard DispatchQueue.current !== queue else {
            workItem()
            return
        }
        
        queue.async(execute: workItem)
        
    }
    
}

extension CodableDataManager {
    
    enum FileProvider {
        case `default`
        case custom(url: URL)
        
        fileprivate var url: URL {
            
            let fileURL: URL
            switch self {
            case .default:
                
                guard let url = try? URL.applicationSupportDirectoryURL() else {
                    return URL(fileURLWithPath: "", isDirectory: true)
                }
                
                fileURL = url
                
            case .custom(let url):
                fileURL = url
            }
            
            return fileURL
        }
        
    }
    
}
