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
                //Clean workspace
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
                //Clean workspace
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
                withAWS(region: eu-central-1, credentials: jankeys) {
                sh 'aws ec2 cp s3://haknin-bucket/crypto.tar.gz /var/lib/jenkins/workspace/crypto.tar.gz' // copy the zip to instance
                sh 'ssh ec2-user@$EC2_IP "cd /home/ec2-user && tar -xvf crypto.tar.gz"' // unzip the file
                sh 'ssh ec2-user@$EC2_IP "chmod +x /home/ec2-user/crypto/app.py"' // give the file executable permissions
                sh 'ssh ec2-user@$EC2_IP "nohup /home/ec2-user/crypto/app.py &"' // run the app in the background
            }
        }
    }

    //----------------
       // stage('Deploy to Instance') {
         //   steps {
           //     withAWS(region: eu-central-1, credentials: jankeys) {
             //       sh 'aws ec2 cp s3://haknin-bucket/crypto.tar.gz /var/lib/jenkins/workspace/crypto.tar.gz' // copy the zip to instance
               //      sshagent(['aws-key-ssh']) {
                 //         sh 'scp -i /home/hakninn/.aws/ori109.pem /var/lib/jenkins/workspace/crypto.tar.gz ec2-user@$EC2_IP:/home/ec2-user'
                   // sh 'ssh -i /home/hakninn/.aws/ori109.pem ec2-user@18.193.101.103:22 "/s3://haknin-bucket/crypto.tar.gz -r -d /crypto/"'
                }
            } 
        }
    }
}
  //-----------------
    
        stage('Run the code') {
            steps {
                ssh ec2-user@$EC2_IP "cd /home/ec2-user/crypto && python3 app.py"
            //    sh 'ssh user@instance-ip "cd /path/to/destination && your-command-to-start-the-code"' // replace with your command to start the code
            }
        }
    }
}
