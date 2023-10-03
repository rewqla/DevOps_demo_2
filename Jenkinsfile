pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
                git 'https://github.com/rewqla/DevOps_demo_2.git'
            }
        }
        stage('Terraform init'){
            steps{
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('Create Ecr'){
            steps{
             dir('terraform') {
                    withCredentials([[
                      $class: 'AmazonWebServicesCredentialsBinding',
                      credentialsId: "terraform-access",
                      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform apply -target=module.ecr --auto-approve'
                    }
                }
            }
        }
        stage('Node task') {
            agent {
                label 'docker-node' 
            }
            stages {
                stage('Push to ecr git data') {
                    steps {
                        sh 'rm -rf *'
                        sh 'git clone https://github.com/rewqla/DevOps_demo_2.git'
                        dir('DevOps_demo_2/demo_node_app') {
                            sh 'aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 325033910552.dkr.ecr.eu-north-1.amazonaws.com'
                            sh 'docker build -t app-repo .'
                            sh 'docker tag app-repo:latest 325033910552.dkr.ecr.eu-north-1.amazonaws.com/app-repo:latest'
                            sh 'docker push 325033910552.dkr.ecr.eu-north-1.amazonaws.com/app-repo:latest'
                       } 
                    }
                }
            }
        }
        stage('Build and task def ECS'){   
            steps{
                dir('terraform') {
                    withCredentials([[
                      $class: 'AmazonWebServicesCredentialsBinding',
                      credentialsId: "terraform-access",
                      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}