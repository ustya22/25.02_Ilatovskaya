import sys
import pymysql
from PyQt6.QtWidgets import QApplication, QMainWindow, QPushButton, QVBoxLayout, QWidget, QTableWidget, QTableWidgetItem, QMessageBox

# Параметры подключения к базе данных
DB_CONFIG = {
    'host': 'MySQL-8.2',
    'user': 'root',
    'password': '',
    'database': '25.02_ilatovskaya'
}

class PatientWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Окно Пациента")
        self.setGeometry(100, 100, 400, 300)

        # Разметка и виджеты
        layout = QVBoxLayout()

        self.view_records_button = QPushButton("Просмотреть Мои Записи")
        self.view_records_button.clicked.connect(self.view_records)
        layout.addWidget(self.view_records_button)

        self.schedule_analysis_button = QPushButton("Записаться на Новый Анализ")
        self.schedule_analysis_button.clicked.connect(self.schedule_analysis)
        layout.addWidget(self.schedule_analysis_button)

        self.table_widget = QTableWidget()
        layout.addWidget(self.table_widget)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

    def view_records(self):
        try:
            connection = pymysql.connect(**DB_CONFIG)
            cursor = connection.cursor()

            query = """
            SELECT s.name AS Анализ, st.name AS Статус, o.summa AS Результат, o.date_of_creation AS Дата
            FROM orders o
            JOIN status st ON o.id_status = st.id
            JOIN services_provided sp ON o.id = sp.id_order
            JOIN services s ON sp.id_employee_services = s.id
            WHERE o.id_patient = %s
            """
            cursor.execute(query, (1,))  # Замените 1 на фактический ID пациента
            results = cursor.fetchall()

            self.table_widget.setRowCount(len(results))
            self.table_widget.setColumnCount(4)
            self.table_widget.setHorizontalHeaderLabels(["Анализ", "Статус", "Результат", "Дата"])

            for row_index, row_data in enumerate(results):
                for col_index, cell_data in enumerate(row_data):
                    self.table_widget.setItem(row_index, col_index, QTableWidgetItem(str(cell_data)))

        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Ошибка Базы Данных", f"Ошибка: {e}")
        finally:
            cursor.close()
            connection.close()

    def schedule_analysis(self):
        QMessageBox.information(self, "Запись на Анализ", "Функция пока не реализована.")

def main():
    app = QApplication(sys.argv)
    window = PatientWindow()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
