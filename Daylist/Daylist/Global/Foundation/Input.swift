//
//  Input.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation

protocol Input {
    associatedtype Input
    
    var input: Input { get }
    
    func bindInput()
}
