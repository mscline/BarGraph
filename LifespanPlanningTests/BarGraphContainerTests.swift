//
//  BarGraphContainerTests.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/9/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit
import XCTest

class BarGraphContainerTests: XCTestCase {

    
        var barGraphContainer = BarGraphContainer(frame: CGRectMake(5, 10, 20, 40))
    
        var sampleGraphItems:Array<Array<BarGraphDataItem>> = {return BarGraphContainerTests.buildSampleInputMatrix()}()

    
    override func setUp() {
        super.setUp()
        
    }
    
    class func buildSampleInputMatrix() -> Array<Array<BarGraphDataItem>> {
        
        let barGraph = BarGraphFacade()
        
        var a = barGraph.createBarGraphDataItem(columnName:"a", subCategoryName: "a", value: 10, color: UIColor.redColor())
        var b = barGraph.createBarGraphDataItem(columnName:"b", subCategoryName: "b", value: 20, color: UIColor.blueColor())
        var c = barGraph.createBarGraphDataItem(columnName:"c", subCategoryName: "c", value: 30, color: UIColor.greenColor())
        var d = barGraph.createBarGraphDataItem(columnName:"d", subCategoryName: "d", value: 40, color: UIColor.yellowColor())
        
        var w = barGraph.createBarGraphDataItem(columnName:"w", subCategoryName: "w", value: 10, color: UIColor.lightGrayColor())
        var x = barGraph.createBarGraphDataItem(columnName:"x", subCategoryName: "x", value: 20, color: UIColor.grayColor())
        var y = barGraph.createBarGraphDataItem(columnName:"y", subCategoryName: "y", value: 30, color: UIColor.darkGrayColor())
        var z = barGraph.createBarGraphDataItem(columnName:"z", subCategoryName: "z", value: 40, color: UIColor.purpleColor())
        
        return [[a, b, c, d],[w, x, y, z]]
    }
    
    
    
    // MARK: HELPERS / DATA MANIPULATION
    
    func test_convertArrayOfInputDataIntoTwoDimensionalArray() {
        
        // build sample data items
        let barGraph = BarGraphFacade()
        
        var a = barGraph.createBarGraphDataItem(columnName:"a", subCategoryName: "a", value: 10, color: UIColor.redColor())
        var b = barGraph.createBarGraphDataItem(columnName:"b", subCategoryName: "b", value: 20, color: UIColor.blueColor())
        var c = barGraph.createBarGraphDataItem(columnName:"c", subCategoryName: "c", value: 30, color: UIColor.greenColor())
        var d = barGraph.createBarGraphDataItem(columnName:"d", subCategoryName: "d", value: 40, color: UIColor.yellowColor())
        
        let inputArray = [a, b, c, d]
        let expectedOutput = [[a],[b],[c],[d]]
        
        // test data
        let outputArray = barGraphContainer.convertArrayOfInputDataIntoTwoDimensionalArray(arrayOfData: inputArray)
        
        XCTAssertEqual(outputArray[1][0], expectedOutput[1][0], "input items not being properly wrapped in nested arrays")
        XCTAssertEqual(outputArray[1][0], expectedOutput[1][0], "input items not being properly wrapped in nested arrays")
        XCTAssertEqual(outputArray[2][0], expectedOutput[2][0], "input items not being properly wrapped in nested arrays")
        XCTAssertEqual(outputArray[3][0], expectedOutput[3][0], "input items not being properly wrapped in nested arrays")
        
    }
    
    func test_setGraphsScale(){
        
        // set property values
        let yAxisValues = [0.0, 3.0, 5.0]
        barGraphContainer.barGraph.frame = CGRectMake(10, 20, 100, 200)
        
        // expected output
        let scaleFactor = barGraphContainer.barGraph.frame.height / 5  // 200/5 = 40
        
        // run
        barGraphContainer.setGraphsScale(yAxisValues: yAxisValues)
        
        // check
        XCTAssertEqual(barGraphContainer.barGraph.yScaleFactor, scaleFactor, "scale factor not correctly caluclated and passed to subviews")
        XCTAssertEqual(barGraphContainer.yValues.yScaleFactor, scaleFactor, "scale factor not correctly caluclated and passed to subviews")
        
    }
    
    func test_autoCalYAxisPaddingIfNeeded_isNeeded(){
    
        // the left padding should always be greater than the size of the y axis titles / numbers
        // if it is, it will be adjusted so that the padding is equal to the needed size
        
        // set properties
        barGraphContainer.leftPadding = 10
        
        // create sample input
        let valueA = 100.0
        let valueB = 10000000000.0
        let valueC = 10.0
        
        // calc expected output
        let attrString = TextFormatter.createAttributedString(String("\(valueB)"), withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Right)
        let numbersWidth = attrString.boundingRectWithSize(CGSizeMake(1000, 16), options:nil, context: nil).size.width
        
        // test 1
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueA, valueB, valueC])
        XCTAssertEqual(barGraphContainer.leftPadding, numbersWidth, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
        // test 2
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueB, valueA, valueC])
        XCTAssertEqual(barGraphContainer.leftPadding, numbersWidth, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
        // test 3
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueA, valueC, valueB])
        XCTAssertEqual(barGraphContainer.leftPadding, numbersWidth, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
    }

    func test_autoCalYAxisPaddingIfNeeded_isNotNeeded(){
        
        // the left padding should be unaffected
        
        // set properties
        barGraphContainer.leftPadding = 500
        
        // create sample input
        let valueA = 100.0
        let valueB = 10000000000.0
        let valueC = 10.0
        
        // calc expected output
        let attrString = TextFormatter.createAttributedString(String("\(valueB)"), withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Right)
        let numbersWidth = attrString.boundingRectWithSize(CGSizeMake(1000, 16), options:nil, context: nil).size.width
        
        // test 1
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueA, valueB, valueC])
        XCTAssertEqual(barGraphContainer.leftPadding, 500, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
        // test 2
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueB, valueA, valueC])
        XCTAssertEqual(barGraphContainer.leftPadding, 500, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
        // test 3
        barGraphContainer.autoCalYAxisPaddingIfNeeded(yAxisValues: [valueA, valueC, valueB])
        XCTAssertEqual(barGraphContainer.leftPadding, 500, "not correctly calculating y padding to adjust for large y axis titles (ie, large numbers")
        
        
    }

    
//    func test_autoCalYAxisPaddingIfNeeded(#yAxisValues: Array<Double>){
//        
//        // iterate through y-axis titles and check width
//        // if width greater than padding change padding
//        
//        if autoCalcYAxisPadding == true { leftPadding = 0; }
//        var widthOfLargestString = leftPadding
//        
//        for number in yAxisValues {
//            
//            let attrString = TextFormatter.createAttributedString(String("\(number)"), withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Right)
//            let numbersWidth = attrString.boundingRectWithSize(CGSizeMake(1000, 16), options:nil, context: nil).size.width  // NOT WORKING ????
//            if widthOfLargestString < numbersWidth { widthOfLargestString = numbersWidth}
//            
//        }
//        
//        leftPadding = widthOfLargestString
//        
//    }
    
    
    // MARK: INISTANTIATION
    
    func test_allComponentsCreated(){
    
        
        XCTAssertNotNil(barGraphContainer.barGraph, "bar graph collection view not instantiated")
        XCTAssertNotNil(barGraphContainer.yValues, "yValues collection veiw not instantiated")
        XCTAssertNotNil(barGraphContainer.columnHeadings, "column headings collection view not instantiated")
        XCTAssertNotNil(barGraphContainer.xAxis, "x axis [a view] not instantiated")
        XCTAssertNotNil(barGraphContainer.yAxis, "y axis [a view] not instantiated")
        
    }
    
    func test_subviewsAddedToSuperview(){
    
        let barGraphCV = helper_doesSubviewExistInSuperview(barGraphContainer.barGraph as UIView!)
        let yvalCV = helper_doesSubviewExistInSuperview(barGraphContainer.yValues as UIView!)
        let colCV = helper_doesSubviewExistInSuperview(barGraphContainer.columnHeadings as UIView!)
        
        let xAxis = helper_doesSubviewExistInSuperview(barGraphContainer.xAxis as UIView!)
        let yAxis = helper_doesSubviewExistInSuperview(barGraphContainer.yAxis as UIView!)
        
        XCTAssert(barGraphCV, "no longer added to main view")
        XCTAssert(yvalCV, "no longer added to main view")
        XCTAssert(colCV, "no longer added to main view")
        
        XCTAssert(xAxis, "no longer added to main view")
        XCTAssert(yAxis, "no longer added to main view")
    }

    func helper_doesSubviewExistInSuperview(subview:UIView?) -> Bool {
    
        let ourSubview = subview as UIView!
        
        for view in barGraphContainer.subviews {
        
            let theView = view as? UIView
            if theView == subview { return true; }
        }
    
        return false
    }
    
    func test_setDefaultColors(){
    
        XCTAssert(barGraphContainer.backgroundColor == UIColor.whiteColor(), "don't change default colors")

        XCTAssert(barGraphContainer.barGraph.backgroundColor == UIColor.clearColor(), "don't change default colors")
        XCTAssert(barGraphContainer.yValues.backgroundColor == UIColor.clearColor(), "don't change default colors")
        XCTAssert(barGraphContainer.columnHeadings.backgroundColor == UIColor.clearColor(), "don't change default colors")
        
        XCTAssert(barGraphContainer.xAxis.backgroundColor == UIColor.blackColor(), "don't change default colors")
        XCTAssert(barGraphContainer.yAxis.backgroundColor == UIColor.blackColor(), "don't change default colors")
    }
}
