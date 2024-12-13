// swiftlint:disable all
import Amplify
import Foundation

extension Position {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case y
    case z
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let position = Position.keys
    
    model.listPluralName = "Positions"
    model.syncPluralName = "Positions"
    
    model.fields(
      .field(position.y, is: .required, ofType: .double),
      .field(position.z, is: .required, ofType: .double)
    )
    }
}