// swiftlint:disable all
import Amplify
import Foundation

public struct Player: Model {
  public let username: String
  public var currentGameId: String?
  public var position: Position?
  public var score: Int?
  public var highScore: Int
  public var isOnline: Bool
  public var isPlayerAlive: Bool?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(username: String,
      currentGameId: String? = nil,
      position: Position? = nil,
      score: Int? = nil,
      highScore: Int,
      isOnline: Bool,
      isPlayerAlive: Bool? = nil) {
    self.init(username: username,
      currentGameId: currentGameId,
      position: position,
      score: score,
      highScore: highScore,
      isOnline: isOnline,
      isPlayerAlive: isPlayerAlive,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(username: String,
      currentGameId: String? = nil,
      position: Position? = nil,
      score: Int? = nil,
      highScore: Int,
      isOnline: Bool,
      isPlayerAlive: Bool? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.username = username
      self.currentGameId = currentGameId
      self.position = position
      self.score = score
      self.highScore = highScore
      self.isOnline = isOnline
      self.isPlayerAlive = isPlayerAlive
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}