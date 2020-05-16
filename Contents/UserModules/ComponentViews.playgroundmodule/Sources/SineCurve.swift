/* 
    Wave Lab - Sine Curve
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SwiftUI

struct SineCurve: Shape {
    /// This sine curve's initial phase difference. Use π/2 for a cosine curve.
    var φ₀: CGFloat = 0
    
    var animatableData: CGFloat {
        get { φ₀ }
        set { φ₀ = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(
            x: 0,
            y: rect.midY - sin(φ₀) * rect.midY
        ))
        let n = Int(rect.width)
        for i in 1...n {
            path.addLine(to: CGPoint(
                x: rect.width * CGFloat(i) / CGFloat(n),
                y: rect.midY - sin(2 * CGFloat(i) * CGFloat.pi / CGFloat(n) + φ₀) * rect.midY
            ))
        }
        return path
    }
}
