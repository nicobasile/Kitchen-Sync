//
//  AppDelegate+Resolving.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { AuthenticationService() }.scope(application)
    register { FirestoreItemRepository() as ItemRepository }.scope(application)
  }
}
