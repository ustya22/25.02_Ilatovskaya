import sys
import random
import string
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel, QLineEdit, QPushButton, QMessageBox, QCheckBox
from PyQt6.QtGui import QPixmap
from PyQt6.QtCore import Qt, QTimer
from PIL import Image, ImageDraw, ImageFont
import pymysql
from laborant_window import LabTechnicianWindow
from bux_window import AccountantWindow

class LoginWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.captcha_required = False
        self.captcha_text = ""
        self.attempts = 0

    def initUI(self):
        self.setWindowTitle('Вход')
        self.setGeometry(100, 100, 300, 300)

        layout = QVBoxLayout()

        self.login_label = QLabel('Логин:')
        self.login_input = QLineEdit()
        layout.addWidget(self.login_label)
        layout.addWidget(self.login_input)

        self.password_label = QLabel('Пароль:')
        self.password_input = QLineEdit()
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        layout.addWidget(self.password_label)
        layout.addWidget(self.password_input)

        self.show_password_checkbox = QCheckBox('Показать пароль')
        self.show_password_checkbox.stateChanged.connect(self.toggle_password_visibility)
        layout.addWidget(self.show_password_checkbox)

        self.captcha_label = QLabel()
        self.captcha_input = QLineEdit()
        self.captcha_input.setPlaceholderText("Введите CAPTCHA")
        self.captcha_input.setVisible(False)
        layout.addWidget(self.captcha_label)
        layout.addWidget(self.captcha_input)

        self.refresh_captcha_button = QPushButton('Обновить CAPTCHA')
        self.refresh_captcha_button.clicked.connect(self.generate_captcha)
        self.refresh_captcha_button.setVisible(False)
        layout.addWidget(self.refresh_captcha_button)

        self.login_button = QPushButton('Войти')
        self.login_button.clicked.connect(self.login)
        layout.addWidget(self.login_button)

        self.setLayout(layout)

    def toggle_password_visibility(self):
        if self.show_password_checkbox.isChecked():
            self.password_input.setEchoMode(QLineEdit.EchoMode.Normal)
        else:
            self.password_input.setEchoMode(QLineEdit.EchoMode.Password)

    def login(self):
        login = self.login_input.text()
        password = self.password_input.text()

        if self.captcha_required and self.captcha_input.text().lower() != self.captcha_text.lower():
            QMessageBox.warning(self, 'Ошибка', 'Неверная CAPTCHA')
            self.block_login()
            return

        try:
            connection = connect_to_database()
            cursor = connection.cursor()
            query = "SELECT * FROM employee WHERE login = %s AND password = %s"
            cursor.execute(query, (login, password))
            result = cursor.fetchone()

            if result:
                self.show_user_info(result)
                self.attempts = 0  # Сброс попыток при успешном входе
            else:
                QMessageBox.warning(self, 'Ошибка', 'Неверный логин или пароль')
                self.attempts += 1
                if self.attempts >= 1:
                    self.show_captcha()

        except pymysql.Error as e:
            QMessageBox.critical(self, 'Ошибка базы данных', f'Ошибка подключения к базе данных: {e}')
        finally:
            cursor.close()
            connection.close()

    def show_captcha(self):
        self.captcha_required = True
        self.generate_captcha()
        self.captcha_input.setVisible(True)
        self.refresh_captcha_button.setVisible(True)

    def generate_captcha(self):
        self.captcha_text = ''.join(random.choices(string.ascii_letters + string.digits, k=4))
        image = Image.new('RGB', (100, 50), color=(255, 255, 255))
        draw = ImageDraw.Draw(image)
        font = ImageFont.load_default()

        # Рисуем случайные линии и шум
        for _ in range(5):
            x1 = random.randint(0, 100)
            y1 = random.randint(0, 50)
            x2 = random.randint(0, 100)
            y2 = random.randint(0, 50)
            draw.line([(x1, y1), (x2, y2)], fill=(0, 0, 0))

        # Рисуем текст CAPTCHA
        for i, char in enumerate(self.captcha_text):
            x = 20 + (i * 20)
            y = random.randint(10, 30)
            draw.text((x, y), char, font=font, fill=(0, 0, 0))

        image.save('captcha.png')
        self.captcha_label.setPixmap(QPixmap('captcha.png'))

    def block_login(self):
        self.login_button.setEnabled(False)
        QTimer.singleShot(10000, lambda: self.login_button.setEnabled(True))

    def show_user_info(self, user_data):
        role_id = user_data[6]
        if role_id in [1, 2]:
            self.lab_technician_window = LabTechnicianWindow(user_data)
            self.lab_technician_window.show()
        elif role_id in [3]:
            self.bux_window = AccountantWindow(user_data)
            self.bux_window.show()
        else:
            self.user_info_window = UserInfoWindow(user_data)
            self.user_info_window.show()
        self.close()

class UserInfoWindow(QWidget):
    def __init__(self, user_data):
        super().__init__()
        self.user_data = user_data
        self.initUI()

    def initUI(self):
        self.setWindowTitle('Информация о пользователе')
        self.setGeometry(100, 100, 400, 300)

        layout = QVBoxLayout()

        self.user_label = QLabel(f'Добро пожаловать, {self.user_data[2]} {self.user_data[1]}')
        layout.addWidget(self.user_label)

        self.role_label = QLabel(f'Роль: {self.get_user_role(self.user_data[6])}')
        layout.addWidget(self.role_label)

        self.logout_button = QPushButton('Выйти')
        self.logout_button.clicked.connect(self.logout)
        layout.addWidget(self.logout_button)

        self.setLayout(layout)

    def get_user_role(self, role_id):
        try:
            connection = connect_to_database()
            cursor = connection.cursor()
            query = "SELECT name FROM post WHERE id = %s"
            cursor.execute(query, (role_id,))
            result = cursor.fetchone()
            return result[0] if result else 'Неизвестно'
        except pymysql.Error as e:
            QMessageBox.critical(self, 'Ошибка базы данных', f'Ошибка при получении роли: {e}')
            return 'Неизвестно'
        finally:
            cursor.close()
            connection.close()

    def logout(self):
        self.close()
        login_window = LoginWindow()
        login_window.show()

def connect_to_database():
    return pymysql.connect(
        host='MySQL-8.2',
        user='root',
        password='',
        database='25.02_ilatovskaya'
    )

if __name__ == '__main__':
    app = QApplication(sys.argv)
    login_window = LoginWindow()
    login_window.show()
    sys.exit(app.exec())
