// swiftlint:disable all
import Amplify
import Foundation

public struct Player: Model {
  public let id: String
  public var username: String
  public var position: Position?
  public var currentGameId: String?
  public var highScore: Int?
  public var isOnline: Bool
  public var lastActiveAt: Temporal.DateTime?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      position: Position? = nil,
      currentGameId: String? = nil,
      highScore: Int? = nil,
      isOnline: Bool,
      lastActiveAt: Temporal.DateTime? = nil) {
    self.init(id: id,
      username: username,
      position: position,
      currentGameId: currentGameId,
      highScore: highScore,
      isOnline: isOnline,
      lastActiveAt: lastActiveAt,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      username: String,
      position: Position? = nil,
      currentGameId: String? = nil,
      highScore: Int? = nil,
      isOnline: Bool,
      lastActiveAt: Temporal.DateTime? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.position = position
      self.currentGameId = currentGameId
      self.highScore = highScore
      self.isOnline = isOnline
      self.lastActiveAt = lastActiveAt
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}