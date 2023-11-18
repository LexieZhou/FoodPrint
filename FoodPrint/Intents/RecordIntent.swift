//
//  RecordIntent.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 18/11/2023.
//

import Foundation
import AppIntents
import SwiftUI
import Intents


struct RecordIntent: AppIntent {

    static let title: LocalizedStringResource = "Record a Meal"
    static let description: LocalizedStringResource = "Record a Meal in Foodprint app!"
    
    static let openAppWhenRun: Bool = true


  func perform() async throws -> some IntentResult & ProvidesDialog {
      /// Navigate to the HomepageView
      await FoodPrintApp.resetToHomePage()

    return .result(dialog: "Opening Foodprint App ...")
  }
}

