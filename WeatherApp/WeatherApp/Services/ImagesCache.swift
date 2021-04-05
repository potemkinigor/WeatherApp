//
//  ImagesCache.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import UIKit

protocol ImagesCacheProtocol {
    var imagesCache: [String : UIImage] { get set }
}

final class ImagesCache {
    
    static let shared = ImagesCache()
    
    var imagesCache: [String : UIImage] = [ : ]
    
    private init() {
        
    }
}
