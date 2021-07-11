//
//  Game.swift
//  Xib
//
//  Created by Владислав on 21.06.2021.
//

import Foundation


enum GameStatus {
    case start
    case win
}

class Game {
    
    struct Item {
        var tittle: String
        var isFound: Bool
        var isError: Bool
    }
    
    private let numbers = Array(1...16)
    var items:[Item] = []
    private var countItems:Int
    var nextItem:Int = 1
    var gameStatus:GameStatus = .start
    var timer:Timer?
    private var currentTime:Double = 0.000 {
        didSet {
            updateTimer(currentTime)
        }
    }
    
    private var updateTimer:((Double) -> Void)
    
    init(countItems:Int, time:Double, updateTimer: @escaping (_ time:Double) -> Void) {
        self.countItems = countItems
        self.updateTimer = updateTimer
        setupGame()
    }
 
    
    private func setupGame() {
        var numsShuffled = numbers.shuffled()
        
        while items.count < countItems {
            let item = Item(tittle: String(numsShuffled.removeFirst()), isFound: false, isError: false)
            items.append(item)
        }
        nextItem = 1
        
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] _ in
            self?.currentTime += 0.001
            self?.currentTime = (self?.currentTime.rounded(toPlaces: 4))!
        })
        updateTimer(currentTime)
    }
    
    func check(index:Int) {
        if items[index].tittle == String(nextItem) {
            items[index].isFound = true
            nextItem += 1
        } else {
            items[index].isError = true
        }
        
        if nextItem > items.count {
            gameStatus = .win
            nextItem = 1
            timer?.invalidate()
        }
    }
    
    func newGame() {
        items.removeAll(keepingCapacity: true)
        gameStatus = .start
        currentTime = 0
        setupGame()
    }
}



extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
