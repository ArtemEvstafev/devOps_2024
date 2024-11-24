pipeline {
    agent any
    
    triggers {
        pollSCM 'H/5 * * * *'
    }

    environment {
        APP_IMAGE = "amicus37/greeting:latest"
        SONAR_SERVER = "http://sonar-server:9000"
        SONAR_PROJECT = "myapp-project"
        DOCKER_COMPOSE_FILE = "docker-compose.yml"
    }

    stages { 
        stage('Test Docker') {
            steps {
                echo "Docker.."
                script {
                    sh 'docker version'
                }
            }
        }
        stage('Checkout') {
            steps {
                echo "Checkout.."
                sh '''
                echo "doing checkout.."
                '''
                git branch: 'hmw4', url: 'https://github.com/ArtemEvstafev/devOps_2024.git' 
            }
        }

        stage('Build Application') {
            steps {
                echo "Building.."
                sh '''
                echo "doing build stuff.."
                '''
                script {
                    sh 'bash buildWithDocker.sh'
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
                    sh 'curl http://web:5000'pytest tests/
                    sh 'docker run --rm web pytest tests/ --junitxml=test-reports/report.xml'
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
                withSonarQubeEnv('SonarQube') {
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
                    sh 'docker-compose down && docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            script {
            	sh 'docker stop web db && docker rm web db'
            }
            echo 'Cleaning up resources...'
            junit '**/test-reports/*.xml'
        }
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}

