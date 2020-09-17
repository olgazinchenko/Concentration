//
//  Concentration.swift
//  Concentration
//
//  Created by Olga on 16.09.2020.
//  Copyright © 2020 Olga. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyOneFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
            // check if cards match
            if cards[matchIndex].identifier == cards[index].identifier {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyOneFaceUpCard = nil
        } else {
            // either no cards  or 2 cards are face up
            for flipDowmIndex in cards.indices {
                cards[flipDowmIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyOneFaceUpCard = index
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        //TODO: Shuffle the cards
    }
}
