pipeline {
    agent any

    environment {
        APP_IMAGE = "myapp:latest"
        SONAR_SERVER = "http://sonar-server:9000"
        SONAR_PROJECT = "myapp-project"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checkout.."
                sh '''
                echo "doing checkout.."
                '''
                git branch: 'main', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build Application') {
            steps {
                echo "Building.."
                sh '''
                echo "doing build stuff.."
                '''
                script {
                    // Собираем Docker-контейнер
                    sh 'docker-compose build'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo "Testing.."
                sh '''
                echo "doing test stuff.."
                '''
                script {
                    // Запускаем тесты в контейнере web
                    sh 'docker-compose run --rm web pytest --junitxml=test-reports/report.xml'
                }
            }
        }

        stage('Generate Allure Reports') {
            steps {
                echo "Reports.."
                sh '''
                echo "doing reports.."
                '''
                script {
                    // Собираем отчёты в Allure
                    allure([
                        includeProperties: false, 
                        jdk: '', 
                        results: [[path: 'test-reports']]
                    ])
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "Analyzing.."
                sh '''
                echo "doing analysis.."
                '''
                withSonarQubeEnv('SonarQube') { // Указываем SonarQube сервер
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=$SONAR_PROJECT \
                        -Dsonar.sources=./app \
                        -Dsonar.host.url=$SONAR_SERVER \
                        -Dsonar.login=<YOUR_SONAR_TOKEN>
                    """
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                echo "Quality check.."
                sh '''
                echo "checking quality.."
                '''
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo "Deploying.."
                sh '''
                echo "deploying app.."
                '''
                script {
                    // Развёртывание Docker-контейнеров
                    sh 'docker-compose down && docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            // Сохраняем тестовые отчёты в Jenkins
            junit '**/test-reports/*.xml'
        }
        failure {
            // Уведомление при провале
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}

