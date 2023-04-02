//
//  IncidentsViewModes.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 30/03/2023.
//

import Foundation

enum IncidentsViewModes: String {
    case all = "All "
    case active = "Active "
    case closed = "Closed "
}

struct Menu {
    
    var currentMode: IncidentsViewModes
    
    //    func computeMetricMeasurement(inputData: Double) -> Double {
    func returnMenu() {
        switch(currentMode) {
        case .all:
            return
        case .active:
            return
        case .closed:
            return
        }
    }
}
