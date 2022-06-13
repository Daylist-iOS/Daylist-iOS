//
//  Output.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation

protocol Output {
    associatedtype Output
    
    var output: Output { get }
    
    func bindOutput()
}
