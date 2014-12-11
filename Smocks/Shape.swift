//
//  Shape.swift
//  Smocks
//
//  Created by Guy Morita on 12/9/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

import Foundation
import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
            case .Zero:
                return "0"
            case .Ninety:
                return "90"
            case .OneEighty:
                return "180"
            case .TwoSeventy:
                return "270"
        }
    }
    
    // every instance of Orientation returns a random orientation based on the # of orientations
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
    
    // method to return the next orientation
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1: -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        // when would it be less than zero?
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

// # of shape varieties
let NumShapeTypes: UInt32 = 7

// Shape indexes
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
    
    // color of the shape
    let color: BlockColor
    
    // block comprising the shape
    var blocks = Array<Block>()
    
    var orientation: Orientation
    
    var column, row: Int
    
    // subclasses must override this property
    // computed dictionary
    // [:] denotes a dictionary. really?
    // (columnDiff: Int, rowDiff: Int) is a tuple - good for passing / returning multiple values without defining a custom struct
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    // sample accessor
    // let arrayOfDiffs = blockRowColumnPositions[Orientation.0]!
    // let columnDifference = arrayOfDiffs[0].columnDiff
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }
    
    // computed property which returns the bottom blocks of the shape at its current orientation
    var bottomBlocks: Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }
    
    var hashValue: Int {
        return reduce(blocks, 0) {$0.hashValue ^ $1.hashValue}
    }
    
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    // special init which must call the init. simplifies the init process for users of Shape class.
    convenience init(column: Int, row: Int) {
        self.init(column: column, row: row, color: BlockColor.random(), orientation: Orientation.random())
    }
    
    // final cannot be overwritten by subclasses
    final func initializeBlocks() {
        // if cond first attempts to assign an annry into blockRow.. after extracting it from the computed dict. if not found, block is not executed.
        // equivalent to:
        // let blockRowColumnTranslations = blockRowColumnPositions[orientation]
        // if blockRowColumnTranslations != nil {
            // Code…
        // }
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    
    final func rotateBlocks(orientation: Orientation) {
        if let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {
            // #1
            for (idx, (columnDiff:Int, rowDiff:Int)) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + columnDiff
                blocks[idx].row = row + rowDiff
            }
        }
    }
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: true)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: false)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows: 1)
    }
    
    final func raiseShapeByOneRow() {
        shiftBy(0, rows: -1)
    }
    
    final func shiftRightByOneColumn() {
        shiftBy(1, rows: 0)
    }
    
    final func shiftLeftByOneColumn() {
        shiftBy(-1, rows: 0)
    }
    
    // adjusts each row and column respectively
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    // modifying the column/row properties before rotating blocks to their current orientation
    final func moveTo(column: Int, row:Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    // generates a random shape
    final class func random(startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(column:startingColumn, row:startingRow)
        case 1:
            return LineShape(column:startingColumn, row:startingRow)
        case 2:
            return TShape(column:startingColumn, row:startingRow)
        case 3:
            return SShape(column:startingColumn, row:startingRow)
        case 4:
            return ZShape(column:startingColumn, row:startingRow)
        case 5:
            return LShape(column:startingColumn, row:startingRow)
        default:
            return JShape(column:startingColumn, row:startingRow)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}


