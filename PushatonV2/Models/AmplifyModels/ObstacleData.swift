// swiftlint:disable all
import Amplify
import Foundation

public struct ObstacleData: Embeddable {
  var isLow: Bool
  var coinArrangement: CoinArrangement?
  var coinValue: Int?
}