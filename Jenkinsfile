pipeline {
    agent any  // Runs on Jenkins master

    environment {
        SLAVE_USER = "ubuntu"
        SLAVE_IP   = "3.109.210.1"              // Replace with your slave EC2 public IP
        PROJECT_DIR = "/home/ubuntu/myweb"      // Path on slave EC2
        VENV_DIR    = "/home/ubuntu/venv"       // Virtual environment on slave
        REPO_URL    = "https://github.com/Thilakeshaws27/Django-jen.git"
    }

    stages {

        stage('Build on Master (Optional)') {
            steps {
                echo "Building on master (optional) or just preparing SSH deploy..."
            }
        }

        stage('Deploy to Slave EC2') {
            steps {
                sh """
                ssh ${SLAVE_USER}@${SLAVE_IP} '
                    # Clone or pull the repo
                    if [ ! -d "${PROJECT_DIR}" ]; then
                        git clone ${REPO_URL} ${PROJECT_DIR}
                    else
                        cd ${PROJECT_DIR} && git pull origin main
                    fi

                    # Setup virtual environment
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -r ${PROJECT_DIR}/requirements.txt

                    # Django migrations & collectstatic
                    cd ${PROJECT_DIR}
                    python manage.py migrate
                    python manage.py collectstatic --noinput

                    # Restart Gunicorn and Nginx
                    sudo systemctl restart gunicorn
                    sudo systemctl restart nginx
                '
                """
            }
        }
    }

    post {
        success {
            echo "✅ Django app deployed successfully to slave EC2!"
        }
        failure {
            echo "❌ Deployment failed! Check SSH and logs."
        }
    }
}
