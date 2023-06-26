pipeline {
    agent any
    triggers {
        pollSCM('*/5 * * * *')
    }
    environment {
        EC2_IP = "18.198.202.101"
    }
    stages {
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
        stage('Clone') {
            steps {
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
        stage('Setting Up The Test Server And Running Checks') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-ori109', keyFileVariable: 'KEY_FILE')]) {
                        sh "scp -i /var/lib/jenkins/workspace/ori109.pem -o StrictHostKeyChecking=no crypto.tar.gz ec2-user@$EC2_IP:/home/ec2-user"
                        sh "ssh -i /var/lib/jenkins/workspace/ori109.pem -o StrictHostKeyChecking=no ec2-user@$EC2_IP 'tar xzvf crypto.tar.gz'"
                        sh "ssh -i /var/lib/jenkins/workspace/ori109.pem -o StrictHostKeyChecking=no ec2-user@$EC2_IP bash -x crypto-site/deploy.sh &"

                    }
                }
            }
        }
    }
}
