//
//  HeadlinesArticleRemoteRepositoryTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import Alamofire
import Mocker

@testable import DutchNews

class HeadlinesArticleRemoteRepositoryTests: XCTestCase {
    
    var articleRepository: ArticleRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        
        articleRepository = HeadlinesArticleRemoteRepository(networkService: RepositoryDependenciesFactory.createMockAPIClient(),
                                                             authentictor: RepositoryDependenciesFactory.createAuthentictor(),
                                                             validator: RepositoryDependenciesFactory.createValidator())
        disposeBag = DisposeBag()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
        articleRepository = nil
    }
    
    func testFetchMockArticles() {
        do {
            let exptection = self.expectation(description: "testFetchMockArticles")
            exptection.expectedFulfillmentCount = 2
            
            let data = mockResponserFetcher(name: "HeadlineSuccessResponse")
            let mock = try NetworkMockBuilder(URL: "https://newsapi.org/v2/top-headlines?country=nl")
                .set(method: .get)
                .set(statusCode: 200)
                .set(contentType: .json)
                .set(data: [.get: data])
                .build()
            
            Mocker.register(mock)
            
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
                XCTAssertNil(error, "Error Occured with info: \(error!.localizedDescription)")
            }
            
        } catch let error {
            XCTFail("Error Occured with info: \(error.localizedDescription)")
        }
    }
    
    func testErrorOnFetchMockArticles() {
        do {
            let exptection = self.expectation(description: "testErrorOnFetchMockArticles")
            exptection.expectedFulfillmentCount = 2
            let data = mockResponserFetcher(name: "HeadlineFailureResponse")
            let mock = try NetworkMockBuilder(URL: AppConfig.BaseURL.absoluteString + "top-headlines?country=nl")
                .set(method: .get)
                .set(statusCode: 401)
                .set(contentType: .json)
                .set(data: [.get: data])
                .build()
            
            Mocker.register(mock)
            
            articleRepository.fetchArticles()
                .observeOn(MainScheduler.asyncInstance)
                .subscribe { (event) in
                    
                    switch event {
                    case .next(let element):
                        XCTFail("Stream emitted Element: \(element)")
                    case .error(let error):
                        print("Error Occured with info: \(error.localizedDescription)")
                        exptection.fulfill()
                    case .completed:
                        print("Observer completed")
                    }
                    
                    exptection.fulfill()
                }.disposed(by: disposeBag)
            
            self.waitForExpectations(timeout: 30.0) { (error) in
                XCTAssertNil(error, "Error Occured with info: \(error!.localizedDescription)")
            }
            
        } catch let error {
            XCTFail("Error Occured with info: \(error.localizedDescription)")
        }
    }
    
    func testRealFetchArticles() {
        
        let exptection = self.expectation(description: "testRealFetchArticles")
        exptection.expectedFulfillmentCount = 2
        
        let articleRepository = HeadlinesArticleRemoteRepository(networkService: RepositoryDependenciesFactory.createAPIClient(),
                                                                 authentictor: RepositoryDependenciesFactory.createAuthentictor(),
                                                                 validator: RepositoryDependenciesFactory.createValidator())
        
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
            XCTAssertNil(error, "Error Occured with info: \(error!.localizedDescription)")
        }
        
    }
    
    func testErrorOnFetchArticles() {
        let exptection = self.expectation(description: "testErrorOnFetchArticles")
        exptection.expectedFulfillmentCount = 2
        
        let articleRepository = HeadlinesArticleRemoteRepository(networkService: RepositoryDependenciesFactory.createAPIClient(),
                                                                 authentictor: APIAuthenticator(token: ""),
                                                                 validator: RepositoryDependenciesFactory.createValidator())
        
        articleRepository.fetchArticles()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { (event) in
                
                switch event {
                case .next(let element):
                    XCTFail("Stream emitted Element: \(element)")
                case .error(let error):
                    print("Error Occured with info: \(error.localizedDescription)")
                    exptection.fulfill()
                case .completed:
                    print("Observer completed")
                }
                
                exptection.fulfill()
            }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertNil(error, "Error Occured with info: \(error!.localizedDescription)")
        }
        
    }
    
    func mockResponserFetcher(name: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        return try! Data(contentsOf: bundle.url(forResource: name, withExtension: "json")!)
    }
    
}
