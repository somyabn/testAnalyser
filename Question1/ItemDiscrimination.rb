require 'json'
require 'pry'
file = File.read('answers.json')
data_hash = JSON.parse(file)
score = 0
questionsThatGotScored = Hash.new()
questions = []
scoreIndex = {}
testQuestions = ["Find the center","Pittsburgh and Philadelphia","Mets batting average","Oil in a barrel",
                 "Surface of cube with holes","Choosing rainy-day outfits","Televisions per household",
                 "Angie's trip to Kalamazoo","Divisors of 759325","Widget sales","Orchard trees",
                 "Solar panel production","Climbing Mt. Fuji"]
#score each student by test performance 
data_hash.each do |response|
	response.each do |user|
     user["correct"] == true ? score += 1 : score
     user["correct"] == true ? questions << user["question"] : questions
     end
     scoreIndex[response.last["user_id"]] =  score
     questionsThatGotScored[response.last["user_id"]] = questions
     score =0
     questions = []
 end
#classify students according to test scores
topCohort = scoreIndex.select{|key, hash| hash >= 7 }
middleCohort = scoreIndex.select{|key, hash| (hash > 6 && hash < 7)}
bottomCohort = scoreIndex.select{|key, hash| hash <= 6 }
# getting IDI for each questions on test (Item Discrimination (which has range of -1.0 to
# 1.0) roughly indicates how well the question evaluates student ability. Values
# above 0.3 are generally good questions, values between 0.0 and 0.3 are mediocre,
# and values under 0.0 usually have errors in their grading))
def getItemDiscriminationIndex(str,questionsThatGotScored,topCohort,bottomCohort) 
   questionsThatGotScoredByTopCohort = questionsThatGotScored.select{|key, hash| topCohort.keys.include?(key)}
   ques1DiscrTopIndex = ((questionsThatGotScoredByTopCohort.select{|key, hash| hash.include?(str)}.length).to_f)/(topCohort.length).to_f
   questionsThatGotScoredByBottomCohort = questionsThatGotScored.select{|key, hash| bottomCohort.keys.include?(key)}
   ques1DiscrBottomIndex = ((questionsThatGotScoredByBottomCohort.select{|key, hash| hash.include?(str)}.length).to_f)/(bottomCohort.length).to_f   
   itemDiscriminationIndex =  ques1DiscrTopIndex -    ques1DiscrBottomIndex  
end  
testQuestions.each do |str|
   itemDiscriminationIndex = getItemDiscriminationIndex(str,questionsThatGotScored,topCohort,bottomCohort) 
   puts "Question name: #{str}  IDI : #{itemDiscriminationIndex}" 
end     