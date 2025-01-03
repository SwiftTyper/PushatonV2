// swiftlint:disable all
import Amplify
import Foundation

public struct Game: Model {
  public let id: String
  public var player1Id: String
  public var player2Id: String?
  public var status: GameStatus
  public var winner: String?
  public var obstacles: [ObstacleData]
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      status: GameStatus,
      winner: String? = nil,
      obstacles: [ObstacleData] = [],
      createdAt: Temporal.DateTime? = nil) {
    self.init(id: id,
      player1Id: player1Id,
      player2Id: player2Id,
      status: status,
      winner: winner,
      obstacles: obstacles,
      createdAt: createdAt,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      status: GameStatus,
      winner: String? = nil,
      obstacles: [ObstacleData] = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.player1Id = player1Id
      self.player2Id = player2Id
      self.status = status
      self.winner = winner
      self.obstacles = obstacles
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}