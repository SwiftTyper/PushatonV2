// swiftlint:disable all
import Amplify
import Foundation

extension Game {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case player1Id
    case player2Id
    case status
    case winner
    case obstacles
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let game = Game.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Games"
    model.syncPluralName = "Games"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [game.id])
    )
    
    model.fields(
      .field(game.id, is: .required, ofType: .string),
      .field(game.player1Id, is: .required, ofType: .string),
      .field(game.player2Id, is: .optional, ofType: .string),
      .field(game.status, is: .required, ofType: .enum(type: GameStatus.self)),
      .field(game.winner, is: .optional, ofType: .string),
      .field(game.obstacles, is: .required, ofType: .embeddedCollection(of: ObstacleData.self)),
      .field(game.createdAt, is: .optional, ofType: .dateTime),
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
  public var winner: FieldPath<String>   {
      string("winner") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}