pipeline {
    agent any
     triggers {
        pollSCM('*/1 * * * *')
     }
     stages {
        stage('Cleanup') {
            steps {
                // Clean workspace
                cleanWs()
            }
        }
        stage('Clone') {
            steps {
                // Checkout source code from Git
                sh 'git clone https://github.com/Haknin/crypto-site.git'
            }
        }
        stage('Build & Zip') {
            steps {
                script {
                    sh 'tar czvf crypto.tar.gz crypto-site' // zip the code
                }
            }
        }
        stage('Upload to S3') {
            steps {
                sh 'aws s3 cp crypto.tar.gz s3://haknin-bucket/'
            }
        }

        stage('Deploy to Instance') {
            steps {
                withAWS(region: 'your-aws-region', credentials: 'your-aws-credentials') {
                    sh 'aws ec2 cp s3://your-s3-bucket/code.zip /path/to/destination' // copy the zip to instance
                    sh 'ssh user@instance-ip "unzip /path/to/destination/code.zip -d /path/to/destination"' // unzip the code on the instance
                }
            }
        }

        stage('Runnnn the code') {
            steps {
                sh 'ssh user@instance-ip "cd /path/to/destination && your-command-to-start-the-code"' // replace with your command to start the code
            }
        }
    }
}
