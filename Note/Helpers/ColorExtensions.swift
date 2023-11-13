//
//  ColorExtensions.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation
import SwiftUI

extension Color {
  init(rgb: RGB) {
    self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
  }
}

