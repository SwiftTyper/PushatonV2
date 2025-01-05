// swiftlint:disable all
import Amplify
import Foundation

public struct Game: Model {
  public let id: String
  public var player1Id: String
  public var player2Id: String?
  public var player1Score: Int
  public var player2Score: Int
  public var isPlayer1Alive: Bool
  public var isPlayer2Alive: Bool
  public var status: GameStatus
  public var winner: String?
  public var obstacles: [ObstacleData]
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      player1Score: Int,
      player2Score: Int,
      isPlayer1Alive: Bool,
      isPlayer2Alive: Bool,
      status: GameStatus,
      winner: String? = nil,
      obstacles: [ObstacleData] = [],
      createdAt: Temporal.DateTime? = nil) {
    self.init(id: id,
      player1Id: player1Id,
      player2Id: player2Id,
      player1Score: player1Score,
      player2Score: player2Score,
      isPlayer1Alive: isPlayer1Alive,
      isPlayer2Alive: isPlayer2Alive,
      status: status,
      winner: winner,
      obstacles: obstacles,
      createdAt: createdAt,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      player1Score: Int,
      player2Score: Int,
      isPlayer1Alive: Bool,
      isPlayer2Alive: Bool,
      status: GameStatus,
      winner: String? = nil,
      obstacles: [ObstacleData] = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.player1Id = player1Id
      self.player2Id = player2Id
      self.player1Score = player1Score
      self.player2Score = player2Score
      self.isPlayer1Alive = isPlayer1Alive
      self.isPlayer2Alive = isPlayer2Alive
      self.status = status
      self.winner = winner
      self.obstacles = obstacles
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}