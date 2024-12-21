// swiftlint:disable all
import Amplify
import Foundation

extension Player {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case username
    case currentGameId
    case position
    case highScore
    case score
    case isAlive
    case isOnline
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let player = Player.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.read]),
      rule(allow: .private, operations: [.create, .read]),
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.update, .delete])
    ]
    
    model.listPluralName = "Players"
    model.syncPluralName = "Players"
    
    model.attributes(
      .index(fields: ["username"], name: nil),
      .primaryKey(fields: [player.username])
    )
    
    model.fields(
      .field(player.username, is: .required, ofType: .string),
      .field(player.currentGameId, is: .optional, ofType: .string),
      .field(player.position, is: .optional, ofType: .embedded(type: Position.self)),
      .field(player.highScore, is: .required, ofType: .int),
      .field(player.score, is: .required, ofType: .int),
      .field(player.isAlive, is: .required, ofType: .bool),
      .field(player.isOnline, is: .required, ofType: .bool),
      .field(player.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(player.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Player> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Player: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

extension Player.IdentifierProtocol {
  public static func identifier(username: String) -> Self {
    .make(fields:[(name: "username", value: username)])
  }
}
extension ModelPath where ModelType == Player {
  public var username: FieldPath<String>   {
      string("username") 
    }
  public var currentGameId: FieldPath<String>   {
      string("currentGameId") 
    }
  public var highScore: FieldPath<Int>   {
      int("highScore") 
    }
  public var score: FieldPath<Int>   {
      int("score") 
    }
  public var isAlive: FieldPath<Bool>   {
      bool("isAlive") 
    }
  public var isOnline: FieldPath<Bool>   {
      bool("isOnline") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}