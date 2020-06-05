//
//  String+Data.swift
//  movieApp
//
//  Created by Merouane Bellaha on 03/06/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

extension String {
    /// get data from URL 
    var data: Data? {
        guard let url = URL(string: K.request.baseImageUrl+self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
