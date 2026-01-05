pipeline {
    agent any  // Runs on Jenkins master

    environment {
        SLAVE_USER  = "ubuntu"
        SLAVE_IP    = "3.109.210.1"                  // Replace with your slave EC2 public IP
        PROJECT_DIR = "/home/ubuntu/myweb"          // Django app path on slave
        VENV_DIR    = "/home/ubuntu/venv"           // Virtual environment path
        REPO_URL    = "https://github.com/Thilakeshaws27/Django-jen.git"
    }

    stages {

        stage('Build on Master (Optional)') {
            steps {
                echo "✅ Preparing to deploy Django app to slave EC2..."
            }
        }

        stage('Deploy to Slave EC2') {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no ${SLAVE_USER}@${SLAVE_IP} '
                    echo "📂 Ensuring project directory exists..."
                    mkdir -p ${PROJECT_DIR}

                    # Clone or pull latest repo
                    if [ ! -d "${PROJECT_DIR}/.git" ]; then
                        git clone ${REPO_URL} ${PROJECT_DIR}
                    else
                        cd ${PROJECT_DIR} && git reset --hard && git pull origin main
                    fi

                    echo "🐍 Setting up Python virtual environment..."
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -r ${PROJECT_DIR}/requirements.txt

                    echo "🛠 Running migrations..."
                    cd ${PROJECT_DIR}
                    python manage.py migrate

                    echo "📦 Collecting static files..."
                    # Ensure STATIC_ROOT exists before collectstatic
                    mkdir -p ${PROJECT_DIR}/staticfiles
                    python manage.py collectstatic --noinput

                    echo "🔄 Restarting Gunicorn if exists..."
                    if systemctl list-units --full -all | grep -Fq "gunicorn.service"; then
                        sudo systemctl restart gunicorn
                    else
                        echo "⚠ Gunicorn service not found, skipping restart."
                    fi

                    echo "🔄 Restarting Nginx if exists..."
                    if systemctl list-units --full -all | grep -Fq "nginx.service"; then
                        sudo systemctl restart nginx
                    else
                        echo "⚠ Nginx service not found, skipping restart."
                    fi

                    echo "✅ Deployment completed on slave EC2!"
                '
                """
            }
        }
    }

    post {
        success {
            echo "🎉 Django app deployed successfully to slave EC2!"
        }
        failure {
            echo "❌ Deployment failed! Check Jenkins logs and slave EC2 configuration."
        }
    }
}
