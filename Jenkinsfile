pipeline {
  agent any
  stages {

    stage('Lint HTML') {
      steps {
        sh 'tidy -q -e *.html'
      }
    }
    
    stage('Build Docker Image') {
      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
          sh '''
            docker build -t awsdev123/capstone .
          '''
        }
      }
    }

    stage('Push Image To Dockerhub') {
      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
          sh '''
            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
            docker push awsdev123/capstone
          '''
        }
      }
    }

    stage('Set kubectl context') {
      steps {
        withAWS(region:'us-west-2', credentials:'proj5') {
          sh '''
            kubectl config use-context arn:aws eks:us-west-2:kubeconfig:cluster/jenkinsproj5
          '''
        }
      }
    }

    stage('Deploy blue container') {
      steps {
        withAWS(region:'us-west-2', credentials:'proj5') {
          sh '''
            kubectl apply -f ./blue/blue-controller.json
          '''
        }
      }
    }

    stage('Deploy green container') {
      steps {
        withAWS(region:'us-west-2', credentials:'proj5') {
          sh '''
            kubectl apply -f ./green/green-controller.json
          '''
        }
      }
    }

    stage('Create the service in the cluster, redirect to blue') {
      steps {
        withAWS(region:'us-west-2', credentials:'proj5') {
          sh '''
            kubectl apply -f ./blue/blue-service.json
          '''
        }
      }
    }

    stage('Wait user approve') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

    stage('Create the service in the cluster, redirect to green') {
      steps {
        withAWS(region:'us-west-2', credentials:'proj5') {
          sh '''
            kubectl apply -f ./green/green-service.json
          '''
        }
      }
    }

  }
}