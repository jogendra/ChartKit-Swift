//
//  BarChart.swift
//  ChartKit-Swift
//
//  Created by JOGENDRA on 28/07/18.
//  Copyright © 2018 Jogendra Singh. All rights reserved.
//

import UIKit

@IBDesignable
class BarChart: UIView {

    // Array of NSNumber
    var data = [Any]()
    // Array of NSString, nil if you don't want labels.
    var xLabels = [Any]()
    // Max y value for chart (only works when autoMax is NO)
    @IBInspectable var max: CGFloat = 0.0
    // Auto set max value
    @IBInspectable var isAutoMax = false
    @IBInspectable var barColor: UIColor?
    var barColors = [Any]()
    @IBInspectable var barSpacing: Int = 0
    @IBInspectable var barBackgroundColor: UIColor?
    // Round bar height to pixel for sharper chart
    @IBInspectable var isRoundToPixel = false

    var accessibleElements = [Any]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadDefaults()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadDefaults()

    }

    func loadDefaults() {
        opaque = false
        // Initialize an empty array which will be populated in -drawRect:
        accessibleElements = [Any]()
        xLabels = nil
        autoMax = true
        barColor = UIColor(red: 106.0 / 255, green: 175.0 / 255, blue: 232.0 / 255, alpha: 1)
        barSpacing = 8
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        roundToPixel = true
    }

    func prepareForInterfaceBuilder() {
        loadDefaults()
        data = [3, 1, 4, 1, 5, 9, 2, 6]
        xLabels = ["T", "E", "A", "C", "h", "a", "r", "t"]
    }

    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let max: Double = autoMax ? data.value(forKeyPath: "@max.self")! : self.max
        var barMaxHeight: CGFloat = rect.height
        let numberOfBars: Int = data.count
        let barWidth = CGFloat((rect.width - barSpacing * (numberOfBars - 1)) / numberOfBars)
        let barWidthRounded: CGFloat = ceil(barWidth)
        if xLabels {
            let fontSize: CGFloat = floor(barWidth)
            let labelsTopMargin: CGFloat = ceil(fontSize * 0.33)
            barMaxHeight -= fontSize + labelsTopMargin
            (xLabels as NSArray).enumerateObjects(usingBlock: {(_ label: String, _ idx: Int, _ stop: Bool) -> Void in
                var paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                label.draw(in: CGRect(x: idx * (barWidth + barSpacing), y: barMaxHeight + labelsTopMargin, width: barWidth, height: fontSize * 1.2), withAttributes: [.font: UIFont(name: "HelveticaNeue", size: fontSize), .foregroundColor: UIColor(white: 0.56, alpha: 1), .paragraphStyle: paragraphStyle])
            })
        }

        for i in 0..<numberOfBars {
            var barHeight = CGFloat((max == 0 ? 0 : barMaxHeight * data[i] / max))
            if barHeight > barMaxHeight {
                barHeight = barMaxHeight
            }
            if roundToPixel {
                barHeight = CGFloat(Int(barHeight))
            }
            var x: CGFloat = floor(i * (barWidth + barSpacing))
            backgroundColor?.setFill()
            var backgroundRect = CGRect(x: x, y: 0, width: barWidthRounded, height: barMaxHeight)
            context.fill(backgroundRect)
            var barColor: UIColor? = barColors ? barColors[i % barColors.count] : barColor
            barColor?.setFill()
            var barRect = CGRect(x: x, y: barMaxHeight - barHeight, width: barWidthRounded, height: barHeight)
            context.fill(barRect)
            // Populate self.accessibleElements with each bar's name and value.
            var element = UIAccessibilityElement(accessibilityContainer: self)
            // The frame can be set to just rect, if it improves usability.
            element.accessibilityFrame = convert(barRect, to: nil)
            // If xLabels has not been initialized, give each bar a name to identify them in the accessibiltyLabel.
            var barLabel = xLabels[i] ? xLabels[i] : "Bar \(i + 1) of \(numberOfBars)"
            // Combine eacb bar's title and value into the accessiblityLabel.
            /* The label uses a percentage estimate, in case the value and max are too large, but if a use case
             * requires count out of a total, substitute the following single-line comment.
             */
            // [NSString stringWithFormat:@"%@ : %@ out of %d", barLabel, self.data[i], (int)max];
            var percentage = (Double((data[i]) as? NSNumber ?? 0.0)) / max
            element.accessibilityLabel = "\(barLabel) : %.2f %%"
            accessibleElements.append(element)
        }
    }

    // MARK: Accessibility
    var isAccessibilityElement: Bool {
        return false
    }

    func accessibilityElementCount() -> Int {
        return data.count
    }

    func accessibilityElement(at index: Int) -> Any? {
        return accessibleElements[index]
    }

    func index(ofAccessibilityElement element: Any) -> Int {
        return accessibleElements.index(of: element)
    }

    // MARK: Setters
    var data: UnsafeRawPointer? {
        self.data = data
        setNeedsDisplay()
    }

    func setXLabels(_ xLabels: [Any]) {
        self.xLabels = xLabels
        setNeedsDisplay()
    }

    func setMax(_ max: CGFloat) {
        self.max = max
        setNeedsDisplay()
    }

    func setAutoMax(_ autoMax: Bool) {
        self.autoMax = autoMax
        setNeedsDisplay()
    }

    func setBarColors(_ barColors: [Any]) {
        self.barColors = barColors
        setNeedsDisplay()
    }

    func setBarColor(_ barColor: UIColor) {
        self.barColor = barColor
        setNeedsDisplay()
    }

    func setBarSpacing(_ barSpacing: Int) {
        self.barSpacing = barSpacing
        setNeedsDisplay()
    }

    var backgroundColor: UIColor? {
        self.backgroundColor = backgroundColor
        setNeedsDisplay()
    }

}
