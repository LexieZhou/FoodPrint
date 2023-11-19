//
//  RecordShortcuts.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 18/11/2023.
//

import Foundation
import AppIntents
import Intents

// 1
struct RecordShortcuts: AppShortcutsProvider {
  // 2
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: RecordIntent(),
      phrases: [
        "Record a meal",
        "Open Foodprint and record a meal",
        "Open Foodprint to record a meal",
        "I have just eaten a meal. Could you help me record it?",
        "I am having my breakfast. Could you help me record it?",
        "I am having my lunch. Could you help me record it?",
        "I am having my dinner. Could you help me record it?"
      ],
      shortTitle: "Create a Meal Record",
      systemImageName: "camera.fill"
    )
  }
}
