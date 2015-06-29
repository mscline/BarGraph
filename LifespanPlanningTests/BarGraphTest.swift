//
//  BarGraph.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/4/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit
import XCTest

class BarGraphTest: XCTestCase {
/*
    
        let barGraph = BarGraphFacade(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
    

    
    // MARK: HELPER METHODS

    func buildSampleOneDimensionalInputMatrix() -> Array<BarGraphDataItem> {
        
        var a = barGraph.createBarGraphDataItem(columnName:"a", subCategoryName: "a", value: 1, color: UIColor.redColor())
        var b = barGraph.createBarGraphDataItem(columnName:"b", subCategoryName: "b", value: 2, color: UIColor.blueColor())
        var c = barGraph.createBarGraphDataItem(columnName:"c", subCategoryName: "c", value: 3, color: UIColor.greenColor())
        var d = barGraph.createBarGraphDataItem(columnName:"d", subCategoryName: "d", value: 4, color: UIColor.yellowColor())
        
        return [a, b, c, d]
    }
    
    func buildSampleInputMatrix() -> Array<Array<BarGraphDataItem>> {
        
        var a = barGraph.createBarGraphDataItem(columnName:"a", subCategoryName: "a", value: 1, color: UIColor.redColor())
        var b = barGraph.createBarGraphDataItem(columnName:"b", subCategoryName: "b", value: 2, color: UIColor.blueColor())
        var c = barGraph.createBarGraphDataItem(columnName:"c", subCategoryName: "c", value: 3, color: UIColor.greenColor())
        var d = barGraph.createBarGraphDataItem(columnName:"d", subCategoryName: "d", value: 4, color: UIColor.yellowColor())

        var w = barGraph.createBarGraphDataItem(columnName:"1", subCategoryName: "1", value: 1, color: UIColor.lightGrayColor())
        var x = barGraph.createBarGraphDataItem(columnName:"2", subCategoryName: "2", value: 2, color: UIColor.grayColor())
        var y = barGraph.createBarGraphDataItem(columnName:"3", subCategoryName: "3", value: 3, color: UIColor.darkGrayColor())
        var z = barGraph.createBarGraphDataItem(columnName:"4", subCategoryName: "4", value: 4, color: UIColor.blackColor())

        return [[a, b, c, d],[w, x, y, z]]
    }

    
    // MARK: convertArrayOfInputDataIntoTwoDimensionalArray
    
    func test_convertArrayOfInputDataIntoTwoDimensionalArray_valid(){
        
        
        let input = buildSampleOneDimensionalInputMatrix()
        let output = barGraph.convertArrayOfInputDataIntoTwoDimensionalArray(arrayOfData: input)
        
        let inputValue1 = input[0]
        let inputValue2 = input.last
        
        let outputValue1 = output[0][0]
        let outputValue2 = output[input.count - 1][0]
        
        XCTAssertEqual(inputValue1, outputValue1, "array not correctly wrapped in parent array")
        XCTAssertEqual(inputValue2!, outputValue2, "array not correctly wrapped in parent array")

    }
    
    
    // MARK: flipXYCoordinateInMatrix

    func test_flipXYCoordinatesInMatrix_validOutput(){

        var inputArray = buildSampleInputMatrix()
        var outputArray = barGraph.flipXYCoordinatesInMatrix(inputMatrix: inputArray)
        
        
        // test basic values
        checkIfFlippedXYCoord(valueA: 0, valueB: 0, inputArray: inputArray, outputArray: outputArray)
        checkIfFlippedXYCoord(valueA: 1, valueB: 0, inputArray: inputArray, outputArray: outputArray)
        checkIfFlippedXYCoord(valueA: 0, valueB: 1, inputArray: inputArray, outputArray: outputArray)

        // test [lastX][lastY] -> flipped
        let numberOfRowsMinus1 = inputArray.count - 1
        let numberOfColumnsMinus1 = inputArray[0].count - 1
        
        checkIfFlippedXYCoord(valueA: numberOfRowsMinus1, valueB: numberOfColumnsMinus1, inputArray: inputArray, outputArray: outputArray)
        
    }
    
    func checkIfFlippedXYCoord(#valueA:Int, valueB:Int, inputArray:Array<Array<BarGraphDataItem>>, outputArray:Array<Array<BarGraphDataItem>>){
        
        let testInputValue = inputArray[valueA][valueB].columnName
        let testOutput = outputArray[valueB][valueA].columnName
        
        XCTAssertEqual(testInputValue, testOutput, "input \(testInputValue) does not equal expected output \(testOutput)")
    
    }
    */
}
