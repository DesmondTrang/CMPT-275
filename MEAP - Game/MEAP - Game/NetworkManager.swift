//
//  NetworkManager.swift
//  MEAP
//
//  Created by Amirsaman Fazelipour on 2018-12-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

