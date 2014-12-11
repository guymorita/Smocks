//
//  Block.swift
//  Smocks
//
//  Created by Guy Morita on 12/9/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

import Foundation
import SpriteKit

let NumberOfColors: UInt32 = 6

// declaring enum
// implements the Printable protocol?
enum BlockColor: Int, Printable {
    
    // Blue = 0, Orange = 1, etc...
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    // computed property > a function
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    // need to adhere to the Printable protocol, otherwise the code won't compile
    var description: String {
        return self.spriteName
    }
    
    static func random() -> BlockColor {
        // chooses a random color
        return BlockColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    }
}

// Hashable allows it to be stored the Array2D
class Block: Hashable, Printable {
    
    // using let, we can never reassign the var
    let color: BlockColor
    
    // location of the block on the board
    var column: Int
    var row: Int
    // will represent the visual element of the block. rendering / animating each block
    var sprite: SKSpriteNode?
    
    // shortcute to recover the filename of the sprite
    var spriteName: String {
        return color.description
    }
    
    // generating a unique integer to store each block
    var hashValue: Int {
        return self.column ^ self.row
    }

    // to comply with the printable protocol
    var description: String {
        // string interpolation with \(blah)
        return "\(color): [\(column), \(row)]"
    }
    
    // initializing the block with three inputs
    init(column: Int, row: Int, color: BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
    
}

// in comparing two blocks it will only return true to both if they are in the same spot in the 2D array
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}