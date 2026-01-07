//
//  ContentView.swift
//  WordGarden
//
//  Created by Oscar De Villiers on 2025/12/31.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0 // index to wordToGuess
    @State private var wordToGuess = ""
    @State private var revealWord = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    private let wordsToGuess = ["SWIFT", "CAT", "DOG"] // All Caps
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            // TODO: Switch to wordsToGuess[currentWordIndex]
            Text(revealWord)
                .font(.title)
            if playAgainHidden {
                
                HStack {
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            // As long as guessedLetter is not an empty String we can continue, otherwise don't do anything
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                        }
                    
                    Button("Guess a Letter") {
                        guessALetter()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
                
            } else {
                
                Button("Another Word?") {
                    // TODO: Another Word Button Action Here
                    textFieldIsFocused = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
                
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        }
    }
    
    func guessALetter() {
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealWord = wordToGuess.map { letter in
            lettersGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
        guessedLetter = ""
    }
}

#Preview {
    ContentView()
}
