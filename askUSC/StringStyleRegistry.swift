//
//  StringStyleRegistry.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/17/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SwiftRichString

class StringStyleRegistry {
    
    static let shared = StringStyleRegistry()
    private init() {
        
    }
    
    var isRun = false
    var styleArray = [Style]()
    
    func register() {
        if (isRun) {
            print("StringStyleRegistry.register has already been called!")
            return
        }
        let styles = styleStruct()
        let mirror = Mirror(reflecting: styles)
        for style in mirror.children {
            Styles.register(style.label!, style: style.value as! StyleProtocol)
        }
        isRun = true
        print("Style init")
    }
    
}

fileprivate struct styleStruct {
    let welcomeStyle = Style {
        $0.font = SystemFonts.HelveticaNeue_Thin.font(size: 27)
        $0.color = UIColor(rgb: 0xFFCC00)
    }
    let nameStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 27)
        $0.color = UIColor.white
    }
    let logOutStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 17)
        $0.color = UIColor(rgb: SharedInfo.USC_redColor)
    }
}

enum StringStyles: String {
    case welcome = "welcomeStyle"
    case name = "nameStyle"
    case logOut = "logOutStyle"
}
