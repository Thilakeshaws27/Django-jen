pipeline {
    agent any

    environment {
        APP_DIR     = "/home/ubuntu/myweb"     // Change as needed on slave
        VENV_DIR    = "venv"
        DJANGO_PORT = "8000"
        DJANGO_EC2  = "ubuntu@3.109.210.1"   // Change to your slave IP
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Thilakeshaws27/Django-jen.git'
            }
        }

        stage('Install Dependencies (Jenkins)') {
            steps {
                sh '''
                python3 -m venv ${VENV_DIR}
                . ${VENV_DIR}/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Django Checks') {
            steps {
                sh '''
                . ${VENV_DIR}/bin/activate
                python manage.py check
                '''
            }
        }

        stage('Run Migrations (Jenkins Test)') {
            steps {
                sh '''
                . ${VENV_DIR}/bin/activate
                python manage.py migrate --noinput
                '''
            }
        }

        stage('Deploy to Django EC2') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no ${DJANGO_EC2} "mkdir -p ${APP_DIR}"

                # Copy project folders and files to slave
                scp -o StrictHostKeyChecking=no -r \
                    app1 app4 myweb manage.py requirements.txt django.sh \
                    ${DJANGO_EC2}:${APP_DIR}

                ssh -o StrictHostKeyChecking=no ${DJANGO_EC2} "
                    cd ${APP_DIR} &&
                    rm -rf ${VENV_DIR} &&
                    python3 -m venv ${VENV_DIR} &&
                    . ${VENV_DIR}/bin/activate &&
                    pip install --upgrade pip &&
                    pip install -r requirements.txt &&
                    chmod +x django.sh &&
                    ./django.sh
                "
                '''
            }
        }
    }
}
