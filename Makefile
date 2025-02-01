# Имя образа Docker
DOCKER_IMAGE = zmk-builder

# Плата, используемая для сборки (nice_nano_v2)
BOARD = nice_nano_v2

# Текущая директория как ZMK_CONFIG
ZMK_CONFIG = $(CURDIR)

# Опции сборки
BUILD_DIR = build
ZMK_APP_DIR = /workspace/zmk/app

# Команда для запуска Docker-контейнера
DOCKER_RUN = docker run --rm -v $(ZMK_CONFIG):/workspace $(DOCKER_IMAGE)

# Основные цели
all: build-left build-right

# Сборка прошивки (левая половина)
build-left:
	$(DOCKER_RUN) west build -d $(BUILD_DIR)_left -s $(ZMK_APP_DIR) -b $(BOARD) -- \
		-DZMK_CONFIG=/workspace -DSHIELD=corne_left

# Сборка прошивки (правая половина)
build-right:
	$(DOCKER_RUN) west build -d $(BUILD_DIR)_right -s $(ZMK_APP_DIR) -b $(BOARD) -- \
		-DZMK_CONFIG=/workspace -DSHIELD=corne_right

# Очистка сборки
clean:
	rm -rf $(BUILD_DIR)_left $(BUILD_DIR)_right

# Прошивка (левая половина)
flash-left:
	cp $(BUILD_DIR)_left/zephyr/zmk.uf2 /Volumes/NICENANO/

# Прошивка (правая половина)
flash-right:
	cp $(BUILD_DIR)_right/zephyr/zmk.uf2 /Volumes/NICENANO/

# Запуск контейнера для отладки
shell:
	docker run --rm -it -v $(ZMK_CONFIG):/workspace $(DOCKER_IMAGE) /bin/bash

