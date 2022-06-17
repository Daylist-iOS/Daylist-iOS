//
//  BaseViewModel.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation
import RxSwift

protocol BaseViewModel: Input, Output {
    var apiSession: APIService { get }
    
    var bag: DisposeBag { get }
}
