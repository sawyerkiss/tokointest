//
//  tokointestTests.swift
//  tokointestTests
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import XCTest
@testable import tokointest

class tokointestTests: XCTestCase {
    
    var sut: ArticleListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockAPIService = MockApiService()
        sut = ArticleListViewModel(apiService: mockAPIService)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_articles() {
        // Given
        mockAPIService.completeArticles = [Article]()
        
        // When
        sut.initFetchAllArticles()
        
        // Assert
        XCTAssert(mockAPIService!.isFetchArticlesCalled)
    }
    
    func test_fetch_articles_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied
        
        // When
        sut.initFetchAllArticles()
        
        mockAPIService.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }
    
    func test_create_cell_view_model() {
        // Given
        let articles = StubGenerator().stubArticles()
        mockAPIService.completeArticles = articles
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.initFetchAllArticles()
        mockAPIService.fetchSuccess()
        
        // Number of cell view model is equal to the number of Articles
        XCTAssertEqual( sut.numberOfCells, articles.count )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_loading_when_fetching() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetchAllArticles()
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        // When finished fetching
        mockAPIService!.fetchSuccess()
        XCTAssertFalse( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_user_press_article_item() {
        
        //Given a sut with fetched Articles
        let indexPath = IndexPath(row: 0, section: 0)
        goToFetchArticlesFinished()
        
        //When
        sut.userPressed( at: indexPath )
        
        //Assert
        XCTAssertTrue( sut.isAllowSegue )
        XCTAssertNotNil( sut.selectedArticle )
        
    }
    
    func test_get_cell_view_model() {
        
        //Given a sut with fetched articles
        goToFetchArticlesFinished()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testArticle = mockAPIService.completeArticles[indexPath.row]
        
        // When
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.author, testArticle.author)
        
    }
    
    func test_cell_view_model() {
        let article = Article(dict: ["author":"author", "title":"title", "url":"url", "urlToImage":"urlToImage","description":"description","publishedAt":"publishedAt","content":"content"])
        let articleWithouAuthorAndDesc = Article(dict: ["author": nil, "title":"title", "url":"url", "urlToImage":"urlToImage","description": nil,"publishedAt":"publishedAt","content":"content"])
        
        // When creat cell view model
        let cellViewModel = sut!.createCellViewModel( article: article )
        let cellViewModelWithoutAuthorAndDesc = sut!.createCellViewModel( article: articleWithouAuthorAndDesc )
        
        // Assert the correctness of display information
        XCTAssertEqual( article?.author, cellViewModel.author )
        XCTAssertEqual( article?.urlToImage, cellViewModel.urlToImage )
        
        XCTAssertEqual(cellViewModel.description, article?.description)
        XCTAssertEqual(cellViewModelWithoutAuthorAndDesc.description, "" )
        XCTAssertEqual( cellViewModel.publishedAt, article?.publishedAt )
    }
    
}

//MARK: State control
extension tokointestTests {
    private func goToFetchArticlesFinished() {
        mockAPIService.completeArticles = StubGenerator().stubArticles()
        sut.initFetchAllArticles()
        mockAPIService.fetchSuccess()
    }
}

class MockApiService: APIServiceProtocol {
    
    var isFetchArticlesCalled = false
    
    var completeArticles: [Article] = [Article]()
    var completeClosure: ((Bool, [Article], APIError?) -> ())!
    
    func fetchAllArticles(complete: @escaping (Bool, [Article], APIError?) -> Void) {
        isFetchArticlesCalled = true
        completeClosure = complete
    }
    
    func fetchSpecificArticles(subject: String, complete: @escaping (Bool, [Article], APIError?) -> Void) {
        isFetchArticlesCalled = true
        completeClosure = complete
    }
    
    func fetchSuccess() {
        completeClosure( true, completeArticles, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completeArticles, error )
    }
    
}

class StubGenerator {
    func stubArticles() -> [Article] {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let articles = try! decoder.decode(Articles.self, from: data)
        return articles.articles
    }
}

