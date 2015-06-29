//
//  YValuesTests.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/9/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit
import XCTest

class YValuesTests: XCTestCase {

    func test_reverseOrderOfArray(){
    
        let yValuesCV = YValues(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
        
        let inputArray = ["a","b","c", "d"]
        
        let outputArray = yValuesCV.reverseOrderOfArray(inputArray)
        
        XCTAssertEqual(inputArray[0], outputArray[3], "output array not ordered correctly")
        XCTAssertEqual(inputArray[1], outputArray[2], "output array not ordered correctly")
        XCTAssertEqual(inputArray[2], outputArray[1], "output array not ordered correctly")
        XCTAssertEqual(inputArray[3], outputArray[0], "output array not ordered correctly")
    }

    func test_findScaledHeightForCellAtIndex(){

        // SET VAR
        let yValuesCV = YValues(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
        yValuesCV.yScaleFactor = 3
        yValuesCV.yValuesInReverseOrderForDisplay = [11,6,3,1]

        // OUTPUT
        let y0 = yValuesCV.findScaledHeightForCellAtIndex(index: NSIndexPath(forRow: 0, inSection: 0))
        let y1 = yValuesCV.findScaledHeightForCellAtIndex(index: NSIndexPath(forRow: 1, inSection: 0))
        let y2 = yValuesCV.findScaledHeightForCellAtIndex(index: NSIndexPath(forRow: 2, inSection: 0))
        let y3 = yValuesCV.findScaledHeightForCellAtIndex(index: NSIndexPath(forRow: 3, inSection: 0))
        
        // EXPECTED OUTPUT
        // cell height = change in y
        // scaled cell height = scale factor * change in y
        // ht = 3 * [5,3,2,1]
        
        // the last value will always be 20, by default
        
        // CHECK
        XCTAssertEqual(y0, CGFloat(15), "y axis values [collection view hieghts] no longer properly spaced")
        XCTAssertEqual(y1, CGFloat(9), "y axis values [collection view hieghts] no longer properly spaced")
        XCTAssertEqual(y2, CGFloat(6), "y axis values [collection view hieghts] no longer properly spaced")
        XCTAssertEqual(y3, CGFloat(20.0), "y axis values [collection view hieghts] no longer properly spaced")
        
    }
    
    
        
}
