//
//  material-design-extension.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation
import MaterialComponents

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct FlatColor {
        struct Green {
            static let Fern = UIColor(netHex: 0x6ABB72)
            static let MountainMeadow = UIColor(netHex: 0x3ABB9D)
            static let ChateauGreen = UIColor(netHex: 0x4DA664)
            static let PersianGreen = UIColor(netHex: 0x2CA786)
        }
        
        struct Blue {
            static let PictonBlue = UIColor(netHex: 0x5CADCF)
            static let Mariner = UIColor(netHex: 0x3585C5)
            static let CuriousBlue = UIColor(netHex: 0x4590B6)
            static let Denim = UIColor(netHex: 0x2F6CAD)
            static let Chambray = UIColor(netHex: 0x485675)
            static let BlueWhale = UIColor(netHex: 0x29334D)
        }
        
        struct Violet {
            static let Wisteria = UIColor(netHex: 0x9069B5)
            static let BlueGem = UIColor(netHex: 0x533D7F)
        }
        
        struct Yellow {
            static let Energy = UIColor(netHex: 0xF2D46F)
            static let Turbo = UIColor(netHex: 0xF7C23E)
        }
        
        struct Orange {
            static let NeonCarrot = UIColor(netHex: 0xF79E3D)
            static let Sun = UIColor(netHex: 0xEE7841)
        }
        
        struct Red {
            static let TerraCotta = UIColor(netHex: 0xE66B5B)
            static let Valencia = UIColor(netHex: 0xCC4846)
            static let Cinnabar = UIColor(netHex: 0xDC5047)
            static let WellRead = UIColor(netHex: 0xB33234)
        }
        
        struct Gray {
            static let AlmondFrost = UIColor(netHex: 0xA28F85)
            static let WhiteSmoke = UIColor(netHex: 0xEFEFEF)
            static let Iron = UIColor(netHex: 0xD1D5D8)
            static let IronGray = UIColor(netHex: 0x75706B)
        }
    }
    
    struct MDColor {
        static let red = UIColor.init(netHex: 0xF44336)
        static let pink = UIColor.init(netHex: 0xE91E63)
        static let purple = UIColor.init(netHex: 0x9C27B0)
        static let deepPurple = UIColor.init(netHex: 0x673AB7)
        static let indigo = UIColor.init(netHex: 0x3F51B5)
        static let blue = UIColor.init(netHex: 0x2196F3)
        static let lightBlue = UIColor.init(netHex: 0x03A9F4)
        static let cyan = UIColor.init(netHex: 0x00BCD4)
        static let teal = UIColor.init(netHex: 0x009688)
        static let green = UIColor.init(netHex: 0x4CAF50)
        static let lightGreen = UIColor.init(netHex: 0x8BC34A)
        static let lime = UIColor.init(netHex: 0xCDDC39)
        static let yellow = UIColor.init(netHex: 0xFFEB3B)
        static let amber = UIColor.init(netHex: 0xFFC107)
        static let orange = UIColor.init(netHex: 0xFF9800)
        static let deepOrange = UIColor.init(netHex: 0xFF5722)
        static let brown = UIColor.init(netHex: 0x795548)
        static let grey = UIColor.init(netHex: 0x9E9E9E)
        static let blueGrey = UIColor.init(netHex: 0x607D8B)
    }
}

extension CGSize {
    struct MDSize {
        static let FloatBottonSize = CGSize.init(width: 56, height: 56)
    }
    
}

extension CGFloat {
    struct MDFloat {
        static let denseTwoLineHeight = CGFloat.init(60)
        static let toolBarHeight = CGFloat.init(56)
        static let listItemHeight = CGFloat.init(48)
    }
}
