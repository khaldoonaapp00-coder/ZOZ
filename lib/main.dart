<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تطبيق الفحص الذكي</title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --accent: #22c55e;
            --danger: #ef4444;
            --border: #334155;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #818cf8;
        }

        .question-box {
            font-size: 1.1rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .options-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 25px;
        }

        .option-btn {
            background-color: #334155;
            color: var(--text-color);
            border: 2px solid transparent;
            padding: 12px 16px;
            border-radius: 10px;
            cursor: pointer;
            text-align: right;
            font-size: 1rem;
            transition: all 0.2s ease;
        }

        .option-btn:hover {
            background-color: #475569;
            border-color: var(--primary);
        }

        .option-btn.correct {
            background-color: rgba(34, 197, 94, 0.2);
            border-color: var(--accent);
            color: #4ade80;
        }

        .option-btn.wrong {
            background-color: rgba(239, 68, 68, 0.2);
            border-color: var(--danger);
            color: #f87171;
        }

        .btn-next {
            background-color: var(--primary);
            color: white;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
            display: none;
        }

        .btn-next:hover {
            background-color: var(--primary-hover);
        }

        .result-box {
            text-align: center;
            display: none;
        }

        .result-box h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        .restart-btn {
            background-color: var(--accent);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            margin-top: 15px;
        }

        .progress {
            font-size: 0.9rem;
            color: #94a3b8;
            margin-bottom: 15px;
            text-align: left;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>نظام الفحص الذكي</h2>
        
        <div id="quiz-container">
            <div class="progress" id="progress-text">السؤال 1 من 3</div>
            <div class="question-box" id="question-text">جاري تحميل السؤال...</div>
            <div class="options-list" id="options-container"></div>
            <button class="btn-next" id="next-btn" onclick="nextQuestion()">السؤال التالي</button>
        </div>

        <div class="result-box" id="result-container">
            <h3>نتيجة الفحص</h3>
            <p id="score-text" style="font-size: 1.2rem; margin-bottom: 15px;"></p>
            <button class="restart-btn" onclick="restartQuiz()">إعادة الفحص</button>
        </div>
    </div>

    <script>
        // بيانات الأسئلة (يمكنك تعديلها بكل سهولة أو ربطها بقاعدة بيانات لاحقاً)
        const quizData = [
            {
                question: "ما هي الدالة المستخدمة في لغة بايثون لمعرفة طول النص أو القائمة؟",
                options: ["size()", "length()", "len()", "count()"],
                correct: 2
            },
            {
                question: "أي من لغات الويب التالية تستخدم لتنسيق وتصميم صفحات الويب وتغيير الألوان؟",
                options: ["HTML", "CSS", "Python", "JavaScript"],
                correct: 1
            },
            {
                question: "ما هو الرمز المستخدم للتعليقات السطرية (Single-line comments) في بايثون؟",
                options: ["//", "/*", "#", "<!--"],
                correct: 2
            }
        ];

        let currentQuestionIndex = 0;
        let score = 0;
        let answered = false;

        const questionText = document.getElementById("question-text");
        const optionsContainer = document.getElementById("options-container");
        const nextBtn = document.getElementById("next-btn");
        const progressText = document.getElementById("progress-text");
        const quizContainer = document.getElementById("quiz-container");
        const resultContainer = document.getElementById("result-container");
        const scoreText = document.getElementById("score-text");

        function loadQuestion() {
            answered = false;
            nextBtn.style.display = "none";
            optionsContainer.innerHTML = "";

            const currentQ = quizData[currentQuestionIndex];
            progressText.innerText = `السؤال ${currentQuestionIndex + 1} من ${quizData.length}`;
            questionText.innerText = currentQ.question;

            currentQ.options.forEach((option, index) => {
                const btn = document.createElement("button");
                btn.classList.add("option-btn");
                btn.innerText = option;
                btn.onclick = () => selectOption(index, btn);
                optionsContainer.appendChild(btn);
            });
        }

        function selectOption(selectedIndex, selectedBtn) {
            if (answered) return;
            answered = true;

            const currentQ = quizData[currentQuestionIndex];
            const allButtons = optionsContainer.querySelectorAll(".option-btn");

            if (selectedIndex === currentQ.correct) {
                selectedBtn.classList.add("correct");
                score++;
            } else {
                selectedBtn.classList.add("wrong");
                allButtons[currentQ.correct].classList.add("correct");
            }

            // إظهار زر التالي أو إنهاء الاختبار إذا كان الأخير
            if (currentQuestionIndex < quizData.length - 1) {
                nextBtn.style.display = "block";
            } else {
                nextBtn.innerText = "عرض النتيجة";
                nextBtn.style.display = "block";
                nextBtn.onclick = showResult;
            }
        }

        function nextQuestion() {
            currentQuestionIndex++;
            loadQuestion();
            // إعادة تعيين دالة زر التالي للاستخدام الطبيعي
            nextBtn.onclick = nextQuestion;
            nextBtn.innerText = "السؤال التالي";
        }

        function showResult() {
            quizContainer.style.display = "none";
            resultContainer.style.display = "block";
            scoreText.innerText = `لقد أجبت بشكل صحيح على ${score} من ${quizData.length} أسئلة.`;
        }

        function restartQuiz() {
            currentQuestionIndex = 0;
            score = 0;
            quizContainer.style.display = "block";
            resultContainer.style.display = "none";
            loadQuestion();
        }

        // تشغيل التطبيق لأول مرة
        loadQuestion();
    </script>
</body>
</html>
