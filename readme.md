# **Скрипт для автоматической минимальной установки Debian 12**

Установка Debian 12 в минимальной конфигурации может быть автоматизирована с помощью файла предустановки (preseed). Ниже предоставлен пример такого файла и инструкции по его использованию.

---

**Файл предустановки (preseed.cfg):**

```
# Установка локали и раскладки клавиатуры
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us

# Конфигурация сети
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string debian
d-i netcfg/get_domain string localdomain

# Настройки зеркала репозитория
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# Разметка диска
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/expert_recipe string                         \
      boot-root ::                                            \
              100 200 100 ext4                                \
                      $primary{ } $bootable{ }                \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      mountpoint{ / }                         \
              .                                               \
              512 10000 1000000000 ext4                       \
                      method{ keep }                          \
              .
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Установка минимального набора пакетов
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano

# Отключение установки рекомендованных пакетов
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false

# Установка пароля root
d-i passwd/root-password password rootpassword
d-i passwd/root-password-again password rootpassword

# Создание пользователя с правами sudo
d-i passwd/user-fullname string User
d-i passwd/username string user
d-i passwd/user-password password userpassword
d-i passwd/user-password-again password userpassword
d-i usermod -aG sudo user
d-i user-setup/allow-password-weak boolean true

# Установка загрузчика GRUB
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda

# Завершение установки
d-i finish-install/reboot_in_progress note
```

---

**Инструкция по использованию файла предустановки:**

1. **Сохраните файл** выше как `preseed.cfg`.

2. **Скачайте Debian 12 Netinst ISO** с официального сайта: [Debian Downloads](https://www.debian.org/distrib/netinst).

3. **Создайте загрузочную флешку** с помощью утилиты, например, Rufus или Etcher.

4. **Скопируйте файл `preseed.cfg`** в корень флешки или в каталог `/preseed/`.

5. **При загрузке с флешки**, на начальном экране установки, нажмите `Tab` или `e` (в зависимости от загрузчика), чтобы изменить параметры загрузки.

6. **Добавьте следующие параметры** к строке загрузки:

   ```
   auto=true priority=critical file=/cdrom/preseed.cfg
   ```

   Это укажет установщику использовать ваш файл предустановки для автоматической установки.

7. **Начните установку**, нажав `Enter`. Установка пройдет автоматически без необходимости вашего вмешательства.

---

**Примечания:**

- **Пароли и имена пользователей** в файле `preseed.cfg` указаны в открытом виде. Рекомендуется изменить их перед использованием и хранить файл в безопасном месте.
- **Диск назначения** в файле предустановки задан как `/dev/sda`. Убедитесь, что это правильный диск для установки в вашей системе.
- **Пакеты для установки** перечислены в строке `d-i pkgsel/include string`. Вы можете добавить или удалить пакеты по своему усмотрению.
- **Дополнительные настройки**, такие как установка `node.js 20` и `openjdk-17-jdk-headless`, могут быть выполнены после первой загрузки системы, так как их установка требует дополнительных репозиториев или команд.

---

**Установка дополнительных пакетов после установки системы:**

После завершения минимальной установки вы можете установить дополнительные пакеты:

```bash
# Обновление системы
sudo apt update && sudo apt upgrade -y

# Установка Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Установка OpenJDK 17 без графической оболочки
sudo apt install -y openjdk-17-jdk-headless

# Настройка переменных окружения для Java
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

**Объяснение:**

- **Файл предустановки** позволяет автоматизировать процесс установки Debian с минимальным набором пакетов и настроек.
- **Установка дополнительных пакетов после установки** обеспечивает более гибкий подход, позволяя настроить систему под ваши конкретные требования.
- **Настройка переменных окружения** для Java обеспечивает корректную работу Java-приложений, которые требуют переменной `JAVA_HOME`.

---

**Важно:**

- Перед началом убедитесь, что вы полностью понимаете процесс и возможные риски автоматической установки.
- Рекомендуется протестировать установку в виртуальной машине перед развертыванием на реальном оборудовании.
- Всегда сохраняйте резервные копии важных данных перед выполнением установки.
