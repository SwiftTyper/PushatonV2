// swiftlint:disable all
import Amplify
import Foundation

extension Game {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case player1Id
    case player2Id
    case player1Score
    case player2Score
    case status
    case lastUpdateTime
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let game = Game.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Games"
    model.syncPluralName = "Games"
    
    model.attributes(
      .primaryKey(fields: [game.id])
    )
    
    model.fields(
      .field(game.id, is: .required, ofType: .string),
      .field(game.player1Id, is: .required, ofType: .string),
      .field(game.player2Id, is: .optional, ofType: .string),
      .field(game.player1Score, is: .required, ofType: .int),
      .field(game.player2Score, is: .required, ofType: .int),
      .field(game.status, is: .optional, ofType: .enum(type: GameStatus.self)),
      .field(game.lastUpdateTime, is: .optional, ofType: .dateTime),
      .field(game.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(game.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Game> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Game: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Game {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var player1Id: FieldPath<String>   {
      string("player1Id") 
    }
  public var player2Id: FieldPath<String>   {
      string("player2Id") 
    }
  public var player1Score: FieldPath<Int>   {
      int("player1Score") 
    }
  public var player2Score: FieldPath<Int>   {
      int("player2Score") 
    }
  public var lastUpdateTime: FieldPath<Temporal.DateTime>   {
      datetime("lastUpdateTime") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}