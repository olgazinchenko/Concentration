//
//  ViewController.swift
//  Concentration
//
//  Created by Olga on 15.09.2020.
//  Copyright © 2020 Olga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private static let halloweenTheme = Theme(
        emojis: ["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎", "🧛‍♂️", "🧟‍♀️", "🧙‍♂️"],
        backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    )
    
    private static let facesTheme = Theme(
        emojis: ["😀","😆","😅","🤣","😇","😉","😍","😋","😝", "😎", "🥺", "🤬"],
        backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        cardColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    )
    
    private static let handsTheme = Theme(
        emojis: ["🙌","👍","🤘","🖖","🤙","✊","👌","👏","👆", "💪", "☝️", "🤝"],
        backgroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
        cardColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    )
    
    private static let sportsTheme = Theme(
        emojis: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏", "🎱", "🏓", "🏸"],
        backgroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
        cardColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    )
    
    private static let animalsTheme = Theme(
        emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨", "🐯", "🦁", "🐷"],
        backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
        cardColor: #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
    )
    
    private static let natureTheme = Theme(
        emojis: ["🍄","🌷","🌺","🌸","🌼","🌻","🥀","💐","🌾", "🍀", "☘️", "🌵"],
        backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        cardColor: #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
    )
    
    private static let themes = [halloweenTheme, facesTheme, handsTheme, sportsTheme, animalsTheme, natureTheme]
    
    private var theme = randomTheme()
        
    private var emoji = [Card:String]()
    
    var score = 0
    
    private var scoreEmojis = [ClickedEmoji]()
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCountLabel.text = "Flips: \(game.getFlipCount())"
        theme = ViewController.randomTheme()
        score = 0
        updateViewFromModel()
        scoreEmojis = [ClickedEmoji]()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
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
    
    private func updateViewFromModel() {
        view.backgroundColor = theme.backgroundColor
        flipCountLabel.textColor = theme.cardColor
        scoreCountLabel.textColor = theme.cardColor
        scoreCountLabel.text = "Score: \(score)"
        newGameButton.setTitleColor(theme.cardColor, for: UIControl.State.normal)
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : theme.cardColor
            }
        }
    }
    
    private static func randomTheme() -> Theme {
        if let randomTheme = themes.randomElement() {
            return randomTheme
        } else {
            return Theme()
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, theme.emojis.count > 0 {
            emoji[card] = theme.emojis.remove(at: theme.emojis.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
        
    private func calculateGameScore(for sender: UIButton) -> Int {
        let card = game.cards
        let button = sender
        for index in cardButtons.indices {
            let checkButton = cardButtons[index]
            let emojiSymbol = String(button.currentTitle ?? "?")
            if button == checkButton, card[index].isFaceUp {
                scoreEmojis.append(ClickedEmoji(emoji: emojiSymbol, time: Date.init()))
            }
            if card[index].isFaceUp, card[index].isMatched, button == checkButton {
                var timeInterval = [Int]()
                    for index in scoreEmojis.indices {
                        if scoreEmojis[index].emoji == emojiSymbol {
                            timeInterval.append(Int(Date.init().timeIntervalSince(scoreEmojis[index].time)))
                        }
                    }
                if let maxTimeInterval = timeInterval.max(), maxTimeInterval < 10 {
                    score += 1
                }
                score += 2
                scoreEmojis = scoreEmojis.filter {
                    $0.emoji != emojiSymbol
                }
            }
        }
        if scoreEmojis.count > 2 {
            let checkEmoji = scoreEmojis[scoreEmojis.count - 2].emoji
            for index in 0..<scoreEmojis.count - 2 {
                if checkEmoji == scoreEmojis[index].emoji {
                    score -= 1
                }
            }
        }
        return score
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
