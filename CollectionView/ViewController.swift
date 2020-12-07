//
//  ViewController.swift
//  CollectionView
//
//  Created by Yeliz Keçeci on 29.11.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    let gameManager = GameManager()
    
    var showTimer = Timer()
    var hideTimer = Timer()
    var gameTimer = Timer()
    var randomPosition = 0
    var storedHighScore = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }
    
    func checkGameEnded() {
        if gameManager.counter == 0 {
            timeLabel.text = "Game Over"
            self.showTimer.invalidate()
            self.hideTimer.invalidate()
            gameTimer.invalidate()
            
            let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.restartGame()
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startGame() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timers in
            timeLabel.text = "Time : \(gameManager.counter)"
            gameManager.counter -= 1
            checkGameEnded()
        })
        
        startTimer()
        storedHighScore = defaults.integer(forKey: "highScore")
        highScoreLabel.text = "High Score : \(storedHighScore)"
    }
    
    func restartGame() {
        scoreLabel.text = "Score : 0"
        gameManager.initializeGame()
        startGame()
    }
    func startTimer(){
        showTimer = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: true, block: { [self] timers in
            gameManager.showRandomPosition()
            self.collectionView.reloadData()
            hideTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [self] timers in
                gameManager.hideSelectedPosition()
                self.collectionView.reloadData()
            })
            
        })
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameManager.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageItem = gameManager.images[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = imageItem.image
        cell.imageView.isHidden = imageItem.isHidden
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameManager.tappedOn(indexPath: indexPath)
        scoreLabel.text = "Score \(gameManager.score)"
        
        if gameManager.score > storedHighScore {
            defaults.set(gameManager.score, forKey: "highScore")
        }
    }
}
