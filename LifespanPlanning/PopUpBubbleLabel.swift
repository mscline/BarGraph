//
//  PopUpBubbleLabel.swift
//  LifespanPlanning
//
//  Created by Monsoon Co on 6/16/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//


import UIKit

@IBDesignable class PopUpBubbleLabel: UIView {
    
    
    // subviews
    var textView = UITextView(frame: CGRectMake(0, 0, 0, 0))
    var tailView:UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
    
    // layout
    var tailWidth:CGFloat = 10
    var tailHeight:CGFloat = 10
    var tailYPosition:CGFloat = 10
    
    var textPadding:CGFloat = 0  // did I put it in?
    
    
    // INSPECTABLES
    // text and colors
    @IBInspectable var bodyText:String = "Sample Text:\n\nNote: popup does not size correctly in Storyboard."                             { didSet{ textView.text = bodyText} }
    @IBInspectable var textColor:UIColor = UIColor.blackColor()                    { didSet{ formatSubviews()} }
    @IBInspectable var bodyColor:UIColor = UIColor.redColor()                      { didSet{ formatSubviews()} }
    @IBInspectable var cornerRadius:CGFloat = 14
        { didSet{ formatSubviews()} }
    
    // layout
    @IBInspectable var tailPointsLeft:Bool = true { didSet{ setSubViewFrames() } }
    @IBInspectable var autofitTextHeight:Bool = false
        { didSet{ stretchParentsHeightToFitIfDesired(); setSubViewFrames()} }

    
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
        
        setDefaultFrameForUseInStoryboard()  // can't get size because not calc yet
        
        addTail()
        formatSubviews()
        
        stretchParentsHeightToFitIfDesired()
        setSubViewFrames()
        
        addSubview(tailView)
        addSubview(textView)
        
    }
    
    
    // MARK: LAYOUT
    
    func formatSubviews(){
        
        // set colors
        self.backgroundColor = UIColor.clearColor()
        textView.backgroundColor = bodyColor
        tailView.backgroundColor = bodyColor
        
        // set corner radius and clip to bounds
        tailView.layer.cornerRadius = 10
        textView.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        // default text
        textView.text = bodyText
        textView.textColor = textColor
        textView.textAlignment = NSTextAlignment.Center
        textView.contentInset = UIEdgeInsetsMake(0, textPadding, 0, textPadding)  // top, left, bottom, right
        
    }
    
    func setDefaultFrameForUseInStoryboard(){
        
        // can't get the frame size in IB, but want to show something, so set some defaults

        var viewWidth: CGFloat = self.frame.width
        var viewHeight:CGFloat = self.frame.height
        
        if viewWidth == 0 { viewWidth = CGFloat(200); }
        if viewHeight == 0 { viewHeight = CGFloat(100); }

        frame = CGRectMake(frame.origin.x, frame.origin.y, viewWidth, viewHeight)
    }
    
    func stretchParentsHeightToFitIfDesired() {
        
        // exit if not wanted
        if autofitTextHeight != true { return; }
        
        // calc text size and set frame
        let formattedText = TextFormatter.createAttributedString(bodyText, withFont: nil, fontSize: nil, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)
        var desiredFrameHeight = formattedText.boundingRectWithSize(CGSizeMake(textView.frame.width, 5000), options:NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height
        
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, desiredFrameHeight)
        
    }
    
    func setSubViewFrames(){

        // if tail pointing left, then move the text over
        // if pointing right, then text will be on left and tail to its left
        
        var textXPosition:CGFloat
        var tailXPosition:CGFloat
        
        if tailPointsLeft == true {
        
            tailXPosition = 0
            textXPosition = tailWidth
            
        } else {
            
            textXPosition = 0
            tailXPosition = self.bounds.size.width - tailWidth
            
        }
        
        var viewWidth: CGFloat = self.frame.width
        var viewHeight:CGFloat = self.frame.height

        textView.frame = CGRectMake(textXPosition, 0, viewWidth - tailWidth, viewHeight)        
        tailView.frame = CGRectMake(tailXPosition, tailYPosition, tailWidth, tailHeight)
    
    }
    

    // MARK: BUILD GRAPHICS FOR TAIL
    
    func addTail(){
    
        // remove all old layers
        for layer in tailView.subviews{
            
            layer.removeFromSuperlayer()
            
        }
        
        // create layer and add
        let tailLayer = buildTailShapeLayer()
        //tailView.layer.addSublayer(tailLayer)

    }
    
    func buildTailShapeLayer() -> CAShapeLayer {
    
        // CREATE LAYER
        let shapeLayer = CAShapeLayer()
        
        // set color and line settings
        shapeLayer.fillColor = bodyColor.CGColor
        //shapeLayer.strokeColor = UIColor.blackColor().CGColor
        //shapeLayer.lineWidth = 2.0
        
        
        // BUILD SHAPE FROM LINE SEGEMENTS (ie a Bezier Path)
        let connectedLineSegments = UIBezierPath()
        
        // 1) set start point = center
        //connectedLineSegments.moveToPoint(CGPointMake(tailWidth/2, tailHeight/2))
        
        // 2) connect with point on our circle
        //connectedLineSegments.addLineToPoint(xyCoordPointOnArc)  // crash if no value
        
        // 3) draw arc
        let center:CGPoint = CGPointMake(tailWidth, 0)
        let radius:CGFloat = tailWidth
        let startAngle:CGFloat = 90
        let finalAngle:CGFloat = 180
        let clockwise = false
        
        connectedLineSegments.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: finalAngle, clockwise: clockwise)

        // 3) draw arc
//        let center:CGPoint = CGPointMake(tailWidth, 0)
//        let radius:CGFloat = tailWidth
//        let startAngle:CGFloat = 90
//        let finalAngle:CGFloat = 180
//        let clockwise = false
//        
//        connectedLineSegments.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: finalAngle, clockwise: clockwise)
        // 4) draw line from last point back to the center
        connectedLineSegments.closePath()  // rather than calling addLine, we could use close path which will draw a line to connect our line with our start point
        
        
        // use our Bezier Path as a mask
        shapeLayer.path = connectedLineSegments.CGPath
        
        return shapeLayer
        
    }

}
