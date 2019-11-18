//  Copyright © 2019 Software101. All rights reserved.

import Foundation

struct Card {
    enum Suit: String {
        case spades = "S"
        case clubs = "C"
        case hearts = "H"
        case diamonds = "D"
    }
    
    enum Rank: String {
        case ace = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "T"
        case jack = "J"
        case queen = "Q"
        case king = "K"
        
        var valueLow: Int {
            switch self {
            case .ace: return 1
            case .two: return 2
            case .three: return 3
            case .four: return 4
            case .five: return 5
            case .six: return 6
            case .seven: return 7
            case .eight: return 8
            case .nine: return 9
            case .ten, .jack, .queen, .king: return 10
            }
        }
        
        var valueHigh: Int {
            switch self {
            case .ace: return 11
            case .two: return 2
            case .three: return 3
            case .four: return 4
            case .five: return 5
            case .six: return 6
            case .seven: return 7
            case .eight: return 8
            case .nine: return 9
            case .ten, .jack, .queen, .king: return 10
            }
        }
    }
    
    enum Errors: Error {
        case invalidSuit
        case invalidRank
        case invalidInput
    }
    
    let suit: Suit
    let rank: Rank
    
    init(_ value: String) throws {
        guard value.count == 2 else { throw Errors.invalidInput }
        guard let first = value.first, let rank = Rank(rawValue: String(first)) else { throw Errors.invalidRank }
        guard let last = value.last, let suit = Suit(rawValue: String(last)) else { throw Errors.invalidSuit }
        self.rank = rank
        self.suit = suit
    }
    
    var valueLow: Int {
        return rank.valueLow
    }
    
    var valueHigh: Int {
        return rank.valueHigh
    }
}

struct Player {
    static let dealerName = "Dealer"
    let name: String
    let hand: Hand
    var isDealer: Bool {
        return name == Player.dealerName
    }
    var value: Int { return hand.value }
    
    init(_ name: String, hand: Hand) {
        self.name = name
        self.hand = hand
    }
    
    func winningHand(_ dealer: Hand) -> Bool {
        if hand.isBust { return false }
        if dealer.isBust { return true }
        if dealer > hand, !hand.isFiveCardTrick || dealer.isPontoon { return false }
        if hand.isPontoon { return true }
        if hand.isFiveCardTrick { return true }
        return hand >= dealer
    }
}

struct Hand {
    static let targetValue = 21
    let cards: [Card]
    
    var value: Int {
        var sorted = cards.sorted { $0.valueLow > $1.valueLow }
        var value = 0
        while !sorted.isEmpty {
            let card = sorted.removeFirst()
            if card.rank != .ace {
                value += card.valueLow
            } else {
                let remainder = sorted.count + 1
                for i in 0...remainder {
                    print(card)
                    let high = (remainder - i) * card.valueHigh
                    let low = i * card.valueLow
                    if high + low + value <= Hand.targetValue
                        || i == remainder - 1 {
                        value += high + low
                        break
                    }
                }
                
                break
            }
            if value > Hand.targetValue { break }
        }
        
        return value
    }
    
    var isBust: Bool {
        return value > Hand.targetValue
    }
    
    var isPontoon: Bool {
        guard cards.count == 2, value == Hand.targetValue else { return false }
        let sorted = cards.sorted { $0.valueLow < $1.valueLow }
        guard let first = sorted.first, let last = sorted.last else { return false }
        return first.rank == .ace && [Card.Rank.jack, Card.Rank.queen, Card.Rank.king].contains(last.rank)
    }
    
    var isFiveCardTrick: Bool {
        return cards.count >= 5 && value <= Hand.targetValue
    }
    
    init(_ cards: [String]) throws {
        self.cards = try cards.map { try Card($0) }
    }
}

extension Hand {
    static func > (left: Hand, right: Hand) -> Bool {
        return left.value > right.value
    }
    
    static func < (left: Hand, right: Hand) -> Bool {
        return left.value < right.value
    }
    
    static func <= (left: Hand, right: Hand) -> Bool {
        return left.value <= right.value
    }
    
    static func >= (left: Hand, right: Hand) -> Bool {
        return left.value >= right.value
    }
    
    static func == (left: Hand, right: Hand) -> Bool {
        return left.value == right.value
    }
}

extension Player {
  static func > (left: Player, right: Player) -> Bool {
    return left.value > right.value
  }
}
