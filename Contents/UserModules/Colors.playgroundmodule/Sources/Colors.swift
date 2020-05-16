/* 
    Wave Lab - Colors
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SwiftUI

/// A namespace for custom colors.
public enum Colors {
    /// The color "vividBlue" in SwiftUI's type
    public static let vividBlue = Color(
        .sRGB,
        red: 0.008,
        green: 0.361,
        blue: 0.937
    )
    
    public static let vividBlueLegacy = UIColor(
        displayP3Red: 0.008,
        green: 0.361,
        blue: 0.937,
        alpha: 1
    )
}
