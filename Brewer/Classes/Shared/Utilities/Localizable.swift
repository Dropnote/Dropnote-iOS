// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Edit
  case navigationEdit
  /// Done
  case navigationDone
  /// Start brewing
  case startBrewingItemTitle
  /// History
  case historyItemTitle
  /// Settings
  case settingsItemTitle
  /// Search
  case historyFilterPlaceholder
  /// Here you'll see the history of your brewings
  case historyEmptySetDescription
  /// Sort
  case brewingsSortingSortTitle
  /// From the oldest
  case brewingsSortingDateAscending
  /// From the newest
  case brewingsSortingDateDescending
  /// From the worst
  case brewingsSortingScoreAscending
  /// From the best
  case brewingsSortingScoreDescending
  /// Brewing sequence
  case settingsBrewingSequenceMenuItemTitle
  /// Default
  case settingsBrewingSequenceMenuDefaultSubtitle
  /// Units
  case settingsUnitsMenuItemTitle
  /// About
  case settingsAboutMenuItemTitle
  /// Feedback
  case settingsFeedbackMenuItemTitle
  /// Thanks for translation
  case settingsAboutThanksForTransaltion
  /// Pick method
  case methodPickItemTitle
  /// Espresso machine
  case methodEsspressoMachine
  /// Pour-Over
  case methodPourOver
  /// Aeropress
  case methodAeropress
  /// V60
  case methodDetailV60
  /// Chemex
  case methodDetailChemex
  /// Traditional
  case methodDetailTraditional
  /// Inverted
  case methodDetailInverted
  /// Sequence
  case sequenceItemTitle
  /// Units
  case unitsItemTitle
  /// Coffee weight
  case attributeCoffeeWeight
  /// Grind size
  case attributeGrindSize
  /// Tamp strength
  case attributeTampStrength
  /// Temperature
  case attributeTemperature
  /// Water weight or volume
  case attributeWaterWeight
  /// Time
  case attributeTime
  /// Notes
  case attributeNotes
  /// Water
  case unitCategoryWater
  /// Coffee
  case unitCategoryCoffee
  /// Temperature
  case unitCategoryTemperature
  /// New brew
  case newBrewItemTitle
  /// Type your coffee...
  case newBrewCoffeeInputPlaceholder
  /// Type your espresso machine...
  case newBrewCoffeeMachinePlaceholder
  /// Coffee
  case selectableSearchCoffeeItemTitle
  /// Espresso machine
  case selectableSearchCoffeeMachineItemTitle
  /// Tap here to use slider
  case grindSizeSliderButtonTitle
  /// Tap here to provide numerical value
  case grindSizeNumericButtonTitle
  /// Extra fine
  case grindSizeLevelExtraFine
  /// Fine
  case grindSizeLevelFine
  /// Medium
  case grindSizeLevelMedium
  /// Coarse
  case grindSizeLevelCoarse
  /// Type duration of brewing process
  case timeInformativeText
  /// Type or select grind size
  case grindSizeInformativeText
  /// Type weight or volume of water.\nUnit can be changed in settings
  case waterInformativeText
  /// Type water temperature.\nUnit can be changed in settings
  case temperatureInformativeText
  /// Type coffee weight.\nUnit can be changed in settings
  case weightInformativeText
  /// Select tamping strength
  case tampingInformativeText
  /// Brew details
  case brewDetailsItemTitle
  /// Score
  case brewDetailScore
  /// Score details
  case brewScoreDetailsItemTitle
  /// Remove brew
  case brewDetailsRemoveTitle
  /// Are you sure you want to remove this brew?
  case brewDetailsConfirmationTitle
  /// Yes
  case brewDetailsConfirmationYes
  /// No
  case brewDetailsConfirmationNo
  /// Aroma
  case cuppingAttributeAroma
  /// Acidity
  case cuppingAttributeAcidity
  /// Aftertaste
  case cuppingAttributeAftertaste
  /// Balance
  case cuppingAttributeBalance
  /// Body
  case cuppingAttributeBody
  /// Sweetness
  case cuppingAttributeSweetness
  /// Overall
  case cuppingAttributeOverall
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .navigationEdit:
        return L10n.tr("NavigationEdit")
      case .navigationDone:
        return L10n.tr("NavigationDone")
      case .startBrewingItemTitle:
        return L10n.tr("StartBrewingItemTitle")
      case .historyItemTitle:
        return L10n.tr("HistoryItemTitle")
      case .settingsItemTitle:
        return L10n.tr("SettingsItemTitle")
      case .historyFilterPlaceholder:
        return L10n.tr("HistoryFilterPlaceholder")
      case .historyEmptySetDescription:
        return L10n.tr("HistoryEmptySetDescription")
      case .brewingsSortingSortTitle:
        return L10n.tr("BrewingsSortingSortTitle")
      case .brewingsSortingDateAscending:
        return L10n.tr("BrewingsSortingDateAscending")
      case .brewingsSortingDateDescending:
        return L10n.tr("BrewingsSortingDateDescending")
      case .brewingsSortingScoreAscending:
        return L10n.tr("BrewingsSortingScoreAscending")
      case .brewingsSortingScoreDescending:
        return L10n.tr("BrewingsSortingScoreDescending")
      case .settingsBrewingSequenceMenuItemTitle:
        return L10n.tr("SettingsBrewingSequenceMenuItemTitle")
      case .settingsBrewingSequenceMenuDefaultSubtitle:
        return L10n.tr("SettingsBrewingSequenceMenuDefaultSubtitle")
      case .settingsUnitsMenuItemTitle:
        return L10n.tr("SettingsUnitsMenuItemTitle")
      case .settingsAboutMenuItemTitle:
        return L10n.tr("SettingsAboutMenuItemTitle")
      case .settingsFeedbackMenuItemTitle:
        return L10n.tr("SettingsFeedbackMenuItemTitle")
      case .settingsAboutThanksForTransaltion:
        return L10n.tr("SettingsAboutThanksForTransaltion")
      case .methodPickItemTitle:
        return L10n.tr("MethodPickItemTitle")
      case .methodEsspressoMachine:
        return L10n.tr("MethodEsspressoMachine")
      case .methodPourOver:
        return L10n.tr("MethodPourOver")
      case .methodAeropress:
        return L10n.tr("MethodAeropress")
      case .methodDetailV60:
        return L10n.tr("MethodDetailV60")
      case .methodDetailChemex:
        return L10n.tr("MethodDetailChemex")
      case .methodDetailTraditional:
        return L10n.tr("MethodDetailTraditional")
      case .methodDetailInverted:
        return L10n.tr("MethodDetailInverted")
      case .sequenceItemTitle:
        return L10n.tr("SequenceItemTitle")
      case .unitsItemTitle:
        return L10n.tr("UnitsItemTitle")
      case .attributeCoffeeWeight:
        return L10n.tr("AttributeCoffeeWeight")
      case .attributeGrindSize:
        return L10n.tr("AttributeGrindSize")
      case .attributeTampStrength:
        return L10n.tr("AttributeTampStrength")
      case .attributeTemperature:
        return L10n.tr("AttributeTemperature")
      case .attributeWaterWeight:
        return L10n.tr("AttributeWaterWeight")
      case .attributeTime:
        return L10n.tr("AttributeTime")
      case .attributeNotes:
        return L10n.tr("AttributeNotes")
      case .unitCategoryWater:
        return L10n.tr("UnitCategoryWater")
      case .unitCategoryCoffee:
        return L10n.tr("UnitCategoryCoffee")
      case .unitCategoryTemperature:
        return L10n.tr("UnitCategoryTemperature")
      case .newBrewItemTitle:
        return L10n.tr("NewBrewItemTitle")
      case .newBrewCoffeeInputPlaceholder:
        return L10n.tr("NewBrewCoffeeInputPlaceholder")
      case .newBrewCoffeeMachinePlaceholder:
        return L10n.tr("NewBrewCoffeeMachinePlaceholder")
      case .selectableSearchCoffeeItemTitle:
        return L10n.tr("SelectableSearchCoffeeItemTitle")
      case .selectableSearchCoffeeMachineItemTitle:
        return L10n.tr("SelectableSearchCoffeeMachineItemTitle")
      case .grindSizeSliderButtonTitle:
        return L10n.tr("GrindSizeSliderButtonTitle")
      case .grindSizeNumericButtonTitle:
        return L10n.tr("GrindSizeNumericButtonTitle")
      case .grindSizeLevelExtraFine:
        return L10n.tr("GrindSizeLevelExtraFine")
      case .grindSizeLevelFine:
        return L10n.tr("GrindSizeLevelFine")
      case .grindSizeLevelMedium:
        return L10n.tr("GrindSizeLevelMedium")
      case .grindSizeLevelCoarse:
        return L10n.tr("GrindSizeLevelCoarse")
      case .timeInformativeText:
        return L10n.tr("TimeInformativeText")
      case .grindSizeInformativeText:
        return L10n.tr("GrindSizeInformativeText")
      case .waterInformativeText:
        return L10n.tr("WaterInformativeText")
      case .temperatureInformativeText:
        return L10n.tr("TemperatureInformativeText")
      case .weightInformativeText:
        return L10n.tr("WeightInformativeText")
      case .tampingInformativeText:
        return L10n.tr("TampingInformativeText")
      case .brewDetailsItemTitle:
        return L10n.tr("BrewDetailsItemTitle")
      case .brewDetailScore:
        return L10n.tr("BrewDetailScore")
      case .brewScoreDetailsItemTitle:
        return L10n.tr("BrewScoreDetailsItemTitle")
      case .brewDetailsRemoveTitle:
        return L10n.tr("BrewDetailsRemoveTitle")
      case .brewDetailsConfirmationTitle:
        return L10n.tr("BrewDetailsConfirmationTitle")
      case .brewDetailsConfirmationYes:
        return L10n.tr("BrewDetailsConfirmationYes")
      case .brewDetailsConfirmationNo:
        return L10n.tr("BrewDetailsConfirmationNo")
      case .cuppingAttributeAroma:
        return L10n.tr("CuppingAttributeAroma")
      case .cuppingAttributeAcidity:
        return L10n.tr("CuppingAttributeAcidity")
      case .cuppingAttributeAftertaste:
        return L10n.tr("CuppingAttributeAftertaste")
      case .cuppingAttributeBalance:
        return L10n.tr("CuppingAttributeBalance")
      case .cuppingAttributeBody:
        return L10n.tr("CuppingAttributeBody")
      case .cuppingAttributeSweetness:
        return L10n.tr("CuppingAttributeSweetness")
      case .cuppingAttributeOverall:
        return L10n.tr("CuppingAttributeOverall")
    }
  }

  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
