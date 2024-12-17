// swiftlint:disable all
import Amplify
import Foundation

extension Player {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case username
    case position
    case currentGameId
    case highScore
    case isOnline
    case lastActiveAt
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let player = Player.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Players"
    model.syncPluralName = "Players"
    
    model.attributes(
      .primaryKey(fields: [player.id])
    )
    
    model.fields(
      .field(player.id, is: .required, ofType: .string),
      .field(player.username, is: .required, ofType: .string),
      .field(player.position, is: .optional, ofType: .embedded(type: Position.self)),
      .field(player.currentGameId, is: .optional, ofType: .string),
      .field(player.highScore, is: .optional, ofType: .int),
      .field(player.isOnline, is: .required, ofType: .bool),
      .field(player.lastActiveAt, is: .optional, ofType: .dateTime),
      .field(player.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(player.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Player> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Player: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Player {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var username: FieldPath<String>   {
      string("username") 
    }
  public var currentGameId: FieldPath<String>   {
      string("currentGameId") 
    }
  public var highScore: FieldPath<Int>   {
      int("highScore") 
    }
  public var isOnline: FieldPath<Bool>   {
      bool("isOnline") 
    }
  public var lastActiveAt: FieldPath<Temporal.DateTime>   {
      datetime("lastActiveAt") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}