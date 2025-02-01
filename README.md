# Сборка Docker-образа
docker build -t zmk-builder .

# Запуск контейнера и сборка прошивки
cd /workspace
west build -s app -b nice_nano_v2 -- -DZMK_CONFIG=/workspace -DSHIELD=corne_left

# Альтернативный вариант: Однострочник
docker run --rm -v $(pwd):/workspace zmk-builder \
    west build -s app -b nice_nano_v2 -- -DZMK_CONFIG=/workspace -DSHIELD=corne_left

# Прошивка
cp build/zephyr/zmk.uf2 /Volumes/NICENANO/
