class Groupmate
	constructor: (@id, @name, @darkHair, @bornInFirstHalf, @rockListener, @shortHair, @switched, @phoneEndsEven)->

groupmates = [
	new Groupmate(1, "Никита", true, false, false, true, false, true) 
	new Groupmate(2, "Рома", false, true, false, true, true, false)
	new Groupmate(3, "Аня",  false, false, false, false, false, false) 
	new Groupmate(4, "Антон", true, false, true, false, false, false)
	new Groupmate(5, "Вика", true, false, false, false, false, false) 
	new Groupmate(6, "Денис", true, false, true, false, true, true)
	new Groupmate(7, "Дима", true, false, true, true, false, false) 
	new Groupmate(8, "Кирилл", true, true, false, true, false, true)
	new Groupmate(9, "Матвей", true, true, true, true, false, true)
	new Groupmate(10, "Серёжа", true, true, true, false, false, true) 
	new Groupmate(11, "Серёжа", false, false, true, false, false, false)
	new Groupmate(12, "Филипп", true, true, true, false, true,true) 
	new Groupmate(13, "Юля", false, true, true, false, false, true)
	new Groupmate(14, "Алексей", true, true, false, true, false, false) 
	new Groupmate(15, "Аня", false, true, true, false, false, false)
]

class Question
	constructor: (@text, @shortDescr, @cond)->

questions = [
	new Question("У этого человека тёмные волосы?", "тёмные волосы", (mate)->mate.darkHair == true )
	new Question("Этот человек родился в первую половину года (с января по июнь включительно)?", "ранний день рождения", (mate)->mate.bornInFirstHalf is true )
	new Question("Этот человек слушает музыку в жанре рок?", "слушает рок", (mate)->mate.rockListener is true )
	new Question("У этого человека короткие волосы?","короткие волосы", (mate)->mate.shortHair is true )
	new Question("Этот человек учился на другой специальности перед тем, как поступить на бизнес-информатику?", "перевёлся", (mate)->mate.switched is true )
	new Question("Номер мобильного телефона этого человека заканчивается на чётную цифру?", "чётный номер", (mate)->mate.phoneEndsEven is true )
]

fillQuestionForm = (question)-> 
	el = $("#questionText")
	el.hide(500)
	el.text question.text
	el.show(500)	

uncolor = (mate)->$("#id"+mate.id).addClass "nocolor"
addColor = (mate)->$("#id"+mate.id).removeClass "nocolor"

answer = (inputArray, question, boolBtn)->
	toUncolor =  []
	toReturn = []
	inputArray.map (mate)-> if question.cond(mate) then toReturn.push(mate) else toUncolor.push(mate) 
	if not boolBtn then [toUncolor,toReturn] = [toReturn, toUncolor]
	$ "#choices"
		.append "<p>"+(if boolBtn then "" else "не ") + question.shortDescr + "</p>" 
	toUncolor.map uncolor
	failed.push toUncolor
	return toReturn

shuffle = `function (o){
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};`


shuffledQuestions = shuffle questions
workingArrayOfMates = do groupmates.slice
index = 0
failed = []

checkArray = (array)->
	if array.length is 1 
		$(".result-img").attr "src","images/(#{array[0].id}).png"
		$(".modal-body>h2").text "#{array[0].name}"
		$("<button/>", {id:"hiddenBtn","data-toggle":"modal", "data-target":"#resultModal"})	
			.insertAfter $(".navbar-brand")
				.click()
				.remove()
		$ ".question-form>.btn"
			.attr "disabled",""

	else if array.length is 0 then alert "404"

updateField = ->
	++index
	fillQuestionForm questions[index]
	
	
$ ->
	$("#yes-btn").click ->
		workingArrayOfMates = answer workingArrayOfMates, shuffledQuestions[index], true
		checkArray workingArrayOfMates
		do updateField

	$("#no-btn").click ->
		workingArrayOfMates = answer workingArrayOfMates, shuffledQuestions[index], false
		checkArray workingArrayOfMates
		do updateField

	$("#backBtn").click ->
		if index > 0
			--index
			t = failed.pop()
			console.log t
			t.map addColor
			workingArrayOfMates = workingArrayOfMates.concat t		
			fillQuestionForm questions[index]
			$ "#choices>p:last"
				.remove()
		

	fillQuestionForm questions[index]

