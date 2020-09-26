//
//  HeadlinesArticleLocalRepositoryTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import RxBlocking
import Alamofire
import Mocker
import XCTest

@testable import DutchNews

class HeadlinesArticleLocalRepositoryTests: XCTestCase {
    
    var articleRepository: ArticleRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        
        articleRepository = HeadlinesArticleLocalRepository(storage: RepositoryDependenciesFactory.createStorage())
        disposeBag = DisposeBag()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
        articleRepository = nil
    }
    
    func testSaveArticle() {
        
        let article = Article(title: "Mock 1",
                              author: "Unit Test",
                              description: "Mock object for unit test ",
                              source: ArticleSource(id: "", name: "DutchApps"),
                              url: URL(string: "https://example.com")!,
                              imageUrl: nil,
                              publishedAt: Date(),
                              content: "test content",type: .mock)
        
        do {
            try articleRepository.save(article: article)
            print("object saved successfully.")
        }catch {
            XCTFail("Error Occured in saving article with info: \(error.localizedDescription)")
        }
    }
    
    func testSaveArticles() {
        
        let articles = self.mockResponserFetcher(name: "HeadlineSuccessResponse")
        
        do {
            try articleRepository.save(articles: articles)
            print("articles saved successfully.")
        }catch {
            XCTFail("Error Occured in saving articles with info: \(error.localizedDescription)")
        }
        
    }
    
    func testErrorOnSaveArticle() {
        
        let article = Article(title: "Mock 2",
                              author: "Unit Test",
                              description: "Mock object for unit test ",
                              source: ArticleSource(id: "", name: "DutchApps"),
                              url: URL(string: "https://example.com")!,
                              imageUrl: nil,
                              publishedAt: Date(),
                              content: "test content",type: .mock)
        
        do {
            try articleRepository.save(article: article)
            try articleRepository.save(article: article)
            XCTFail("Expected that calling save method twise rise error.")
        }catch {
            XCTAssertNotNil(error, "An error must be occured.")
            print("Error was happened. Fulfill expecations")
        }
    }
    
    func testRealFetchArticles() {
        
        let exptection = self.expectation(description: "testRealFetchArticles")
        exptection.expectedFulfillmentCount = 1
        
        articleRepository.fetchArticles()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { (event) in
                switch event {
                case .next(let element):
                    print("element ", element)
                case .error(let error):
                    XCTFail("Error Occured with info: \(error.localizedDescription)")
                    exptection.fulfill()
                case .completed:
                    print("Observer completed")
                }
                
                exptection.fulfill()
                
            }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertTrue(error == nil, "Error Occured with info: \(error!.localizedDescription)")
        }
        
    }
    
    func testSearchingArticleFromLocalRepository() {
        
        let exptection = self.expectation(description: "testRealFetchArticles")
        exptection.expectedFulfillmentCount = 2
        
        articleRepository.search(keyword: "Mock")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { (event) in
                switch event {
                case .next(let element):
                    print("element ", element)
                case .error(let error):
                    XCTFail("Error Occured with info: \(error.localizedDescription)")
                    exptection.fulfill()
                case .completed:
                    print("Observer completed")
                }
                
                exptection.fulfill()
                
            }.disposed(by: disposeBag)
        
        articleRepository.search(keyword: "test").subscribe { (event) in
            switch event {
            case .next(let element):
                print("element ", element)
            case .error(let error):
                XCTFail("Error Occured with info: \(error.localizedDescription)")
                exptection.fulfill()
            case .completed:
                print("Observer completed")
            }
            
            exptection.fulfill()
            
        }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 20.0) { (error) in
            XCTAssertTrue(error == nil, "Error Occured with info: \(error!.localizedDescription)")
        }
        
    }
    
    func mockResponserFetcher(name: String) -> [Article] {
        let bundle = Bundle(for: type(of: self))
        
        guard let data = try? Data(contentsOf: bundle.url(forResource: name, withExtension: "json")!) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let objs = try? decoder.decode([Article].self, from: data) else {
            return []
        }
        
        return objs
        
    }
    
}
