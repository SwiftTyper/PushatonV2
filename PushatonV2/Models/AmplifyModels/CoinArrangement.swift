// swiftlint:disable all
import Amplify
import Foundation

public enum CoinArrangement: String, EnumPersistable {
  case straight = "STRAIGHT"
  case doubleStraight = "DOUBLE_STRAIGHT"
  case arc = "ARC"
}