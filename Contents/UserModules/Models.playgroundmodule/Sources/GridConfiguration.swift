/* 
    Wave Lab - Grid Configuration
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import CoreGraphics

/// A model to configure a grid.
public struct GridConfiguration {
    /// The x-axis' name shown at its positive end.
    public var xTitle: String
    /// The maximum x-value intended to be contained.
    public var xMax: CGFloat
    /// The minimum x-value intended to be contained.
    public var xMin: CGFloat
    /// The total x-axis length in the coordinate plain.
    public var xTotal: CGFloat { xMax - xMin }
    /// A multiple, for which x-grid lines will be drawn and labels will be added.
    public var xStepSize: CGFloat
    /// The y-axis' name shown at its positive end.
    public var yTitle: String
    /// The maximum y-value intended to be contained.
    public var yMax: CGFloat
    /// The minimum y-value intended to be contained.
    public var yMin: CGFloat
    /// The total y-axis length in the coordinate plain.
    public var yTotal: CGFloat { yMax - yMin }
    /// A multiple, for which y-grid lines will be drawn and labels will be added.
    public var yStepSize: CGFloat
    
    /// Instantiates a new GridConfiguration object.
    /// - Parameter xTitle: The x-axis' name shown at its positive end.
    /// - Parameter xMax: The maximum x-value intended to be contained.
    /// - Parameter xMin: The minimum x-value intended to be contained.
    /// - Parameter xStepSize: A multiple, for which x-grid lines will be drawn and labels will be added.
    /// - Parameter yTitle: The y-axis' name shown at its positive end.
    /// - Parameter yMax: The maximum y-value intended to be contained.
    /// - Parameter yMin: The minimum y-value intended to be contained.
    /// - Parameter yStepSize: The total y-axis length in the coordinate plain.
    public init(xTitle: String, xMax: CGFloat, xMin: CGFloat, xStepSize: CGFloat, yTitle: String, yMax: CGFloat, yMin: CGFloat, yStepSize: CGFloat) {
        self.xTitle = xTitle
        self.xMax = xMax
        self.xMin = xMin
        self.xStepSize = xStepSize
        self.yTitle = yTitle
        self.yMax = yMax
        self.yMin = yMin
        self.yStepSize = yStepSize
    }
}
