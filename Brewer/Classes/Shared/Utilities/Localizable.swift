// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Edit
  case NavigationEdit
  /// Done
  case NavigationDone
  /// Start brewing
  case StartBrewingItemTitle
  /// History
  case HistoryItemTitle
  /// Settings
  case SettingsItemTitle
  /// Search
  case HistoryFilterPlaceholder
  /// Here you'll see the history of your brewings
  case HistoryEmptySetDescription
  /// Sort
  case BrewingsSortingSortTitle
  /// From the oldest
  case BrewingsSortingDateAscending
  /// From the newest
  case BrewingsSortingDateDescending
  /// From the worst
  case BrewingsSortingScoreAscending
  /// From the best
  case BrewingsSortingScoreDescending
  /// Brewing sequence
  case SettingsBrewingSequenceMenuItemTitle
  /// Default
  case SettingsBrewingSequenceMenuDefaultSubtitle
  /// Units
  case SettingsUnitsMenuItemTitle
  /// About
  case SettingsAboutMenuItemTitle
  /// Feedback
  case SettingsFeedbackMenuItemTitle
  /// Thanks for translation
  case SettingsAboutThanksForTransaltion
  /// Pick method
  case MethodPickItemTitle
  /// Espresso machine
  case MethodEsspressoMachine
  /// Pour-Over
  case MethodPourOver
  /// Aeropress
  case MethodAeropress
  /// V60
  case MethodDetailV60
  /// Chemex
  case MethodDetailChemex
  /// Traditional
  case MethodDetailTraditional
  /// Inverted
  case MethodDetailInverted
  /// Sequence
  case SequenceItemTitle
  /// Units
  case UnitsItemTitle
  /// Coffee weight
  case AttributeCoffeeWeight
  /// Grind size
  case AttributeGrindSize
  /// Tamp strength
  case AttributeTampStrength
  /// Temperature
  case AttributeTemperature
  /// Water weight or volume
  case AttributeWaterWeight
  /// Time
  case AttributeTime
  /// Notes
  case AttributeNotes
  /// Water
  case UnitCategoryWater
  /// Coffee
  case UnitCategoryCoffee
  /// Temperature
  case UnitCategoryTemperature
  /// New brew
  case NewBrewItemTitle
  /// Type your coffee...
  case NewBrewCoffeeInputPlaceholder
  /// Type your espresso machine...
  case NewBrewCoffeeMachinePlaceholder
  /// Coffee
  case SelectableSearchCoffeeItemTitle
  /// Espresso machine
  case SelectableSearchCoffeeMachineItemTitle
  /// Tap here to use slider
  case GrindSizeSliderButtonTitle
  /// Tap here to provide numerical value
  case GrindSizeNumericButtonTitle
  /// Extra fine
  case GrindSizeLevelExtraFine
  /// Fine
  case GrindSizeLevelFine
  /// Medium
  case GrindSizeLevelMedium
  /// Coarse
  case GrindSizeLevelCoarse
  /// Type duration of brewing process
  case TimeInformativeText
  /// Type or select grind size
  case GrindSizeInformativeText
  /// Type weight or volume of water.\nUnit can be changed in settings
  case WaterInformativeText
  /// Type water temperature.\nUnit can be changed in settings
  case TemperatureInformativeText
  /// Type coffee weight.\nUnit can be changed in settings
  case WeightInformativeText
  /// Select tamping strength
  case TampingInformativeText
  /// Brew details
  case BrewDetailsItemTitle
  /// Score
  case BrewDetailScore
  /// Score details
  case BrewScoreDetailsItemTitle
  /// Remove brew
  case BrewDetailsRemoveTitle
  /// Are you sure you want to remove this brew?
  case BrewDetailsConfirmationTitle
  /// Yes
  case BrewDetailsConfirmationYes
  /// No
  case BrewDetailsConfirmationNo
  /// Aroma
  case CuppingAttributeAroma
  /// Acidity
  case CuppingAttributeAcidity
  /// Aftertaste
  case CuppingAttributeAftertaste
  /// Balance
  case CuppingAttributeBalance
  /// Body
  case CuppingAttributeBody
  /// Sweetness
  case CuppingAttributeSweetness
  /// Overall
  case CuppingAttributeOverall
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .NavigationEdit:
        return L10n.tr("NavigationEdit")
      case .NavigationDone:
        return L10n.tr("NavigationDone")
      case .StartBrewingItemTitle:
        return L10n.tr("StartBrewingItemTitle")
      case .HistoryItemTitle:
        return L10n.tr("HistoryItemTitle")
      case .SettingsItemTitle:
        return L10n.tr("SettingsItemTitle")
      case .HistoryFilterPlaceholder:
        return L10n.tr("HistoryFilterPlaceholder")
      case .HistoryEmptySetDescription:
        return L10n.tr("HistoryEmptySetDescription")
      case .BrewingsSortingSortTitle:
        return L10n.tr("BrewingsSortingSortTitle")
      case .BrewingsSortingDateAscending:
        return L10n.tr("BrewingsSortingDateAscending")
      case .BrewingsSortingDateDescending:
        return L10n.tr("BrewingsSortingDateDescending")
      case .BrewingsSortingScoreAscending:
        return L10n.tr("BrewingsSortingScoreAscending")
      case .BrewingsSortingScoreDescending:
        return L10n.tr("BrewingsSortingScoreDescending")
      case .SettingsBrewingSequenceMenuItemTitle:
        return L10n.tr("SettingsBrewingSequenceMenuItemTitle")
      case .SettingsBrewingSequenceMenuDefaultSubtitle:
        return L10n.tr("SettingsBrewingSequenceMenuDefaultSubtitle")
      case .SettingsUnitsMenuItemTitle:
        return L10n.tr("SettingsUnitsMenuItemTitle")
      case .SettingsAboutMenuItemTitle:
        return L10n.tr("SettingsAboutMenuItemTitle")
      case .SettingsFeedbackMenuItemTitle:
        return L10n.tr("SettingsFeedbackMenuItemTitle")
      case .SettingsAboutThanksForTransaltion:
        return L10n.tr("SettingsAboutThanksForTransaltion")
      case .MethodPickItemTitle:
        return L10n.tr("MethodPickItemTitle")
      case .MethodEsspressoMachine:
        return L10n.tr("MethodEsspressoMachine")
      case .MethodPourOver:
        return L10n.tr("MethodPourOver")
      case .MethodAeropress:
        return L10n.tr("MethodAeropress")
      case .MethodDetailV60:
        return L10n.tr("MethodDetailV60")
      case .MethodDetailChemex:
        return L10n.tr("MethodDetailChemex")
      case .MethodDetailTraditional:
        return L10n.tr("MethodDetailTraditional")
      case .MethodDetailInverted:
        return L10n.tr("MethodDetailInverted")
      case .SequenceItemTitle:
        return L10n.tr("SequenceItemTitle")
      case .UnitsItemTitle:
        return L10n.tr("UnitsItemTitle")
      case .AttributeCoffeeWeight:
        return L10n.tr("AttributeCoffeeWeight")
      case .AttributeGrindSize:
        return L10n.tr("AttributeGrindSize")
      case .AttributeTampStrength:
        return L10n.tr("AttributeTampStrength")
      case .AttributeTemperature:
        return L10n.tr("AttributeTemperature")
      case .AttributeWaterWeight:
        return L10n.tr("AttributeWaterWeight")
      case .AttributeTime:
        return L10n.tr("AttributeTime")
      case .AttributeNotes:
        return L10n.tr("AttributeNotes")
      case .UnitCategoryWater:
        return L10n.tr("UnitCategoryWater")
      case .UnitCategoryCoffee:
        return L10n.tr("UnitCategoryCoffee")
      case .UnitCategoryTemperature:
        return L10n.tr("UnitCategoryTemperature")
      case .NewBrewItemTitle:
        return L10n.tr("NewBrewItemTitle")
      case .NewBrewCoffeeInputPlaceholder:
        return L10n.tr("NewBrewCoffeeInputPlaceholder")
      case .NewBrewCoffeeMachinePlaceholder:
        return L10n.tr("NewBrewCoffeeMachinePlaceholder")
      case .SelectableSearchCoffeeItemTitle:
        return L10n.tr("SelectableSearchCoffeeItemTitle")
      case .SelectableSearchCoffeeMachineItemTitle:
        return L10n.tr("SelectableSearchCoffeeMachineItemTitle")
      case .GrindSizeSliderButtonTitle:
        return L10n.tr("GrindSizeSliderButtonTitle")
      case .GrindSizeNumericButtonTitle:
        return L10n.tr("GrindSizeNumericButtonTitle")
      case .GrindSizeLevelExtraFine:
        return L10n.tr("GrindSizeLevelExtraFine")
      case .GrindSizeLevelFine:
        return L10n.tr("GrindSizeLevelFine")
      case .GrindSizeLevelMedium:
        return L10n.tr("GrindSizeLevelMedium")
      case .GrindSizeLevelCoarse:
        return L10n.tr("GrindSizeLevelCoarse")
      case .TimeInformativeText:
        return L10n.tr("TimeInformativeText")
      case .GrindSizeInformativeText:
        return L10n.tr("GrindSizeInformativeText")
      case .WaterInformativeText:
        return L10n.tr("WaterInformativeText")
      case .TemperatureInformativeText:
        return L10n.tr("TemperatureInformativeText")
      case .WeightInformativeText:
        return L10n.tr("WeightInformativeText")
      case .TampingInformativeText:
        return L10n.tr("TampingInformativeText")
      case .BrewDetailsItemTitle:
        return L10n.tr("BrewDetailsItemTitle")
      case .BrewDetailScore:
        return L10n.tr("BrewDetailScore")
      case .BrewScoreDetailsItemTitle:
        return L10n.tr("BrewScoreDetailsItemTitle")
      case .BrewDetailsRemoveTitle:
        return L10n.tr("BrewDetailsRemoveTitle")
      case .BrewDetailsConfirmationTitle:
        return L10n.tr("BrewDetailsConfirmationTitle")
      case .BrewDetailsConfirmationYes:
        return L10n.tr("BrewDetailsConfirmationYes")
      case .BrewDetailsConfirmationNo:
        return L10n.tr("BrewDetailsConfirmationNo")
      case .CuppingAttributeAroma:
        return L10n.tr("CuppingAttributeAroma")
      case .CuppingAttributeAcidity:
        return L10n.tr("CuppingAttributeAcidity")
      case .CuppingAttributeAftertaste:
        return L10n.tr("CuppingAttributeAftertaste")
      case .CuppingAttributeBalance:
        return L10n.tr("CuppingAttributeBalance")
      case .CuppingAttributeBody:
        return L10n.tr("CuppingAttributeBody")
      case .CuppingAttributeSweetness:
        return L10n.tr("CuppingAttributeSweetness")
      case .CuppingAttributeOverall:
        return L10n.tr("CuppingAttributeOverall")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}
