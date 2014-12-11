//
//  Array2D.swift
//  Smocks
//
//  Created by Guy Morita on 12/9/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

import Foundation

// defining the Array2D class which will represent the tetris grid
// need to create our own class because it will be passed by reference as opposed to a struct
// passed by value
// <T> allows it to stores any type of data
class Array2D<T> {
    let columns: Int
    let rows: Int
    
    // the underlying data structure
    var array: Array<T?> // ? symbolizes an optional value, empty is nil
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        // initantiating the array with the desired size
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    // custom interface for our 2D Array
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
    
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}