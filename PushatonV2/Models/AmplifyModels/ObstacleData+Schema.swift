// swiftlint:disable all
import Amplify
import Foundation

extension ObstacleData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case isLow
    case coinArrangement
    case coinValue
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let obstacleData = ObstacleData.keys
    
    model.listPluralName = "ObstacleData"
    model.syncPluralName = "ObstacleData"
    
    model.fields(
      .field(obstacleData.isLow, is: .required, ofType: .bool),
      .field(obstacleData.coinArrangement, is: .optional, ofType: .enum(type: CoinArrangement.self)),
      .field(obstacleData.coinValue, is: .optional, ofType: .int)
    )
    }
}