//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Justin Gazlay on 10/30/14.
//  Copyright (c) 2014 Justin Gazlay. All rights reserved.
//

import Foundation

class SlotBrain {
    enum typeOfMatch {
        case noMatch
        case pair
        case twoPair
        case trips
        case fullHouse
        case quads
    }
    
    
    class func unpackSlotColumnsIntoSlotRows (slots: [[Slot]]) -> [[Slot]] {
        
        var slotsInRows: [[Slot]] = []
        
        for (columnIndex, slotsColumn) in enumerate(slots) {
            for (slotIndex, slot) in enumerate(slotsColumn) {
                if columnIndex == 0 {
                    let slotsRow = [slot]
                    slotsInRows.append(slotsRow)
                }
                else {
                    slotsInRows[slotIndex].append(slot)
                }
            }
        }
        
        return slotsInRows
    }
    
    class func computeWinnings (slots: [[Slot]]) -> Int {
        var slotsInRows = unpackSlotColumnsIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfAKindWinCount = 0
        var pairWinCount = 0
        var twoPairWinCount = 0
        var fullHouseWinCount = 0
        var fourOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            if checkForFlush(slotRow) == true {
                println("flush")
                winnings += 1
                flushWinCount += 1
            }
            
            if checkForStraight(slotRow) == true {
                println("straight")
                winnings += 1
                straightWinCount += 1
            }
            
            let matchType = checkForMatches(slotRow)
            switch matchType {
            case .quads:
                println("Four of a Kind")
                winnings += 9
                fourOfAKindWinCount += 1
            case .fullHouse:
                println("Full House")
                winnings += 7
                fullHouseWinCount += 1
            case .trips:
                println("Three of a Kind")
                winnings += 4
                threeOfAKindWinCount += 1
            case .twoPair:
                println("Two Pair")
                winnings += 2
                twoPairWinCount += 1
            case .pair:
                println("Pair")
                winnings += 1
                pairWinCount += 1
            default:
                winnings += 0
            }
        }
        
        if flushWinCount == 3 {
            println("Royal Flush")
            winnings += 15
        }
        
        if straightWinCount == 3 {
            println("Epic Straight")
            winnings += 1000
        }
        
        if fourOfAKindWinCount == 3 {
            println("Quads everywhere")
            winnings += 5000
        }
        
        if fullHouseWinCount == 3 {
            println("All the Houses are Full")
            winnings += 3000
        }
        
        if threeOfAKindWinCount == 3 {
            println("threes all around")
            winnings += 50
        }
        
        if twoPairWinCount == 3 {
            println("Doubles Night")
            winnings += 25
        }
        
        if pairWinCount == 3 {
            println("All paired up")
            winnings += 10
        }
        
        return winnings
    }
    
    class func checkForFlush (slotRow: [Slot]) -> Bool {
        
        for slot in slotRow {
            if slot.isRed != slotRow[0].isRed {
                return false
            }
        }
        return true
    }
    
    class func checkForStraight (slotRow: [Slot]) -> Bool {
        if slotRow.count > 2 {
            if slotRow[0].value == slotRow[1].value - 1 {
                for (slotIndex, slot) in enumerate(slotRow) {
                    if slotRow[0].value != slot.value - slotIndex {
                        return false
                    }
                }
                return true
            }
            else if slotRow[0].value == slotRow[1].value + 1 {
                for (slotIndex, slot) in enumerate(slotRow) {
                    if slotRow[0].value != slot.value + slotIndex {
                        return false
                    }
                }
                return true
            }
            else {
                return false
            }
        }
        else {
            return false //need at least three slots to have a straight
        }
        
    }
    
    class func checkForMatches (slotRow: [Slot]) -> typeOfMatch {
        var slotValueCountArray = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        var countOfPairs = 0
        var countOfTrips = 0
        var countOfQuads = 0
    
        var handType: typeOfMatch
        
        for slot in slotRow {
            slotValueCountArray[slot.value - 1] += 1
        }
        
        for valueCount in slotValueCountArray {
            if valueCount == 2 {
                countOfPairs++
            }
            else if valueCount == 3 {
                countOfTrips++
            }
            else if valueCount == 4 {
                countOfQuads++
            }
        }
        
        let matchTypes = (countOfPairs, countOfTrips, countOfQuads)
        switch matchTypes {
        case (0, 0, 4):
            handType = typeOfMatch.quads
        case (1, 1, 0):
            handType = typeOfMatch.fullHouse
        case (0, 1, 0):
            handType = typeOfMatch.trips
        case (2, 0, 0):
            handType = typeOfMatch.twoPair
        case (1, 0, 0):
            handType = typeOfMatch.pair
        default:
            handType = typeOfMatch.noMatch
        }
        
        return handType
    }
    
    
    
    
    
    
    
    
    
}