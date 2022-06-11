//
//  DispatchQueue+HTTPCookieSync.swift
//  HTTPCookieSync
//
//  Created by Dmytrii Golovanov on 12.06.2022.
//  Copyright © 2022 Dmytrii Golovanov. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let httpCookieSync = DispatchQueue(
        label: "HTTPCookieSync_Queue",
        qos: .utility
    )
}
