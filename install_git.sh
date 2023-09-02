#!/bin/bash

# Установка Git
sudo apt update
sudo apt install -y git

# Конфигурация Git
echo "Введите ваше имя пользователя Git:"
read git_username
git config --global user.name "$git_username"

echo "Введите вашу электронную почту Git:"
read git_email
git config --global user.email "$git_email"

# Вывод настроек Git
echo "Настройки Git:"
git config --list

echo "Установка и настройка Git завершены."
