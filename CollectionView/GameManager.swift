//
//  GameManager.swift
//  CollectionView
//
//  Created by Yeliz Keçeci on 2.12.2020.
//

import UIKit

class GameManager {
    private let characterIcon: UIImage = UIImage(named: "jerry")!
    var images: [ImageItem] = []
    var counter = 5
    var score = 0
    private var selectedPosition: Int?
    
    init() {
        initializeGame()
    }
    
    func initializeGame() {
        for _ in 0...9 {
            images.append(ImageItem(image: characterIcon, isHidden: true))
        }
        
        selectedPosition = nil
        score = 0
        counter = 20
    }
    
    func showRandomPosition() {
        let randomPosition = Int.random(in: 0..<9)
        selectedPosition = randomPosition
        images[randomPosition].isHidden = false
    }
    
    func hideSelectedPosition() {
        guard let selectedPosition = selectedPosition else { return }
        images[selectedPosition].isHidden = true
    }

    func tappedOn(indexPath: IndexPath) {
        guard let selectedPosition = selectedPosition else { return }
        if selectedPosition == indexPath.row && !images[selectedPosition].isHidden {
            score += 10
        } else {
            score -= 5
        }
    }
}
