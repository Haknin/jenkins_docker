pipeline {
    agent any
     triggers {
        pollSCM('*/5 * * * *')
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
                withAWS(region: eu-central-1, credentials: 'your-aws-credentials')
                {
      
                    sh 'ssh user@instance-ip "unzip /path/to/destination/code.zip -d /path/to/destination"' // unzip the code on the instance
                    sh 'aws s3 cp s3://haknin-bucket/crypto.tar.gz /var/lib/jenkins/workspace/crypto.tar.gz'
                    //sshagent(['aws-key-ssh']) {
                       //  sh 'scp -i /var/lib/jenkins/key.pem /var/lib/jenkins/workspace/crypto.tar.gz ec2-user@$EC2_IP_TEST:/home/ec2-user'
                
                
                
                
                
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
