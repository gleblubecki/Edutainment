import SwiftUI

struct ContentView: View {
    @State private var startGame = false
    @State private var questionsAmount = [5, 10, 20]
    @State private var questionAmount = 5
    @State private var multiplicationTable = 1
    
    @FocusState private var amountIsFocused: Bool
    
    @State private var answer = 0
    @State private var task = Int.random(in: 1...12)
    
    @State private var gamesPLayed = 0
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var showingRound = 0

    @State private var animationAmount = 1.0

    var body: some View {
        if startGame == false {
            ZStack {
                //Settings
                
                Color("SettingsBgColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer(); Spacer(); Spacer(); Spacer(); Spacer()
                    
                    Text("Multiplication Game")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("ButtonsBgColor"))

                    VStack(spacing: 10) {
                        Spacer()
                        
                        Text("Amount of questions")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                        
                            Section {
                                Picker("", selection: $questionAmount) {
                                    ForEach(questionsAmount, id: \.self) {
                                        Text("\($0)")
                                            .font(.system(size: 30))
                                    }
                                }
                                .pickerStyle(.segmented)
                                
//                                Stepper("\(questionsAmount) questions", value: $questionsAmount, in: 5...20)
                            }
                                .padding(15)
                                .frame(width: 310, height: 55)
                                .font(.title2)
                                .background(Color("ButtonsBgColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.black)
                        
                        Text("Choose multiplication table")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                        
                        Section {
                            Stepper("\(multiplicationTable) x \(multiplicationTable)", value: $multiplicationTable, in: 1...12)
                        }
                            .padding(15)
                            .frame(width: 310, height: 55)
                            .font(.title2)
                            .background(Color("ButtonsBgColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.black)
                        
                        Spacer()
                        Spacer()

                        
                        Button("Start the game!") {
                            //start
                            startGame.toggle()
                        }
                            .padding(20)
                            .background(Color("ButtonsBgColor"))
                            .font(.title2)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                    }
                }
            }
        } else {
            ZStack {
                //Game process
                
                Color("ActiveBgColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer(); Spacer(); Spacer(); Spacer(); Spacer()
                    
                    Text("Multiplication Game")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("ActiveButtonColor"))
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 10) {
                        
                        VStack(spacing: 25) {
                            Text("Round: \(gamesPLayed)/\(questionAmount)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                            
                            Text("Score: \(score)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }

                        Spacer()
                        
                        Text("How much will it be?")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                        
                        Section {
                            Text("\(multiplicationTable) x \(task)")
                        }
                            .padding(15)
                            .frame(width: 310, height: 55)
                            .font(.title2)
                            .background(Color("ActiveButtonColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.black)
        
                        Text("Enter your answer:")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                        
                        Section {
                            TextField("Your answer", value: $answer, format: .number)
                                .keyboardType(.numberPad)
                                .focused($amountIsFocused)
                        }
                        .padding(15)
                        .frame(width: 310, height: 55)
                        .font(.title2)
                        .background(Color("ActiveButtonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.black)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Done") {
                                            amountIsFocused = false
                                        }
                                    }
                                }
                        
                        Spacer()
                        Spacer()
                        
                        Button("Enter", action: gameStarted)
                            .padding(20)
                            .background(Color("ActiveButtonColor"))
                            .font(.title2)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Spacer()
                        
                    }
                }
            }
            .alert(gamesPLayed == questionAmount ? "That was the last question" : scoreTitle, isPresented: $showingScore) {
                if gamesPLayed == questionAmount {
                    Button("Restart", action: restartGame)
                } else {
                    Button("Continue", action: refreshTask)
                }
            } message: {
                if gamesPLayed == questionAmount {
                    Text("Well done! Your score \(score). Want you play again?")
                } else if scoreTitle == "Correct" {
                    Text("Nice! Let's continue.")
                } else {
                    Text("The correct answer is \(multiplicationTable * task).")
                }
            }
        }
    }
    
    func gameStarted() {
        showingRound = gamesPLayed/questionAmount
        
        if gamesPLayed == questionAmount {
            startGame = false
            score = 0
            gamesPLayed = 0
            showingRound = 0
        }
        
        if multiplicationTable * task == answer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong!"
        }
        showingScore = true
        gamesPLayed += 1
    }
    
    func refreshTask() {
        task = Int.random(in: 1...12)
    }
    
    func restartGame() {
        startGame = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
