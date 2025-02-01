# Базовый образ с Ubuntu
FROM ubuntu:22.04

# Обновление пакетов и установка зависимостей
RUN apt update && apt install -y \
    cmake ninja-build gperf ccache dfu-util \
    device-tree-compiler wget xz-utils file \
    python3-pip python3-setuptools python3-wheel python3-dev \
    git unzip udev \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем west (менеджер Zephyr)
RUN pip3 install --upgrade west

# Создаём рабочую директорию
WORKDIR /workspace

# Скачиваем и устанавливаем Zephyr SDK
RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.4/zephyr-sdk-0.16.4_linux-x86_64.tar.xz \
    && tar -xf zephyr-sdk-0.16.4_linux-x86_64.tar.xz -C /opt \
    && /opt/zephyr-sdk-0.16.4/setup.sh -t all -c

# Устанавливаем переменные окружения
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-0.16.4
ENV PATH="$ZEPHYR_SDK_INSTALL_DIR/sysroots/x86_64-pokysdk-linux/usr/bin:$PATH"

# Клонируем ZMK
RUN git clone --recurse-submodules https://github.com/zmkfirmware/zmk.git /workspace/zmk

# Настраиваем west
WORKDIR /workspace/zmk
RUN west init -l app && west update && west zephyr-export

# Указываем рабочую директорию
WORKDIR /workspace

CMD ["/bin/bash"]

