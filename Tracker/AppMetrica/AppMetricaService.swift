//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 16.11.2024.
//

import Foundation
import AppMetricaCore

final class AppMetricaService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "9f5e1eed-c548-4c2e-9fcc-953ac9610785") else { return }
        AppMetrica.activate(with: configuration)
    }

    static func report(event: AppMetricaEvent, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
