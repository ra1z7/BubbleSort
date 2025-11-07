//
//  ContentView.swift
//  BubbleSort
//
//  Created by Purnaman Rai (College) on 29/10/2025.
//

import SwiftUI

struct NumBox: View, Identifiable {
    let id = UUID()
    let number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
            .foregroundStyle(.black)
            .frame(width: 20, height: 20)
            .padding(10)
            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
            .clipShape(.rect(cornerRadius: 15))
    }
}

struct ContentView: View {
    @State private var numbersToSort = [Int]()
    
    enum SortingState: String {
        case sorting = "Sorting..."
        case completed = "Sorting Complete"
        case idle = ""
    }
    
    @State private var sortingState = SortingState.idle
    @State private var allNumbersSorted = false
    @State private var showingSettings = false
    @State private var sortingSpeed = 0.5
    @State private var hapticTrigger = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                withAnimation {
                    showingSettings.toggle()
                    hapticTrigger.toggle()
                }
            } label: {
                Image(systemName: showingSettings ? "xmark" : "gearshape.fill")
                    .foregroundStyle(.black)
                    .contentTransition(.symbolEffect(.replace))
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: hapticTrigger)
        }
        
        ZStack {
            VStack {
                Text(sortingState.rawValue)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(width: 170, height: 50)
                    .contentTransition(.numericText())
                    .animation(.default, value: sortingState)
                
                HStack {
                    ForEach(numbersToSort, id: \.self) { number in
                        NumBox(number: number)
                    }
                    .animation(.bouncy, value: numbersToSort)
                    .sensoryFeedback(.impact(flexibility: .soft), trigger: numbersToSort)
                    
                    if sortingState != .sorting {
                        Button {
                            while true {
                                let randomNumber = Int.random(in: 0..<100)
                                if !numbersToSort.contains(randomNumber) && numbersToSort.count < 15 {
                                    withAnimation {
                                        numbersToSort.append(randomNumber)
                                        hapticTrigger.toggle()
                                    }
                                    break
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .semibold))
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(numbersToSort.count == 15 ? Color.secondary.opacity(0.2) : Color.red)
                                .foregroundStyle(.white)
                                .clipShape(.rect(cornerRadius: 15))
                        }
                        .animation(.bouncy, value: sortingState)
                        .transition(.scale)
                        .disabled(numbersToSort.count == 15)
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: hapticTrigger)
                    }
                    
                    if numbersToSort.isEmpty {
                        Button {
                            withAnimation {
                                let randomOrder = [7, 2, 9, 1, 8, 3, 5, 4, 6]
                                for number in randomOrder {
                                    numbersToSort.append(number)
                                    hapticTrigger.toggle()
                                }
                            }
                        } label: {
                            Text("Add Samples")
                                .frame(width: 86, height: 20)
                                .padding(10)
                                .background(.secondary.opacity(0.2))
                                .foregroundStyle(.gray)
                                .clipShape(.rect(cornerRadius: 15))
                                .font(.system(size: 12, design: .monospaced))
                        }
                        .transition(.blurReplace)
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: hapticTrigger)
                    }
                }
                .disabled(showingSettings)
                
                HStack {
                    if sortingState != .sorting && !numbersToSort.isEmpty {
                        Button("Sort") {
                            if numbersToSort.count > 1 {
                                Task {
                                    withAnimation {
                                        sortingState = .sorting
                                        allNumbersSorted = false
                                        hapticTrigger.toggle()
                                    }
                                    
                                    while !allNumbersSorted {
                                        var sortedCount = 0
                                        
                                        for i in 0..<numbersToSort.count - 1 {
                                            if numbersToSort[i] < numbersToSort[i + 1] {
                                                sortedCount += 1
                                                continue
                                            } else {
                                                let temp = numbersToSort[i]
                                                withAnimation {
                                                    numbersToSort[i] = numbersToSort[i + 1]
                                                    numbersToSort[i + 1] = temp
                                                }
                                                
                                                try? await Task.sleep(for: .seconds(1.1 - sortingSpeed))
                                            }
                                        }
                                        
                                        if sortedCount == numbersToSort.count - 1 {
                                            withAnimation {
                                                sortingState = .completed
                                            }
                                            try? await Task.sleep(for: .seconds(0.5))
                                            allNumbersSorted = true
                                        }
                                    }
                                }
                            }
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                        .transition(.blurReplace)
                        .sensoryFeedback(.start, trigger: hapticTrigger)
                        .sensoryFeedback(.success, trigger: allNumbersSorted)
                        
                        Button("Shuffle") {
                            withAnimation {
                                sortingState = .idle
                                numbersToSort.shuffle()
                                hapticTrigger.toggle()
                            }
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                        .transition(.blurReplace)
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: hapticTrigger)
                    }
                    
                    if !numbersToSort.isEmpty {
                        Button {
                            withAnimation {
                                if sortingState == .sorting {
                                    allNumbersSorted = true
                                    sortingState = .idle
                                    return
                                }
                                sortingState = .idle
                                numbersToSort.removeAll()
                                hapticTrigger.toggle()
                            }
                        } label: {
                            Image(systemName: sortingState == .sorting ? "xmark" : "trash.fill")
                                .imageScale(.small)
                                .frame(width: 10, height: 20)
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .transition(.scale.combined(with: .blurReplace))
                        .sensoryFeedback(.stop, trigger: hapticTrigger)
                    }
                }
                .frame(width: 220, height: 35)
                .padding()
                .fontDesign(.monospaced)
                .disabled(showingSettings)
            }
            .blur(radius: showingSettings ? 20 : 0)
            
            if showingSettings {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.thinMaterial)
                        .frame(width: 300, height: 90)
                        .transition(.blurReplace)
                        .shadow(radius: 6)
                    
                    VStack {
                        Text("Adjust Sorting Speed")
                        
                        Slider(value: $sortingSpeed, in: 0.1...1.0, step: 0.1) {
                            Text("Adjust Sorting Speed")
                        } minimumValueLabel: {
                            Text("1x")
                        } maximumValueLabel: {
                            Text("5x")
                        }
                        .frame(width: 250)
                        .sensoryFeedback(.selection, trigger: sortingSpeed)
                    }
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.secondary)
                }
                .transition(.blurReplace)
            }
        }
    }
}

#Preview {
    ContentView()
}
