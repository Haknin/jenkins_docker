pipeline {
    agent any
     triggers {
        pollSCM('*/5 * * * *')
    }
    environment {
        EC2_IP = "18.197.144.85"
    }
     stages {
        stage('Cleanup') {
            steps {
                Clean workspace
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
                sh 'aws s3 cp s3://roylatin-flask-artifacts/crypto.tar.gz /var/lib/jenkins/workspace/crypto.tar.gz'
                sshagent(['aws-key-ssh']) {
                         sh 'scp -i /var/lib/jenkins/key.pem /var/lib/jenkins/workspace/crypto.tar.gz ec2-user@$EC2_IP_TEST:/home/ec2-user'
                    
                withAWS(region: eu-central-1, credentials: jankeys) {
                    sh 'aws ec2 cp s3://haknin-bucket/crypto.tar.gz /var/lib/jenkins/workspace/crypto.tar.gz' // copy the zip to instance
                     sshagent(['aws-key-ssh']) {
                          sh 'scp -i /home/hakninn/.aws/ori109.pem /var/lib/jenkins/workspace/crypto.tar.gz ec2-user@$EC2_IP:/home/ec2-user'
                   // sh 'ssh -i /home/hakninn/.aws/ori109.pem ec2-user@18.193.101.103:22 "/s3://haknin-bucket/crypto.tar.gz -r -d /crypto/"'

                }
            }
        }
    }
}
        stage('Run the code') {
            steps {
                sh 'ssh user@instance-ip "cd /path/to/destination && your-command-to-start-the-code"' // replace with your command to start the code
            }
        }
    }
}
