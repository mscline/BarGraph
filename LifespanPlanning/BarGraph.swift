//
//  BarGraph.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/2/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class BarGraph: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
        // data arrays
        var dataSetFromUser:Array<Array<BarGraphDataItem>>?            // format dataSet[category][column]
        var dataSetForDisplay:Array<Array<BarGraphDataItem>>?          // flips x and y coords of input matrix, giving us dataSet[column][category]
        var linearVersionOfDataSetForCollectionView:Array<BarGraphDataItem>?
    
        // settings
        var showColumnTotals:Bool = false
        var showColumnSubTotals:Bool = false
    
        // AutoCalc / set by Parent View
        var maxValue:CGFloat = 0  // will be = last value in y-Axis values
        var widthOfCell:CGFloat = 0
        var yScaleFactor:CGFloat = 1.0
    
        // Touches
        var delegateForTouches:BarGraphItemWasTouchedProtocol?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCollectionView()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
    }
    
    
    // MARK: COLLECTION VIEW - SETUP
    
    // here we are not going to create a full custom layout, we are just going to use a layout flow and override some of its delegate methods
    // - a cell / data item stores the color and its height values

    func setupCollectionView(){
        
        dataSource = self
        delegate = self
        
        // register collection view cell so can create programatically
        self.registerClass(BarGraphColumnCell.classForCoder(), forCellWithReuseIdentifier: "barGraphDataCell")
        
        // set scroll direction and set collection view delegate
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal  // a horizontal scroll gives you a vertical layout !!!
        collectionViewLayout = layout  // this will automatically set the flowLayout delegate to be the same as the collectionView.delegate
    
        // add gestures to cv (not going to use didSelect delegate method because harder to implement various touches)
        addGestures()
        
    }

    
    // MARK: LOAD DATA
    
    func loadDataForCollectionView(#arraysOfCategoryItemsNestedInsideOneBigArray:Array<Array<BarGraphDataItem>>, widthOfColumn:CGFloat) {
        
        
        // set variables
        self.widthOfCell = widthOfColumn
        self.dataSetFromUser = arraysOfCategoryItemsNestedInsideOneBigArray
        
        // reorganize data matrix
        let dataSetWithPaddingCells = addRowToMatrixToCreateTopSpace(&dataSetFromUser!)
        self.dataSetForDisplay = flipXYCoordinatesInMatrix(inputMatrix:dataSetWithPaddingCells)

        // calculate element heights
        setScaledHeight()
        clipColumnItemsHeightIfGoingOffScreen_andSetSpacerValueWhichWillBeUsedAsTitle()

        // covert data matrix into array and display
        self.linearVersionOfDataSetForCollectionView = convertMatrixIntoSingleArray(dataSetForDisplay: dataSetForDisplay!)

        self.reloadData()
        
    }
    
    
    // MARK: COLLECTION VIEW - DATASOURCE

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1;
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if linearVersionOfDataSetForCollectionView == nil { return 0; }

        return linearVersionOfDataSetForCollectionView!.count
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let barItem = linearVersionOfDataSetForCollectionView![indexPath.row]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("barGraphDataCell", forIndexPath: indexPath) as! BarGraphColumnCell
        
        cell.backgroundColor = barItem.color
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        addColumnSubTotalsIfRequired(dataObject: barItem, cell: cell, indexPath: indexPath)
        formatCell(dataObject: barItem, cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func formatCell(#dataObject:BarGraphDataItem, cell:BarGraphColumnCell, indexPath:NSIndexPath){
    
        // fail ???
        // if collection view being reloaded due to a layout change, it is necessary to update subview sizes
        cell.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        cell.bottomLabel = UILabel(frame: CGRectMake(0, self.frame.size.height - 14, self.frame.size.width, 14))

        
        // format based on whether spacer, normal item, selected item
        if isASpacerCell(indexPath) {
            
            cell.layer.borderWidth = 0
            
        }else if dataObject.isSelected == true {
            
            cell.layer.borderWidth = 2.5
            
        }else{
            
            cell.layer.borderWidth = 0.5
        }
    }
    
    func addColumnSubTotalsIfRequired(#dataObject:BarGraphDataItem, cell:BarGraphColumnCell, indexPath:NSIndexPath){
    
        var textString = ""
        let isAHeaderCell = isASpacerCell(indexPath)
        
        
        // add total sums
        if isAHeaderCell && showColumnTotals {
        
            let text = String("\(dataObject.value_akaHeightOfBar)")
            
            cell.bottomLabel.attributedText = TextFormatter.createAttributedString(text, withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)
            
        } else {
        
            cell.bottomLabel.attributedText =  TextFormatter.createAttributedString("", withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)
            
        }
        
        // add subCategory Totals
        if !isAHeaderCell && showColumnSubTotals {
        
            let text = String("\(dataObject.value_akaHeightOfBar)")
            
            var attributedText = TextFormatter.createAttributedString(text, withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)
            
            cell.label.attributedText = attributedText
        
        } else {
        
            cell.label.attributedText = TextFormatter.createAttributedString("", withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)
            
        }
        
    }
    
    func isASpacerCell(indexPath:NSIndexPath) -> Bool {
        
        let numberOfItemsInColumn = dataSetForDisplay![0].count
        let rowNumber = indexPath.row % numberOfItemsInColumn
        
        if rowNumber == 0 {
        
            return true
            
        } else {
        
            return false
        }
    }
    
    
    // MARK: COLLECTION VIEW - LAYOUT
    
    // set size of cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let barItem = linearVersionOfDataSetForCollectionView![indexPath.row]
        let height = barItem.scaledHeight
        
        return CGSizeMake(widthOfCell, height)
        
    }
    
    // spacing between columns
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
        
    }
    
    // spacing between items within column
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }

    
    // MARK: SETUP GESTURES
    
    func addGestures() {
    
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        addGestureRecognizer(tapGestureRecognizer)

        var doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGestureRecognizer)

        var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongTap:"))
        addGestureRecognizer(longPressGestureRecognizer)

        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        addGestureRecognizer(panGestureRecognizer)

        
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        tapGestureRecognizer.requireGestureRecognizerToFail(longPressGestureRecognizer)
        tapGestureRecognizer.requireGestureRecognizerToFail(panGestureRecognizer)
    }
    
    func handleTap(sender:UIGestureRecognizer){
    
        if sender.state == UIGestureRecognizerState.Ended
        {
            forwardGestureToUser(sender, touchType: TouchType.singleTap)
        }
    }
    
    func handleDoubleTap(sender:UITapGestureRecognizer){
    
        if sender.state == UIGestureRecognizerState.Ended
        {
            forwardGestureToUser(sender, touchType: TouchType.doubleTap)
        }
    
    }
    
    func handleLongTap(sender:UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Ended {
    
            forwardGestureToUser(sender, touchType: TouchType.longPress)
        }
    
    }
    
    func handlePan(sender:UIPanGestureRecognizer){
    
        if sender.state == UIGestureRecognizerState.Began {
            
            forwardGestureToUser(sender, touchType: TouchType.dragStart)
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            forwardGestureToUser(sender, touchType: TouchType.dragInProgress)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            forwardGestureToUser(sender, touchType: TouchType.dragEnd)
        }
        
    }
    
    
    // MARK: HANDLE GESTURES
    
    func forwardGestureToUser(sender:UIGestureRecognizer, touchType:TouchType){
    
        let pointTouched = sender.locationInView(self)
        let locationOfTouchInGraph = sender.locationInView(self.superview)
        let touchInfo = returnCorrected_touchOrigin_column_category_andConfirmIsValid(pointTouched: pointTouched)
        
        // if invalid touch, exit (This shouldn't happen unless dragging object)
        if touchInfo.3 == false {
        
            delegateForTouches?.graphReceivedTouch(touchOrigin: TouchOrigin.outOfBounds, touchType: touchType, columnTouched: 0, subCategory: 0, locationOfTouchOnGraph: locationOfTouchInGraph)
            return
        
        }
        
        // forward info to user
        delegateForTouches?.graphReceivedTouch(touchOrigin: touchInfo.0, touchType: touchType, columnTouched: touchInfo.1, subCategory: touchInfo.2, locationOfTouchOnGraph: locationOfTouchInGraph)
       
    }


    // MARK: helpers
    
    func returnCorrected_touchOrigin_column_category_andConfirmIsValid(#pointTouched:CGPoint) -> (TouchOrigin, Int, Int, Bool) {
    
        var touchOrigin = TouchOrigin.barGraphItem
        
        let tupleWith_isValid_column_subCategory = getIndexForTouchPointAndConvertIntoTupleWithIsValid_column_subCategory(pointTouched: pointTouched)
        let column = tupleWith_isValid_column_subCategory.1
        
        // if touch is not on a cell, then exit (this should never happen)
        if tupleWith_isValid_column_subCategory.0 == false {
            
            return (touchOrigin, 0, 0, false);
        }
        
        // if touch on spacer cell, then change touch origin 
        // (that is, we want to know if it is in subCategory index == 0)
        if tupleWith_isValid_column_subCategory.2 == 0 {
            
            touchOrigin = TouchOrigin.aboveBarGraphColumn
        }
        
        // the subCategory row numbers are in reverse order for display, fix it
        let currentSubCategoryIndex = tupleWith_isValid_column_subCategory.2
        let correctedSubcategory = currentSubCategoryIndex - 1  // don't include the cell used for padding
        
        return (touchOrigin, column, correctedSubcategory, true)
        
    }
    
    func getIndexForTouchPointAndConvertIntoTupleWithIsValid_column_subCategory(#pointTouched:CGPoint) -> (Bool, Int, Int) {

        let index = self.indexPathForItemAtPoint(pointTouched)?.row
        if index == nil { return (false,0,0); }
        
        let numberOfItemsInColumn = dataSetForDisplay![0].count
        
        let column = Int(index! / numberOfItemsInColumn)
        let subCategory = index! % numberOfItemsInColumn
        
        return (true, column, subCategory)
        
    }
    
    
    // MARK: DATA MANIPULATION

    func checkDatasetsDataIntegrity(){
    
    }
    
    func flipXYCoordinatesInMatrix(#inputMatrix:Array<Array<BarGraphDataItem>>) -> Array<Array<BarGraphDataItem>> {

        
        // PART 1: build an empty output matrix of same size as input matrix but with flipped x and y components
        var outputArray = [Array<BarGraphDataItem>]()

        // for each item in a row of our input array, we will create a column for our output array
        var row = inputMatrix[0]
        
        for item in row {
            
            var column = [BarGraphDataItem]()
            outputArray.append(column)
        }

        // PART 2: iterate through each item in the input array and set the proper value in the output array (it is the inverse)
        let numberOfRows = inputMatrix.count
        let numberOfColumns = inputMatrix[0].count

        for var row = 0; row < numberOfRows; row++ {
        
            for var column = 0; column < numberOfColumns; column++ {
            
                let objectFromInputArray = inputMatrix[row][column]
                
                outputArray[column].append(objectFromInputArray)
                
            }
            
        }
        
        return outputArray
    }
    
    func convertMatrixIntoSingleArray(#dataSetForDisplay:Array<Array<BarGraphDataItem>>!) -> Array <BarGraphDataItem> {
    
        var outputArray = [BarGraphDataItem]()
        
        for nestedArray in dataSetForDisplay {
            
            outputArray = outputArray + nestedArray
            
        }
        
        return outputArray
    }
    
    func addRowToMatrixToCreateTopSpace(inout inputMatrix:Array<Array<BarGraphDataItem>>) -> Array<Array<BarGraphDataItem>> {

        // create a new row to insert our values in
        var addRowToArray = [BarGraphDataItem]()
        
        // for each column in our matrix, insert a black colored barItem
        let row = inputMatrix[0]
        
        for column in row  {
            
            var blackBarItem = BarGraphDataItem(columnName: "spacer", subCategoryName: "spacer", value: 100000, color: UIColor.clearColor())
            addRowToArray.append(blackBarItem)
        }
        
        // add the new row and return the value
        inputMatrix.insert(addRowToArray, atIndex: 0)
     
        return inputMatrix
    
    }

    func setScaledHeight(){
    
        // iterate thru all items and add scaled height
        
        for column in dataSetForDisplay! {
            
            for item in column {
            
                item.scaledHeight = item.value_akaHeightOfBar * yScaleFactor
            }
        }
    }
    
    func clipColumnItemsHeightIfGoingOffScreen_andSetSpacerValueWhichWillBeUsedAsTitle(){
    
        for column in dataSetForDisplay! {
            
            let maxPossibleValue = self.frame.height
            var sumOfColumnHeightsSoFar:CGFloat = 0
            
            // for each item in column, starting with the last
            for var i = column.count - 1; i > -1; i-- {
            
                var item = column[i]
                if sumOfColumnHeightsSoFar + item.scaledHeight > maxPossibleValue {
                
                    item.scaledHeight = maxPossibleValue - sumOfColumnHeightsSoFar
                }
                
                sumOfColumnHeightsSoFar = sumOfColumnHeightsSoFar + item.scaledHeight
                
            }
            
            column[0].value_akaHeightOfBar = (sumOfColumnHeightsSoFar - column[0].scaledHeight) / yScaleFactor
        }
    }

    
    // OTHER
    
    func printDataSet(inputMatrix:Array<Array<BarGraphDataItem>>){
    
        for array in inputMatrix {
        
            println(); println(); println()
            print("[")
            
            for item in array {
            
                print(" \(item.subCategoryName)/\(item.value_akaHeightOfBar)/\(item.scaledHeight), ")
            }
            
            print("]")
        
        }
    }
    
    
    
}
