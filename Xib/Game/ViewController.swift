//
//  ViewController.swift
//  Xib
//
//  Created by Владислав on 19.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameButtons: [UIButton]!
    @IBOutlet weak var nextNumber: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    lazy var game = Game(countItems: gameButtons.count, time: 0.000) { [weak self] (time) in
        guard let self = self else { return }
        
        self.timerLabel.text = "\(time)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    private func setupScreen() {
        for index in game.items.indices {
            gameButtons[index].setTitle(game.items[index].tittle, for: .normal)
            gameButtons[index].alpha = 1
            gameButtons[index].isEnabled = true
        }
        nextNumber.text = String(game.nextItem)
    }
    
    private func updateUI() {
        for index in game.items.indices {
            if game.items[index].isFound {
                gameButtons[index].alpha = 0
            }
            
            if game.items[index].isError {
                let currentColor = gameButtons[index].backgroundColor
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic) { [weak self] in
                    self?.gameButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3991018282)
                } completion: { [weak self] _ in
                    self?.gameButtons[index].backgroundColor = currentColor
                    self?.game.items[index].isError = false
                }
            }
        }
        nextNumber.text = String(game.nextItem)
        
        if game.gameStatus == .win {
            let winAlert = UIAlertController(title: "WIN!", message: "Your time is \(timerLabel.text!)", preferredStyle: .actionSheet)
            winAlert.addAction(UIAlertAction(title: "Reload game", style: .default, handler: { _ in
                self.reloadGame()
            }))
            self.present(winAlert, animated: true, completion: nil)
        }
        
        
    }
    
    private func reloadGame() {
        setupScreen()
        game.newGame()
    }

    @IBAction func clickStartButton(_ sender: UIButton) {
        setupScreen()
        game.startTimer()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        guard let buttonIndex = gameButtons.firstIndex(of: sender) else {return}
        game.check(index: buttonIndex)
        
        updateUI()
    }
}
