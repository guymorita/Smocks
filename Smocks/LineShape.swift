//
//  LineShape.swift
//  Smocks
//
//  Created by Guy Morita on 12/9/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

import Foundation

class LineShape:Shape {
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero: [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.OneEighty: [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.Ninety: [(-1, 0), (0, 0), (1, 0), (2, 0)],
            Orientation.TwoSeventy: [(-1, 0), (0, 0), (1, 0), (2, 0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero: [blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[FourthBlockIdx]],
            Orientation.Ninety: blocks,
            Orientation.TwoSeventy: blocks
        ]
    }
}