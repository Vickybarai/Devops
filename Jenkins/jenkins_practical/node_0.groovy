node {  
    stage('PULL') { 
                git branch: 'master', url: 'https://github.com/Vickybarai/jenkins.git'
                echo 'NODE :Pulling code from repository...'
    }
    stage('BUILD') { 
        echo 'BUILD SUCCESS'

    }
    stage('Test') { 
         echo 'TEST SUCCESS'
    }
    stage('Deploy') { 
         echo 'DEPLOY SUCCESS'
    }
}