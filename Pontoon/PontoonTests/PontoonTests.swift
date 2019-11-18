//
//  PontoonTests.swift
//  PontoonTests
//
//  Created by PJ COOK on 18/11/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Pontoon

class PontoonTests: XCTestCase {
    func test_winning_hand() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["2H", "5D"]))
        let player = Player("Bob", hand: try Hand(["7H", "5S"]))
        
        XCTAssertTrue(player > dealer)
        XCTAssertTrue(player.hand > dealer.hand)
        XCTAssertTrue(dealer.isDealer)
        XCTAssertFalse(player.isDealer)
        XCTAssertTrue(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_player_isBust() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "KC"]))
        let player = Player("Bob", hand: try Hand(["KH", "KD", "4D"]))
        
        XCTAssertFalse(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_dealer_isBust() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "KC", "4D"]))
        let player = Player("Bob", hand: try Hand(["KH", "KD"]))
        
        XCTAssertTrue(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_dealer_higher_score() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "KC"]))
        let player = Player("Bob", hand: try Hand(["KH", "9D"]))
        
        XCTAssertFalse(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_player_pontoon() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "KC"]))
        let player = Player("Bob", hand: try Hand(["KH", "AD"]))
        
        XCTAssertTrue(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_dealer_pontoon() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "AC"]))
        let player = Player("Bob", hand: try Hand(["TH", "5D"]))
        
        XCTAssertFalse(player.winningHand(dealer.hand))
    }
    
    func test_winningHand_player_fiveCardTrick() throws {
        let dealer = Player(Player.dealerName, hand: try Hand(["KS", "9C"]))
        let player = Player("Bob", hand: try Hand(["2H", "5D", "3S", "4D", "2C"]))
        
        XCTAssertTrue(player.winningHand(dealer.hand))
    }
    
    func test_hand_pontoon() throws {
        let hand = try Hand(["AH", "JD"])
        XCTAssertEqual(Hand.targetValue, hand.value)
        XCTAssertTrue(hand.isPontoon)
    }
    
    func test_hand_not_pontoon() throws {
        let hand1 = try Hand(["5H", "JD"])
        XCTAssertFalse(hand1.isPontoon)
        
        let hand2 = try Hand(["KH"])
        XCTAssertFalse(hand2.isPontoon)
    }
    
    func test_hand_five_card_trick() throws {
        let hand = try Hand(["AH", "AD", "AS", "AC", "2D"])
        XCTAssertEqual(16, hand.value)
        XCTAssertTrue(hand.isFiveCardTrick)
    }
    
    func test_hand_multiple_aces() throws {
        let hand = try Hand(["AH", "AD"])
        XCTAssertEqual(12, hand.value)
        XCTAssertFalse(hand.isBust)
    }
    
    func test_card_init_throws() throws {
        XCTAssertThrowsError(try Card("D2"))
        XCTAssertThrowsError(try Card("2G"))
        XCTAssertThrowsError(try Card("2DD"))
    }
    
    func test_hand_bust() throws {
        let hand = try Hand(["KH", "JD", "3C"])
        XCTAssertEqual(23, hand.value)
        XCTAssertTrue(hand.isBust)
    }
    
    func test_hand_operators() throws {
        let hand1 = try Hand(["KH", "3C"])
        let hand2 = try Hand(["5H", "2C"])
        
        XCTAssertTrue(hand1 > hand2)
        XCTAssertFalse(hand1 < hand2)
        XCTAssertFalse(hand1 <= hand2)
        XCTAssertTrue(hand1 >= hand2)
        XCTAssertFalse(hand1 == hand2)
    }
    
    func test_sample_data1() throws {
        let hand = try Hand(["QH","AC"])
        XCTAssertTrue(hand.isPontoon)
    }
    
    func test_sample_data2() throws {
        let hand = try Hand(["3D","2C","4H","AD","5C"])
        XCTAssertTrue(hand.isFiveCardTrick)
    }
    
    func test_sample_data3() throws {
        let hand = try Hand(["7C","AD","9H"])
        XCTAssertEqual(17, hand.value)
    }
    
    func test_sample_data4() throws {
        let hand = try Hand(["AD","8S","2H"])
        XCTAssertEqual(21, hand.value)
    }
    
    func test_sample_data5() throws {
        let hand = try Hand(["AD","AH","AS"])
        XCTAssertEqual(13, hand.value)
    }
}
