//
//  QuestionView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct Cell: View {
    
    let fruit: String
    @Binding var selectedFruit: String?
    
    var body: some View {
        Button {
            self.selectedFruit = self.fruit
        } label: {
            HStack {
                Text(fruit)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.filled)
    }
}


struct QuizView: View {
    var quiz: [Question]
    var quizIndex: Int = 0
    var numStars: Int = 0
    
    @State var isCorrect: Bool? = nil
    @State var checked: Bool = false
    
    @State var selectedFruit: String? = nil
    
    @State var characterImage: String = "Character_Question"
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]
    
    @ViewBuilder
    var hasNextQuestion: some View {
        if quizIndex < quiz.count - 1 {
            NavigationLink {
                QuizView(quiz: quiz, quizIndex: quizIndex + 1, numStars: isCorrect ?? false ? numStars + 1 : numStars)
            } label: {
                Text("Next")
            }
        } else {
            NavigationLink {
                QuizCompleteView(numStars: isCorrect ?? false ? numStars + 1 : numStars)
            } label: {
                Text("Submit")
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Question \(quizIndex + 1)")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                if checked {
                    hasNextQuestion
                } else {
                    Button(action: {
                        isCorrect = quiz[quizIndex].answer == selectedFruit
                        checked = true
                    }, label: {
                        Text("Check Answer")
                    })
                }
            }
            
            ZStack(alignment: .top) {
                UserScene(characterImage: $characterImage, question: quiz[quizIndex])
                
                VStack {
                    Text("\(isCorrect ?? false ? "Correct✅" : "Incorrect🙅🏻‍♀️")")
                    Text("The Correct Answer is \(quiz[quizIndex].answer)")
                }
                .font(.title2)
                .opacity(checked ? 1 : 0)
                .padding()
            }
            .frame(maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(quiz[quizIndex].choice, id: \.self) { item in
                    Cell(fruit: item, selectedFruit: self.$selectedFruit)
                }
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: isCorrect) { isCorrect in
            characterImage = isCorrect ?? false ? "Character_Happy" : "Character_Cry"
        }
    }
}

#Preview {
    QuizView(quiz: [Question(question: "Who is Jack", choice: ["用力吹氣", "用火把燒", "用力撞", "爬上屋頂"], answer: "用火把燒"), Question(question: "Who is Jack", choice: ["用力吹氣", "用火把燒", "用力撞", "爬上屋頂"], answer: "用火把燒")], quizIndex: 0)
}
