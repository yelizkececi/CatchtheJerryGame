//
//  GameManagerTests.swift
//  CollectionViewTests
//
//  Created by Yeliz Keçeci on 5.12.2020.
//

import XCTest
@testable import CollectionView

class GameManagerTests: XCTestCase {
    
    var game: GameManager!
    
    override func setUp() {
        super.setUp()
        
        game = GameManager()
    }
    
    func testInitializeGame() {
        XCTAssertEqual(game.counter, 20)
        XCTAssertEqual(game.images.count, 9)
        XCTAssertEqual(game.score, 0)
    }
    
    func testShowAndHideRandomPosition() {
        game.showRandomPosition()
        let nonHiddenImages = game.images.filter {
            !$0.isHidden
        }
        XCTAssertEqual(nonHiddenImages.count, 1)
        
        game.hideSelectedPosition()
        let nonHiddenImagesAfterHide = game.images.filter {
            !$0.isHidden
        }
        XCTAssertEqual(nonHiddenImagesAfterHide.count, 0)
    }
    
    func testTappedOnSuccessful() {
        game.showRandomPosition()
        
        let selectedIndex = game.images.firstIndex(where: {
            !$0.isHidden
        })!
        
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        game.tappedOn(indexPath: selectedIndexPath)
        XCTAssertEqual(game.score, 10)
    }
    
    func testTappedOnWrong() {
        game.showRandomPosition()
        
        let nonselectedIndex = game.images.firstIndex(where: {
            $0.isHidden
        })!
        
        let nonselectedIndexPath = IndexPath(row: nonselectedIndex, section: 0)
        game.tappedOn(indexPath: nonselectedIndexPath)
        XCTAssertEqual(game.score, -5)
    }
    
    func testTappedAfterHidden() {
        game.showRandomPosition()
        
        let selectedIndex = game.images.firstIndex(where: {
            !$0.isHidden
        })!
        
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        game.hideSelectedPosition()
        game.tappedOn(indexPath: selectedIndexPath)
        XCTAssertEqual(game.score, -5)
    }
}
