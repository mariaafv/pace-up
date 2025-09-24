// WorkoutPlan.swift
import Foundation

// Representa o objeto 'workoutPlan' inteiro que está no Firestore
struct WorkoutPlan: Codable {
    let week1: [WorkoutDay]
    let week2: [WorkoutDay]
    let week3: [WorkoutDay]
    let week4: [WorkoutDay]
}

// Representa cada item individual no array de uma semana
struct WorkoutDay: Codable {
    let day: String
    let type: String
    let duration_minutes: Int
    let description: String
}
