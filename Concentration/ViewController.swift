//
//  ViewController.swift
//  Concentration
//
//  Created by Olga on 15.09.2020.
//  Copyright © 2020 Olga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        let flipCount = game.incrementFlipCount()
        flipCountLabel.text = "Flips: \(flipCount)"
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCountLabel.text = "Score: \(String(calculateGameScore(for: sender)))"
        } else {
            print("Choosen card not in cardButtons")
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCountLabel.text = "Flips: \(game.getFlipCount())"
        emojiChoices = ViewController.randomTheme()
        updateViewFromModel()
        scoreEmojis = [String]()
        score = 0
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    static let themes = [
        ["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎", "🧛‍♂️", "🧟‍♀️", "🧙‍♂️"],
        ["😀","😆","😅","🤣","😇","😉","😍","😋","😝", "😎", "🥺", "🤬"],
        ["🙌","👍","🤘","🖖","🤙","✊","👌","👏","👆", "💪", "☝️", "🤝"],
        ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏", "🎱", "🏓", "🏸"],
        ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨", "🐯", "🦁", "🐷"],
        ["🍄","🌷","🌺","🌸","🌼","🌻","🥀","💐","🌾", "🍀", "☘️", "🌵"]
    ]
    
    static func randomTheme() -> [String] {
        if let randomTheme: [String] = themes.randomElement() {
            return randomTheme
        } else {
            return ["??"]
        }
    }
    
    var emojiChoices = randomTheme()
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    var score = 0
    var scoreEmojis = [String]()
        
    func calculateGameScore(for sender: UIButton) -> Int {
        let card = game.cards
        let button = sender
        for index in cardButtons.indices {
            let checkButton = cardButtons[index]
            if button == checkButton, card[index].isFaceUp {
                scoreEmojis.append(String(button.currentTitle ?? "?"))
            }
            if card[index].isFaceUp, card[index].isMatched, button == checkButton {
                score += 2
                scoreEmojis = scoreEmojis.filter {
                    $0 != String(button.currentTitle ?? "?")
                }
            }
        }
        if scoreEmojis.count > 2 {
            let checkEmoji = scoreEmojis[scoreEmojis.count - 2]
            for index in 0..<scoreEmojis.count - 2 {
                if checkEmoji == scoreEmojis[index] {
                        score -= 1
                }
            }
        }
        return score
    }
}
