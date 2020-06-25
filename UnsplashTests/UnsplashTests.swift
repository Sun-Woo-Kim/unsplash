//
//  UnsplashTests.swift
//  UnsplashTests
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import XCTest
import RxSwift
@testable import Unsplash

class UnsplashTests: XCTestCase {

    var searchViewModel: SearchViewModel?
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        searchViewModel = SearchViewModel()

    }

    override func tearDown() {
        searchViewModel = nil
        disposeBag = DisposeBag()
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchAPI() throws {

        let expt = expectation(description: "Waiting done Search API...")

        NetworkManager.getPhotoSearchInfo(request: .init(page: 1, query: "office"))
            .asObservable()
            .subscribe(
                onNext: { response in
                    XCTAssertNotNil(response)
                    expt.fulfill()
                },
                onError: { error in
                    XCTAssertNil(error)
                    XCTAssertThrowsError(error)
                }
        ).disposed(by: disposeBag)

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetListAPI() throws {

        let expt = expectation(description: "Waiting done List API...")

        NetworkManager.getPhotoListInfo()
            .asObservable()
            .subscribe(
                onNext: { results in
                    XCTAssertNotNil(results)
                    XCTAssertTrue(results.count > 0)
                    expt.fulfill()
            },
                onError: { error in
                    XCTAssertNil(error)
            }
        ).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
