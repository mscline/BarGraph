//
//  BarGraphContainer.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/8/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class BarGraphContainer: UIView, GraphInterfaceProtocol {
    
    
        // collection views
        var barGraph:BarGraph!
        var yValues:YValues!
        var columnHeadings:ColumnHeadings!
    
        // other screen elements
        var yAxis:UIView!
        var xAxis:UIView!
    
        // read only data used for reload on change in layout
        private (set) var readOnly_rawData:Array<Array<BarGraphDataItem>>? // ie the setter is private
        private (set) var readOnly_arrayOfCategoryTitles: Array<String>?
        private (set) var readOnly_arrayOfYTitles: Array<Double>?
    
    
        // UI settings
        var showColumnTotals:Bool = true
        var showColumnSubTotals:Bool = true
        var autoCalcYAxisPadding:Bool = false  // if there is not enough room for the text it will wrap weirdly
        var paddingBetweenXAxisAndColumnTitles:CGFloat = 6
    
        var leftPadding:CGFloat = 50   // the user may specify default, but if the text will not fit, it will be automatically adjusted, turn on autoCalcYAsixPadding
        var bottomPadding:CGFloat = 20
        var topPadding:CGFloat = 10
    
        // AutoCalc Variables
        var columnWidth:CGFloat = 0
        var scaleFactor:CGFloat = 1.0

        // UI adjustments
        let yValueCorrection:CGFloat = -7  // will bring yValues collection view up a bit, about 1/2 font size, to center title
        let xValueCorrection:CGFloat = 6   // to add cross hatch on y-axis, added a "-" to the title and moved it over on the y-axis
    
        // Touches
        var delegateForTouches:BarGraphItemWasTouchedProtocol? {
    
            didSet{
        
                // rather than having embedded collection views implicitly reporting back to this main view, which will simply forward the messages, the collection views will just forward them
                barGraph.delegateForTouches = delegateForTouches
                yValues.delegateForTouches = delegateForTouches
                columnHeadings.delegateForTouches = delegateForTouches
            }
        }
    
    
    // MARK: SETUP
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup(){
    
        addElements()
        setColors()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPositions()
    }
    
    func addElements(){
    
        barGraph = BarGraph(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
        yValues = YValues(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
        columnHeadings = ColumnHeadings(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: UICollectionViewFlowLayout())
        
        yAxis = UIView(frame:CGRectMake(0, 0, 0, 0))
        xAxis = UIView(frame:CGRectMake(0, 0, 0, 0))

        addSubview(barGraph)
        addSubview(yValues)
        addSubview(columnHeadings)

        addSubview(yAxis)
        addSubview(xAxis)
    }
    
    func setColors(){

        //self.backgroundColor = UIColor.whiteColor()
        
        barGraph.backgroundColor = UIColor.clearColor()
        yValues.backgroundColor = UIColor.clearColor()
        columnHeadings.backgroundColor = UIColor.clearColor()
    
        xAxis.backgroundColor = UIColor.blackColor()
        yAxis.backgroundColor = UIColor.blackColor()
    }
    
    
    // MARK: LAYOUT
    
    // when change in bounds, rebuild graph to layout and scale properly (using frame doesn't work)
    override var bounds:CGRect {
    
        didSet {
        
            reloadGraphAndUpdateLayout()

        }
        
    }
    
    func reloadGraphAndUpdateLayout(){
        
        if(readOnly_arrayOfCategoryTitles == nil && readOnly_arrayOfYTitles == nil && readOnly_rawData == nil) { print("\n\nxxxxxxxxx cancel");
            return; }
        
                print("xxxxxxx redrawing")
        loadDataForCollectionView(arraysOfCategoryItemsNestedInsideOneBigArray: readOnly_rawData!, arrayOfCategoryTitles: readOnly_arrayOfCategoryTitles!, arrayOfYTitles: readOnly_arrayOfYTitles!)
    }
    
    func autoCalYAxisPaddingIfNeeded(#yAxisValues: Array<Double>){
        
        // iterate through y-axis titles and check width
        // if width greater than padding change padding
        
        if autoCalcYAxisPadding == true { leftPadding = 0; }
        var widthOfLargestString = leftPadding
        
        for number in yAxisValues {
            
            let attrString = TextFormatter.createAttributedString(String("\(number)"), withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Right)
            let numbersWidth = attrString.boundingRectWithSize(CGSizeMake(1000, 16), options:nil, context: nil).size.width  // NOT WORKING ????
            if widthOfLargestString < numbersWidth { widthOfLargestString = numbersWidth}
            
        }
        
        leftPadding = widthOfLargestString
        
    }
    
    func setPositions(){
    
        barGraph.frame = CGRectMake(leftPadding,
                                    topPadding,
                                    self.frame.size.width - leftPadding,
                                    self.frame.size.height - bottomPadding)
        
        yValues.frame =  CGRectMake(0 + xValueCorrection,
                                    topPadding + yValueCorrection,
                                    leftPadding,
                                    self.frame.height - bottomPadding - 2 * yValueCorrection)
        
        columnHeadings.frame = CGRectMake(leftPadding,
            topPadding + self.frame.height - bottomPadding + paddingBetweenXAxisAndColumnTitles,
            self.frame.width - leftPadding,
            bottomPadding - paddingBetweenXAxisAndColumnTitles)
        
        xAxis.frame = CGRectMake(leftPadding, barGraph.frame.origin.y + barGraph.frame.size.height, barGraph.frame.width, 1)
        yAxis.frame = CGRectMake(leftPadding, barGraph.frame.origin.y, 2, barGraph.frame.height)
        
    }
    
    
    // MARK: LOAD DATA
    
    func loadDataForCollectionView(#arraysOfCategoryItemsNestedInsideOneBigArray: Array<Array<BarGraphDataItem>>, arrayOfCategoryTitles: Array<String>, arrayOfYTitles: Array<Double>) {

        // save data - will use to reload if there is a change in the layout
        readOnly_arrayOfCategoryTitles = arrayOfCategoryTitles
        readOnly_arrayOfYTitles = arrayOfYTitles
        readOnly_rawData = arraysOfCategoryItemsNestedInsideOneBigArray
        
        // scale graph based on largest value in array of axis values (aka, the last one)
        setGraphsScale(yAxisValues: arrayOfYTitles)  // SORT TO PREVENT ERRORS
        
        // adjust left padding (need to increase size if have large numbers) and calc column width
        autoCalYAxisPaddingIfNeeded(yAxisValues: arrayOfYTitles)
        setPositions()
        
        let numberOfColumns = CGFloat(arraysOfCategoryItemsNestedInsideOneBigArray[0].count)
        columnWidth = barGraph.frame.width / numberOfColumns
        
        // various settings
        barGraph.showColumnSubTotals = showColumnSubTotals
        barGraph.showColumnTotals = showColumnTotals
        
        // update our three collections views (the graph, x-axis, y-axis) with data
        barGraph.loadDataForCollectionView(arraysOfCategoryItemsNestedInsideOneBigArray: arraysOfCategoryItemsNestedInsideOneBigArray, widthOfColumn:columnWidth)
        updateColumnTitles(columnTitles: arrayOfCategoryTitles)
        updateYValues(yAxisTitles: arrayOfYTitles)

    }

    func loadDataForCollectionView(#array: Array<BarGraphDataItem>, arrayOfCategoryTitles: Array<String>, arrayOfYTitles: Array<Double>) {
        
        // convert it into our expected matrix format so we do not have to have different handling depending on user input
        let dataMatrix = convertArrayOfInputDataIntoTwoDimensionalArray(arrayOfData: array)
        
        // call main load function, above
        loadDataForCollectionView(arraysOfCategoryItemsNestedInsideOneBigArray: dataMatrix, arrayOfCategoryTitles: arrayOfCategoryTitles, arrayOfYTitles: arrayOfYTitles)
        
    }

    func updateColumnTitles(#columnTitles:[String]){
        
        columnHeadings.columnHeadingsFromUser = columnTitles
        columnHeadings.columnWidth = columnWidth
        columnHeadings.reloadData()
        
    }
    
    func updateYValues(#yAxisTitles:[Double]){
        
        //let cellHeight = self.frame.height / yAxisTitles.count
        
        yValues.yValues = yAxisTitles
        yValues.reloadData()
        
    }
    
    
    // MARK: helpers

    func convertArrayOfInputDataIntoTwoDimensionalArray(#arrayOfData:Array<BarGraphDataItem>) -> Array<Array<BarGraphDataItem>>{
        
        var outputArray = [Array<BarGraphDataItem>]()
        
        for item in arrayOfData {
            
            // put item in array
            var nestedArray = [BarGraphDataItem]()
            nestedArray.append(item)
            
            // put array in output array
            outputArray.append(nestedArray)
        }
        
        return outputArray
    }
    
    func setGraphsScale(#yAxisValues: Array<Double>){
    
        let maxValue = CGFloat(yAxisValues.last!)
        let scaleFactor = barGraph.frame.height / maxValue
        
        barGraph.yScaleFactor = scaleFactor
        yValues.yScaleFactor = scaleFactor

    }

}
