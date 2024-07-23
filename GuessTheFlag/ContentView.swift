//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Arnav Oruganty on 04/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correct_answer = Int.random(in: 0...2)
    
    @State private var correct_choice = false
    @State private var end_game = false
    @State private var reached_8_questions = false
    @State private var show_final_score = false
    @State private var score = 0
    @State private var question_count = 0
    @State private var score_title = ""
    
    func flag_tapped (number: Int){
        if (question_count < 8){
            if (number == correct_answer) {
                score += 1
                correct_choice = true
                end_game = false
                score_title = "Correct!! That is the flag of \(countries[correct_answer])."
            } else {
                correct_choice = false
                end_game = true
                score_title = "Wrong!! That is the flag of \(countries[number])."
            }
            question_count += 1
        }
        
        if (question_count == 8) {
            show_final_score = true
            score_title = "Congratualtions!! You completed the game successfully."
        }
    }
    
    func ask_next_flag() {
        countries.shuffle()
        correct_answer = Int.random(in: 0...2)
    }
    
    func reset_game() {
        score = 0
        question_count = 0
        countries.shuffle()
        correct_answer = Int.random(in: 0...2)
        correct_choice = false
        end_game = false
        reached_8_questions = false
        show_final_score = false
    }
    
    var body: some View{
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.35), location: 0.5),
                .init(color: Color(red: 0.85, green: 0.15, blue: 0.2), location: 0.5)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack (spacing: 30) {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding()
                
                VStack (spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.title.weight(.regular))
                        Text(countries[correct_answer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flag_tapped(number: number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.rect(cornerRadius: 20))
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Score: \(score)")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding()
                
                Spacer()
            }
            .padding()
        }
        .alert(score_title, isPresented: $correct_choice) {
            Button("Continue", action: ask_next_flag)
        } message: {
            Text("Current Score: \(score)")
        }
        
        .alert(score_title, isPresented: $end_game) {
            Button("Restart Game", action: reset_game)
        } message: {
            Text("Total Score: \(score)")
        }
        
        .alert(score_title, isPresented: $show_final_score) {
            Button("Restart Game", action: reset_game)
        } message: {
            Text("Your final score is: \(score)")
        }
    }
}

#Preview {
    ContentView()
}
