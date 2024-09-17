# Workstation on Debian 12




## 1. Установка Debian 12 в минимальной конфигурации 

> Установка Debian 12 в минимальной конфигурации может быть автоматизирована с помощью файла предустановки **preseed.cfg**. 

---
**Скрипт для автоматической минимальной установки Debian 12:**

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
      single ::                                               \
              1000 10000 1000000000 ext4                      \
                      $primary{ }                             \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      mountpoint{ / }                         \
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

---


## 2. Установка Debian 12 в конфигурации Workstation

### Описание каждого блока  файла `preseed.cfg` и объяснение его назначения: 

> Файл **`preseed.cfg`** представляет собой автоматизированный сценарий установки **Debian 12**, который позволяет настроить систему без необходимости вмешательства пользователя.



#### 1. **Установка локали и раскладки клавиатуры**

```plaintext
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us,ru
d-i keyboard-configuration/toggle select win+space
```

- **`locale string en_US.UTF-8`** — Устанавливает локаль системы на английский язык (США) с кодировкой UTF-8.
- **`keyboard-configuration/xkb-keymap select us,ru`** — Настраивает клавиатурные раскладки на английскую (США) и русскую.
- **`keyboard-configuration/toggle select win+space`** — Определяет комбинацию клавиш (`Win+Space`) для переключения раскладок клавиатуры.

#### 2. **Конфигурация часового пояса**

```plaintext
d-i time/zone string Europe/Warsaw
d-i clock-setup/utc boolean true
```

- **`time/zone string Europe/Warsaw`** — Устанавливает часовой пояс системы на `Europe/Warsaw`.
- **`clock-setup/utc boolean true`** — Указывает, что системные часы настроены на время UTC.

#### 3. **Конфигурация сети с DHCP**

```plaintext
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string deb
d-i netcfg/get_domain string localdomain
d-i netcfg/dhcp_options select Configure network automatically
d-i netcfg/disable_dhcp boolean false
```

- **`netcfg/choose_interface select auto`** — Автоматически выбирает сетевой интерфейс для использования.
- **`netcfg/get_hostname string deb`** — Устанавливает имя хоста (hostname) системы как `deb`.
- **`netcfg/get_domain string localdomain`** — Устанавливает доменное имя по умолчанию как `localdomain`.
- **`netcfg/dhcp_options select Configure network automatically`** — Настраивает сеть автоматически с использованием DHCP.
- **`netcfg/disable_dhcp boolean false`** — Указывает, что DHCP не отключен (т.е. используется).

#### 4. **Настройки зеркала репозитория**

```plaintext
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
```

- **`mirror/country string manual`** — Устанавливает ручной выбор страны для зеркала репозитория.
- **`mirror/http/hostname string deb.debian.org`** — Указывает основное зеркало репозитория Debian.
- **`mirror/http/directory string /debian`** — Путь к директории репозитория.
- **`mirror/http/proxy string`** — Оставляет пустым параметр прокси-сервера, означая, что прокси не используется.

#### 5. **Разметка диска**

```plaintext
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
```

- **`partman-auto/disk string /dev/sda`** — Указывает диск (`/dev/sda`) для автоматической разметки.
- **`partman-auto/method string regular`** — Выбирает стандартный метод разметки.
- **`partman-auto/choose_recipe select atomic`** — Выбирает шаблон разметки `atomic`.
- **`partman-auto/expert_recipe`** — Определяет собственный рецепт разметки:
  - Создает два раздела: один для загрузки и основной раздел (`/`).
  - **`100 200 100 ext4`** — Устанавливает размер раздела от 100 до 200 МБ с файловой системой `ext4`.
  - **`method{ format }`** — Форматирует раздел.
  - **`use_filesystem{ } filesystem{ ext4 }`** — Использует файловую систему `ext4`.
  - **`mountpoint{ / }`** — Монтирует корневой раздел.
- **`partman/confirm_write_new_label boolean true`** — Подтверждает запись новой метки раздела.
- **`partman/choose_partition select finish`** — Завершает выбор разделов.
- **`partman/confirm boolean true`** — Подтверждает внесенные изменения в разметку диска.
- **`partman/confirm_nooverwrite boolean true`** — Подтверждает установку, если присутствует несохраненная информация.

#### 6. **Установка минимального набора пакетов**

```plaintext
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano unattended-upgrades \
    firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-atheros \
    alsa-utils pulseaudio pavucontrol network-manager network-manager-gnome wpasupplicant \
    cheese xserver-xorg-input-all xserver-xorg-video-all xorg xfce4 xfce4-terminal lightdm lightdm-gtk-greeter \
    openssh-client curl wget mc firefox-esr nftables firewalld snort suricata ossec-hids fail2ban
```

- **`tasksel/first multiselect standard`** — Выбирает установку стандартного набора пакетов.
- **`pkgsel/include string ...`** — Определяет дополнительные пакеты для установки:
  - **`sudo, git, python3.11, python3-pip, virtualenv`** — Инструменты для администрирования и разработки.
  - **`nano`** — Текстовый редактор.
  - **`unattended-upgrades`** — Автоматические обновления безопасности.
  - **`firmware-*`** — Драйверы для различных устройств (например, Wi-Fi).
  - **`alsa-utils, pulseaudio, pavucontrol`** — Пакеты для работы со звуком.
  - **`network-manager, network-manager-gnome, wpasupplicant`** — Инструменты управления сетью и Wi-Fi.
  - **`cheese`** — Программа для работы с веб-камерой.
  - **`xserver-xorg-input-all, xserver-xorg-video-all, xorg`** — Пакеты для установки X-сервера.
  - **`xfce4, xfce4-terminal`** — Среда рабочего стола XFCE4 и терминал.
  - **`lightdm, lightdm-gtk-greeter`** — Дисплейный менеджер и его графическая оболочка.
  - **`openssh-client, curl, wget, mc, firefox-esr`** — Инструменты для удаленного доступа, загрузки и браузер.
  - **`nftables, firewalld`** — Инструменты управления фаерволом.
  - **`snort, suricata, ossec-hids, fail2ban`** — Системы обнаружения вторжений (IDS).

#### 7. **Отключение установки рекомендованных пакетов**

```plaintext
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false
```

- Отключает установку рекомендованных пакетов:
  - **`restricted`** и **`universe`** — Отключение репозиториев с ограниченными пакетами.
  - **`install-recommends`** — Отключает установку рекомендованных пакетов.

#### 8. **Отключение возможности входа под root**

```plaintext
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true
```

- **`passwd/root-login boolean false`** — Запрещает прямой вход в систему под пользователем `root`.
- **`passwd/make-user boolean true`** — Создает обычного пользователя.

#### 9. **Создание пользователя с правами sudo**

```plaintext
d-i passwd/user-fullname string ssobol7
d-i passwd/username string ssobol7
d-i passwd/user-password password qwerty
d-i passwd/user-password-again password qwerty
d-i passwd/expire password true
d-i usermod -aG sudo ssobol7
d-i user-setup/allow-password-weak boolean true
```

- Создает пользователя `ssobol7` с правами `

sudo` и временным паролем `qwerty`.
- **`passwd/expire password true`** — Требует смены пароля при первом входе в систему.
- **`user-setup/allow-password-weak boolean true`** — Разрешает слабый пароль.

#### 10. **Установка автоматических обновлений безопасности**

```plaintext
d-i pkgsel/update-policy select unattended-upgrades
```

- **`pkgsel/update-policy select unattended-upgrades`** — Включает автоматическое обновление безопасности.

#### 11. **Установка загрузчика GRUB**

```plaintext
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda
```

- **`grub-installer/only_debian boolean true`** — Устанавливает загрузчик GRUB только для Debian.
- **`grub-installer/with_other_os boolean false`** — Не ищет другие операционные системы.
- **`grub-installer/bootdev string /dev/sda`** — Устанавливает GRUB на диск `/dev/sda`.

#### 12. **Настройка файла `sources.list`**

```plaintext
d-i preseed/late_command string "echo 'deb http://deb.debian.org/debian bookworm main non-free-firmware' > /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list;"
```

- Использует `late_command` для настройки репозиториев в файле `/etc/apt/sources.list`:
  - Устанавливает основные репозитории и их исходники.
  - Включает репозитории безопасности и обновлений.

#### 13. **Настройка `Firewalld` для режима Workstation**

```plaintext
d-i preseed/late_command string "systemctl enable firewalld; systemctl start firewalld; firewall-cmd --set-default-zone=work;"
```

- Автоматически включает и настраивает `Firewalld` для режима "Workstation".

#### 14. **Настройка IDS после установки**

```plaintext
d-i preseed/late_command string "systemctl enable snort; systemctl start snort; systemctl enable suricata; systemctl start suricata; systemctl enable ossec-hids; systemctl start ossec-hids; systemctl enable fail2ban; systemctl start fail2ban;"
```

- Включает и запускает системы обнаружения вторжений (`Snort`, `Suricata`, `OSSEC`, `Fail2ban`) после установки.

#### 15. **Завершение установки**

```plaintext
d-i finish-install/reboot_in_progress note
```

- Завершает процесс установки, включая перезагрузку системы.

### Итог

Этот файл `preseed.cfg` обеспечивает полностью автоматизированную установку Debian с базовой конфигурацией рабочего стола и инструментами безопасности, включая IDS, фаервол и необходимые утилиты для full-stack разработки.

---

### Полный код `preseed.cfg`:

```
# Установка локали и раскладки клавиатуры
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us,ru
d-i keyboard-configuration/toggle select win+space

# Конфигурация часового пояса
d-i time/zone string Europe/Warsaw
d-i clock-setup/utc boolean true

# Конфигурация сети с DHCP
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string deb
d-i netcfg/get_domain string localdomain
d-i netcfg/dhcp_options select Configure network automatically
d-i netcfg/disable_dhcp boolean false

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
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano unattended-upgrades \
    firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-atheros \
    alsa-utils pulseaudio pavucontrol network-manager network-manager-gnome wpasupplicant \
    cheese xserver-xorg-input-all xserver-xorg-video-all xorg xfce4 xfce4-terminal lightdm lightdm-gtk-greeter \
    openssh-client curl wget mc firefox-esr nftables firewalld snort suricata ossec-hids fail2ban

# Отключение установки рекомендованных пакетов
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false

# Отключение возможности входа под root
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true

# Создание пользователя с правами sudo
d-i passwd/user-fullname string ssobol7
d-i passwd/username string ssobol7
d-i passwd/user-password password qwerty
d-i passwd/user-password-again password qwerty
d-i passwd/expire password true
d-i usermod -aG sudo ssobol7
d-i user-setup/allow-password-weak boolean true

# Установка автоматических обновлений безопасности
d-i pkgsel/update-policy select unattended-upgrades

# Установка загрузчика GRUB
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda

# Настройка файла sources.list
d-i preseed/late_command string "echo 'deb http://deb.debian.org/debian bookworm main non-free-firmware' > /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list;"

# Настройка Firewalld для режима Workstation
d-i preseed/late_command string "systemctl enable firewalld; systemctl start firewalld; firewall-cmd --set-default-zone=work;"

# Настройка IDS после установки
d-i preseed/late_command string "systemctl enable snort; systemctl start snort; systemctl enable suricata; systemctl start suricata; systemctl enable ossec-hids; systemctl start ossec-hids; systemctl enable fail2ban; systemctl start fail2ban;"

# Завершение установки
d-i finish-install/reboot_in_progress note

```

---

&nbsp;

