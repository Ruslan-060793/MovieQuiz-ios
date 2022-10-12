import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    func show(quiz result: QuizResultsViewModel) {
        
        let staticServiceImplementation = StatisticServiceImplementation()
        staticServiceImplementation.store(correct: correctAnswers, total: questionsAmount)
        
        //Здесь лежит количество игр
        let gamesCount = staticServiceImplementation.gamesCount
        
        //Здесь лежит точность ответов
        let accurancy = staticServiceImplementation.totalAccuracy
        
        //Рекорд по ответам
        let currentGame = GameRecord(correct: correctAnswers, total: questionsAmount, date: Date())
        
        staticServiceImplementation.bestGame = currentGame
        let bestGame = staticServiceImplementation.bestGame
        
        let message: String = "Ваш результат\(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", accurancy))%"
        
        let alert = UIAlertController(
                    title: result.title,
                    message: message,
                    preferredStyle: .alert)

                let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                    self.currentQuestionIndex = 0
        
                    // скидываем счётчик правильных ответов
                    self.correctAnswers = 0
        
                    // заново показываем первый вопрос
                    self.questionFactory?.requestNextQuestion()
                }
        
                alert.addAction(action)
        
                self.present(alert, animated: true, completion: nil)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                    self?.show(quiz: viewModel)
                }
    }
    
    // MARK: - Lifecycle

    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        questionFactory?.requestNextQuestion()
    }
    
    
    @IBAction private func noButtonClicked(noButtonClicked sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer{
            showAnswerResult(isCorrect: false)
        }else{
            showAnswerResult(isCorrect: true)
        }
        
        self.isEnableButton(isEnable: false)
    }
    
    
    @IBAction private func yesButtonClicked(yesButtonClicked sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer{
            showAnswerResult(isCorrect: true)
        }else{
            showAnswerResult(isCorrect: false)
        }
        
        self.isEnableButton(isEnable: false)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.questionNumber)"
    }
    
//    private func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
//            self.currentQuestionIndex = 0
//
//            // скидываем счётчик правильных ответов
//            self.correctAnswers = 0
//
//            // заново показываем первый вопрос
//            self.questionFactory?.requestNextQuestion()
//        }
//
//        alert.addAction(action)
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    //тут отображается результат ответа красный или зеленый в зависимости от ответа
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isEnableButton(isEnable: true)
            self.showNextQuestionOrResults()
            
        }
        
    }
    
    private func isEnableButton(isEnable: Bool){
        self.yesButton.isEnabled = isEnable
        self.noButton.isEnabled = isEnable
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            alertPresenter?.showEndGameAlert(quiz: viewModel)
        } else {
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
