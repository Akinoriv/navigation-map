  
#!/bin/bash

cd app
sudo apt update                 # обнавляю менеджер пакетов 

yes Y | sudo apt install nodejs # скачиваю и устанавливаю нодеджс/ соглашаюсь со всем
yes Y | sudo apt install npm    # скачиваю и устанавливаю  менеджер ракетов 
npm install                     # идет в файл package.json и цстанавливает все зависимости 
sudo npm install forever -g     # скачала и установила пакет форевер для авт работы
forever start index.js          # запустила свою страничку
