//
//  MisonicUITests.swift
//  MisonicUITests
//
//  Created by Kostia Kolesnyk on 10/10/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import XCTest

class MisonicUITests: XCTestCase {

    lazy var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSearchButton_ShouldOpenSearch() {
        let searchButtonID = app.navigationBars.buttons["searchButton"]
        XCTAssertTrue(searchButtonID.exists)
        searchButtonID.tap()
        
        // Check Search results table view on screen
        let searchViewID = app.otherElements["SearchScreenView"]
        XCTAssertTrue(searchViewID.exists)
        
    }
    
    func testSearchBarEnter_FindArtists() {
        let searchButtonID = app.navigationBars.buttons["searchButton"]
        XCTAssertTrue(searchButtonID.exists)
        searchButtonID.tap()
        
        // Check search bar on screen
        sleep(1)
        let searchBar = app.otherElements["SearchBar"]
        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("The Doors")
        
        sleep(10)
        
        let tableView = app.tables["ResultsTableView"]
        XCTAssertTrue(tableView.exists)
        XCTAssertTrue(tableView.children(matching: .cell).count > 0)
    }

}
