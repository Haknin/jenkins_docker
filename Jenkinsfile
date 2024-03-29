pipeline {
    agent any
    environment {
        testInstance = 'i-0ea8ce1eda456590b' // Replace with your test instance ID
        prodInstance = 'i-0bd12600caeb45b15' // Replace with your prod instance ID
        sshKeyPath = '/home/hakninn/.aws/ori109.pem'
        dockerImageName = 'haknin/crypto_docker:latest'
        flaskAppPath = '/flask'
        testInstanceIP = '' // Environment variable for test instance IP
        prodInstanceIP = '' // Environment variable for prod instance IP
    }
    stages {
        stage('Start Instances') {
            steps {
                script {
                    def instanceIds = [testInstance, prodInstance]
                    withAWS(region: 'eu-central-1', credentials: 'ssh-ori109') {
                        instanceIds.each { instanceId ->
                            sh "aws ec2 start-instances --instance-ids $instanceId"
                        }
                    }
                    // Retrieve IP addresses for instances
                    withAWS(region: 'eu-central-1', credentials: 'ssh-ori109') {
                        testInstanceIP = sh(
                            returnStdout: true,
                            script: "aws ec2 describe-instances --instance-ids $testInstance --query 'Reservations[].Instances[].PublicIpAddress' --output text"
                        ).trim()
                        prodInstanceIP = sh(
                            returnStdout: true,
                            script: "aws ec2 describe-instances --instance-ids $prodInstance --query 'Reservations[].Instances[].PublicIpAddress' --output text"
                        ).trim()
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh 'echo "Performing cleanup..."'
                sh 'rm -rf flask flask.tar.gz'
            }
        }
        stage('Clone') {
            steps {
                sh 'echo "Building..."'
                sh 'git clone https://github.com/Haknin/crypto-site.git'
                sh 'ls flask'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'echo "Building Docker image..."'
                sh "sudo docker build -t $dockerImageName ./$flaskAppPath"
            }
        }
        stage('Push To Docker Hub') {
            steps {
                sh 'echo "Pushing to Docker Hub..."'
                withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'sudo docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                    sh 'sudo docker push $dockerImageName'
                }
            }
        }
        stage('Pull Docker Image on Test Server') {
            steps {
                sh 'echo "Pulling Docker image on test server..."'
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$testInstanceIP \"docker pull $dockerImageName\""
            }
        }
        stage('Check Flask with cURL on test server') {
            steps {
                sh 'echo "Building and running Flask app on the test server..."'
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$testInstanceIP \"sudo docker rm -f test\""
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$testInstanceIP \"sudo docker run -d -p 5000:5000 --name test $dockerImageName\""
                sh 'sleep 15' // Give some time for the app to start
                sh 'echo "Checking Flask app using cURL..."'
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$testInstanceIP \"curl -s http://localhost:5000\""
            }
            post {
                success {
                    echo "Flask app is running successfully on the test server."
                }
                failure {
                    error "Flask app check on the test server failed. Exiting the pipeline."
                }
            }
        }
        stage('Pull Docker Image on EC2') {
            steps {
                sh 'echo "Pulling Docker image on EC2 prod server..."'
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$prodInstanceIP \"docker pull $dockerImageName\""
            }
        }
        stage('Run Flask App on EC2 prod server') {
            steps {
                sh 'echo "Running Flask app on EC2 prod server..."'
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$prodInstanceIP \"sudo docker rm -f prod\""
                sh "sudo ssh -i $sshKeyPath -o StrictHostKeyChecking=no ec2-user@$prodInstanceIP \"sudo docker run -d -p 5000:5000 --name prod $dockerImageName\""
            }
        }
        stage('Stop Instances') {
            steps {
                script {
                    def instanceIds = [testInstance]
                    withAWS(region: 'eu-central-1', credentials: 'ssh-ori109') {
                        instanceIds.each { instanceId ->
                            sh "aws ec2 stop-instances --instance-ids $instanceId"
                        }
                    }
                }
            }
        }
    }
}
