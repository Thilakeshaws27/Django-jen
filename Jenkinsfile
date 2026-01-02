pipeline {
    agent any

    environment {
        APP_DIR     = "/home/ubuntu/django-app"
        VENV_DIR    = "venv"
        DJANGO_EC2  = "ubuntu@13.232.183.201"
        DJANGO_SETTINGS_MODULE = "myproject.settings"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Thilakeshaws27/Django-jen.git'
            }
        }

        stage('Install Dependencies (Jenkins Test)') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Django Basic Test') {
            steps {
                sh '''
                . venv/bin/activate
                python manage.py check
                '''
            }
        }

        stage('Deploy to Django EC2') {
            steps {
                sh '''
                # Ensure app directory exists
                ssh ${DJANGO_EC2} "mkdir -p ${APP_DIR}"

                # Copy Django project files (NO venv)
                scp -r manage.py requirements.txt myproject apps dev_django.sh ${DJANGO_EC2}:${APP_DIR}

                # Install dependencies and deploy
                ssh ${DJANGO_EC2} "
                  cd ${APP_DIR} &&
                  rm -rf venv &&
                  python3 -m venv venv &&
                  . venv/bin/activate &&
                  pip install --upgrade pip &&
                  pip install -r requirements.txt &&
                  export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE} &&
                  python manage.py migrate &&
                  python manage.py collectstatic --noinput &&
                  chmod +x dev_django.sh &&
                  ./dev_django.sh restart
                "
                '''
            }
        }
    }
}
