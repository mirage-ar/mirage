//
//  Subject+Extension.swift
//  Core
//
//  Created by Saad on 18/02/2023.
//

import Combine
import Foundation

public extension Subject {
    func send(result: Result<Output, Failure>) {
        switch result {
        case .success(let value):
            send(value)

        case .failure(let error):
            send(completion: .failure(error))
        }
    }
}
