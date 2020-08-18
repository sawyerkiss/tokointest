//
//  APIServiceTests.swift
//  MVVMPlaygroundTests
//
//  Created by Neo on 01/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
@testable import tokointest

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_top_headline() {

        // Given A apiservice
        let sut = self.sut!

        let expect = XCTestExpectation(description: "callback")

        sut.fetchAllArticles(complete: { (success, articles, error) in
            expect.fulfill()
            XCTAssertEqual( articles.count, 16)
            for article in articles {
                XCTAssertNotNil(article.title)
            }
            
        })

        wait(for: [expect], timeout: 3.1)
    }
    
    func test_specific_articles() {
        fetch_specific_articles(subject: "bitcoin", count: 20)
        fetch_specific_articles(subject: "earthquake", count: 17)
        fetch_specific_articles(subject: "animal", count: 15)
        fetch_specific_articles(subject: "apple", count: 14)
    }
    
    func fetch_specific_articles(subject: String, count:Int) {

           // Given A apiservice
           let sut = self.sut!

           let expect = XCTestExpectation(description: "callback")

           sut.fetchSpecificArticles(subject: subject,complete: { (success, articles, error) in
               expect.fulfill()
               XCTAssertEqual( articles.count, count)
               for article in articles {
                   XCTAssertNotNil(article.title)
               }
               
           })

           wait(for: [expect], timeout: 3.1)
       }
    
}
