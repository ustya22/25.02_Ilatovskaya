-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: MySQL-8.2
-- Время создания: Фев 26 2025 г., 16:37
-- Версия сервера: 8.2.0
-- Версия PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `25.02_ilatovskaya`
--

-- --------------------------------------------------------

--
-- Структура таблицы `account composition`
--

CREATE TABLE `account composition` (
  `id` int NOT NULL,
  `id_order` int NOT NULL,
  `id_invoices_issued` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `analyzer`
--

CREATE TABLE `analyzer` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `production_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `employee`
--

CREATE TABLE `employee` (
  `id` int NOT NULL,
  `surname` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `patronymic` varchar(50) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `id_post` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `employee_services`
--

CREATE TABLE `employee_services` (
  `id` int NOT NULL,
  `id_employee` int NOT NULL,
  `id_service` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `insurance_company`
--

CREATE TABLE `insurance_company` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `INN` varchar(50) NOT NULL,
  `payment_account` varchar(50) NOT NULL,
  `BIK` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `invoices_issued`
--

CREATE TABLE `invoices_issued` (
  `id` int NOT NULL,
  `start_period` date NOT NULL,
  `end_period` date NOT NULL,
  `summa` decimal(10,0) NOT NULL,
  `id_employee` int NOT NULL,
  `id_company` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `date_of _creation` date NOT NULL,
  `end_date` date NOT NULL,
  `summa` decimal(8,2) NOT NULL,
  `id_status` int NOT NULL,
  `id_patient` int NOT NULL,
  `id_employee_services` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `patient`
--

CREATE TABLE `patient` (
  `id` int NOT NULL,
  `surname` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `patronymic` varchar(50) NOT NULL,
  `passport_number` int NOT NULL,
  `passport_series` int NOT NULL,
  `date_of_birth` date NOT NULL,
  `telephone_number` varchar(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `insurance_policy_number` varchar(20) NOT NULL,
  `id_type_policy` int NOT NULL,
  `id_company` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

CREATE TABLE `post` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `services`
--

CREATE TABLE `services` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `period_of_execution` int NOT NULL,
  `average_deviation` decimal(5,5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `services_provided`
--

CREATE TABLE `services_provided` (
  `id` int NOT NULL,
  `id_order` int NOT NULL,
  `id_employee_services` int NOT NULL,
  `id_analyzer` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `time spent` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `status`
--

CREATE TABLE `status` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `type_of_insurance_policy`
--

CREATE TABLE `type_of_insurance_policy` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `account composition`
--
ALTER TABLE `account composition`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_order` (`id_order`,`id_invoices_issued`),
  ADD KEY `id_invoices_issued` (`id_invoices_issued`);

--
-- Индексы таблицы `analyzer`
--
ALTER TABLE `analyzer`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_post` (`id_post`);

--
-- Индексы таблицы `employee_services`
--
ALTER TABLE `employee_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_employee` (`id_employee`,`id_service`),
  ADD KEY `id_service` (`id_service`);

--
-- Индексы таблицы `insurance_company`
--
ALTER TABLE `insurance_company`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `invoices_issued`
--
ALTER TABLE `invoices_issued`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_employee` (`id_employee`,`id_company`),
  ADD KEY `id_company` (`id_company`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_status` (`id_status`,`id_patient`,`id_employee_services`),
  ADD KEY `id_patient` (`id_patient`);

--
-- Индексы таблицы `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_type_policy` (`id_type_policy`,`id_company`),
  ADD KEY `id_company` (`id_company`);

--
-- Индексы таблицы `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `services_provided`
--
ALTER TABLE `services_provided`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_order` (`id_order`,`id_employee_services`),
  ADD KEY `id_analyzer` (`id_analyzer`);

--
-- Индексы таблицы `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `type_of_insurance_policy`
--
ALTER TABLE `type_of_insurance_policy`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `account composition`
--
ALTER TABLE `account composition`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `analyzer`
--
ALTER TABLE `analyzer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `employee_services`
--
ALTER TABLE `employee_services`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `insurance_company`
--
ALTER TABLE `insurance_company`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `invoices_issued`
--
ALTER TABLE `invoices_issued`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `patient`
--
ALTER TABLE `patient`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `services`
--
ALTER TABLE `services`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `services_provided`
--
ALTER TABLE `services_provided`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `status`
--
ALTER TABLE `status`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `type_of_insurance_policy`
--
ALTER TABLE `type_of_insurance_policy`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `account composition`
--
ALTER TABLE `account composition`
  ADD CONSTRAINT `account composition_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `account composition_ibfk_2` FOREIGN KEY (`id_invoices_issued`) REFERENCES `invoices_issued` (`id`);

--
-- Ограничения внешнего ключа таблицы `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`id_post`) REFERENCES `post` (`id`);

--
-- Ограничения внешнего ключа таблицы `employee_services`
--
ALTER TABLE `employee_services`
  ADD CONSTRAINT `employee_services_ibfk_1` FOREIGN KEY (`id_employee`) REFERENCES `employee` (`id`),
  ADD CONSTRAINT `employee_services_ibfk_2` FOREIGN KEY (`id_service`) REFERENCES `services` (`id`);

--
-- Ограничения внешнего ключа таблицы `invoices_issued`
--
ALTER TABLE `invoices_issued`
  ADD CONSTRAINT `invoices_issued_ibfk_1` FOREIGN KEY (`id_company`) REFERENCES `insurance_company` (`id`),
  ADD CONSTRAINT `invoices_issued_ibfk_2` FOREIGN KEY (`id_employee`) REFERENCES `employee` (`id`);

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`id_status`) REFERENCES `status` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id`);

--
-- Ограничения внешнего ключа таблицы `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`id_company`) REFERENCES `insurance_company` (`id`),
  ADD CONSTRAINT `patient_ibfk_2` FOREIGN KEY (`id_type_policy`) REFERENCES `type_of_insurance_policy` (`id`);

--
-- Ограничения внешнего ключа таблицы `services_provided`
--
ALTER TABLE `services_provided`
  ADD CONSTRAINT `services_provided_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `services_provided_ibfk_2` FOREIGN KEY (`id_analyzer`) REFERENCES `analyzer` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
